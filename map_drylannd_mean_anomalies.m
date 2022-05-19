% Example map of DrylANNd GPP, NEE, and ET
latlim = [31 49];
lonlim = [-125 -96];
windowSize = 7;
b = ones(1,windowSize)/windowSize;
a = 1;
monthToUse = 10;
ndays = 30+31+30+31+31+30+31; % Apr-Oct

% Load aridity index
load ./data/TerraClimate_AridityIndex.mat;
aridity = NaN(size(ai));
aridity(ai < 0.03) = 1;
aridity(ai >= 0.03 & ai<0.2) = 2;
aridity(ai >= 0.2 & ai<0.5) = 3;
aridity(ai >= 0.5 & ai<=0.75) = 4;

% Load DrylANNd predictions
load ./output/DrylANNd_monthly_prediction.mat;
g = fillmissing(GPP, "linear", 1, "EndValues","none");
g = filter(b, a, g, [], 1);
mGPP = ndays * squeeze(mean(g(mo==monthToUse,:,:), 1, "omitnan"));
g = fillmissing(NEE, "linear", 1, "EndValues","none");
g = filter(b, a, g, [], 1);
mNEE = ndays * squeeze(mean(g(mo==monthToUse,:,:), 1, "omitnan"));
g = fillmissing(ET, "linear", 1, "EndValues","none");
g = filter(b, a, g, [], 1);
mET = ndays * squeeze(mean(g(mo==monthToUse,:,:), 1, "omitnan"));
clear g;

%% Map mean annuals
states = shaperead('usastatehi','UseGeoCoords',true);

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 6.5 8];

% GPP
clr = wesanderson('aquatic4'); clr(3,:) = [];
clr1 = make_cmap([1 1 1; clr(2,:); clr(1,:)], 10);
subplot(3,2,1)
axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',4,'MLineLocation',8,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','off','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(states,'FaceColor',[0.9 0.9 0.9],'EdgeColor','none')
surfm(lat, lon, mGPP)
caxis([0 1500])
colormap(gca, clr1);
geoshow(states,'FaceColor','none','EdgeColor',[0.3 0.3 0.3])
ax = gca;
ax.Position(1) = 0.08;
ax.Position(2) = 0.75;
text(-0.2, 0.85, 'a', 'FontSize',12, 'FontWeight','bold')

cb = colorbar('southoutside');
cb.Position(1) = 0.08;
cb.Position(2) = 0.73;
cb.Position(3) = 0.33;
cb.Ticks = 0:150:1500;
cb.TickLength = 0.05;
cb.TickLabels = {'0','','300','','600','','900','','1200','','1500'};
ylabel(cb, 'GPP (g C m^{-2} year^{-1})', 'FontSize',8)
% ttl = title('Mean annual', 'FontSize',12);

% NEE
clr1 = make_cmap([clr(4,:); clr(3,:); 1 1 1], 6);
clr2 = make_cmap([1 1 1; clr(2,:); clr(1,:)], 6);
clr1 = [clr1(1:5, :); clr2(2:end, :)];
subplot(3,2,3)
axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',4,'MLineLocation',8,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','off','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(states,'FaceColor',[0.9 0.9 0.9],'EdgeColor','none')
surfm(lat, lon, mNEE)
caxis([-500 500])
colormap(gca, flipud(clr1));
geoshow(states,'FaceColor','none','EdgeColor',[0.3 0.3 0.3])
ax = gca;
ax.Position(1) = 0.08;
ax.Position(2) = 0.42;

cb = colorbar('southoutside');
cb.Position(1) = 0.08;
cb.Position(2) = 0.4;
cb.Position(3) = 0.33;
cb.Ticks = -500:100:500;
cb.TickLength = 0.055;
ylabel(cb, 'NEE (g C m^{-2} year^{-1})', 'FontSize',8)
text(-0.2, 0.85, 'c', 'FontSize',12, 'FontWeight','bold')

% ET
clr1 = make_cmap([1 1 1; clr(2,:); clr(1,:)], 7);
subplot(3,2,5)
axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',4,'MLineLocation',8,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','off','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(states,'FaceColor',[0.9 0.9 0.9],'EdgeColor','none')
surfm(lat, lon, mET)
caxis([0 700])
colormap(gca, clr1);
geoshow(states,'FaceColor','none','EdgeColor',[0.3 0.3 0.3])
ax = gca;
ax.Position(1) = 0.08;
ax.Position(2) = 0.09;
text(-0.2, 0.85, 'e', 'FontSize',12, 'FontWeight','bold')

