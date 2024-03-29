% validation stats
alphabet = 'abcdefghijklmnopqrstuvwxyz';
xlbs = {'CZ2','CZ3','Hn2','Hn3','Jo2','KLS','Me6','Mpj','MtB','Rls','Rms','Rwf','Rws','SCg','SCs','SCw','SRG','SRM','SRS','Seg','Ses','Ton','Var','Vcm','Vcp','Whs','Wjs','Wkg'};

load ./output/validation/monthly/DrylANNd_Ameriflux_validation.mat;
n = length(Ameriflux_monthly);
lc = {Ameriflux_monthly.IGBP};
lc{strcmp({Ameriflux_monthly.Site},'US-Mpj')} = 'SAV';
lc = strrep(lc, 'CSH', 'SHB');
lc = strrep(lc, 'OSH', 'SHB');
lc = strrep(lc, 'WSA', 'SAV');
ulc = unique(lc);
clr = wesanderson('aquatic4'); clr(3,:) = [];

[~, I] = sort(lc);
Ameriflux_monthly = Ameriflux_monthly(I);
lc = lc(I);
xlbs = xlbs(I);

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 6.5 6];

%% GPP
% Overall scatter
subplot(3,3,1)
ylim = [-1 10];
plot(ylim, ylim, 'k-')
hold on;
for i = 1:n
    ia = find(strcmp(lc{i}, ulc));
    scatter(Ameriflux_monthly(i).GPP, Ameriflux_monthly(i).GPP_DrylANNd, 5, clr(ia,:), 'filled')
end
set(gca, 'XLim',ylim, 'YLim',ylim, 'TickDir','out', 'TickLength',[0.02 0.])
box off;
hold off;
y = extractfield(Ameriflux_monthly,'GPP');
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd');
r = corr(y', yhat', 'rows','pairwise')^2;
mae = mean(abs(y-yhat), "omitnan");
text(ylim(1)+0.6*diff(ylim), ylim(1)+0.2*diff(ylim), ['R^{2} = ', sprintf('%.2f', r)], 'FontSize',8)
text(ylim(1)+0.6*diff(ylim), ylim(1)+0.1*diff(ylim), ['MAE = ', sprintf('%.2f', mae)], 'FontSize',8)
text(ylim(1)+0.05*diff(ylim), ylim(2), 'a', 'FontSize',12)
xlabel('observed GPP (g C m^{-2} day^{-1})', 'FontSize',8)
ylabel('modeled GPP (g C m^{-2} day^{-1})', 'FontSize',8)

% R^2 at each site
subplot(3,3,[2 3])
for i = 1:n
    
    y = Ameriflux_monthly(i).GPP;
    yhat = Ameriflux_monthly(i).GPP_DrylANNd;
    ib = ~isnan(yhat);
    r = corr(y(ib), yhat(ib), 'rows','pairwise')^2;

    ia = find(strcmp(lc{i}, ulc));
    bar(i, r, 'FaceColor',clr(ia, :), 'FaceAlpha',0.7, 'EdgeColor',clr(ia, :), 'LineWidth',2)
    hold on;
    
    r = corr(y(ib), Ameriflux_monthly(i).MOD17_GPP(ib), 'rows','pairwise')^2;
    plot(i, r, '+', 'Color', [0.2 0.2 0.2], 'LineWidth',1.2)
end

% ENF overall
C = Ameriflux_monthly(strcmp(lc, ulc(1)));
y = extractfield(C, 'GPP');
yhat1 = extractfield(C, 'GPP_DrylANNd');
yhat2 = extractfield(C, 'MOD17_GPP');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
b1 = bar(n+2, r, 'FaceColor',clr(1, :), 'FaceAlpha',0.7, 'EdgeColor',clr(1, :), 'LineWidth',2);
r = corr(y(ib)', yhat2(ib)', 'rows','pairwise')^2;
p1 = plot(n+2, r, '+', 'Color', [0.2 0.2 0.2], 'LineWidth',1.2);

