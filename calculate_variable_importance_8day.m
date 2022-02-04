% Test variable importance by sequentially destroying information content
tic

nsims = 100;
vars = {'NDVI','EVI','NIRv','kNDVI',...
    'LSWI1','LSWI2','LSWI3','MOD11_Day','MOD11_Night','MYD11_Day','MYD11_Night',...
    'L4SM_Root','L4SM_Surf','L4SM_TSoil'};
ks = length(vars);
rng(3);

load ./data/Ameriflux_8day;
load ./output/DrylANNd_8day.mat;
n = length(Ameriflux_8day);

dMAE_GPP = NaN(ks,n);
dMAE_NEE = NaN(ks,n);
dMAE_ET = NaN(ks,n);

% Loop through each site and calculate change in MAE when variable is
% destroyed
for i = 1:n
    % Convert monthly mean latent heat flux to monthly mean daily ET
    Ameriflux_8day(i).ET = Ameriflux_8day(i).LE * (1/1000000) * 60 * 60 * 24 * 0.408; % W m-2 --> MJ m-2 day-2 --> mm day-1
    C = Ameriflux_8day(i);
    Xc = [extractfield(C, 'NDVI')' extractfield(C, 'EVI')' extractfield(C, 'NIRv')' ...
        extractfield(C, 'kNDVI')' extractfield(C, 'LSWI1')' extractfield(C, 'LSWI2')' extractfield(C, 'LSWI3')' ...
        extractfield(C, 'MOD11_Day')' extractfield(C, 'MOD11_Night')' extractfield(C, 'MYD11_Day')' extractfield(C, 'MYD11_Night')' ...
        extractfield(C, 'L4SM_Root')' extractfield(C, 'L4SM_Surf')' extractfield(C, 'L4SM_Tsoil')' ...
        extractfield(C, 'MCD12_FOR')' extractfield(C, 'MCD12_GRS')' extractfield(C, 'MCD12_SAV')' extractfield(C, 'MCD12_SHB')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 
    
    % Initialize validation matrix
    Yv = NaN(size(Yc,1), size(Xc,2), nsims);
    Yvv = NaN(size(Yc,1), size(Xc,2), nsims);
    
    nets = DrylANNd.NNets;
    
    for k = 1:ks
        
        kidx = find(strcmp(vars(k), DrylANNd.Xnames));

        mu = nanmean(Xc(kidx,:));
        s = nanstd(Xc(kidx,:));
        
        for j = 1:nsims
            
            Xcc = Xc;
            Xcc(kidx, :) = normrnd(mu, s, [1, size(Xc, 2)]);
            
            net = nets{randi(length(nets), 1)};
            Yvv(:,:,j) = net(Xcc) .* DrylANNd.Yscale + DrylANNd.Yoffset;
            Yv(:,:,j) = net(Xc) .* DrylANNd.Yscale + DrylANNd.Yoffset;

        end
        Yv_mean = squeeze(nanmean(Yv(:,:,:), 3));
        Yvv_mean = squeeze(nanmean(Yvv(:,:,:), 3));
        
        dMAE_GPP(k, i) = nanmean(abs(Yvv_mean(1,:) - Yc(1,:))) - nanmean(abs(Yv_mean(1,:) - Yc(1,:)));
        dMAE_NEE(k, i) = nanmean(abs(Yvv_mean(2,:) - Yc(2,:))) - nanmean(abs(Yv_mean(2,:) - Yc(2,:)));
        dMAE_ET(k, i) = nanmean(abs(Yvv_mean(3,:) - Yc(3,:))) - nanmean(abs(Yv_mean(3,:) - Yc(3,:)));
        
    end
end
toc

% Plot GPP variable importance
varlabels = {'NDVI','EVI','NIRv','kNDVI','LSWI (band 5)','LSWI (band 6)','LSWI (band 7)',...
    'MOD11 (Day)','MOD11 (Night)','MYD11 (Day)','MYD11 (Night)',...
    'L4SM (rootzone)','L4SM (surface)','L4SM (T_{soil})'};
lc = {Ameriflux_8day.IGBP}; 
lc(strcmp(lc, 'CSH') | strcmp(lc, 'OSH')) = {'SHB'};
lc(strcmp(lc, 'WSA')) = {'SAV'};
lc(strcmp({Ameriflux_8day.Site}, 'US-Mpj')) = {'SAV'};
ulc = unique(lc);
clr = wesanderson('aquatic4'); clr(3,:) = [];

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 5 4];

ym = nanmedian(dMAE_GPP, 2);
[~,idx] = sort(ym,'ascend');

for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    dmae = dMAE_GPP(idx, lcidx);
    scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)', [],1), 10, clr(i,:), 'filled')
    hold on;
end
scatter(ym(idx), 1:ks, 40, 'k', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaMAE (g C m^{-2} day^{-1})')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','w','FontSize',9)
ax.Position(1) = 0.22;
ax.Position(3) = 0.75;
text(repmat(ax.XLim(1),1,ks), 1:ks, varlabels(idx), 'HorizontalAlignment','right','FontSize',9)
lgd = legend('ENF','GRA','SAV','SHB','Median', 'Location','southeast', 'FontSize',9);
legend('boxoff')

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/DrylANNd_variableimportance_GPP_8day.tif')
close all;

% Plot NEE variable importance
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 5 4];

ym = nanmedian(dMAE_NEE, 2);
[~,idx] = sort(ym,'ascend');

for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    dmae = dMAE_NEE(idx, lcidx);
    scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)', [],1), 10, clr(i,:), 'filled')
    hold on;
end
scatter(ym(idx), 1:ks, 40, 'k', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaMAE (g C m^{-2} day^{-1})')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','w','FontSize',9)
ax.Position(1) = 0.22;
ax.Position(3) = 0.75;
text(repmat(ax.XLim(1),1,ks), 1:ks, varlabels(idx), 'HorizontalAlignment','right','FontSize',9)
lgd = legend('ENF','GRA','SAV','SHB','Median', 'Location','southeast', 'FontSize',9);
legend('boxoff')

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/DrylANNd_variableimportance_NEE_8day.tif')
close all;

% Plot ET variable importance
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 5 4];

ym = nanmedian(dMAE_ET, 2);
[~,idx] = sort(ym,'ascend');

for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    dmae = dMAE_ET(idx, lcidx);
    scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)', [],1), 10, clr(i,:), 'filled')
    hold on;
end
scatter(ym(idx), 1:ks, 40, 'k', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaMAE (mm day^{-1})')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','w','FontSize',9)
ax.Position(1) = 0.22;
ax.Position(3) = 0.75;
text(repmat(ax.XLim(1),1,ks), 1:ks, varlabels(idx), 'HorizontalAlignment','right','FontSize',9)
lgd = legend('ENF','GRA','SAV','SHB','Median', 'Location','southeast', 'FontSize',9);
legend('boxoff')

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/DrylANNd_variableimportance_ET_8day.tif')
close all;