cb = colorbar('southoutside');
cb.Position(1) = 0.08;
cb.Position(2) = 0.07;
cb.Position(3) = 0.33;
cb.Ticks = 0:100:700;
cb.TickLength = 0.05;
ylabel(cb, 'ET (mm year^{-1})', 'FontSize',8)

%% Plot mean observed vs. predicted at EC sites
load ./output/validation/monthly/DrylANNd_Ameriflux_validation.mat;
years = 2015:2020;
siteGPP = NaN(length(2015:2020), length(Ameriflux_monthly));
siteNEE = NaN(length(2015:2020), length(Ameriflux_monthly));
siteET = NaN(length(2015:2020), length(Ameriflux_monthly));
predGPP = NaN(length(2015:2020), length(Ameriflux_monthly));
predNEE = NaN(length(2015:2020), length(Ameriflux_monthly));
predET = NaN(length(2015:2020), length(Ameriflux_monthly));
for i = 1:length(Ameriflux_monthly)
    [~, ia, ib] = intersect(Ameriflux_monthly(i).Year(Ameriflux_monthly(i).Month == monthToUse), years);
    
    gpp = fillmissing(Ameriflux_monthly(i).GPP, 'linear', 'EndValues','none');
    nee = fillmissing(Ameriflux_monthly(i).NEE, 'linear', 'EndValues','none');
    et = fillmissing(Ameriflux_monthly(i).ET, 'linear', 'EndValues','none');
    agpp = filter(b, a, gpp, [], 1); agpp = agpp(Ameriflux_monthly(i).Month == monthToUse);
    anee = filter(b, a, nee, [], 1); anee = anee(Ameriflux_monthly(i).Month == monthToUse);
    aet = filter(b, a, et, [], 1); aet = aet(Ameriflux_monthly(i).Month == monthToUse);
    siteGPP(ib, i) = agpp(ia) * ndays; % mean daily --> total annual
    siteNEE(ib, i) = anee(ia) * ndays; % mean daily --> total annual
    siteET(ib, i) = aet(ia) * ndays; % mean daily --> total annual
    
    gpp = fillmissing(Ameriflux_monthly(i).GPP_DrylANNd, 'linear', 'EndValues','none');
    nee = fillmissing(Ameriflux_monthly(i).NEE_DrylANNd, 'linear', 'EndValues','none');
    et = fillmissing(Ameriflux_monthly(i).ET_DrylANNd, 'linear', 'EndValues','none');
    agpp = filter(b, a, gpp, [], 1); agpp = agpp(Ameriflux_monthly(i).Month == monthToUse);
    anee = filter(b, a, nee, [], 1); anee = anee(Ameriflux_monthly(i).Month == monthToUse);
    aet = filter(b, a, et, [], 1); aet = aet(Ameriflux_monthly(i).Month == monthToUse);
    predGPP(ib, i) = agpp(ia) * ndays; % mean daily --> total annual
    predNEE(ib, i) = anee(ia) * ndays; % mean daily --> total annual
    predET(ib, i) = aet(ia) * ndays; % mean daily --> total annual
    
end
clear b a windowSize;

% Scatterplots
subplot(3,2,2)
xylims = [0 1000];
idx = find(sum(isnan(predGPP))==0 & sum(isnan(siteGPP))==0);
plot(xylims, xylims, 'k-')
hold on;
scatter(mean(siteGPP(:,idx), 'omitnan'), mean(predGPP(:,idx), 'omitnan'), 20, [0.4 0.4 0.4], "filled")
for i = idx
    
    ym = mean(siteGPP(:,i), 'omitnan');
    yhatm = mean(predGPP(:,i), 'omitnan');

    s = std(siteGPP(:,i), 'omitnan');
    se = s / sqrt(sum(~isnan(siteGPP(:,i))));
    plot([ym-s ym+s], [yhatm yhatm], '-', 'Color',[0.4 0.4 0.4])
    
    s = std(predGPP(:,i), 'omitnan');
    se = s / sqrt(sum(~isnan(predGPP(:,i))));
    plot([ym ym], [yhatm-s yhatm+s], '-', 'Color',[0.4 0.4 0.4])

end
ax = gca;
set(ax, 'YLim',xylims, 'XLim',xylims, 'TickDir','out', 'TickLength',[0.02 0])
r = corr(mean(siteGPP(:,idx), 'omitnan')', mean(predGPP(:,idx), 'omitnan')', 'rows','pairwise') ^ 2;
text(xylims(1)+0.05*diff(xylims), xylims(2), ['R^{2} = ', sprintf('%.2f', r)], 'FontSize', 8);
box off;
xlabel('Site mean GPP (g C m^{-2})', 'FontSize',8)
ylabel('DrylANNd mean GPP (g C m^{-2})', 'FontSize',8)
ax.Position(1) = 0.6;
ax.Position(2) = 0.745;
text(xylims(1)-0.35*diff(xylims), xylims(2), 'b', 'FontSize',12, 'FontWeight','bold', 'VerticalAlignment','middle')
text(xylims(2), xylims(2), '1:1', 'FontSize',8, 'HorizontalAlignment','right', 'VerticalAlignment','bottom', 'Rotation',45)
hold off;

