% Read in MODIS LST

load ./data/Ameriflux_daily.mat;
n = length(Ameriflux);

load ./data/MCD12C1_fc.mat;
[LON,LAT] = meshgrid(lon, lat);
LON = reshape(LON, [], 1);
LAT = reshape(LAT, [], 1);
e = referenceEllipsoid('World Geodetic System 1984');

for i = 1:n
    
    site = Ameriflux(i).Site;
    dt = datenum(Ameriflux(i).Year, 1, 1) + Ameriflux(i).DOY - 1;

    distm = distance(Ameriflux(i).Lat, Ameriflux(i).Lon, LAT, LON, e);
    distidx = find(distm == min(distm));
    xind = find(lon == LON(distidx));
    yind = find(lat == LAT(distidx));
    
    Ameriflux(i).MCD12_BSV = NaN(size(dt));
    Ameriflux(i).MCD12_BSV(:) = MCD12C1_BSV(yind, xind);
    
    Ameriflux(i).MCD12_CRP = NaN(size(dt));
    Ameriflux(i).MCD12_CRP(:) = MCD12C1_CRP(yind, xind);
    
    Ameriflux(i).MCD12_FOR = NaN(size(dt));
    Ameriflux(i).MCD12_FOR(:) = MCD12C1_FOR(yind, xind);
    
    Ameriflux(i).MCD12_GRS = NaN(size(dt));
    Ameriflux(i).MCD12_GRS(:) = MCD12C1_GRS(yind, xind);
    
    Ameriflux(i).MCD12_SAV = NaN(size(dt));
    Ameriflux(i).MCD12_SAV(:) = MCD12C1_SAV(yind, xind);
    
    Ameriflux(i).MCD12_SHB = NaN(size(dt));
    Ameriflux(i).MCD12_SHB(:) = MCD12C1_SHB(yind, xind);
    
end

save('./data/Ameriflux_daily.mat','Ameriflux');
