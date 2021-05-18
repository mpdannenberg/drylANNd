%% Read Ameriflux dryland data + MODIS veg indices

fns = glob('./data/*_daily.csv');
info = readtable('./data/Ameriflux_site_table.xlsx');
n = length(fns);
filtThresh = 3;

for j = 1:n
    
    flx = readtable(fns{j}, 'TreatAsEmpty','NA');
    site = strsplit(fns{j},'_'); site = site{2};
    idx = find(strcmp(info.Site_ID, site));
    [yr,mo,dy] = datevec(datenum(flx.Year,1,1)+flx.DoY-1);
    
    % Site variables
    Ameriflux(j).Site = site;
    Ameriflux(j).Lat = info.Latitude(idx);
    Ameriflux(j).Lon = info.Longitude(idx);
    Ameriflux(j).Elevation = info.Elevation(idx);
    Ameriflux(j).Name = info.Name{idx};
    Ameriflux(j).IGBP = info.IGBP{idx};
    Ameriflux(j).Koeppen = info.Koeppen_ID{idx};
    
    % Time variables
    Ameriflux(j).Year = flx.Year;
    Ameriflux(j).Month = mo;
    Ameriflux(j).Day = dy;
    Ameriflux(j).DOY = flx.DoY;
    
    % Carbon flux variables
    Ameriflux(j).NEE = flx.NEE_f; Ameriflux(j).NEE(flx.NEE_fqc > filtThresh) = NaN;
    Ameriflux(j).NEE_fqc = flx.NEE_fqc; 
    Ameriflux(j).Reco = flx.Reco_f; Ameriflux(j).Reco(flx.NEE_fqc > filtThresh) = NaN;
    Ameriflux(j).GPP = flx.GPP_f; Ameriflux(j).GPP(flx.GPP_fqc > filtThresh) = NaN;
    Ameriflux(j).GPP_fqc = flx.GPP_fqc; 
    
    % Energy flux variables
    Ameriflux(j).LE = flx.LE_f; Ameriflux(j).LE(flx.LE_fqc > filtThresh) = NaN;
    Ameriflux(j).LE_fqc = flx.LE_fqc; 
    Ameriflux(j).H = flx.H_f; Ameriflux(j).H(flx.H_fqc > filtThresh) = NaN;
    Ameriflux(j).H_fqc = flx.H_fqc; 
    Ameriflux(j).Rg = flx.Rg_f; Ameriflux(j).Rg(flx.Rg_fqc > filtThresh) = NaN;
    Ameriflux(j).Rg_fqc = flx.Rg_fqc; 
    
    % Meteorological variables
    Ameriflux(j).Tair = flx.Tair_f; Ameriflux(j).Tair(flx.Tair_fqc > filtThresh) = NaN;
    Ameriflux(j).Tair_fqc = flx.Tair_fqc; 
    Ameriflux(j).Tmin = flx.Tmin_f; Ameriflux(j).Tmin(flx.Tair_fqc > filtThresh) = NaN;
    Ameriflux(j).VPD = flx.VPD_f; Ameriflux(j).VPD(flx.VPD_fqc > filtThresh) = NaN;
    Ameriflux(j).VPD_fqc = flx.VPD_fqc; 
    Ameriflux(j).VPDmax = flx.VPDmax_f; Ameriflux(j).VPDmax(flx.VPD_fqc > filtThresh) = NaN;
    Ameriflux(j).P = flx.P;
    
end

save('./data/Ameriflux_daily.mat','Ameriflux');

