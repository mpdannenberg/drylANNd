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

% Get TerraClimate PPT and PET climatologies
glat = ncread('D:/Data_Analysis/TerraClimate/TerraClimate19812010_ppt.nc', 'lat');
glon = ncread('D:/Data_Analysis/TerraClimate/TerraClimate19812010_ppt.nc', 'lon');
[GLON, GLAT] = meshgrid(glon, glat);
ppt = ncread('D:/Data_Analysis/TerraClimate/TerraClimate19812010_ppt.nc', 'ppt');
ppt = sum(ppt, 3)';
pet = ncread('D:/Data_Analysis/TerraClimate/TerraClimate19812010_pet.nc', 'pet');
pet = sum(pet, 3)';

% Resample to CMG grid
ppt05 = interp2(GLON, GLAT, ppt, LON, LAT, 'nearest');
pet05 = interp2(GLON, GLAT, pet, LON, LAT, 'nearest');

% Calculate aridity index
ai = ppt05 ./ pet05;
aridity = NaN(size(ai));
aridity(ai < 0.03) = 1;
aridity(ai >= 0.03 & ai<0.2) = 2;
aridity(ai >= 0.2 & ai<0.5) = 3;
aridity(ai >= 0.5 & ai<=0.75) = 4;

% Subset to region of interest and save
ai = ai(latidx, lonidx);
save('./data/TerraClimate_AridityIndex.mat', 'ai','lat','lon');

