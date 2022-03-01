% Read in MODIS LST

load ./data/Ameriflux_daily.mat;
n = length(Ameriflux);
yrs = 2015:2020;

% T = readtable('./data/RangelandAnalysis_FractionalCover/Ameriflux_site_subset_2020VegetationCover.csv');

for i = 1:n
    
    site = Ameriflux(i).Site;
    yr = Ameriflux(i).Year;
    dt = datenum(yr, 1, 1) + Ameriflux(i).DOY - 1;

    Ameriflux(i).Rangeland_AFG = NaN(size(dt));
    Ameriflux(i).Rangeland_PFG = NaN(size(dt));
    Ameriflux(i).Rangeland_SHR = NaN(size(dt));
    Ameriflux(i).Rangeland_TRE = NaN(size(dt));
    Ameriflux(i).Rangeland_LTR = NaN(size(dt));
    Ameriflux(i).Rangeland_BGR = NaN(size(dt));

    for y = 1:length(yrs)
        T = readtable(['./data/RangelandAnalysis_FractionalCover/Ameriflux_sites_', num2str(yrs(y)), '_VegetationCover.xlsx']);
        
        idx = strcmp(T.Site_ID, site);
        
        Ameriflux(i).Rangeland_AFG(yr == yrs(y)) = T.AFG(idx);
        Ameriflux(i).Rangeland_PFG(yr == yrs(y)) = T.PFG(idx);
        Ameriflux(i).Rangeland_SHR(yr == yrs(y)) = T.SHR(idx);
        Ameriflux(i).Rangeland_TRE(yr == yrs(y)) = T.TRE(idx);
        Ameriflux(i).Rangeland_LTR(yr == yrs(y)) = T.LTR(idx);
        Ameriflux(i).Rangeland_BGR(yr == yrs(y)) = T.BGR(idx);
        
    end
end

save('./data/Ameriflux_daily.mat','Ameriflux');
