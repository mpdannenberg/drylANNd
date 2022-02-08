% Read in MODIS vegetation indices

load ./data/Ameriflux_daily.mat;
n = length(Ameriflux);

MOD17 = readtable('./data/US-dryland-MOD17-MOD17A2HGF-061-results.csv');
MOD17.JDay = datenum(MOD17.Date);
MOD17.MOD17A2HGF_061_Gpp_500m(MOD17.MOD17A2HGF_061_Gpp_500m > 30000) = NaN;
MOD17.MOD17A2HGF_061_Gpp_500m = MOD17.MOD17A2HGF_061_Gpp_500m * 1000 * (1/8); % Convert from kg C m-2 --> g C m-2 day-1

MOD16 = readtable('./data/US-dryland-MOD16-MOD16A2GF-061-results.csv');
MOD16.JDay = datenum(MOD16.Date);
MOD16.MOD16A2GF_061_ET_500m(MOD16.MOD16A2GF_061_ET_500m > 30000) = NaN;
MOD16.MOD16A2GF_061_ET_500m = MOD16.MOD16A2GF_061_ET_500m * (1/8); % Convert from kg H2O m-2 --> mm day-1

for i = 1:n
    
    site = Ameriflux(i).Site;
    dt = datenum(Ameriflux(i).Year, 1, 1) + Ameriflux(i).DOY - 1;
    gpp = NaN(size(dt));
    et = NaN(size(dt));
    
    % MOD17
    temp = MOD17(strcmp(MOD17.ID, site), :);
    [~,ia,ib] = intersect(dt, temp.JDay);
    
    gpp(ia) = temp.MOD17A2HGF_061_Gpp_500m(ib);
    gpp_f = fillmissing(gpp, "previous");
    Ameriflux(i).MOD17_GPP = gpp_f;

    % MOD16
    temp = MOD16(strcmp(MOD16.ID, site), :);
    [~,ia,ib] = intersect(dt, temp.JDay);
    
    et(ia) = temp.MOD16A2GF_061_ET_500m(ib);
    et_f = fillmissing(et, "previous");
    Ameriflux(i).MOD16_ET = et_f;

end

save('./data/Ameriflux_daily.mat','Ameriflux');

