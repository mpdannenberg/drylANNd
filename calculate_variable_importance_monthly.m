% Test variable importance by sequentially destroying information content
tic

nsims = 100;
vars = {'NDVI','EVI','NIRv','kNDVI',...
    'LSWI1','LSWI2','LSWI3','MOD11_Day','MOD11_Night','MYD11_Day','MYD11_Night',...
    'L4SM_Root','L4SM_Surf','L4SM_TSoil'};
ks = length(vars);
rng(3);
excludeSites = {'MX-EMg','US-CZ4','US-Me2','US-Sne','US-Snf'}; % exclude sites from calibration (not dryland, missing data, or weird site)
stagger = 0.08;

load ./data/Ameriflux_monthly;
load ./output/DrylANNd_monthly.mat;
Ameriflux_monthly = Ameriflux_monthly(~ismember({Ameriflux_monthly.Site}, excludeSites));
n = length(Ameriflux_monthly);
yscale = DrylANNd.Yscale;
yoffset = DrylANNd.Yoffset;

dMAE_GPP = NaN(ks,n);
dMAE_NEE = NaN(ks,n);
dMAE_ET = NaN(ks,n);
dR2_GPP = NaN(ks,n);
dR2_NEE = NaN(ks,n);
dR2_ET = NaN(ks,n);

% Loop through each site and calculate change in MAE when variable is
% destroyed
for i = 1:n
    % Convert monthly mean latent heat flux to monthly mean daily ET
    Ameriflux_monthly(i).ET = Ameriflux_monthly(i).LE * (1/1000000) * 60 * 60 * 24 * 0.408; % W m-2 --> MJ m-2 day-2 --> mm day-1
    C = Ameriflux_monthly(i);
    Xc = [extractfield(C, 'NDVI')' extractfield(C, 'EVI')' extractfield(C, 'NIRv')' ...
        extractfield(C, 'kNDVI')' extractfield(C, 'LSWI1')' extractfield(C, 'LSWI2')' extractfield(C, 'LSWI3')' ...
        extractfield(C, 'MOD11_Day')' extractfield(C, 'MOD11_Night')' extractfield(C, 'MYD11_Day')' extractfield(C, 'MYD11_Night')' ...
        extractfield(C, 'L4SM_Root')' extractfield(C, 'L4SM_Surf')' extractfield(C, 'L4SM_Tsoil')' ...
        extractfield(C, 'Rangeland_AFG')' extractfield(C, 'Rangeland_PFG')' extractfield(C, 'Rangeland_SHR')' extractfield(C, 'Rangeland_TRE')' extractfield(C, 'Rangeland_LTR')' extractfield(C, 'Rangeland_BGR')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 
    
    % Initialize validation matrix
    Yv = NaN(size(Yc,1), size(Xc,2), nsims);
    Yvv = NaN(size(Yc,1), size(Xc,2), nsims);

    Ys = repmat(yscale, 1, size(Xc,2));
    Ym = repmat(yoffset, 1, size(Xc,2));

    nets = DrylANNd(i).NNets;
    
    for k = 1:ks
        
        kidx = find(strcmp(vars(k), DrylANNd(i).Xnames));

        mu = mean(Xc(kidx,:), 'omitnan');
        s = std(Xc(kidx,:), 'omitnan');
        
        for j = 1:nsims
            
            Xcc = Xc;
            Xcc(kidx, :) = normrnd(mu, s, [1, size(Xc, 2)]);
            
            net = nets{randi(length(nets), 1)};
            Yvv(:,:,j) = net(Xcc) .* Ys + Ym;
            Yv(:,:,j) = net(Xc) .* Ys + Ym;

        end
        Yv_mean = squeeze(nanmean(Yv(:,:,:), 3));
        Yvv_mean = squeeze(nanmean(Yvv(:,:,:), 3));
        
        dMAE_GPP(k, i) = 100 * (nanmean(abs(Yvv_mean(1,:) - Yc(1,:))) - nanmean(abs(Yv_mean(1,:) - Yc(1,:)))) ./ nanmean(abs(Yv_mean(1,:) - Yc(1,:)));
        dMAE_NEE(k, i) = 100 * (nanmean(abs(Yvv_mean(2,:) - Yc(2,:))) - nanmean(abs(Yv_mean(2,:) - Yc(2,:)))) ./ nanmean(abs(Yv_mean(2,:) - Yc(2,:)));
        dMAE_ET(k, i) = 100 * (nanmean(abs(Yvv_mean(3,:) - Yc(3,:))) - nanmean(abs(Yv_mean(3,:) - Yc(3,:)))) ./ nanmean(abs(Yv_mean(3,:) - Yc(3,:)));

        dR2_GPP(k, i) = corr(Yvv_mean(1,:)', Yc(1,:)', 'rows','pairwise')^2 - corr(Yv_mean(1,:)', Yc(1,:)', 'rows','pairwise')^2;
        dR2_NEE(k, i) = corr(Yvv_mean(2,:)', Yc(2,:)', 'rows','pairwise')^2 - corr(Yv_mean(2,:)', Yc(2,:)', 'rows','pairwise')^2;
        dR2_ET(k, i) = corr(Yvv_mean(3,:)', Yc(3,:)', 'rows','pairwise')^2 - corr(Yv_mean(3,:)', Yc(3,:)', 'rows','pairwise')^2;
        
    end
end
toc

% Plot variable importance
varlabels = {'NDVI','EVI','NIRv','kNDVI','LSWI (band 5)','LSWI (band 6)','LSWI (band 7)',...
    'MOD11 (Day)','MOD11 (Night)','MYD11 (Day)','MYD11 (Night)',...
    'L4SM (rootzone)','L4SM (surface)','L4SM (T_{soil})'};
lc = {Ameriflux_monthly.IGBP}; 
lc(strcmp(lc, 'CSH') | strcmp(lc, 'OSH')) = {'SHB'};
lc(strcmp(lc, 'WSA')) = {'SAV'};
lc(strcmp({Ameriflux_monthly.Site}, 'US-Mpj')) = {'SAV'};
ulc = unique(lc);
clr = wesanderson('aquatic4'); clr(3,:) = [];

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 6.5 8];

