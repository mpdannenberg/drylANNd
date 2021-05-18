% Read in MODIS LST

load ./data/Ameriflux_daily.mat;
n = length(Ameriflux);

MCD43 = readtable('./data/Ameriflux-drylands-MCD43A4-006-results.csv');
MCD43.JDay = datenum(MCD43.Date);
MCD43.MCD43A4_006_Nadir_Reflectance_Band1(MCD43.MCD43A4_006_BRDF_Albedo_Band_Mandatory_Quality_Band1 == 255) = NaN;
MCD43.MCD43A4_006_Nadir_Reflectance_Band2(MCD43.MCD43A4_006_BRDF_Albedo_Band_Mandatory_Quality_Band2 == 255) = NaN;
MCD43.MCD43A4_006_Nadir_Reflectance_Band3(MCD43.MCD43A4_006_BRDF_Albedo_Band_Mandatory_Quality_Band3 == 255) = NaN;
MCD43.MCD43A4_006_Nadir_Reflectance_Band4(MCD43.MCD43A4_006_BRDF_Albedo_Band_Mandatory_Quality_Band4 == 255) = NaN;
MCD43.MCD43A4_006_Nadir_Reflectance_Band5(MCD43.MCD43A4_006_BRDF_Albedo_Band_Mandatory_Quality_Band5 == 255) = NaN;
MCD43.MCD43A4_006_Nadir_Reflectance_Band6(MCD43.MCD43A4_006_BRDF_Albedo_Band_Mandatory_Quality_Band6 == 255) = NaN;
MCD43.MCD43A4_006_Nadir_Reflectance_Band7(MCD43.MCD43A4_006_BRDF_Albedo_Band_Mandatory_Quality_Band7 == 255) = NaN;

for i = 1:n
    
    site = Ameriflux(i).Site;
    dt = datenum(Ameriflux(i).Year, 1, 1) + Ameriflux(i).DOY - 1;
    
    % MCD43
    temp = MCD43(strcmp(MCD43.ID, site), :);
    [~,ia,ib] = intersect(dt, temp.JDay);
    [yr, mo, dy] = datevec(temp.JDay);
    doy = temp.JDay - datenum(yr, 1, 1) + 1;
    
    % Get raw bands
    Band1 = temp.MCD43A4_006_Nadir_Reflectance_Band1;
    Band2 = temp.MCD43A4_006_Nadir_Reflectance_Band2;
    Band3 = temp.MCD43A4_006_Nadir_Reflectance_Band3;
    Band4 = temp.MCD43A4_006_Nadir_Reflectance_Band4;
    Band5 = temp.MCD43A4_006_Nadir_Reflectance_Band5;
    Band6 = temp.MCD43A4_006_Nadir_Reflectance_Band6;
    Band7 = temp.MCD43A4_006_Nadir_Reflectance_Band7;
    
    % Calculate vegetation indices
    NDVI = (Band2 - Band1) ./ (Band2 + Band1);
    kNDVI = tanh(NDVI.^2);
    EVI = 2.5*(Band2 - Band1) ./ (Band2 + 6*Band1 - 7.5*Band3 + 1);
    NIRv = Band2 .* (NDVI - 0.08);
    LSWI1 = (Band2 - Band5) ./ (Band2 + Band5);
    LSWI2 = (Band2 - Band6) ./ (Band2 + Band6);
    LSWI3 = (Band2 - Band7) ./ (Band2 + Band7);
    
    % Filter vegetation indices for outliers 
    NDVI_f = filtering_outliers(NDVI, doy, 'lwl',3, 'uwl',3, 'thres',0.1*range(NDVI), 'cycles',2, 'winsize',15);
    kNDVI_f = filtering_outliers(kNDVI, doy, 'lwl',3, 'uwl',3, 'thres',0.1*range(kNDVI), 'cycles',2, 'winsize',15);
    EVI_f = filtering_outliers(EVI, doy, 'lwl',3, 'uwl',3, 'thres',0.1*range(EVI), 'cycles',2, 'winsize',15);
    NIRv_f = filtering_outliers(NIRv, doy, 'lwl',3, 'uwl',3, 'thres',0.1*range(NIRv), 'cycles',2, 'winsize',15);
    LSWI1_f = filtering_outliers(LSWI1, doy, 'lwl',3, 'uwl',3, 'thres',0.1*range(LSWI1), 'cycles',2, 'winsize',15);
    LSWI2_f = filtering_outliers(LSWI2, doy, 'lwl',3, 'uwl',3, 'thres',0.1*range(LSWI2), 'cycles',2, 'winsize',15);
    LSWI3_f = filtering_outliers(LSWI3, doy, 'lwl',3, 'uwl',3, 'thres',0.1*range(LSWI3), 'cycles',2, 'winsize',15);
    
    Ameriflux(i).NDVI = NaN(size(dt));
    Ameriflux(i).EVI = NaN(size(dt));
    Ameriflux(i).NIRv = NaN(size(dt));
    Ameriflux(i).kNDVI = NaN(size(dt));
    Ameriflux(i).LSWI1 = NaN(size(dt));
    Ameriflux(i).LSWI2 = NaN(size(dt));
    Ameriflux(i).LSWI3 = NaN(size(dt));
    
    Ameriflux(i).NDVI(ia) = NDVI_f(ib);
    Ameriflux(i).EVI(ia) = EVI_f(ib); 
    Ameriflux(i).NIRv(ia) = NIRv_f(ib);
    Ameriflux(i).kNDVI(ia) = kNDVI_f(ib);
    Ameriflux(i).LSWI1(ia) = LSWI1_f(ib);
    Ameriflux(i).LSWI2(ia) = LSWI2_f(ib);
    Ameriflux(i).LSWI3(ia) = LSWI3_f(ib);
    
    
end

save('./data/Ameriflux_daily.mat','Ameriflux');
