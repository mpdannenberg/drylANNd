% Comparison of (inter)annual variability at sites with full records
alphabet = 'abcdefghijklmnopqrstuvwxyz';
includeSites = {'Me6','Mpj','Rls','Rms','Rws','SRG','SRM','Seg','Ses','Ton','Var','Vcm','Vcp','Whs','Wjs','Wkg'};
nrows = 2; % number of rows in figure
ncols = 2; % number of columns in figure
windowSize = 6;
endMonth = 10;
syear = 2015;
eyear = 2020;
years = syear:eyear;
daysInMonth = [31 28 31 30 31 30 31 31 30 31 30 31];
ndays = sum(daysInMonth((endMonth-windowSize+1):endMonth));

load ./output/validation/monthly/DrylANNd_Ameriflux_validation.mat;
Ameriflux_monthly = Ameriflux_monthly(contains({Ameriflux_monthly.Site}, includeSites));
n = length(Ameriflux_monthly);
lc = {Ameriflux_monthly.IGBP};
lc = strrep(lc, 'CSH', 'SHB');
lc = strrep(lc, 'OSH', 'SHB');
lc = strrep(lc, 'WSA', 'SAV');
ulc = unique(lc);
clr = wesanderson('aquatic4'); clr(3,:) = [];

%% GPP
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 6.5 5.75];

%ax = tight_subplot(nrows,ncols,[0.1 0.1],[0.1 0.03],[0.1 0.03]);
GPP_obs = NaN(length(syear:eyear), n);
GPP_est = NaN(length(syear:eyear), n);
GPP_modis = NaN(length(syear:eyear), n);
ylim = [0 1000];
%axes(ax(1))
subplot(nrows, ncols, 1)
    
% Annual 
for i = 1:n
    
    yr = Ameriflux_monthly(i).Year;
    mo = Ameriflux_monthly(i).Month(yr >= syear);
    y = Ameriflux_monthly(i).GPP(yr >= syear);
    yhat = Ameriflux_monthly(i).GPP_DrylANNd(yr >= syear);
    modis = Ameriflux_monthly(i).MOD17_GPP(yr >= syear);

    mean_y = movmean(y, [windowSize-1 0], 'omitnan');
    mean_y = ndays*mean_y(mo == endMonth);
    GPP_obs(:,i) = mean_y;
    mean_yhat = movmean(yhat, [windowSize-1 0], 'omitnan');
    mean_yhat = ndays*mean_yhat(mo == endMonth);
    GPP_est(:,i) = mean_yhat;
    mean_modis = movmean(modis, [windowSize-1 0], 'omitnan');
    mean_modis = ndays*mean_modis(mo == endMonth);
    GPP_modis(:,i) = mean_modis;
    
    % DrylANNd
    scatter(mean_y, mean_yhat, 20, clr(4, :), 'filled')
    hold on;
    mdl = fitlm(mean_y, mean_yhat);
    a = mdl.Coefficients.Estimate(2);
    b = mdl.Coefficients.Estimate(1);
    plot([min(mean_y) max(mean_y)], [a*min(mean_y)+b a*max(mean_y)+b],...
        '-', 'LineWidth',0.8, 'Color',clr(4,:))
    
    % MODIS
    scatter(mean_y, mean_modis, 20, [0.6 0.6 0.6], 'filled')
    hold on;
    mdl = fitlm(mean_y, mean_modis);
    a = mdl.Coefficients.Estimate(2);
    b = mdl.Coefficients.Estimate(1);
    plot([min(mean_y) max(mean_y)], [a*min(mean_y)+b a*max(mean_y)+b],...
        '-', 'LineWidth',0.8, 'Color',[0.6 0.6 0.6])
    
end

set(gca,'XLim',ylim, 'YLim',ylim, 'TickDir','out', 'TickLength',[0.02 0.])
plot(ylim, ylim, '-', 'Color',[0.2 0.2 0.2])
text(ylim(2), ylim(2), '1:1', 'FontSize',8, 'HorizontalAlignment','right', 'VerticalAlignment','bottom', 'Rotation',45)
text(ylim(1)+0.05*diff(ylim), ylim(2), 'a', 'FontSize',12)

r = corr(reshape(GPP_obs, [], 1), reshape(GPP_est, [], 1), 'rows','pairwise') ^2;
mae = mean(abs(reshape(GPP_obs, [], 1) - reshape(GPP_est, [], 1)), 'omitnan');
text(ylim(1)+0.05*diff(ylim), ylim(2)-0.06*diff(ylim),...
    ['DrylANNd: R^{2} = ', sprintf('%.2f', r), '; MAE = ', sprintf('%.2f', mae)],...
    'FontSize',8, 'Color',clr(4,:))