axf = tight_subplot(3, 2, 0.08, [0.1 0.04], [0.1 0.04]);

% GPP
xlim = [-25 110];
axes(axf(1))
ym = nanmedian(dMAE_GPP, 2);
[~,idx] = sort(ym,'ascend'); % if sorting by importance, add (idx) to the "dmae = ...", "scatter(ym...", and "text(repmat..." lines

plot([0 0], [0 ks+0.5], 'k-')
hold on;
for i = 1:ks
    plot(xlim, [i i], '-', 'Color',[0.9 0.9 0.9])
end
pHandle = cell([1 length(ulc)]);
for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    dmae = dMAE_GPP(:, lcidx);
    pHandle{i} = scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)'+normrnd(0,stagger,size(dmae)), [],1), 15, clr(i,:), 'filled');
end
scatter(ym, 1:ks, 50, 'k', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaMAE (%)')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','w','FontSize',9, 'XLim',xlim, 'YTick',1:ks, 'YDir','reverse')
ax.Position(1) = 0.14;
ax.Position(3) = 0.4;
text(repmat(ax.XLim(1),1,ks), 1:ks, varlabels, 'HorizontalAlignment','right','FontSize',8)
lgd = legend([pHandle{1} pHandle{2} pHandle{3} pHandle{4}], 'ENF','GRS','SAV','SHB', 'Location','northoutside', 'FontSize',7, 'Orientation','horizontal');
lgd.Position(1) = 0.5 - lgd.Position(3)/2;
lgd.Position(2) = 0.97;
legend('boxoff')
text(xlim(2),ks,'a', 'FontSize',12, 'HorizontalAlignment','right')
hold off;

xlim = [-0.65 0.25];
axes(axf(2))
ym = nanmedian(dR2_GPP, 2);
[~,idx] = sort(ym,'ascend');

plot([0 0], [0 ks+0.5], 'k-')
hold on;
for i = 1:ks
    plot(xlim, [i i], '-', 'Color',[0.9 0.9 0.9])
