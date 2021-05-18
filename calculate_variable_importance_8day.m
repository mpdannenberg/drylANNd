% Test variable importance by sequentially destroying information content
tic

nsims = 100;
vars = {'NDVI','EVI','NIRv','kNDVI',...
        'LSWI','MOD11\_Day','MOD11\_Night','MYD11\_Day','MYD11\_Night',...
        'L4SM\_Root','L4SM\_Surf','L4SM\_TSoil','L3SM\_VegOpacity'};
ks = length(vars);
rng(3);

load ./data/Ameriflux_8day;
load ./output/DrylANNd_8day.mat;
n = length(Ameriflux_8day);
% Single savanna and shrub classes
lc = {Ameriflux_8day.IGBP}; 
[Ameriflux_8day(strcmp(lc, 'WSA')).IGBP] = deal('SAV');
[Ameriflux_8day(strcmp(lc, 'OSH')|strcmp(lc, 'CSH')).IGBP] = deal('SHB');
[Ameriflux_8day(strcmp({Ameriflux_8day.Site}, 'US-Mpj')).IGBP] = deal('SAV');
clear lc;

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
        extractfield(C, 'kNDVI')' ...
        extractfield(C, 'LSWI3')' extractfield(C, 'MOD11_Day')' extractfield(C, 'MOD11_Night')' ...
        extractfield(C, 'MYD11_Day')' extractfield(C, 'MYD11_Night')' extractfield(C, 'L4SM_Root')' ...
        extractfield(C, 'L4SM_Surf')' extractfield(C, 'L4SM_Tsoil')' extractfield(C, 'L3SM_VegOpacity')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 
    Yv = NaN(3, size(Xc,2), nsims);
    Yvv = NaN(3, size(Xc,2), nsims);
    
    nets = DrylANNd(strcmp({DrylANNd.IGBP}, Ameriflux_8day(i).IGBP)).NNets;
    
    for k = 1:ks
        
        mu = nanmean(Xc(k,:));
        s = nanstd(Xc(k,:));
        
        for j = 1:nsims
            
            Xcc = Xc;
            Xcc(k, :) = normrnd(mu, s, [1, size(Xc, 2)]);
            
            net = nets{randi(length(nets), 1)};
            Yvv(:,:,j) = net(Xcc);
            Yv(:,:,j) = net(Xc);

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
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 5 4];

ym = nanmean(dMAE_GPP, 2);
yl = quantile(dMAE_GPP, 0.05, 2);
yu = quantile(dMAE_GPP, 0.95, 2);
[~,idx] = sort(ym,'ascend');

scatter(ym(idx), 1:ks, 40, 'k', 'filled')
hold on;
plot([yl(idx) yu(idx)]', [(1:ks)' (1:ks)']', 'k-')
xlabel('\DeltaMAE (g C m^{-2} day^{-1})')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','w','FontSize',9)
ax.Position(1) = 0.22;
ax.Position(3) = 0.75;
text(repmat(ax.XLim(1),1,ks), 1:ks, vars(idx), 'HorizontalAlignment','right','FontSize',9)

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/DrylANNd_variableimportance_GPP_8day.tif')
close all;

% Plot NEE variable importance
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 5 4];

ym = nanmean(dMAE_NEE, 2);
yl = quantile(dMAE_NEE, 0.05, 2);
yu = quantile(dMAE_NEE, 0.95, 2);
[~,idx] = sort(ym,'ascend');

scatter(ym(idx), 1:ks, 40, 'k', 'filled')
hold on;
plot([yl(idx) yu(idx)]', [(1:ks)' (1:ks)']', 'k-')
xlabel('\DeltaMAE (g C m^{-2} day^{-1})')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','w','FontSize',9)
ax.Position(1) = 0.22;
ax.Position(3) = 0.75;
text(repmat(ax.XLim(1),1,ks), 1:ks, vars(idx), 'HorizontalAlignment','right','FontSize',9)

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/DrylANNd_variableimportance_NEE_8day.tif')
close all;

% Plot ET variable importance
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 5 4];

ym = nanmean(dMAE_ET, 2);
yl = quantile(dMAE_ET, 0.05, 2);
yu = quantile(dMAE_ET, 0.95, 2);
[~,idx] = sort(ym,'ascend');

scatter(ym(idx), 1:ks, 40, 'k', 'filled')
hold on;
plot([yl(idx) yu(idx)]', [(1:ks)' (1:ks)']', 'k-')
xlabel('\DeltaMAE (mm day^{-1})')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','w','FontSize',9)
ax.Position(1) = 0.22;
ax.Position(3) = 0.75;
text(repmat(ax.XLim(1),1,ks), 1:ks, vars(idx), 'HorizontalAlignment','right','FontSize',9)

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/DrylANNd_variableimportance_ET_8day.tif')
close all;