% GRS overall
C = Ameriflux_monthly(strcmp(lc, ulc(2)));
y = extractfield(C, 'GPP');
yhat1 = extractfield(C, 'GPP_DrylANNd');
yhat2 = extractfield(C, 'MOD17_GPP');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
b2 = bar(n+3, r, 'FaceColor',clr(2, :), 'FaceAlpha',0.7, 'EdgeColor',clr(2, :), 'LineWidth',2);
r = corr(y(ib)', yhat2(ib)', 'rows','pairwise')^2;
plot(n+3, r, '+', 'Color', [0.2 0.2 0.2], 'LineWidth',1.2)

% SAV overall
C = Ameriflux_monthly(strcmp(lc, ulc(3)));
y = extractfield(C, 'GPP');
yhat1 = extractfield(C, 'GPP_DrylANNd');
yhat2 = extractfield(C, 'MOD17_GPP');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
b3 = bar(n+4, r, 'FaceColor',clr(3, :), 'FaceAlpha',0.7, 'EdgeColor',clr(3, :), 'LineWidth',2);
r = corr(y(ib)', yhat2(ib)', 'rows','pairwise')^2;
plot(n+4, r, '+', 'Color', [0.2 0.2 0.2], 'LineWidth',1.2)

% SHB overall
C = Ameriflux_monthly(strcmp(lc, ulc(4)));
y = extractfield(C, 'GPP');
yhat1 = extractfield(C, 'GPP_DrylANNd');
yhat2 = extractfield(C, 'MOD17_GPP');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
b4 = bar(n+5, r, 'FaceColor',clr(4, :), 'FaceAlpha',0.7, 'EdgeColor',clr(4, :), 'LineWidth',2);
r = corr(y(ib)', yhat2(ib)', 'rows','pairwise')^2;
plot(n+5, r, '+', 'Color', [0.2 0.2 0.2], 'LineWidth',1.2)

box off;
set(gca, 'YLim', [0 1], 'YAxisLocation','right', 'XTick',[1:n (n+2):(n+5)],...
    'XTickLabel',[xlbs,{'ENF','GRS','SAV','SHB'}], 'FontSize',8, 'TickDir','out', 'TickLength',[0.01 0.])
text(1,1,'b', 'FontSize',12)
ylb = ylabel('R^{2}', 'Rotation',0, 'HorizontalAlignment','left', 'VerticalAlignment','middle');
ylb.Position(1) = 37;

lgd = legend([b1, b2, b3, b4, p1], 'ENF', 'GRS', 'SAV', 'SHB', 'MODIS', ...
    'Location','northoutside', 'Orientation','horizontal');
lgd.Position(1) = 0.38;
lgd.Position(2) = 0.96;
legend('boxoff')

%% NEE
% Overall scatter
subplot(3,3,4)
ylim = [-6 4];
plot(ylim, ylim, 'k-')
hold on;
for i = 1:n
    ia = find(strcmp(lc{i}, ulc));
    scatter(Ameriflux_monthly(i).NEE, Ameriflux_monthly(i).NEE_DrylANNd, 5, clr(ia,:), 'filled')
end
set(gca, 'XLim',ylim, 'YLim',ylim, 'TickDir','out', 'TickLength',[0.02 0.])
box off;
hold off;
y = extractfield(Ameriflux_monthly,'NEE');
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd');
r = corr(y', yhat', 'rows','pairwise')^2;
mae = mean(abs(y-yhat), "omitnan");
text(ylim(1)+0.6*diff(ylim), ylim(1)+0.2*diff(ylim), ['R^{2} = ', sprintf('%.2f', r)], 'FontSize',8)
text(ylim(1)+0.6*diff(ylim), ylim(1)+0.1*diff(ylim), ['MAE = ', sprintf('%.2f', mae)], 'FontSize',8)
text(ylim(1)+0.05*diff(ylim), ylim(2), 'c', 'FontSize',12)
xlabel('observed NEE (g C m^{-2} day^{-1})', 'FontSize',8)
ylabel('modeled NEE (g C m^{-2} day^{-1})', 'FontSize',8)

