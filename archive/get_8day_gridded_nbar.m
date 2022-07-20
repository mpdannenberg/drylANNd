% Aggregate LST data to 8-day, 16-day, and monthly time scales
sampthresh = 2; % minimum number of observations to allow for aggregation
yr = 2015:2020;
doy = 1:8:366;
yrs = reshape(repmat(yr,length(doy),1),[],1);
doys = reshape(repmat(doy',length(yr),1),[],1);
clear yr doy;

% loop through each time segment
fn = matfile('X:/MCD43C4/MCD43_WesternUS.mat');
lat = fn.lat; lon = fn.lon;
yr = fn.yr; mo = fn.mo; dy = fn.dy; doy = fn.doy;
MCD43_NDVI_8day = NaN(length(yrs), length(lat), length(lon));
MCD43_kNDVI_8day = NaN(length(yrs), length(lat), length(lon));
MCD43_NIRv_8day = NaN(length(yrs), length(lat), length(lon));
MCD43_EVI_8day = NaN(length(yrs), length(lat), length(lon));
MCD43_LSWI1_8day = NaN(length(yrs), length(lat), length(lon));
MCD43_LSWI2_8day = NaN(length(yrs), length(lat), length(lon));
MCD43_LSWI3_8day = NaN(length(yrs), length(lat), length(lon));

for i = 1:length(yrs)
    idx = find(yr==yrs(i) & doy>=doys(i) & doy<=(doys(i)+7));
    
    if length(idx)>sampthresh
        
        % NDVI
        temp = fn.MCD43_NDVI(idx, :, :);
        sm = squeeze(max(temp, [], 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_NDVI_8day(i, :, :) = sm;
        
        % kNDVI
        temp = fn.MCD43_kNDVI(idx, :, :);
        sm = squeeze(max(temp, [], 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_kNDVI_8day(i, :, :) = sm;
        
        % NIRv
        temp = fn.MCD43_NIRv(idx, :, :);
        sm = squeeze(max(temp, [], 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_NIRv_8day(i, :, :) = sm;
        
        % EVI
        temp = fn.MCD43_EVI(idx, :, :);
        temp(temp > 1 | temp < -0.2) = NaN;
        sm = squeeze(max(temp, [], 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_EVI_8day(i, :, :) = sm;
        
        % LSWI1
        temp = fn.MCD43_LSWI1(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_LSWI1_8day(i, :, :) = sm;
        
        % LSWI2
        temp = fn.MCD43_LSWI2(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_LSWI2_8day(i, :, :) = sm;
        
        % LSWI3
        temp = fn.MCD43_LSWI3(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_LSWI3_8day(i, :, :) = sm;
        
    end
end

yr = yrs;
doy = doys;
save('./data/NBAR_8day.mat','lat','lon','yr','doy','MCD43_NDVI_8day','MCD43_kNDVI_8day','MCD43_NIRv_8day','MCD43_EVI_8day','MCD43_LSWI1_8day','MCD43_LSWI2_8day','MCD43_LSWI3_8day', '-v7.3');   
