% Read, resample, and subset TerraClimate PPT and PET

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

% Get MODIS lc
info = hdfinfo('D:/Data_Analysis/MCD12C1_v006/MCD12C1.A2020001.006.2021362215328.hdf');
lc = double(hdfread('D:/Data_Analysis/MCD12C1_v006/MCD12C1.A2020001.006.2021362215328.hdf', 'Land_Cover_Type_1_Percent'));
lc  = lc(latidx, lonidx, :);

% Combine into dominant classes
MCD12C1_WAT = lc(:,:,1) + lc(:,:,16);
MCD12C1_FOR = lc(:,:,2) + lc(:,:,3) + lc(:,:,4) + lc(:,:,5) + lc(:,:,6);
MCD12C1_SHB = lc(:,:,7) + lc(:,:,8);
MCD12C1_SAV = lc(:,:,9) + lc(:,:,10);
MCD12C1_GRS = lc(:,:,11);
MCD12C1_CRP = lc(:,:,13) + lc(:,:,15);
MCD12C1_BSV = lc(:,:,17);

save('./data/MCD12C1_fc.mat', 'lat','lon','MCD12C1_WAT','MCD12C1_FOR','MCD12C1_SAV','MCD12C1_SHB','MCD12C1_GRS','MCD12C1_CRP','MCD12C1_BSV', '-v7.3');