% R^2 at each site
subplot(3,3,[5 6])
for i = 1:n
    
    y = Ameriflux_monthly(i).NEE;
    yhat = Ameriflux_monthly(i).NEE_DrylANNd;
    ib = ~isnan(yhat);
    r = corr(y(ib), yhat(ib), 'rows','pairwise')^2;

    ia = find(strcmp(lc{i}, ulc));
    bar(i, r, 'FaceColor',clr(ia, :), 'FaceAlpha',0.7, 'EdgeColor',clr(ia, :), 'LineWidth',2)
    hold on;
    
end

% ENF overall
C = Ameriflux_monthly(strcmp(lc, ulc(1)));
y = extractfield(C, 'NEE');
yhat1 = extractfield(C, 'NEE_DrylANNd');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
bar(n+2, r, 'FaceColor',clr(1, :), 'FaceAlpha',0.7, 'EdgeColor',clr(1, :), 'LineWidth',2)

% GRS overall
C = Ameriflux_monthly(strcmp(lc, ulc(2)));
y = extractfield(C, 'NEE');
yhat1 = extractfield(C, 'NEE_DrylANNd');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
bar(n+3, r, 'FaceColor',clr(2, :), 'FaceAlpha',0.7, 'EdgeColor',clr(2, :), 'LineWidth',2)

% SAV overall
C = Ameriflux_monthly(strcmp(lc, ulc(3)));
y = extractfield(C, 'NEE');
yhat1 = extractfield(C, 'NEE_DrylANNd');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
bar(n+4, r, 'FaceColor',clr(3, :), 'FaceAlpha',0.7, 'EdgeColor',clr(3, :), 'LineWidth',2)

% SHB overall
C = Ameriflux_monthly(strcmp(lc, ulc(4)));
y = extractfield(C, 'NEE');
yhat1 = extractfield(C, 'NEE_DrylANNd');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
bar(n+5, r, 'FaceColor',clr(4, :), 'FaceAlpha',0.7, 'EdgeColor',clr(4, :), 'LineWidth',2)

box off;
set(gca, 'YLim', [0 1], 'YAxisLocation','right', 'XTick',[1:n (n+2):(n+5)],...
    'XTickLabel',[xlbs,{'ENF','GRS','SAV','SHB'}], 'FontSize',8, 'TickDir','out', 'TickLength',[0.01 0.])
text(1,1,'d', 'FontSize',12)
ylb = ylabel('R^{2}', 'Rotation',0, 'HorizontalAlignment','left', 'VerticalAlignment','middle');
ylb.Position(1) = 37;

%% ET
% Overall scatter
subplot(3,3,7)
ylim = [-0.2 6];
plot(ylim, ylim, 'k-')
hold on;
for i = 1:n
    ia = find(strcmp(lc{i}, ulc));
    scatter(Ameriflux_monthly(i).ET, Ameriflux_monthly(i).ET_DrylANNd, 5, clr(ia,:), 'filled')
end
set(gca, 'XLim',ylim, 'YLim',ylim, 'TickDir','out', 'TickLength',[0.02 0.])
box off;
hold off;
y = extractfield(Ameriflux_monthly,'ET');
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd');
r = corr(y', yhat', 'rows','pairwise')^2;
mae = mean(abs(y-yhat), "omitnan");
text(ylim(1)+0.6*diff(ylim), ylim(1)+0.2*diff(ylim), ['R^{2} = ', sprintf('%.2f', r)], 'FontSize',8)
text(ylim(1)+0.6*diff(ylim), ylim(1)+0.1*diff(ylim), ['MAE = ', sprintf('%.2f', mae)], 'FontSize',8)
text(ylim(1)+0.05*diff(ylim), ylim(2), 'e', 'FontSize',12)
xlabel('observed ET (mm day^{-1})', 'FontSize',8)
ylabel('modeled ET (mm day^{-1})', 'FontSize',8)