end
pHandle = cell([1 length(ulc)]);
for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    dmae = dR2_GPP(:, lcidx);
    pHandle{i} = scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)'+normrnd(0,stagger,size(dmae)), [],1), 15, clr(i,:), 'filled');
end
scatter(ym, 1:ks, 50, 'k', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaR^{2}')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','none','FontSize',9, 'XLim',xlim, 'YTick',1:ks, 'YDir','reverse', 'XDir','reverse')
ax.Position(1) = 0.57;
ax.Position(3) = 0.4;
text(xlim(1),ks,'b', 'FontSize',12, 'HorizontalAlignment','right')
hold off;

% NEE
xlim = [-25 110];
axes(axf(3))
ym = nanmedian(dMAE_NEE, 2);
[~,idx] = sort(ym,'ascend');

plot([0 0], [0 ks+0.5], 'k-')
hold on;
for i = 1:ks
    plot(xlim, [i i], '-', 'Color',[0.9 0.9 0.9])
end
for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    %dmae = dMAE_NEE(idx, lcidx);
    dmae = dMAE_NEE(:, lcidx);
    scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)'+normrnd(0,stagger,size(dmae)), [],1), 15, clr(i,:), 'filled')
end
scatter(ym(:), 1:ks, 50, 'k', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaMAE (%)')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','w','FontSize',9,'XLim',xlim, 'YDir','reverse')
ax.Position(1) = 0.14;
ax.Position(3) = 0.4;
text(repmat(ax.XLim(1),1,ks), 1:ks, varlabels(:), 'HorizontalAlignment','right','FontSize',8)
text(xlim(2),ks,'c', 'FontSize',12, 'HorizontalAlignment','right')

xlim = [-0.65 0.25];
axes(axf(4))
ym = nanmedian(dR2_NEE, 2);
[~,idx] = sort(ym,'ascend');

plot([0 0], [0 ks+0.5], 'k-')
hold on;
for i = 1:ks
    plot(xlim, [i i], '-', 'Color',[0.9 0.9 0.9])
end
pHandle = cell([1 length(ulc)]);
for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    dmae = dR2_NEE(:, lcidx);
    pHandle{i} = scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)'+normrnd(0,stagger,size(dmae)), [],1), 15, clr(i,:), 'filled');
end
scatter(ym, 1:ks, 50, 'k', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaR^{2}')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','none','FontSize',9, 'XLim',xlim, 'YTick',1:ks, 'YDir','reverse', 'XDir','reverse')
ax.Position(1) = 0.57;
ax.Position(3) = 0.4;
text(xlim(1),ks,'d', 'FontSize',12, 'HorizontalAlignment','right')
hold off;

% ET
xlim = [-25 110];
axes(axf(5))
ym = nanmedian(dMAE_ET, 2);
[~,idx] = sort(ym,'ascend');

plot([0 0], [0 ks+0.5], 'k-')
hold on;
for i = 1:ks
    plot(xlim, [i i], '-', 'Color',[0.9 0.9 0.9])
end
for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    %dmae = dMAE_ET(idx, lcidx);
    dmae = dMAE_ET(:, lcidx);
    scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)'+normrnd(0,stagger,size(dmae)), [],1), 15, clr(i,:), 'filled')
end
scatter(ym(:), 1:ks, 50, 'k', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaMAE (%)')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','w','FontSize',9,'XLim',xlim,'YDir','reverse')
ax.Position(1) = 0.14;
ax.Position(3) = 0.4;
text(repmat(ax.XLim(1),1,ks), 1:ks, varlabels(:), 'HorizontalAlignment','right','FontSize',8)
text(xlim(2),ks,'e', 'FontSize',12, 'HorizontalAlignment','right')

xlim = [-0.65 0.25];
axes(axf(6))
ym = nanmedian(dR2_ET, 2);
[~,idx] = sort(ym,'ascend');

plot([0 0], [0 ks+0.5], 'k-')
hold on;
for i = 1:ks
    plot(xlim, [i i], '-', 'Color',[0.9 0.9 0.9])
