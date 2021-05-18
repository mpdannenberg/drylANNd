% Read in MODIS LST

load ./data/Ameriflux_daily.mat;
n = length(Ameriflux);

MOD11 = readtable('./data/Ameriflux-drylands-MOD11-MOD11A1-006-results.csv');
MOD11.JDay = datenum(MOD11.Date);
MOD11.MOD11A1_006_LST_Day_1km(MOD11.MOD11A1_006_LST_Day_1km == 0) = NaN;
MOD11.MOD11A1_006_LST_Night_1km(MOD11.MOD11A1_006_LST_Night_1km == 0) = NaN;

MYD11 = readtable('./data/Ameriflux-drylands-MYD11-MYD11A1-006-results.csv');
MYD11.JDay = datenum(MYD11.Date);
MYD11.MYD11A1_006_LST_Day_1km(MYD11.MYD11A1_006_LST_Day_1km == 0) = NaN;
MYD11.MYD11A1_006_LST_Night_1km(MYD11.MYD11A1_006_LST_Night_1km == 0) = NaN;

for i = 1:n
    
    site = Ameriflux(i).Site;
    dt = datenum(Ameriflux(i).Year, 1, 1) + Ameriflux(i).DOY - 1;
    
    % MOD11
    temp = MOD11(strcmp(MOD11.ID, site), :);
    [~,ia,ib] = intersect(dt, temp.JDay);
    
    Ameriflux(i).MOD11_Day = NaN(size(dt));
    Ameriflux(i).MOD11_Night = NaN(size(dt));
    
    Ameriflux(i).MOD11_Day(ia) = temp.MOD11A1_006_LST_Day_1km(ib);
    Ameriflux(i).MOD11_Night(ia) = temp.MOD11A1_006_LST_Night_1km(ib);
    
    % MYD11
    temp = MYD11(strcmp(MYD11.ID, site), :);
    [~,ia,ib] = intersect(dt, temp.JDay);
    
    Ameriflux(i).MYD11_Day = NaN(size(dt));
    Ameriflux(i).MYD11_Night = NaN(size(dt));
    
    Ameriflux(i).MYD11_Day(ia) = temp.MYD11A1_006_LST_Day_1km(ib);
    Ameriflux(i).MYD11_Night(ia) = temp.MYD11A1_006_LST_Night_1km(ib);
    
end

save('./data/Ameriflux_daily.mat','Ameriflux');
