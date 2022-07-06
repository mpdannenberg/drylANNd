% Comparison of seasonal variability at sites with full records
alphabet = 'abcdefghijklmnopqrstuvwxyz';
includeSites = {'Me6','Mpj','Rls','Rms','Rws','SRG','SRM','Seg','Ses','Ton','Var','Vcm','Vcp','Whs','Wjs','Wkg'};
nrows = 4;
ncols = 4;

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
h.Position = [1 1 6.5 6];

ax = tight_subplot(nrows,ncols,[0.03 0.01],[0.05 0.08],[0.1 0.03]);
ylim = [0 10];

for i = 1:n
    
    yr = Ameriflux_monthly(i).Year;
    y = Ameriflux_monthly(i).GPP(yr >= 2015);
    y = reshape(y, 12, []);
    mean_y = mean(y, 2, 'omitnan');
    yhat = Ameriflux_monthly(i).GPP_DrylANNd(yr >= 2015);
    yhat = reshape(yhat, 12, []);
    mean_yhat = mean(yhat, 2, 'omitnan');
    modis = Ameriflux_monthly(i).MOD17_GPP(yr >= 2015);
    modis = reshape(modis, 12, []);
    mean_modis = mean(modis, 2, 'omitnan');

    axes(ax(i))

    p1 = plot(1:12, mean_y, 'k-', 'LineWidth',1.2);
    hold on;
    plot([1:12; 1:12],...
        [mean_y'-std(y, 0, 2, 'omitnan')'; mean_y'+std(y, 0, 2, 'omitnan')'],...
        'k-', 'LineWidth',1.2)
    p2 = plot((1:12)-0.2, mean_yhat, '-', 'LineWidth',1.2, 'Color',clr(4,:));
    plot([1:12; 1:12]-0.2,...
        [mean_yhat'-std(yhat, 0, 2, 'omitnan')'; mean_yhat'+std(yhat, 0, 2, 'omitnan')'],...
        '-', 'LineWidth',1.2, 'Color',clr(4,:))
    p3 = plot((1:12)+0.2, mean_modis, '-', 'LineWidth',1.2, 'Color',[0.6 0.6 0.6]);
    plot([1:12; 1:12]+0.2,...
        [mean_modis'-std(modis, 0, 2, 'omitnan')'; mean_modis'+std(modis, 0, 2, 'omitnan')'],...
        '-', 'LineWidth',1.2, 'Color',[0.6 0.6 0.6])
    hold off;

    set(gca, 'XLim',[0.5 12.5], 'XTick',1:12, 'TickDir','out',...
        'TickLength',[0.02 0.], 'YLim',ylim, 'YTick',ylim(1):2:ylim(2))
    if i <= (nrows-1)*ncols
        set(gca, 'XTickLabel',''); 
    else
        set(gca, 'XTickLabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); 
        xtickangle(0)
    end
    if rem(i, ncols)==1
        ylb = ylabel('GPP (g C m^{-2} day^{-1})');
        ylb.Position(1) = -2;
    else
        set(gca, 'YTickLabel','');
    end
    box off;

    text(1, ylim(2), ['US-',includeSites{i}], 'FontSize', 10)

    r = corr(mean_y, mean_yhat, 'rows','pairwise')^2;
    sdr = std(mean_yhat,'omitnan') / std(mean_y,'omitnan');
    text(1, ylim(2)-0.12*diff(ylim),...
        ['R^{2} = ', sprintf('%.2f',r), '; SDR = ', sprintf('%.2f',sdr)],...
        'FontSize',8, 'Color',clr(4,:))
    r = corr(mean_y, mean_modis, 'rows','pairwise')^2;
    sdr = std(mean_modis,'omitnan') / std(mean_y,'omitnan');
    text(1, ylim(2)-0.22*diff(ylim),...
        ['R^{2} = ', sprintf('%.2f',r), '; SDR = ', sprintf('%.2f',sdr)],...
        'FontSize',8, 'Color',[0.6 0.6 0.6])

    if i == 2
        lgd = legend([p1 p2 p3], 'Eddy covariance', 'DrylANNd', 'MODIS', 'Orientation','horizontal');
        legend('boxoff')
        lgd.FontSize = 9;
        lgd.Position(1) = 0.5 - lgd.Position(3)/2;
        lgd.Position(2) = 0.95;
    end

end

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/validation/monthly/seasonality-gpp.tif')
close all;

%% NEE
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 6.5 6];

ax = tight_subplot(nrows,ncols,[0.03 0.01],[0.05 0.08],[0.1 0.03]);
ylim = [-4 2.8];

