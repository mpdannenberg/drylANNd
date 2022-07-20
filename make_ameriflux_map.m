% Map of US dryland flux sites
latlim = [31 49];
lonlim = [-125 -96];
excludeSites = {'MX-EMg','US-CZ4','US-Me2','US-Sne','US-Snf'}; % exclude sites from calibration (not dryland, missing data, or weird site)
siteOffset = 0.25;

%% Load aridity index
load ./data/TerraClimate_AridityIndex.mat;
aridity = NaN(size(ai));
aridity(ai < 0.03) = 1;
aridity(ai >= 0.03 & ai<0.2) = 2;
aridity(ai >= 0.2 & ai<0.5) = 3;
aridity(ai >= 0.5 & ai<=0.75) = 4;

%% Load Ameriflux data
load ./data/Ameriflux_daily;
Ameriflux = Ameriflux(~ismember({Ameriflux.Site}, excludeSites));
flat = [Ameriflux.Lat];
flon = [Ameriflux.Lon];
sites = {Ameriflux.Site};
n = length(flat);

%% Separate nearby sites
flon(strcmp(sites, 'US-CZ2')) = flon(strcmp(sites, 'US-CZ2')) - siteOffset;
flon(strcmp(sites, 'US-CZ3')) = flon(strcmp(sites, 'US-CZ3')) + siteOffset;
flon(strcmp(sites, 'US-Hn2')) = flon(strcmp(sites, 'US-Hn2')) - siteOffset;
flon(strcmp(sites, 'US-Hn3')) = flon(strcmp(sites, 'US-Hn3')) + siteOffset;
flon(strcmp(sites, 'US-Mpj')) = flon(strcmp(sites, 'US-Mpj')) - siteOffset/2;
flon(strcmp(sites, 'US-Wjs')) = flon(strcmp(sites, 'US-Wjs')) + siteOffset/2;
flon(strcmp(sites, 'US-Rls')) = flon(strcmp(sites, 'US-Rls')) - siteOffset; flat(strcmp(sites, 'US-Rls')) = flat(strcmp(sites, 'US-Rls')) + siteOffset;
flon(strcmp(sites, 'US-Rms')) = flon(strcmp(sites, 'US-Rms')) - siteOffset; flat(strcmp(sites, 'US-Rms')) = flat(strcmp(sites, 'US-Rms')) - siteOffset;
flon(strcmp(sites, 'US-Rwf')) = flon(strcmp(sites, 'US-Rwf')) + siteOffset; flat(strcmp(sites, 'US-Rwf')) = flat(strcmp(sites, 'US-Rwf')) - siteOffset;
flon(strcmp(sites, 'US-Rws')) = flon(strcmp(sites, 'US-Rws')) + siteOffset; flat(strcmp(sites, 'US-Rws')) = flat(strcmp(sites, 'US-Rws')) + siteOffset;
flon(strcmp(sites, 'US-SCg')) = flon(strcmp(sites, 'US-SCg')) + siteOffset;
flon(strcmp(sites, 'US-SCs')) = flon(strcmp(sites, 'US-SCs')) - siteOffset;
flat(strcmp(sites, 'US-SRG')) = flat(strcmp(sites, 'US-SRG')) - siteOffset;
flon(strcmp(sites, 'US-SRM')) = flon(strcmp(sites, 'US-SRM')) - siteOffset; flat(strcmp(sites, 'US-SRM')) = flat(strcmp(sites, 'US-SRM')) + siteOffset/2;
flon(strcmp(sites, 'US-SRS')) = flon(strcmp(sites, 'US-SRS')) + siteOffset; flat(strcmp(sites, 'US-SRS')) = flat(strcmp(sites, 'US-SRS')) + siteOffset/2;
flon(strcmp(sites, 'US-Seg')) = flon(strcmp(sites, 'US-Seg')) + siteOffset; flat(strcmp(sites, 'US-Seg')) = flat(strcmp(sites, 'US-Seg')) - siteOffset;
flon(strcmp(sites, 'US-Ses')) = flon(strcmp(sites, 'US-Ses')) - siteOffset; flat(strcmp(sites, 'US-Ses')) = flat(strcmp(sites, 'US-Ses')) - siteOffset;
flon(strcmp(sites, 'US-Ton')) = flon(strcmp(sites, 'US-Ton')) - siteOffset;
flon(strcmp(sites, 'US-Var')) = flon(strcmp(sites, 'US-Var')) + siteOffset;
flon(strcmp(sites, 'US-Vcm')) = flon(strcmp(sites, 'US-Vcm')) + siteOffset;
flon(strcmp(sites, 'US-Vcp')) = flon(strcmp(sites, 'US-Vcp')) - siteOffset;
flon(strcmp(sites, 'US-Whs')) = flon(strcmp(sites, 'US-Whs')) - siteOffset;
flon(strcmp(sites, 'US-Wkg')) = flon(strcmp(sites, 'US-Wkg')) + siteOffset;


