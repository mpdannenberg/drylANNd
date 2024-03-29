% Test DrylANNd model for GPP/ET/NEE prediction at SRM

nnsize = [14 6]; % size of the hidden layer(s)
nsims = 20;
rng(3);
excludeSites = {'MX-EMg','US-CZ4','US-Me2','US-Sne','US-Snf'}; % exclude sites from calibration (not dryland, missing data, or weird site)

load ./data/Ameriflux_monthly;
Ameriflux_monthly = Ameriflux_monthly(~ismember({Ameriflux_monthly.Site}, excludeSites));
n = length(Ameriflux_monthly);

% Convert monthly mean latent heat flux to monthly mean daily ET
for i = 1:n
    Ameriflux_monthly(i).ET = Ameriflux_monthly(i).LE * (1/1000000) * 60 * 60 * 24 * 0.408; % W m-2 --> MJ m-2 day-2 --> mm day-1
end

% Leave one site out at a time
for j = 1:n
    % what to do with missing data... fill with linear interpolation or
    % something? Maybe not... just loosen restrictions on how many
    % observations are needed for the monthly aggregation
    C = Ameriflux_monthly(setdiff(1:n, j)); 
    V = Ameriflux_monthly(j);
    Xc = [extractfield(C, 'NDVI')' extractfield(C, 'EVI')' extractfield(C, 'NIRv')' ...
        extractfield(C, 'kNDVI')' extractfield(C, 'LSWI1')' extractfield(C, 'LSWI2')' extractfield(C, 'LSWI3')' ...
        extractfield(C, 'MOD11_Day')' extractfield(C, 'MOD11_Night')' extractfield(C, 'MYD11_Day')' extractfield(C, 'MYD11_Night')' ...
        extractfield(C, 'L4SM_Root')' extractfield(C, 'L4SM_Surf')' extractfield(C, 'L4SM_Tsoil')' ...
        extractfield(C, 'Rangeland_AFG')' extractfield(C, 'Rangeland_PFG')' extractfield(C, 'Rangeland_SHR')' extractfield(C, 'Rangeland_TRE')' extractfield(C, 'Rangeland_LTR')' extractfield(C, 'Rangeland_BGR')']'; % Add more as needed
    Xv = [extractfield(V, 'NDVI')' extractfield(V, 'EVI')' extractfield(V, 'NIRv')' ...
        extractfield(V, 'kNDVI')' extractfield(V, 'LSWI1')' extractfield(V, 'LSWI2')' extractfield(V, 'LSWI3')' ...
        extractfield(V, 'MOD11_Day')' extractfield(V, 'MOD11_Night')' extractfield(V, 'MYD11_Day')' extractfield(V, 'MYD11_Night')' ...
        extractfield(V, 'L4SM_Root')' extractfield(V, 'L4SM_Surf')' extractfield(V, 'L4SM_Tsoil')' ...
        extractfield(V, 'Rangeland_AFG')' extractfield(V, 'Rangeland_PFG')' extractfield(V, 'Rangeland_SHR')' extractfield(V, 'Rangeland_TRE')' extractfield(V, 'Rangeland_LTR')' extractfield(V, 'Rangeland_BGR')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 
    Yv = NaN(size(Yc,1), size(Xv,2), nsims);
    
    % put all y variables on common scale (so that variance doesn't overfit
    % to WUE, which is ~1 order of magnitude greater than other variables
%     Ycm = repmat(mean(Yc, 2, 'omitnan'), 1, size(Yc, 2));
%     Ycs = repmat(std(Yc, 0, 2, 'omitnan'), 1, size(Yc, 2));
%     Yvm = repmat(mean(Yc, 2, 'omitnan'), 1, size(Yv, 2));
%     Yvs = repmat(std(Yc, 0, 2, 'omitnan'), 1, size(Yv, 2));
    Ycm = zeros(size(Yc,1), size(Yc,2));
    Ycs = ones(size(Yc,1), size(Yc,2));
    Yvm = zeros(size(Yc,1), size(Yv,2));
    Yvs = ones(size(Yc,1), size(Yv,2));
    Yc = (Yc-Ycm) ./ Ycs;
    
    nets = cell(1,nsims);
    trs = cell(1,nsims);

    for i = 1:nsims
        net = feedforwardnet(nnsize);
        net.trainParam.showWindow = false;
        net.divideParam.trainRatio = 0.75;
        net.divideParam.testRatio = 0.;
        net.divideParam.valRatio = 0.25;
        [net, tr] = train(net, Xc, Yc);

        Yv(:,:,i) = net(Xv) .* Yvs + Yvm;

        nets{i} = net;
        trs{i} = tr;
        clear net tr;
    end

    % Ensemble mean
    Yv_mean = squeeze(nanmean(Yv(:,:,:), 3));
    Yc = Yc .* Ycs + Ycm; % Transform back to original units
    Ameriflux_monthly(j).GPP_DrylANNd = Yv_mean(1,:)';
    Ameriflux_monthly(j).NEE_DrylANNd = Yv_mean(2,:)';
    Ameriflux_monthly(j).ET_DrylANNd = Yv_mean(3,:)';
    
    % Plot time series
    yr = V.Year;
    mo = V.Month;
    dt = datenum(yr, mo, 15);
    Y = Yv;
    ci = quantile(Y,[0.1 0.9],3);
    glim = [floor(min([ci(1,:,1) V.GPP'])*2)/2 ceil(max([ci(1,:,2) V.GPP'])*2)/2];
    nlim = [floor(min([ci(2,:,1) V.NEE'])*2)/2 ceil(max([ci(2,:,2) V.NEE'])*2)/2];
    elim = [floor(min([ci(3,:,1) V.ET'])*2)/2 ceil(max([ci(3,:,2) V.ET'])*2)/2];

    h = figure('Color','w');
    h.Units = 'inches';
    h.Position = [1 1 7 5];
    ax = tight_subplot(3,1,0,0.1,0.1);

    axes(ax(1))
    lo = squeeze(ci(1,:,1));
    hi = squeeze(ci(1,:,2));
    f1=fill([dt(~isnan(lo))' fliplr(dt(~isnan(lo))')], [lo(~isnan(lo)) fliplr(hi(~isnan(lo)))],...
        [244,165,130]/255, 'FaceColor',[244,165,130]/255, 'EdgeColor','none');
    hold on;
    p1=plot(dt(~isnan(lo)), V.GPP(~isnan(lo)),'k-','LineWidth',2);
    p2=plot(dt(~isnan(lo)), squeeze(nanmean(Y(1,(~isnan(lo)),:), 3)), '-','LineWidth',2, 'Color', [178,24,43]/255);
    p3=plot(dt(~isnan(lo)), V.MOD17_GPP(~isnan(lo)), '-','LineWidth',1.2, 'Color', [0.6 0.6 0.6]);
    datetick('x','yyyy');
    box off;
    set(gca, 'XColor','w', 'TickDir','out', 'YLim',glim, 'XLim',[datenum(2015,1,1) datenum(2021,1,1)]);
    ylabel('GPP (gC m^{-2} day^{-1})')
    lgd = legend([p1,p2,f1,p3],'Observed','DrylANNd ensemble mean','DrylANNd 10^{th}-90^{th} pct','MODIS');
    legend('boxoff')
    lgd.Position(1) = lgd.Position(1)+0;
    lgd.Position(2) = lgd.Position(2)+0.09;

    axes(ax(2))
    lo = squeeze(ci(2,:,1));
    hi = squeeze(ci(2,:,2));
    fill([dt(~isnan(lo))' fliplr(dt(~isnan(lo))')], [lo(~isnan(lo)) fliplr(hi(~isnan(lo)))],...
        [244,165,130]/255, 'FaceColor',[244,165,130]/255, 'EdgeColor','none');
    hold on;
    plot(dt(~isnan(lo)), V.NEE(~isnan(lo)),'k-','LineWidth',2);
    plot(dt(~isnan(lo)), squeeze(nanmean(Y(2,(~isnan(lo)),:), 3)), '-','LineWidth',2, 'Color', [178,24,43]/255);
    datetick('x','yyyy');
    box off;
    set(gca, 'XColor','w', 'TickDir','out', 'YAxisLocation','right','YLim',nlim, 'XLim',[datenum(2015,1,1) datenum(2021,1,1)]);
    ylabel('NEE (gC m^{-2} day^{-1})')

    axes(ax(3))
    lo = squeeze(ci(3,:,1));
    hi = squeeze(ci(3,:,2));
    fill([dt(~isnan(lo))' fliplr(dt(~isnan(lo))')], [lo(~isnan(lo)) fliplr(hi(~isnan(lo)))],...
        [244,165,130]/255, 'FaceColor',[244,165,130]/255, 'EdgeColor','none');
    hold on;
    plot(dt(~isnan(lo)), V.ET(~isnan(lo)),'k-','LineWidth',2);
    plot(dt(~isnan(lo)), squeeze(nanmean(Y(3,(~isnan(lo)),:), 3)), '-','LineWidth',2, 'Color', [178,24,43]/255);
    plot(dt(~isnan(lo)), V.MOD16_ET(~isnan(lo)), '-','LineWidth',1.5, 'Color', [0.6 0.6 0.6]);
    datetick('x','yyyy');
    box off;
    set(gca, 'TickDir','out','YLim',elim, 'XLim',[datenum(2015,1,1) datenum(2021,1,1)]);
    ylabel('ET (mm day^{-1})')

    set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
    print('-dtiff','-f1','-r300',['./output/validation/monthly/DrylANNd_monthly_timeseries_',V.Site,'.tif'])
    close all;

    % Make scatterplots
    glim = [floor(min([Yv_mean(1,:) V.GPP'])*2)/2 ceil(max([Yv_mean(1,:) V.GPP'])*2)/2];
    nlim = [floor(min([Yv_mean(2,:) V.NEE'])*2)/2 ceil(max([Yv_mean(2,:) V.NEE'])*2)/2];
    elim = [floor(min([Yv_mean(3,:) V.ET'])*2)/2 ceil(max([Yv_mean(3,:) V.ET'])*2)/2];

    h = figure('Color','w');
    h.Units = 'inches';
    h.Position = [1 1 2 6];
    ax = tight_subplot(3,1,0.1,[0.07 0.08],[0.18 0.05]);

    axes(ax(1))
    plot(glim,glim,'k-');
    hold on;
    s3=scatter(V.GPP, Yv_mean(1,:), 20, [178,24,43]/255, 'filled');
    s4=scatter(V.GPP(~isnan(lo)), V.MOD17_GPP(~isnan(lo)), 10, [0.6 0.6 0.6], 'filled');
    set(gca, 'XLim',glim, 'YLim',glim, 'TickDir','out','TickLength',[0.02 0.02])
    xlabel('Observed GPP (gC m^{-2} day^{-1})', 'FontSize',8)
    ylabel('Modeled GPP (gC m^{-2} day^{-1})', 'FontSize',8)
    box off;
    r = corr(V.GPP, Yv_mean(1,:)', 'rows','pairwise');
    text(glim(1)+0.05*range(glim),glim(2)-0.05*range(glim),['R^{2} = ', num2str(round(r^2, 2))],'FontSize',8, 'Color',[178,24,43]/255);
    mae = nanmean(abs(V.GPP-Yv_mean(1,:)')) ;
    text(glim(1)+0.05*range(glim),glim(2)-0.15*range(glim),['MAE = ', num2str(round(mae, 2))],'FontSize',8, 'Color',[178,24,43]/255);
    r = corr(V.GPP(~isnan(lo)), V.MOD17_GPP(~isnan(lo)), 'rows','pairwise');
    text(glim(2)-0.4*range(glim),glim(1)+0.15*range(glim),['R^{2} = ', num2str(round(r^2, 2))],'FontSize',8, 'Color',[0.6 0.6 0.6]);
    mae = nanmean(abs(V.GPP(~isnan(lo))-V.MOD17_GPP(~isnan(lo)))) ;
    text(glim(2)-0.4*range(glim),glim(1)+0.05*range(glim),['MAE = ', num2str(round(mae, 2))],'FontSize',8, 'Color',[0.6 0.6 0.6]);

    axes(ax(2))
    plot(nlim,nlim,'k-');
    hold on;
    scatter(V.NEE, Yv_mean(2,:), 20, [178,24,43]/255, 'filled')
    set(gca, 'XLim',nlim, 'YLim',nlim, 'TickDir','out','TickLength',[0.02 0.02])
    xlabel('Observed NEE (gC m^{-2} day^{-1})', 'FontSize',8)
    ylabel('Modeled NEE (gC m^{-2} day^{-1})', 'FontSize',8)
    box off;
    r = corr(V.NEE, Yv_mean(2,:)', 'rows','pairwise');
    text(nlim(1)+0.05*range(nlim),nlim(2)-0.05*range(nlim),['R^{2} = ', num2str(round(r^2, 2))],'FontSize',8, 'Color',[178,24,43]/255);
    mae = nanmean(abs(V.NEE-Yv_mean(2,:)')) ;
    text(nlim(1)+0.05*range(nlim),nlim(2)-0.15*range(nlim),['MAE = ', num2str(round(mae, 2))],'FontSize',8, 'Color',[178,24,43]/255);

    axes(ax(3))
    plot(elim,elim,'k-');
    hold on;
    scatter(V.ET, Yv_mean(3,:), 20, [178,24,43]/255, 'filled')
    scatter(V.ET(~isnan(lo)), V.MOD16_ET(~isnan(lo)), 10, [0.6 0.6 0.6], 'filled')
    set(gca, 'XLim',elim, 'YLim',elim, 'TickDir','out','TickLength',[0.02 0.02])
    xlabel('Observed ET (mm day^{-1})', 'FontSize',8)
    ylabel('Modeled ET (mm day^{-1})', 'FontSize',8)
    box off;
    r = corr(V.ET, Yv_mean(3,:)', 'rows','pairwise');
    text(elim(1)+0.05*range(elim),elim(2)-0.05*range(elim),['R^{2} = ', num2str(round(r^2, 2))],'FontSize',8, 'Color',[178,24,43]/255);
    mae = nanmean(abs(V.ET-Yv_mean(3,:)')) ;
    text(elim(1)+0.05*range(elim),elim(2)-0.15*range(elim),['MAE = ', num2str(round(mae, 2))],'FontSize',8, 'Color',[178,24,43]/255);
    r = corr(V.ET(~isnan(lo)), V.MOD16_ET(~isnan(lo)), 'rows','pairwise');
    text(elim(2)-0.4*range(elim),elim(1)+0.15*range(elim),['R^{2} = ', num2str(round(r^2, 2))],'FontSize',8, 'Color',[0.6 0.6 0.6]);
    mae = nanmean(abs(V.ET(~isnan(lo))-V.MOD16_ET(~isnan(lo)))) ;
    text(elim(2)-0.4*range(elim),elim(1)+0.05*range(elim),['MAE = ', num2str(round(mae, 2))],'FontSize',8, 'Color',[0.6 0.6 0.6]);

    set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
    print('-dtiff','-f1','-r300',['./output/validation/monthly/DrylANNd_monthly_scatter_',V.Site,'.tif'])
    close all;

    % Save output
    DrylANNd(j).NNets = nets;
    DrylANNd(j).TrainingRecord = trs;
    DrylANNd(j).TrainingSites = {C.Site};
    DrylANNd(j).Xtraining = Xc;
    DrylANNd(j).Ytraining = Yc;
    DrylANNd(j).Ypredicted = Yv;
    DrylANNd(j).Yscale = Ycs(:, 1);
    DrylANNd(j).Yoffset = Ycm(:, 1);
    DrylANNd(j).Xnames = {'NDVI','EVI','NIRv','kNDVI',...
        'LSWI1','LSWI2','LSWI3','MOD11_Day','MOD11_Night','MYD11_Day','MYD11_Night',...
        'L4SM_Root','L4SM_Surf','L4SM_TSoil','Rangeland_AFG','Rangeland_PFG','Rangeland_SHR','Rangeland_TRE','Rangeland_LTR','Rangeland_BGR'};
    DrylANNd(j).Ynames = {'GPP','NEE','ET'};

end

save('output/validation/monthly/DrylANNd_Ameriflux_validation.mat', 'Ameriflux_monthly', '-v7.3');
save('./output/DrylANNd_monthly.mat', 'DrylANNd');