r = corr(reshape(GPP_obs, [], 1), reshape(GPP_modis, [], 1), 'rows','pairwise') ^2;
mae = mean(abs(reshape(GPP_obs, [], 1) - reshape(GPP_modis, [], 1)), 'omitnan');
text(ylim(1)+0.05*diff(ylim), ylim(2)-0.12*diff(ylim),...
    ['MODIS: R^{2} = ', sprintf('%.2f', r), '; MAE = ', sprintf('%.2f', mae)],...
    'FontSize',8, 'Color',[0.6 0.6 0.6])

xlabel('observed GPP (g C m^{-2})')
ylabel('modeled GPP (g C m^{-2})')

% Anomalies
GPP_obs_anom = GPP_obs - repmat(mean(GPP_obs(years ~= 2020, :)), length(syear:eyear), 1);
GPP_est_anom = GPP_est - repmat(mean(GPP_est(years ~= 2020, :)), length(syear:eyear), 1);
GPP_modis_anom = GPP_modis - repmat(mean(GPP_modis(years ~= 2020, :)), length(syear:eyear), 1);
ylim = [-300 300];

subplot(nrows, ncols, 2)
for i = 1:n
    
    y = GPP_obs_anom(:,i);
    yhat = GPP_est_anom(:,i);
    modis = GPP_modis_anom(:,i);

    scatter(y, yhat, 20, clr(4, :), 'filled')
    hold on;
%     mdl = fitlm(y, yhat);
%     a = mdl.Coefficients.Estimate(2);
%     b = mdl.Coefficients.Estimate(1);
%     plot([min(y) max(y)], [a*min(y)+b a*max(y)+b],...
%         '-', 'LineWidth',0.8, 'Color',clr(4,:))
    
    % MODIS
    scatter(y, modis, 20, [0.6 0.6 0.6], 'filled')
    hold on;
%     mdl = fitlm(y, modis);
%     a = mdl.Coefficients.Estimate(2);
%     b = mdl.Coefficients.Estimate(1);
%     plot([min(y) max(y)], [a*min(y)+b a*max(y)+b],...
%         '-', 'LineWidth',0.8, 'Color',[0.6 0.6 0.6])
    
end

set(gca,'XLim',ylim, 'YLim',ylim, 'TickDir','out', 'TickLength',[0.02 0.])
plot(ylim, ylim, '-', 'Color',[0.2 0.2 0.2])
text(ylim(2), ylim(2), '1:1', 'FontSize',8, 'HorizontalAlignment','right', 'VerticalAlignment','bottom', 'Rotation',45)
text(ylim(1)+0.05*diff(ylim), ylim(2), 'b', 'FontSize',12)

r = corr(reshape(GPP_obs_anom, [], 1), reshape(GPP_est_anom, [], 1), 'rows','pairwise') ^2;
mae = mean(abs(reshape(GPP_obs_anom, [], 1) - reshape(GPP_est_anom, [], 1)), 'omitnan');
text(ylim(1)+0.05*diff(ylim), ylim(2)-0.06*diff(ylim),...
    ['DrylANNd: R^{2} = ', sprintf('%.2f', r), '; MAE = ', sprintf('%.2f', mae)],...
    'FontSize',8, 'Color',clr(4,:))

r = corr(reshape(GPP_obs_anom, [], 1), reshape(GPP_modis_anom, [], 1), 'rows','pairwise') ^2;
mae = mean(abs(reshape(GPP_obs_anom, [], 1) - reshape(GPP_modis_anom, [], 1)), 'omitnan');
text(ylim(1)+0.05*diff(ylim), ylim(2)-0.12*diff(ylim),...
    ['MODIS: R^{2} = ', sprintf('%.2f', r), '; MAE = ', sprintf('%.2f', mae)],...
    'FontSize',8, 'Color',[0.6 0.6 0.6])

xlabel('observed GPP anomaly (g C m^{-2})')
ylabel('modeled GPP anomaly (g C m^{-2})')

% Barplot comparison of 2020
[~,I] = sort(GPP_obs_anom(years==2020, :), 'ascend');

subplot(nrows, ncols, 3:4)
br = bar([GPP_obs_anom(years==2020, I); GPP_est_anom(years==2020, I); GPP_modis_anom(years==2020, I)]',...
    'FaceColor','flat');
br(1).CData = [0 0 0];
br(2).CData = clr(4,:);
br(3).CData = [0.6 0.6 0.6];
set(gca, 'XTick', 1:n, 'XTickLabel',includeSites(I), 'TickDir','out')
box off;
ylabel('2020 GPP anomaly (g C m^{-2})')
ylim = get(gca, 'YLim');
text(1, ylim(2), 'c', 'FontSize',12)
lgd = legend('observed','DrylANNd','MODIS', 'Location', 'southeast');
% lgd.Position(1) = 0.2;
% lgd.Position(2) = 0.37;
legend('boxoff')