%% land cover
lc = {Ameriflux.IGBP};
lc{strcmp({Ameriflux.Site},'US-Mpj')} = 'SAV';
lc = strrep(lc, 'CSH', 'SHB');
lc = strrep(lc, 'OSH', 'SHB');
lc = strrep(lc, 'WSA', 'SAV');
lc = strrep(lc, 'GRA', 'GRS');
[C, ia, ic] = unique(lc);
lc_counts = accumarray(ic, 1);

%% Map
states = shaperead('usastatehi','UseGeoCoords',true);
clr = wesanderson('aquatic4');
dclr1 = make_cmap([clr(1,:); clr(2,:); [1 1 1]], 9);
dclr2 = make_cmap([clr(5,:); clr(4,:); [1 1 1]], 9);
dclr = [dclr1(1:8,:);flipud(dclr2(1:8,:))];
clr(3,:) = [];
gsc = [204,204,204
    150,150,150
    99,99,99
    37,37,37]/255;

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 6.5 3.];

subplot(1,5,1:3)
axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',4,'MLineLocation',8,'MeridianLabel','on',...
        'ParallelLabel','on','GLineWidth',0.5,'Frame','off','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
surfm(lat, lon, aridity)
caxis([0.5 4.5])
colormap(gca, flipud(gsc));
geoshow(states,'FaceColor','none','EdgeColor',[0.3 0.3 0.3])
scatterm(flat,flon,25,clr(ic,:), 'filled',...
    'MarkerEdgeColor','w');
ax=gca;
ax.Position(1) = 0.08;
ax.Position(2) = 0.18;

cb = colorbar('southoutside');
cb.Position = [0.02 0.08 0.52 0.05];
cb.Ticks = 1:4;
cb.TickLength = 0;
cb.TickLabels = {'hyperarid','arid','semiarid','subhumid'};

text(-0.25,0.85,'a', 'FontSize',12, 'FontWeight','bold')

%% Scatterplot of P vs. PET
subplot(1,5,4:5)
scatter(ppt05(aridity==4), pet05(aridity==4), 5, gsc(1,:), "filled")
hold on;
scatter(ppt05(aridity==3), pet05(aridity==3), 5, gsc(2,:), "filled")
scatter(ppt05(aridity==2), pet05(aridity==2), 5, gsc(3,:), "filled")
scatter(ppt05(aridity==1), pet05(aridity==1), 5, gsc(4,:), "filled")
set(gca, 'TickDir','out', 'TickLength',[0.02 0])
for i = 1:n
    latidx = find(abs(Ameriflux(i).Lat - lat) == min(abs(Ameriflux(i).Lat - lat)));
    lonidx = find(abs(Ameriflux(i).Lon - lon) == min(abs(Ameriflux(i).Lon - lon)));
    scatter(ppt05(latidx, lonidx),pet05(latidx, lonidx),25,clr(ic(i),:), 'filled',...
        'MarkerEdgeColor','w');
end
hold off;
ax = gca;
ax.Position(1) = 0.65;
ax.Position(2) = 0.18;
ax.Position(3) = 0.32;
ax.Position(4) = 0.8;
xlabel('Mean annual precipitation (mm)')
ylabel('Mean annual PET (mm)')

text(-300,2480,'b', 'FontSize',12, 'FontWeight','bold')

%% Pie chart of LC types
h1 = axes('Parent', gcf, 'Position', [0.82 0.78 0.2 0.2]);
set(h1, 'Color','w')
p = pie(lc_counts, ones(size(lc_counts)), C);
colormap(gca, clr)
set(findobj(p,'Type','text'), 'FontSize',8);

%% Save figure
set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/drylannd-ameriflux-sites.tif')
close all;

%% Presentation figure 
h = figure('Color','k');
h.Units = 'inches';
h.Position = [1 1 4 4.5];

axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',4,'MLineLocation',8,'MeridianLabel','on',...
        'ParallelLabel','on','GLineWidth',0.5,'Frame','off','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(states,'FaceColor','w','EdgeColor','none')
surfm(lat, lon, aridity)
caxis([0.5 4.5])
colormap(gca, flipud(gsc));
geoshow(states,'FaceColor','none','EdgeColor',[0.3 0.3 0.3])
scatterm(flat,flon,20,clr(ic,:), 'filled',...
    'MarkerEdgeColor','k');
ax=gca;
ax.Position(2) = 0.04;

cb = colorbar('southoutside');
cb.Position = [0.1 0.06 0.8 0.04];
cb.Ticks = 1:4;
cb.TickLength = 0;
cb.TickLabels = {'hyperarid','arid','semiarid','subhumid'};
cb.Color = 'w';

%% Pie chart of LC types
h1 = axes('Parent', gcf, 'Position', [0.74 0.77 0.2 0.2]);
set(h1, 'Color','w')
p = pie(lc_counts, ones(size(lc_counts)), C);
colormap(gca, clr)
set(findobj(p,'Type','text'), 'FontSize',8, 'Color','w');

%% Save figure
set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./presentation/drylannd-ameriflux-sites.tif')
close all;

