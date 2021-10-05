% Read in SMAP L4 soil moisture/temperature

% Load daily Ameriflux data and get information
load ./data/Ameriflux_daily.mat;
n = length(Ameriflux);

sites = {Ameriflux.Site};
lat = [Ameriflux.Lat];
lon = [Ameriflux.Lon];

% Get grid 
cd('R:\data archive\SMAP_L4_SM');
fns = glob('*.h5');
glat = h5read(fns{1}, '/cell_lat');
glon = h5read(fns{1}, '/cell_lon');
glatlon = [reshape(glat,[],1) reshape(glon, [], 1)];

% Find cell index for each Ameriflux site and add variables for L3SM data
xind = NaN(size(lat));
yind = NaN(size(lat));
for i = 1:length(sites)
    DistDeg = distance(lat(i), lon(i), glatlon(:,1), glatlon(:,2));
    DistKM = distdim(DistDeg, 'deg', 'km');

    xy = glatlon(DistKM == min(DistKM), :);
    [xind(i), yind(i)] = find(glat == xy(1,1) & glon == xy(1,2));
    
    Ameriflux(i).L3SM_VegOpacity = NaN(size(Ameriflux(i).DOY));
    Ameriflux(i).L3SM_VegWater = NaN(size(Ameriflux(i).DOY));
    
end
clear glat glon glatlon xy DistDeg DistKM i;

% Get VOD and vegetation water content
cd('R:\data archive\SMAP_L3_SM_P_E');
fns = glob('*.h5');
for i = 1:length(fns)
    
    % Get time stamps
    yr = str2double(fns{i}(16:19));
    mo = str2double(fns{i}(20:21));
    dy = str2double(fns{i}(22:23));
    doy = datenum(yr, mo, dy) - datenum(yr,1,1) +1;
    
    if yr < 2021
        % Get rootzone SM
        vod_am = double(h5read(fns{i}, '/Soil_Moisture_Retrieval_Data_AM/vegetation_opacity')); 
        vod_am(vod_am == -9999) = NaN;
        vwc_am = double(h5read(fns{i}, '/Soil_Moisture_Retrieval_Data_AM/vegetation_water_content')); 
        vwc_am(vwc_am == -9999) = NaN;
        vod_pm = double(h5read(fns{i}, '/Soil_Moisture_Retrieval_Data_PM/vegetation_opacity_pm')); 
        vod_pm(vod_pm == -9999) = NaN;
        vwc_pm = double(h5read(fns{i}, '/Soil_Moisture_Retrieval_Data_PM/vegetation_water_content_pm')); 
        vwc_pm(vwc_pm == -9999) = NaN;

        for j = 1:n
            idx = find(Ameriflux(j).Year==yr & Ameriflux(j).DOY == doy);

            Ameriflux(j).L3SM_VegOpacity(idx) = nanmean([vod_am(xind(j), yind(j)) vod_pm(xind(j), yind(j))]);
            Ameriflux(j).L3SM_VegWater(idx) = nanmean([vwc_am(xind(j), yind(j)) vwc_pm(xind(j), yind(j))]);

        end

        clear yr mo dy doy idx j vod_am vod_pm vwc_am vwc_pm;
    end
end

cd('D:\Publications\NASA_SMAP_DrylANNd');
save('./data/Ameriflux_daily.mat','Ameriflux');

