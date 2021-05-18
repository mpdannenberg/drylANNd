% Map of global arid lands
latlim = [31 49];
lonlim = [-125 -96];

pre = 'D:\Data_Analysis\PRISM\';
f1 = matfile([pre,'PRISM_PPT.mat']);
yr = f1.year;
lat = f1.lat;
lon = f1.lon;
latidx = find(lat >= min(latlim) & lat <= max(latlim));
lonidx = find(lon >= min(lonlim) & lon <= max(lonlim));

P = f1.PPT(latidx, lonidx, find(yr>=1981 & yr<=2010), :);
Pmean = mean(sum(P, 4), 3);
clear pre f1 P yr;

%% Load Ameriflux data
load ./data/Ameriflux_daily;
flat = [Ameriflux.Lat];
flon = [Ameriflux.Lon];
fdist = zeros(size(flat));
n = length(flat);
for i = 1:n
    
    distDeg = distance([flat(i) flon(i)], [flat(setdiff(1:n,i))' flon(setdiff(1:n,i))']);
    if min(distDeg) < 0.1; fdist(i) = 1; end
    
end

flat(fdist == 1) = flat(fdist == 1) + 0.75*rand(1,sum(fdist));
flon(fdist == 1) = flon(fdist == 1) + 0.75*rand(1,sum(fdist));

%% Map
states = shaperead('usastatehi','UseGeoCoords',true);
clr = wesanderson('aquatic4');
dclr1 = make_cmap([clr(1,:); clr(2,:); [1 1 1]], 9);
dclr2 = make_cmap([clr(5,:); clr(4,:); [1 1 1]], 9);
dclr = [dclr1(1:8,:);flipud(dclr2(1:8,:))];

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
surfm(lat(latidx), lon(lonidx), Pmean)
caxis([0 1600])
colormap(gca, flipud(dclr));
geoshow(states,'FaceColor','none','EdgeColor',[0.3 0.3 0.3])
scatterm(flat,flon,20,[0.2 0.2 0.2], 'filled',...
    'MarkerFaceColor','w', 'MarkerEdgeColor','k');
ax=gca;
ax.Position(2) = 0.18;

cb = colorbar('southoutside');
cb.Position = [0.1 0.15 0.8 0.04];
cb.Ticks = 0:100:1600;
cb.TickLength = 0.046;
cb.TickLabels = {'0','','','','400','','','','800','','','','1200','','','','1600'};
xlabel(cb, 'Mean annual precipitation (mm)')

%% Pie chart of LC types

lc = {Ameriflux.IGBP};
lc = strrep(lc, 'CSH', 'SHB');
lc = strrep(lc, 'OSH', 'SHB');
lc = strrep(lc, 'WSA', 'SAV');
[C, ia, ic] = unique(lc);
lc_counts = accumarray(ic, 1);

h1 = axes('Parent', gcf, 'Position', [0.74 0.77 0.2 0.2]);
set(h1, 'Color','w')
p = pie(lc_counts, zeros(size(lc_counts)), C);
colormap(gca, clr)
set(findobj(p,'Type','text'), 'FontSize',8);


%% Save figure
set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/drylannd-ameriflux-sites.tif')
close all;

