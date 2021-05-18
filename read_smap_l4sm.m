% Read in SMAP L4 soil moisture/temperature

% Load daily Ameriflux data and get information
load ./data/Ameriflux_daily.mat;
n = length(Ameriflux);

sites = {Ameriflux.Site};
lat = [Ameriflux.Lat];
lon = [Ameriflux.Lon];

% Get grid 
cd('R:\data archive\SMAP_L4_SM');
fns = glob('*.h5');
glat = h5read(fns{1}, '/cell_lat');
glon = h5read(fns{1}, '/cell_lon');
glatlon = [reshape(glat,[],1) reshape(glon, [], 1)];

% Find cell index for each Ameriflux site and add variables for L4SM data
xind = NaN(size(lat));
yind = NaN(size(lat));
for i = 1:length(sites)
    DistDeg = distance(lat(i), lon(i), glatlon(:,1), glatlon(:,2));
    DistKM = distdim(DistDeg, 'deg', 'km');

    xy = glatlon(DistKM == min(DistKM), :);
    [xind(i), yind(i)] = find(glat == xy(1,1) & glon == xy(1,2));
    
    Ameriflux(i).L4SM_Root = NaN(size(Ameriflux(i).DOY));
    Ameriflux(i).L4SM_Surf = NaN(size(Ameriflux(i).DOY));
    Ameriflux(i).L4SM_Tsoil = NaN(size(Ameriflux(i).DOY));
end
clear glat glon glatlon xy DistDeg DistKM i;

% Get soil moisture
for i = 1:length(fns)
    
    % Get time stamps
    yr = str2double(fns{i}(16:19));
    mo = str2double(fns{i}(20:21));
    dy = str2double(fns{i}(22:23));
    doy = datenum(yr, mo, dy) - datenum(yr,1,1) +1;
    
    % Get rootzone SM
    sm = double(h5read(fns{i}, '/Analysis_Data/sm_rootzone_analysis')); 
    sm(sm==-9999) = NaN;
    for j = 1:n
        idx = find(Ameriflux(j).Year==yr & Ameriflux(j).DOY == doy);
        Ameriflux(j).L4SM_Root(idx) = sm(xind(j), yind(j));
    end
    
    % Get surface SM
    sm = double(h5read(fns{i}, '/Analysis_Data/sm_surface_analysis')); 
    sm(sm==-9999) = NaN;
    for j = 1:n
        idx = find(Ameriflux(j).Year==yr & Ameriflux(j).DOY == doy);
        Ameriflux(j).L4SM_Surf(idx) = sm(xind(j), yind(j));
    end
    
    % Get soil temperature
    sm = double(h5read(fns{i}, '/Analysis_Data/soil_temp_layer1_analysis')); 
    sm(sm==-9999) = NaN;
    for j = 1:n
        idx = find(Ameriflux(j).Year==yr & Ameriflux(j).DOY == doy);
        Ameriflux(j).L4SM_Tsoil(idx) = sm(xind(j), yind(j));
    end
    
    clear yr mo dy doy idx sm j;
end

cd('D:\Publications\Dannenberg_et_al_DrylANNd');
save('./data/Ameriflux_daily.mat','Ameriflux');