% NEE
subplot(3,2,4)
xylims = [-550 100];
idx = find(sum(isnan(predNEE))==0 & sum(isnan(siteNEE))==0);
plot(xylims, xylims, 'k-')
hold on;
scatter(mean(siteNEE(:,idx), 'omitnan'), mean(predNEE(:,idx), 'omitnan'), 20, [0.4 0.4 0.4], "filled")
for i = idx
    
    ym = mean(siteNEE(:,i), 'omitnan');
    yhatm = mean(predNEE(:,i), 'omitnan');

    s = std(siteNEE(:,i), 'omitnan');
    se = s / sqrt(sum(~isnan(siteNEE(:,i))));
    plot([ym-s ym+s], [yhatm yhatm], '-', 'Color',[0.4 0.4 0.4])
    
    s = std(predNEE(:,i), 'omitnan');
    se = s / sqrt(sum(~isnan(predNEE(:,i))));
    plot([ym ym], [yhatm-s yhatm+s], '-', 'Color',[0.4 0.4 0.4])

end
ax = gca;
set(ax, 'YLim',xylims, 'XLim',xylims, 'TickDir','out', 'TickLength',[0.02 0])
r = corr(mean(siteNEE(:,idx), 'omitnan')', mean(predNEE(:,idx), 'omitnan')', 'rows','pairwise') ^ 2;
text(xylims(1)+0.05*diff(xylims), xylims(2), ['R^{2} = ', sprintf('%.2f', r)], 'FontSize', 8);
box off;
xlabel('Site mean NEE (g C m^{-2})', 'FontSize',8)
ylabel('DrylANNd mean NEE (g C m^{-2})', 'FontSize',8)
ax.Position(1) = 0.6;
ax.Position(2) = 0.418;
text(xylims(1)-0.35*diff(xylims), xylims(2), 'd', 'FontSize',12, 'FontWeight','bold', 'VerticalAlignment','middle')
text(xylims(2), xylims(2), '1:1', 'FontSize',8, 'HorizontalAlignment','right', 'VerticalAlignment','bottom', 'Rotation',45)
hold off;

% ET
subplot(3,2,6)
xylims = [100 600];
idx = find(sum(isnan(predET))==0 & sum(isnan(siteET))==0);
plot(xylims, xylims, 'k-')
hold on;
scatter(mean(siteET(:,idx), 'omitnan'), mean(predET(:,idx), 'omitnan'), 20, [0.4 0.4 0.4], "filled")
for i = idx
    
    ym = mean(siteET(:,i), 'omitnan');
    yhatm = mean(predET(:,i), 'omitnan');

    s = std(siteET(:,i), 'omitnan');
    se = s / sqrt(sum(~isnan(siteET(:,i))));
    plot([ym-s ym+s], [yhatm yhatm], '-', 'Color',[0.4 0.4 0.4])
    
    s = std(predET(:,i), 'omitnan');
    se = s / sqrt(sum(~isnan(predET(:,i))));
    plot([ym ym], [yhatm-s yhatm+s], '-', 'Color',[0.4 0.4 0.4])

end
ax = gca;
set(ax, 'YLim',xylims, 'XLim',xylims, 'TickDir','out', 'TickLength',[0.02 0])
r = corr(mean(siteET(:,idx), 'omitnan')', mean(predET(:,idx), 'omitnan')', 'rows','pairwise') ^ 2;
text(xylims(1)+0.05*diff(xylims), xylims(2), ['R^{2} = ', sprintf('%.2f', r)], 'FontSize', 8);
box off;
xlabel('Site mean ET (mm)', 'FontSize',8)
ylabel('DrylANNd mean ET (mm)', 'FontSize',8)
ax.Position(1) = 0.6;
ax.Position(2) = 0.086;
text(xylims(1)-0.35*diff(xylims), xylims(2), 'f', 'FontSize',12, 'FontWeight','bold', 'VerticalAlignment','middle')
text(xylims(2), xylims(2), '1:1', 'FontSize',8, 'HorizontalAlignment','right', 'VerticalAlignment','bottom', 'Rotation',45)
hold off;

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/mean-annual-drylannd.tif')
close all;
