% Read in MODIS LST

load ./data/Ameriflux_daily.mat;
n = length(Ameriflux);

T = readtable('./data/Ameriflux_site_subset_2020VegetationCover.csv');

for i = 1:n
    
    site = Ameriflux(i).Site;
    dt = datenum(Ameriflux(i).Year, 1, 1) + Ameriflux(i).DOY - 1;

    idx = strcmp(T.Site_ID, site);
    
    Ameriflux(i).Rangeland_AFG = NaN(size(dt));
    Ameriflux(i).Rangeland_AFG(:) = T.AFG(idx);
    
    Ameriflux(i).Rangeland_PFG = NaN(size(dt));
    Ameriflux(i).Rangeland_PFG(:) = T.PFG(idx);
    
    Ameriflux(i).Rangeland_SHR = NaN(size(dt));
    Ameriflux(i).Rangeland_SHR(:) = T.SHR(idx);
    
    Ameriflux(i).Rangeland_TRE = NaN(size(dt));
    Ameriflux(i).Rangeland_TRE(:) = T.TRE(idx);
    
    Ameriflux(i).Rangeland_LTR = NaN(size(dt));
    Ameriflux(i).Rangeland_LTR(:) = T.LTR(idx);
    
    Ameriflux(i).Rangeland_BGR = NaN(size(dt));
    Ameriflux(i).Rangeland_BGR(:) = T.BGR(idx);
    
    
end

save('./data/Ameriflux_daily.mat','Ameriflux');