for i = 1:n
    
    yr = Ameriflux_monthly(i).Year;
    y = Ameriflux_monthly(i).NEE(yr >= 2015);
    y = reshape(y, 12, []);
    mean_y = mean(y, 2, 'omitnan');
    yhat = Ameriflux_monthly(i).NEE_DrylANNd(yr >= 2015);
    yhat = reshape(yhat, 12, []);
    mean_yhat = mean(yhat, 2, 'omitnan');

    axes(ax(i))
    
    plot([0.5 12.5], [0 0], '-', 'Color',[0.2 0.2 0.2], 'LineWidth',0.5)
    hold on;
    p1 = plot(1:12, mean_y, 'k-', 'LineWidth',1.2);
    plot([1:12; 1:12],...
        [mean_y'-std(y, 0, 2, 'omitnan')'; mean_y'+std(y, 0, 2, 'omitnan')'],...
        'k-', 'LineWidth',1.2)
    p2 = plot((1:12)-0.2, mean_yhat, '-', 'LineWidth',1.2, 'Color',clr(4,:));
    plot([1:12; 1:12]-0.2,...
        [mean_yhat'-std(yhat, 0, 2, 'omitnan')'; mean_yhat'+std(yhat, 0, 2, 'omitnan')'],...
        '-', 'LineWidth',1.2, 'Color',clr(4,:))
    hold off;

    set(gca, 'XLim',[0.5 12.5], 'XTick',1:12, 'TickDir','out',...
        'TickLength',[0.02 0.], 'YLim',ylim, 'YTick',ylim(1):2:ylim(2))
    if i <= (nrows-1)*ncols
        set(gca, 'XTickLabel',''); 
    else
        set(gca, 'XTickLabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); 
        xtickangle(0)
    end
    if rem(i, ncols)==1
        ylb = ylabel('NEE (g C m^{-2} day^{-1})');
        ylb.Position(1) = -2;
    else
        set(gca, 'YTickLabel','');
    end
    box off;

    text(1, ylim(2), ['US-',includeSites{i}], 'FontSize', 10)

    r = corr(mean_y, mean_yhat, 'rows','pairwise')^2;
    sdr = std(mean_yhat,'omitnan') / std(mean_y,'omitnan');
    text(1, ylim(2)-0.12*diff(ylim),...
        ['R^{2} = ', sprintf('%.2f',r), '; SDR = ', sprintf('%.2f',sdr)],...
        'FontSize',8, 'Color',clr(4,:))

    if i == 2
        lgd = legend([p1 p2], 'Eddy covariance', 'DrylANNd', 'Orientation','horizontal');
        legend('boxoff')
        lgd.FontSize = 9;
        lgd.Position(1) = 0.5 - lgd.Position(3)/2;
        lgd.Position(2) = 0.95;
    end

end

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/validation/monthly/seasonality-nee.tif')
close all;

%% ET
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 6.5 6];

ax = tight_subplot(nrows,ncols,[0.03 0.01],[0.05 0.08],[0.1 0.03]);
ylim = [0 6];

for i = 1:n
    
    yr = Ameriflux_monthly(i).Year;
    y = Ameriflux_monthly(i).ET(yr >= 2015);
    y = reshape(y, 12, []);
    mean_y = mean(y, 2, 'omitnan');
    yhat = Ameriflux_monthly(i).ET_DrylANNd(yr >= 2015);
    yhat = reshape(yhat, 12, []);
    mean_yhat = mean(yhat, 2, 'omitnan');
    modis = Ameriflux_monthly(i).MOD16_ET(yr >= 2015);
    modis = reshape(modis, 12, []);
    mean_modis = mean(modis, 2, 'omitnan');

    axes(ax(i))

    p1 = plot(1:12, mean_y, 'k-', 'LineWidth',1.2);
    hold on;
    plot([1:12; 1:12],...
        [mean_y'-std(y, 0, 2, 'omitnan')'; mean_y'+std(y, 0, 2, 'omitnan')'],...
        'k-', 'LineWidth',1.2)
    p2 = plot((1:12)-0.2, mean_yhat, '-', 'LineWidth',1.2, 'Color',clr(4,:));
    plot([1:12; 1:12]-0.2,...
        [mean_yhat'-std(yhat, 0, 2, 'omitnan')'; mean_yhat'+std(yhat, 0, 2, 'omitnan')'],...
        '-', 'LineWidth',1.2, 'Color',clr(4,:))
    p3 = plot((1:12)+0.2, mean_modis, '-', 'LineWidth',1.2, 'Color',[0.6 0.6 0.6]);
    plot([1:12; 1:12]+0.2,...
        [mean_modis'-std(modis, 0, 2, 'omitnan')'; mean_modis'+std(modis, 0, 2, 'omitnan')'],...
        '-', 'LineWidth',1.2, 'Color',[0.6 0.6 0.6])
    hold off;

    set(gca, 'XLim',[0.5 12.5], 'XTick',1:12, 'TickDir','out',...
        'TickLength',[0.02 0.], 'YLim',ylim, 'YTick',ylim(1):2:ylim(2))
    if i <= (nrows-1)*ncols
        set(gca, 'XTickLabel',''); 
    else
        set(gca, 'XTickLabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); 
        xtickangle(0)
    end
    if rem(i, ncols)==1
        ylb = ylabel('ET (mm day^{-1})');
        ylb.Position(1) = -2;
    else
        set(gca, 'YTickLabel','');
    end
    box off;

    text(1, ylim(2), ['US-',includeSites{i}], 'FontSize', 10)

    r = corr(mean_y, mean_yhat, 'rows','pairwise')^2;
    sdr = std(mean_yhat,'omitnan') / std(mean_y,'omitnan');
    text(1, ylim(2)-0.12*diff(ylim),...
        ['R^{2} = ', sprintf('%.2f',r), '; SDR = ', sprintf('%.2f',sdr)],...
        'FontSize',8, 'Color',clr(4,:))
    r = corr(mean_y, mean_modis, 'rows','pairwise')^2;
    sdr = std(mean_modis,'omitnan') / std(mean_y,'omitnan');
    text(1, ylim(2)-0.22*diff(ylim),...
        ['R^{2} = ', sprintf('%.2f',r), '; SDR = ', sprintf('%.2f',sdr)],...
        'FontSize',8, 'Color',[0.6 0.6 0.6])

    if i == 2
        lgd = legend([p1 p2 p3], 'Eddy covariance', 'DrylANNd', 'MODIS', 'Orientation','horizontal');
        legend('boxoff')
        lgd.FontSize = 9;
        lgd.Position(1) = 0.5 - lgd.Position(3)/2;
        lgd.Position(2) = 0.95;
    end

end

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/validation/monthly/seasonality-et.tif')
close all;