bias = mean(abs(GPP_est_anom(years==2020, I) - GPP_obs_anom(years==2020, I)));
text(1, ylim(2)-0.08*diff(ylim),...
    ['DrylANNd: MAE = ', sprintf('%.2f', bias), ' g C m^{-2}'],...
    'FontSize',8, 'Color',clr(4,:))

bias = mean(abs(GPP_modis_anom(years==2020, I) - GPP_obs_anom(years==2020, I)));
text(1, ylim(2)-0.16*diff(ylim),...
    ['MODIS: MAE = ', sprintf('%.2f', bias), ' g C m^{-2}'],...
    'FontSize',8, 'Color',[0.6 0.6 0.6])

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/validation/monthly/annual-gpp.tif')
close all;


%% ET
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 6.5 5.75];

%ax = tight_subplot(nrows,ncols,[0.1 0.1],[0.1 0.03],[0.1 0.03]);
ET_obs = NaN(length(syear:eyear), n);
ET_est = NaN(length(syear:eyear), n);
ET_modis = NaN(length(syear:eyear), n);
ylim = [0 600];
%axes(ax(1))
subplot(nrows, ncols, 1)
    
% Annual 
for i = 1:n
    
    yr = Ameriflux_monthly(i).Year;
    mo = Ameriflux_monthly(i).Month(yr >= syear);
    y = Ameriflux_monthly(i).ET(yr >= syear);
    yhat = Ameriflux_monthly(i).ET_DrylANNd(yr >= syear);
    modis = Ameriflux_monthly(i).MOD16_ET(yr >= syear);

    mean_y = movmean(y, [windowSize-1 0], 'omitnan');
    mean_y = ndays*mean_y(mo == endMonth);
    ET_obs(:,i) = mean_y;
    mean_yhat = movmean(yhat, [windowSize-1 0], 'omitnan');
    mean_yhat = ndays*mean_yhat(mo == endMonth);
    ET_est(:,i) = mean_yhat;
    mean_modis = movmean(modis, [windowSize-1 0], 'omitnan');
    mean_modis = ndays*mean_modis(mo == endMonth);
    ET_modis(:,i) = mean_modis;
    
    % DrylANNd
    scatter(mean_y, mean_yhat, 20, clr(4, :), 'filled')
    hold on;
    mdl = fitlm(mean_y, mean_yhat);
    a = mdl.Coefficients.Estimate(2);
    b = mdl.Coefficients.Estimate(1);
    plot([min(mean_y) max(mean_y)], [a*min(mean_y)+b a*max(mean_y)+b],...
        '-', 'LineWidth',0.8, 'Color',clr(4,:))
    
    % MODIS
    scatter(mean_y, mean_modis, 20, [0.6 0.6 0.6], 'filled')
    hold on;
    mdl = fitlm(mean_y, mean_modis);
    a = mdl.Coefficients.Estimate(2);
    b = mdl.Coefficients.Estimate(1);
    plot([min(mean_y) max(mean_y)], [a*min(mean_y)+b a*max(mean_y)+b],...
        '-', 'LineWidth',0.8, 'Color',[0.6 0.6 0.6])
    
end

set(gca,'XLim',ylim, 'YLim',ylim, 'TickDir','out', 'TickLength',[0.02 0.])
plot(ylim, ylim, '-', 'Color',[0.2 0.2 0.2])
text(ylim(2), ylim(2), '1:1', 'FontSize',8, 'HorizontalAlignment','right', 'VerticalAlignment','bottom', 'Rotation',45)
text(ylim(1)+0.05*diff(ylim), ylim(2), 'a', 'FontSize',12)

r = corr(reshape(ET_obs, [], 1), reshape(ET_est, [], 1), 'rows','pairwise') ^2;
mae = mean(abs(reshape(ET_obs, [], 1) - reshape(ET_est, [], 1)), 'omitnan');
text(ylim(1)+0.05*diff(ylim), ylim(2)-0.06*diff(ylim),...
    ['DrylANNd: R^{2} = ', sprintf('%.2f', r), '; MAE = ', sprintf('%.2f', mae)],...
    'FontSize',8, 'Color',clr(4,:))

r = corr(reshape(ET_obs, [], 1), reshape(ET_modis, [], 1), 'rows','pairwise') ^2;
mae = mean(abs(reshape(ET_obs, [], 1) - reshape(ET_modis, [], 1)), 'omitnan');
text(ylim(1)+0.05*diff(ylim), ylim(2)-0.12*diff(ylim),...
    ['MODIS: R^{2} = ', sprintf('%.2f', r), '; MAE = ', sprintf('%.2f', mae)],...
    'FontSize',8, 'Color',[0.6 0.6 0.6])

