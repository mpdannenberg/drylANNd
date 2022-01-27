% Resample SMAP L4SM to 0.05 deg CMG grid
parpool local;
latlim = [31 49];
lonlim = [-125 -96];
% qa_lim = 2; % maximum acceptable QA flag
% snow_lim = 0.25; % maximum acceptable snow percentage

% lat/lon for CMG grid
lat = (90-0.025):-0.05:(-90+0.025); ny = length(lat);
lon = (-180+0.025):0.05:(180-0.025); nx = length(lon);
[LON, LAT] = meshgrid(lon, lat);
latidx = lat >= min(latlim) & lat <= max(latlim);
lonidx = lon >= min(lonlim) & lon <= max(lonlim);
lat = lat(latidx);
lon = lon(lonidx);

% Get file names and time info
cd('X:\MCD43C4\');
fns = glob('MCD43*.hdf');
yr = cellfun(@(x) str2double(x(10:13)), fns);
doy = cellfun(@(x) str2double(x(14:16)), fns);
[~,mo,dy] = datevec(datenum(yr,1,1) + doy - 1);

% Filter to only get pre-2021
idx = yr<=2020;
fns = fns(idx);
yr = yr(idx);
mo = mo(idx);
dy = dy(idx);
doy = doy(idx);
clear idx;

% Initialize arrays
MCD43_NDVI = NaN(length(fns), sum(latidx), sum(lonidx));
MCD43_kNDVI = NaN(length(fns), sum(latidx), sum(lonidx));
MCD43_EVI = NaN(length(fns), sum(latidx), sum(lonidx));
MCD43_NIRv = NaN(length(fns), sum(latidx), sum(lonidx));
MCD43_LSWI1 = NaN(length(fns), sum(latidx), sum(lonidx));
MCD43_LSWI2 = NaN(length(fns), sum(latidx), sum(lonidx));
MCD43_LSWI3 = NaN(length(fns), sum(latidx), sum(lonidx));

% Read, calculate vegetation indices, and subset
parfor i = 1:length(fns)
    info = hdfinfo(fns{i}, 'eos');
    b1 = double(hdfread(info.Grid, 'Fields','Nadir_Reflectance_Band1'));
    b2 = double(hdfread(info.Grid, 'Fields','Nadir_Reflectance_Band2'));
    b3 = double(hdfread(info.Grid, 'Fields','Nadir_Reflectance_Band3'));
    b4 = double(hdfread(info.Grid, 'Fields','Nadir_Reflectance_Band4'));
    b5 = double(hdfread(info.Grid, 'Fields','Nadir_Reflectance_Band5'));
    b6 = double(hdfread(info.Grid, 'Fields','Nadir_Reflectance_Band6'));
    b7 = double(hdfread(info.Grid, 'Fields','Nadir_Reflectance_Band7'));
    qa = hdfread(info.Grid, 'Fields','BRDF_Quality');
    %snow = hdfread(info.Grid, 'Fields','Percent_Snow');

    b1(b1 == 32767 | b1<0 | qa == 255) = NaN; b1 = b1 * 0.0001;
    b2(b2 == 32767 | b2<0 | qa == 255) = NaN; b2 = b2 * 0.0001;
    b3(b3 == 32767 | b3<0 | qa == 255) = NaN; b3 = b3 * 0.0001;
    b4(b4 == 32767 | b4<0 | qa == 255) = NaN; b4 = b4 * 0.0001;
    b5(b5 == 32767 | b5<0 | qa == 255) = NaN; b5 = b5 * 0.0001;
    b6(b6 == 32767 | b6<0 | qa == 255) = NaN; b6 = b6 * 0.0001;
    b7(b7 == 32767 | b7<0 | qa == 255) = NaN; b7 = b7 * 0.0001;
    
    % Calculate vegetation indices
    NDVI = (b2 - b1) ./ (b2 + b1);
    kNDVI = tanh(NDVI.^2);
    EVI = 2.5*(b2 - b1) ./ (b2 + 6*b1 - 7.5*b3 + 1);
    NIRv = b2 .* (NDVI - 0.08);
    LSWI1 = (b2 - b5) ./ (b2 + b5);
    LSWI2 = (b2 - b6) ./ (b2 + b6);
    LSWI3 = (b2 - b7) ./ (b2 + b7);
    
    % Add to main arrays
    MCD43_NDVI(i,:,:) = NDVI(latidx, lonidx);
    MCD43_kNDVI(i,:,:) = kNDVI(latidx, lonidx);
    MCD43_EVI(i,:,:) = EVI(latidx, lonidx);
    MCD43_NIRv(i,:,:) = NIRv(latidx, lonidx);
    MCD43_LSWI1(i,:,:) = LSWI1(latidx, lonidx);
    MCD43_LSWI2(i,:,:) = LSWI2(latidx, lonidx);
    MCD43_LSWI3(i,:,:) = LSWI3(latidx, lonidx);
    
end

save('./MCD43_WesternUS.mat', 'lat','lon','yr','mo','dy','doy','MCD43_NDVI','MCD43_kNDVI','MCD43_NIRv','MCD43_EVI','MCD43_LSWI1','MCD43_LSWI2','MCD43_LSWI3', '-v7.3')

