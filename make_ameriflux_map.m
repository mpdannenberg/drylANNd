% Map of US dryland flux sites
latlim = [31 49];
lonlim = [-125 -96];
excludeSites = {'MX-EMg','US-CZ4','US-Me2','US-Sne','US-Snf'}; % exclude sites from calibration (not dryland, missing data, or weird site)

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
fdist = zeros(size(flat));
n = length(flat);
for i = 1:n
    
    distDeg = distance([flat(i) flon(i)], [flat(setdiff(1:n,i))' flon(setdiff(1:n,i))']);
    if min(distDeg) < 0.1; fdist(i) = 1; end
    
end

flat(fdist == 1) = flat(fdist == 1) + 0.5*rand(1,sum(fdist));
flon(fdist == 1) = flon(fdist == 1) + 0.5*rand(1,sum(fdist));

%% land cover
lc = {Ameriflux.IGBP};
lc{strcmp({Ameriflux.Site},'US-Mpj')} = 'SAV';
lc = strrep(lc, 'CSH', 'SHB');
lc = strrep(lc, 'OSH', 'SHB');
lc = strrep(lc, 'WSA', 'SAV');
[C, ia, ic] = unique(lc);
lc_counts = accumarray(ic, 1);

%% Map
states = shaperead('usastatehi','UseGeoCoords',true);
clr = wesanderson('aquatic4');
dclr1 = make_cmap([clr(1,:); clr(2,:); [1 1 1]], 9);
dclr2 = make_cmap([clr(5,:); clr(4,:); [1 1 1]], 9);
dclr = [dclr1(1:8,:);flipud(dclr2(1:8,:))];
clr(3,:) = [];
gsc = [0.4 0.4 0.4
    0.55 0.55 0.55
    0.7 0.7 0.7
    0.85 0.85 0.85];

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 4 4];

axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',4,'MLineLocation',8,'MeridianLabel','on',...
        'ParallelLabel','on','GLineWidth',0.5,'Frame','off','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
surfm(lat, lon, aridity)
caxis([0.5 4.5])
% colormap(gca, dclr2(1:2:7,:));
colormap(gca, gsc);
geoshow(states,'FaceColor','none','EdgeColor',[0.3 0.3 0.3])
% scatterm(flat,flon,20,[0.2 0.2 0.2], 'filled',...
%     'MarkerFaceColor','w', 'MarkerEdgeColor','k');
scatterm(flat,flon,20,clr(ic,:), 'filled',...
    'MarkerEdgeColor','k');
ax=gca;
ax.Position(2) = 0.18;

cb = colorbar('southoutside');
cb.Position = [0.1 0.15 0.8 0.04];
cb.Ticks = 1:4;
cb.TickLength = 0;
cb.TickLabels = {'hyperarid','arid','semiarid','subhumid'};

%% Pie chart of LC types

h1 = axes('Parent', gcf, 'Position', [0.74 0.77 0.2 0.2]);
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
% colormap(gca, dclr2(1:2:7,:));
colormap(gca, gsc);
geoshow(states,'FaceColor','none','EdgeColor',[0.3 0.3 0.3])
% scatterm(flat,flon,20,[0.2 0.2 0.2], 'filled',...
%     'MarkerFaceColor','w', 'MarkerEdgeColor','k');
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

