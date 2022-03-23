% Example map of DrylANNd GPP, NEE, and ET
latlim = [31 49];
lonlim = [-125 -96];
ndays = 31 + 31 + 30 + 31; % Total number of days (for conversion from gC m-2 day-1 to gC m-2)

% Load aridity index
load ./data/TerraClimate_AridityIndex.mat;
aridity = NaN(size(ai));
aridity(ai < 0.03) = 1;
aridity(ai >= 0.03 & ai<0.2) = 2;
aridity(ai >= 0.2 & ai<0.5) = 3;
aridity(ai >= 0.5 & ai<=0.75) = 4;

% Load DrylANNd predictions
load ./output/DrylANNd_monthly_prediction.mat;
mGPP = 365 * squeeze(mean(GPP, 1, "omitnan"));
mNEE = 365 * squeeze(mean(NEE, 1, "omitnan"));
mET = 365 * squeeze(mean(ET, 1, "omitnan"));

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
caxis([0 2000])
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
cb.Ticks = 0:200:2000;
cb.TickLength = 0.05;
ylabel(cb, 'GPP (g C m^{-2} year^{-1})', 'FontSize',8)
ttl = title('Mean annual', 'FontSize',12);

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
clr1 = make_cmap([1 1 1; clr(2,:); clr(1,:)], 10);
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
caxis([0 1000])
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
cb.Ticks = 0:100:1000;
cb.TickLength = 0.05;
ylabel(cb, 'ET (mm year^{-1})', 'FontSize',8)

%% Map 2020 anomalies
windowSize = 4;
b = ones(1,windowSize)/windowSize;
a = 1;
gpp = filter(b, a, GPP, [], 1);
nee = filter(b, a, NEE, [], 1);
et = filter(b, a, ET, [], 1);
clear b a windowSize;

gpp = ndays*gpp(mo==10,:,:);
agpp = squeeze(gpp(6,:,:) - mean(gpp(1:5,:,:), 1));
nee = ndays*nee(mo==10,:,:);
anee = squeeze(nee(6,:,:) - mean(nee(1:5,:,:), 1));
et = ndays*et(mo==10,:,:);
aet = squeeze(et(6,:,:) - mean(et(1:5,:,:), 1));

% GPP
clr1 = make_cmap([clr(4,:); clr(3,:); 1 1 1], 6);
clr2 = make_cmap([1 1 1; clr(2,:); clr(1,:)], 6);
clr1 = [clr1(1:5, :); clr2(2:end, :)];

subplot(3,2,2)
axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',4,'MLineLocation',8,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','off','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(states,'FaceColor',[0.9 0.9 0.9],'EdgeColor','none')
surfm(lat, lon, agpp)
caxis([-200 200])
colormap(gca, clr1);
geoshow(states,'FaceColor','none','EdgeColor',[0.3 0.3 0.3])
ax = gca;
ax.Position(1) = 0.57;
ax.Position(2) = 0.75;
text(-0.2, 0.85, 'b', 'FontSize',12, 'FontWeight','bold')

cb = colorbar('southoutside');
cb.Position(1) = 0.57;
cb.Position(2) = 0.73;
cb.Position(3) = 0.33;
cb.Ticks = -200:40:200;
cb.TickLength = 0.05;
ylabel(cb, 'GPP (g C m^{-2} year^{-1})', 'FontSize',8)
ttl = title('2020 anomaly', 'FontSize',12);

% NEE
subplot(3,2,4)
axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',4,'MLineLocation',8,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','off','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(states,'FaceColor',[0.9 0.9 0.9],'EdgeColor','none')
surfm(lat, lon, anee)
caxis([-100 100])
colormap(gca, flipud(clr1));
geoshow(states,'FaceColor','none','EdgeColor',[0.3 0.3 0.3])
ax = gca;
ax.Position(1) = 0.57;
ax.Position(2) = 0.42;

cb = colorbar('southoutside');
cb.Position(1) = 0.57;
cb.Position(2) = 0.4;
cb.Position(3) = 0.33;
cb.Ticks = -100:20:100;
cb.TickLength = 0.055;
ylabel(cb, 'NEE (g C m^{-2} year^{-1})', 'FontSize',8)
text(-0.2, 0.85, 'd', 'FontSize',12, 'FontWeight','bold')

% ET
subplot(3,2,6)
axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',4,'MLineLocation',8,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','off','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(states,'FaceColor',[0.9 0.9 0.9],'EdgeColor','none')
surfm(lat, lon, aet)
caxis([-100 100])
colormap(gca, clr1);
geoshow(states,'FaceColor','none','EdgeColor',[0.3 0.3 0.3])
ax = gca;
ax.Position(1) = 0.57;
ax.Position(2) = 0.09;
text(-0.2, 0.85, 'f', 'FontSize',12, 'FontWeight','bold')

cb = colorbar('southoutside');
cb.Position(1) = 0.57;
cb.Position(2) = 0.07;
cb.Position(3) = 0.33;
cb.Ticks = -100:20:100;
cb.TickLength = 0.05;
ylabel(cb, 'ET (mm year^{-1})', 'FontSize',8)

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/mean-annual-drylannd-2020-anomaly.tif')
close all;
