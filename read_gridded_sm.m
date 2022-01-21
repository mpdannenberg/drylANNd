% Resample SMAP L4SM to 0.05 deg CMG grid
parpool local;
latlim = [31 49];
lonlim = [-125 -96];

% lat/lon for CMG grid
lat = (90-0.025):-0.05:(-90+0.025); ny = length(lat);
lon = (-180+0.025):0.05:(180-0.025); nx = length(lon);
[LON, LAT] = meshgrid(lon, lat);
latidx = lat >= min(latlim) & lat <= max(latlim);
lonidx = lon >= min(lonlim) & lon <= max(lonlim);

% Get SMAP files and lat/lon
cd('X:\SMAP_L4_SM');
fns = glob('*.h5');
glat = h5read(fns{1}, '/cell_lat')';
glon = h5read(fns{1}, '/cell_lon')';

% Initialize arrays
SMAP_RZSM = NaN(length(fns), sum(latidx), sum(lonidx));
SMAP_SFSM = NaN(length(fns), sum(latidx), sum(lonidx));
SMAP_TS = NaN(length(fns), sum(latidx), sum(lonidx));
yr = cellfun(@(x) str2double(x(16:19)), fns);
mo = cellfun(@(x) str2double(x(20:21)), fns);
dy = cellfun(@(x) str2double(x(22:23)), fns);
doy = datenum(yr, mo, dy) - datenum(yr,1,1) + 1;

% Read and interpolate
parfor i = 1:length(fns)
    % Root zone SM
    sm = double(h5read(fns{i}, '/Analysis_Data/sm_rootzone_analysis'))'; sm(sm==-9999) = NaN;
    smNN = interp2(glon, glat, sm, LON, LAT, 'nearest');
    SMAP_RZSM(i,:,:) = smNN(latidx, lonidx);
    
    % Surface SM
    sm = double(h5read(fns{i}, '/Analysis_Data/sm_surface_analysis'))'; sm(sm==-9999) = NaN;
    smNN = interp2(glon, glat, sm, LON, LAT, 'nearest');
    SMAP_SFSM(i,:,:) = smNN(latidx, lonidx);
    
    % Soil temperature
    sm = double(h5read(fns{i}, '/Analysis_Data/soil_temp_layer1_analysis'))'; sm(sm==-9999) = NaN;
    smNN = interp2(glon, glat, sm, LON, LAT, 'nearest');
    SMAP_TS(i,:,:) = smNN(latidx, lonidx);
    
end

lat = lat(latidx);
lon = lon(lonidx);
save('SMAP_L4SM_WesternUS.mat', 'lat','lon','yr','mo','dy','doy','SMAP_RZSM','SMAP_SFSM','SMAP_TS', '-v7.3')

