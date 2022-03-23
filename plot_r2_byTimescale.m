% plot r^2 by time scale

GPP_drylannd = NaN(3,1);
GPP_modis = NaN(3,1);
NEE_drylannd = NaN(3,1);
ET_drylannd = NaN(3,1);
ET_modis = NaN(3,1);

% 8-day
load ./output/validation/8day/DrylANNd_Ameriflux_validation.mat;
y = extractfield(Ameriflux_8day,'GPP');
yhat = extractfield(Ameriflux_8day,'GPP_DrylANNd');
modis = extractfield(Ameriflux_8day,'MOD17_GPP');
r = corr(y', yhat', 'rows','pairwise')^2;
GPP_drylannd(1) = r;
r = corr(y(~isnan(yhat))', modis(~isnan(yhat))', 'rows','pairwise')^2;
GPP_modis(1) = r;

y = extractfield(Ameriflux_8day,'NEE');
yhat = extractfield(Ameriflux_8day,'NEE_DrylANNd');
r = corr(y', yhat', 'rows','pairwise')^2;
NEE_drylannd(1) = r;

y = extractfield(Ameriflux_8day,'ET');
yhat = extractfield(Ameriflux_8day,'ET_DrylANNd');
modis = extractfield(Ameriflux_8day,'MOD16_ET');
r = corr(y', yhat', 'rows','pairwise')^2;
ET_drylannd(1) = r;
r = corr(y(~isnan(yhat))', modis(~isnan(yhat))', 'rows','pairwise')^2;
ET_modis(1) = r;

% 16-day
load ./output/validation/16day/DrylANNd_Ameriflux_validation.mat;
y = extractfield(Ameriflux_16day,'GPP');
yhat = extractfield(Ameriflux_16day,'GPP_DrylANNd');
modis = extractfield(Ameriflux_16day,'MOD17_GPP');
r = corr(y', yhat', 'rows','pairwise')^2;
GPP_drylannd(2) = r;
r = corr(y(~isnan(yhat))', modis(~isnan(yhat))', 'rows','pairwise')^2;
GPP_modis(2) = r;

y = extractfield(Ameriflux_16day,'NEE');
yhat = extractfield(Ameriflux_16day,'NEE_DrylANNd');
r = corr(y', yhat', 'rows','pairwise')^2;
NEE_drylannd(2) = r;

y = extractfield(Ameriflux_16day,'ET');
yhat = extractfield(Ameriflux_16day,'ET_DrylANNd');
modis = extractfield(Ameriflux_16day,'MOD16_ET');
r = corr(y', yhat', 'rows','pairwise')^2;
ET_drylannd(2) = r;
r = corr(y(~isnan(yhat))', modis(~isnan(yhat))', 'rows','pairwise')^2;
ET_modis(2) = r;

% monthly
load ./output/validation/monthly/DrylANNd_Ameriflux_validation.mat;
y = extractfield(Ameriflux_monthly,'GPP');
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd');
modis = extractfield(Ameriflux_monthly,'MOD17_GPP');
r = corr(y', yhat', 'rows','pairwise')^2;
GPP_drylannd(3) = r;
r = corr(y(~isnan(yhat))', modis(~isnan(yhat))', 'rows','pairwise')^2;
GPP_modis(3) = r;

y = extractfield(Ameriflux_monthly,'NEE');
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd');
r = corr(y', yhat', 'rows','pairwise')^2;
NEE_drylannd(3) = r;

y = extractfield(Ameriflux_monthly,'ET');
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd');
modis = extractfield(Ameriflux_monthly,'MOD16_ET');
r = corr(y', yhat', 'rows','pairwise')^2;
ET_drylannd(3) = r;
r = corr(y(~isnan(yhat))', modis(~isnan(yhat))', 'rows','pairwise')^2;
ET_modis(3) = r;

% Figure
clr = wesanderson('aquatic4'); clr(3,:) = [];
clr2 = make_cmap([1 1 1; clr(4,:)], 6);

h = figure('Color','k');
h.Units = 'inches';
h.Position = [1 1 6.5 3];

b = bar([GPP_drylannd'; NEE_drylannd'; ET_drylannd']);
b(1).FaceColor = clr2(2,:);
b(2).FaceColor = clr2(4,:);
b(3).FaceColor = clr2(6,:);
set(gca, 'Color','k', 'YColor','w', 'XColor','w', 'TickDir','out',...
    'XTickLabel',{'GPP','NEE','ET'}, 'FontSize',12)
box off;
hold on;
plot([1-0.225 1 1+0.225], GPP_modis, 'k+', 'LineWidth',1.2, 'Color', [0.2 0.2 0.2])
plot([3-0.225 3 3+0.225], ET_modis, 'k+', 'LineWidth',1.2, 'Color', [0.2 0.2 0.2])
lgd = legend(b, '8-day', '16-day', 'monthly', 'Location','north', 'Orientation','horizontal');
lgd.TextColor = 'w';
lgd.FontSize = 11;
lgd.Position(2) = 0.9;
legend('boxoff')

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./presentation/validation/timescale-r2.tif')
close all;