xlabel('observed ET (mm)')
ylabel('modeled ET (mm)')

% Anomalies
ET_obs_anom = ET_obs - repmat(mean(ET_obs(years ~= 2020, :)), length(syear:eyear), 1);
ET_est_anom = ET_est - repmat(mean(ET_est(years ~= 2020, :)), length(syear:eyear), 1);
ET_modis_anom = ET_modis - repmat(mean(ET_modis(years ~= 2020, :)), length(syear:eyear), 1);
ylim = [-200 200];

subplot(nrows, ncols, 2)
for i = 1:n
    
    y = ET_obs_anom(:,i);
    yhat = ET_est_anom(:,i);
    modis = ET_modis_anom(:,i);

    scatter(y, yhat, 20, clr(4, :), 'filled')
    hold on;
%     mdl = fitlm(y, yhat);
%     a = mdl.Coefficients.Estimate(2);
%     b = mdl.Coefficients.Estimate(1);
%     plot([min(y) max(y)], [a*min(y)+b a*max(y)+b],...
%         '-', 'LineWidth',0.8, 'Color',clr(4,:))
    
    % MODIS
    scatter(y, modis, 20, [0.6 0.6 0.6], 'filled')
    hold on;
%     mdl = fitlm(y, modis);
%     a = mdl.Coefficients.Estimate(2);
%     b = mdl.Coefficients.Estimate(1);
%     plot([min(y) max(y)], [a*min(y)+b a*max(y)+b],...
%         '-', 'LineWidth',0.8, 'Color',[0.6 0.6 0.6])
    
end

set(gca,'XLim',ylim, 'YLim',ylim, 'TickDir','out', 'TickLength',[0.02 0.])
plot(ylim, ylim, '-', 'Color',[0.2 0.2 0.2])
text(ylim(2), ylim(2), '1:1', 'FontSize',8, 'HorizontalAlignment','right', 'VerticalAlignment','bottom', 'Rotation',45)
text(ylim(1)+0.05*diff(ylim), ylim(2), 'b', 'FontSize',12)

r = corr(reshape(ET_obs_anom, [], 1), reshape(ET_est_anom, [], 1), 'rows','pairwise') ^2;
mae = mean(abs(reshape(ET_obs_anom, [], 1) - reshape(ET_est_anom, [], 1)), 'omitnan');
text(ylim(1)+0.05*diff(ylim), ylim(2)-0.06*diff(ylim),...
    ['DrylANNd: R^{2} = ', sprintf('%.2f', r), '; MAE = ', sprintf('%.2f', mae)],...
    'FontSize',8, 'Color',clr(4,:))

r = corr(reshape(ET_obs_anom, [], 1), reshape(ET_modis_anom, [], 1), 'rows','pairwise') ^2;
mae = mean(abs(reshape(ET_obs_anom, [], 1) - reshape(ET_modis_anom, [], 1)), 'omitnan');
text(ylim(1)+0.05*diff(ylim), ylim(2)-0.12*diff(ylim),...
    ['MODIS: R^{2} = ', sprintf('%.2f', r), '; MAE = ', sprintf('%.2f', mae)],...
    'FontSize',8, 'Color',[0.6 0.6 0.6])

xlabel('observed ET anomaly (mm)')
ylabel('modeled ET anomaly (mm)')

% Barplot comparison of 2020
[~,I] = sort(ET_obs_anom(years==2020, :), 'ascend');

subplot(nrows, ncols, 3:4)
br = bar([ET_obs_anom(years==2020, I); ET_est_anom(years==2020, I); ET_modis_anom(years==2020, I)]',...
    'FaceColor','flat');
br(1).CData = [0 0 0];
br(2).CData = clr(4,:);
br(3).CData = [0.6 0.6 0.6];
set(gca, 'XTick', 1:n, 'XTickLabel',includeSites(I), 'TickDir','out')
box off;
ylabel('2020 ET anomaly (mm)')
ylim = get(gca, 'YLim');
text(1, ylim(2), 'c', 'FontSize',12)
lgd = legend('observed','DrylANNd','MODIS', 'Location', 'southeast');
legend('boxoff')

bias = mean(abs(ET_est_anom(years==2020, I) - ET_obs_anom(years==2020, I)));
text(2, ylim(2),...
    ['DrylANNd: MAE = ', sprintf('%.2f', bias), ' mm'],...
    'FontSize',8, 'Color',clr(4,:))

bias = mean(abs(ET_modis_anom(years==2020, I) - ET_obs_anom(years==2020, I)));
text(2, ylim(2)-0.08*diff(ylim),...
    ['MODIS: MAE = ', sprintf('%.2f', bias), ' mm'],...
    'FontSize',8, 'Color',[0.6 0.6 0.6])

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/validation/monthly/annual-et.tif')
close all;