% R^2 at each site
subplot(3,3,[8 9])
for i = 1:n
    
    y = Ameriflux_monthly(i).ET;
    yhat = Ameriflux_monthly(i).ET_DrylANNd;
    ib = ~isnan(yhat);
    r = corr(y(ib), yhat(ib), 'rows','pairwise')^2;

    ia = find(strcmp(lc{i}, ulc));
    bar(i, r, 'FaceColor',clr(ia, :), 'FaceAlpha',0.7, 'EdgeColor',clr(ia, :), 'LineWidth',2)
    hold on;
    
    r = corr(y(ib), Ameriflux_monthly(i).MOD16_ET(ib), 'rows','pairwise')^2;
    plot(i, r, '+', 'Color', [0.2 0.2 0.2], 'LineWidth',1.2)
end

% ENF overall
C = Ameriflux_monthly(strcmp(lc, ulc(1)));
y = extractfield(C, 'ET');
yhat1 = extractfield(C, 'ET_DrylANNd');
yhat2 = extractfield(C, 'MOD16_ET');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
bar(n+2, r, 'FaceColor',clr(1, :), 'FaceAlpha',0.7, 'EdgeColor',clr(1, :), 'LineWidth',2)
r = corr(y(ib)', yhat2(ib)', 'rows','pairwise')^2;
plot(n+2, r, '+', 'Color', [0.2 0.2 0.2], 'LineWidth',1.2)

% GRS overall
C = Ameriflux_monthly(strcmp(lc, ulc(2)));
y = extractfield(C, 'ET');
yhat1 = extractfield(C, 'ET_DrylANNd');
yhat2 = extractfield(C, 'MOD16_ET');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
bar(n+3, r, 'FaceColor',clr(2, :), 'FaceAlpha',0.7, 'EdgeColor',clr(2, :), 'LineWidth',2)
r = corr(y(ib)', yhat2(ib)', 'rows','pairwise')^2;
plot(n+3, r, '+', 'Color', [0.2 0.2 0.2], 'LineWidth',1.2)

% SAV overall
C = Ameriflux_monthly(strcmp(lc, ulc(3)));
y = extractfield(C, 'ET');
yhat1 = extractfield(C, 'ET_DrylANNd');
yhat2 = extractfield(C, 'MOD16_ET');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
bar(n+4, r, 'FaceColor',clr(3, :), 'FaceAlpha',0.7, 'EdgeColor',clr(3, :), 'LineWidth',2)
r = corr(y(ib)', yhat2(ib)', 'rows','pairwise')^2;
plot(n+4, r, '+', 'Color', [0.2 0.2 0.2], 'LineWidth',1.2)

% SHB overall
C = Ameriflux_monthly(strcmp(lc, ulc(4)));
y = extractfield(C, 'ET');
yhat1 = extractfield(C, 'ET_DrylANNd');
yhat2 = extractfield(C, 'MOD16_ET');
ib = ~isnan(yhat1);
r = corr(y(ib)', yhat1(ib)', 'rows','pairwise')^2;
bar(n+5, r, 'FaceColor',clr(4, :), 'FaceAlpha',0.7, 'EdgeColor',clr(4, :), 'LineWidth',2)
r = corr(y(ib)', yhat2(ib)', 'rows','pairwise')^2;
plot(n+5, r, '+', 'Color', [0.2 0.2 0.2], 'LineWidth',1.2)

box off;
set(gca, 'YLim', [0 1], 'YAxisLocation','right', 'XTick',[1:n (n+2):(n+5)],...
    'XTickLabel',[xlbs,{'ENF','GRS','SAV','SHB'}], 'FontSize',8, 'TickDir','out', 'TickLength',[0.01 0.])
text(1,1,'f', 'FontSize',12)
ylb = ylabel('R^{2}', 'Rotation',0, 'HorizontalAlignment','left', 'VerticalAlignment','middle');
ylb.Position(1) = 37;

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/validation/monthly/overall-site-r2.tif')
close all;
