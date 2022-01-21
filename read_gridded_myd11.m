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
lat = lat(latidx);
lon = lon(lonidx);

% Get file names and time info
cd('X:\MYD11C1\');
fns = glob('*.hdf');
yr = cellfun(@(x) str2double(x(10:13)), fns);
doy = cellfun(@(x) str2double(x(14:16)), fns);
[~,mo,dy] = datevec(datenum(yr,1,1) + doy - 1);

% Filter to only get 2015-present (overlap with SMAP)
idx = yr>=2015;
fns = fns(idx);
yr = yr(idx);
mo = mo(idx);
dy = dy(idx);
doy = doy(idx);
clear idx;

% Initialize arrays
MYD11_Day = NaN(length(fns), sum(latidx), sum(lonidx));
MYD11_Night = NaN(length(fns), sum(latidx), sum(lonidx));

% Read and interpolate
parfor i = 1:length(fns)
    % Day
    lst = double(hdfread(fns{i}, '/LST_Day_CMG'));
    lst(lst == 0) = NaN; % Fill values
    lst = lst * 0.02; % Scale factor
    MYD11_Day(i,:,:) = lst(latidx, lonidx);
    
    % Night
    lst = double(hdfread(fns{i}, '/LST_Night_CMG'));
    lst(lst == 0) = NaN; % Fill values
    lst = lst * 0.02; % Scale factor
    MYD11_Night(i,:,:) = lst(latidx, lonidx);
    
end

save('./MYD11_WesternUS.mat', 'lat','lon','yr','mo','dy','doy','MYD11_Day','MYD11_Night', '-v7.3')