end
pHandle = cell([1 length(ulc)]);
for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    dmae = dR2_ET(:, lcidx);
    pHandle{i} = scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)'+normrnd(0,stagger,size(dmae)), [],1), 15, clr(i,:), 'filled');
end
scatter(ym, 1:ks, 50, 'k', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaR^{2}')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','none','FontSize',9, 'XLim',xlim, 'YTick',1:ks, 'YDir','reverse', 'XDir','reverse')
ax.Position(1) = 0.57;
ax.Position(3) = 0.4;
text(xlim(1),ks,'f', 'FontSize',12, 'HorizontalAlignment','right')
hold off;

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/DrylANNd_variableimportance_monthly.tif')
close all;

%% Presentation figure
h = figure('Color','k');
h.Units = 'inches';
h.Position = [1 1 3.5 8];

axf = tight_subplot(3, 1, 0.08, [0.1 0.04], [0.1 0.04]);

% GPP
xlim = [-25 110];
axes(axf(1))
ym = nanmedian(dMAE_GPP, 2);
[~,idx] = sort(ym,'ascend');

for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    dmae = dMAE_GPP(idx, lcidx);
    scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)'+normrnd(0,stagger,size(dmae)), [],1), 10, clr(i,:), 'filled')
    hold on;
end
scatter(ym(idx), 1:ks, 40, 'w', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaMAE (%)', 'Color','w')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'FontSize',9,...
    'XLim',xlim, 'Color','k', 'XColor','w', 'YColor','k')
ax.Position(1) = 0.28;
ax.Position(3) = 0.7;
text(repmat(ax.XLim(1),1,ks), 1:ks, varlabels(idx), 'HorizontalAlignment','right','FontSize',8,'Color','w')
lgd = legend('ENF','GRS','SAV','SHB', 'Location','northoutside', 'FontSize',7, 'Orientation','horizontal', 'TextColor','w');
lgd.Position(2) = 0.97;
legend('boxoff')
text(xlim(2),1,'a', 'FontSize',12, 'HorizontalAlignment','right')

% NEE
xlim = [-25 110];
axes(axf(2))
ym = nanmedian(dMAE_NEE, 2);
[~,idx] = sort(ym,'ascend');

for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    dmae = dMAE_NEE(idx, lcidx);
    scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)'+normrnd(0,stagger,size(dmae)), [],1), 10, clr(i,:), 'filled')
    hold on;
end
scatter(ym(idx), 1:ks, 40, 'w', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaMAE (%)', 'Color','w')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','k','FontSize',9,...
    'XLim',xlim, 'Color','k', 'XColor','w')
ax.Position(1) = 0.28;
ax.Position(3) = 0.7;
text(repmat(ax.XLim(1),1,ks), 1:ks, varlabels(idx), 'HorizontalAlignment','right','FontSize',8,'Color','w')
text(xlim(2),1,'b', 'FontSize',12, 'HorizontalAlignment','right')

% ET
xlim = [-25 110];
axes(axf(3))
ym = nanmedian(dMAE_ET, 2);
[~,idx] = sort(ym,'ascend');

for i = 1:length(ulc)
    lcidx = find(strcmp(lc, ulc{i}));
    dmae = dMAE_ET(idx, lcidx);
    scatter(reshape(dmae,[],1), reshape(repmat(1:ks, length(lcidx), 1)'+normrnd(0,stagger,size(dmae)), [],1), 10, clr(i,:), 'filled')
    hold on;
end
scatter(ym(idx), 1:ks, 40, 'w', 'Marker','|', 'LineWidth',1.5)
xlabel('\DeltaMAE (%)', 'Color','w')
ax = gca;
box off;
set(ax, 'TickDir','out', 'TickLength',[0.025 0],'YColor','k','FontSize',9,...
    'XLim',xlim, 'Color','k', 'XColor','w')
ax.Position(1) = 0.28;
ax.Position(3) = 0.7;
text(repmat(ax.XLim(1),1,ks), 1:ks, varlabels(idx), 'HorizontalAlignment','right','FontSize',8,'Color','w')
text(xlim(2),1,'c', 'FontSize',12, 'HorizontalAlignment','right')

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./presentation/DrylANNd_variableimportance_monthly.tif')
close all;


