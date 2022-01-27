% Aggregate LST data to 8-day, 16-day, and monthly time scales
sampthresh = 8; % minimum number of observations to allow for aggregation
yr = 2015:2020;
mo = 1:12;
yrs = reshape(repmat(yr,length(mo),1),[],1);
mos = reshape(repmat(mo',length(yr),1),[],1);
clear yr mo;

% loop through each time segment
fn = matfile('X:/MCD43C4/MCD43_WesternUS.mat');
lat = fn.lat; lon = fn.lon;
yr = fn.yr; mo = fn.mo; dy = fn.dy; doy = fn.doy;
MCD43_NDVI_monthly = NaN(length(yrs), length(lat), length(lon));
MCD43_kNDVI_monthly = NaN(length(yrs), length(lat), length(lon));
MCD43_NIRv_monthly = NaN(length(yrs), length(lat), length(lon));
MCD43_EVI_monthly = NaN(length(yrs), length(lat), length(lon));
MCD43_LSWI1_monthly = NaN(length(yrs), length(lat), length(lon));
MCD43_LSWI2_monthly = NaN(length(yrs), length(lat), length(lon));
MCD43_LSWI3_monthly = NaN(length(yrs), length(lat), length(lon));

for i = 1:length(yrs)
    idx = find(yr==yrs(i) & mo==mos(i));
    
    if length(idx)>sampthresh
        
        % NDVI
        temp = fn.MCD43_NDVI(idx, :, :);
        sm = squeeze(max(temp, [], 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_NDVI_monthly(i, :, :) = sm;
        
        % kNDVI
        temp = fn.MCD43_kNDVI(idx, :, :);
        sm = squeeze(max(temp, [], 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_kNDVI_monthly(i, :, :) = sm;
        
        % NIRv
        temp = fn.MCD43_NIRv(idx, :, :);
        sm = squeeze(max(temp, [], 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_NIRv_monthly(i, :, :) = sm;
        
        % EVI
        temp = fn.MCD43_EVI(idx, :, :);
        temp(temp > 1 | temp < -0.2) = NaN;
        sm = squeeze(max(temp, [], 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_EVI_monthly(i, :, :) = sm;
        
        % LSWI1
        temp = fn.MCD43_LSWI1(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_LSWI1_monthly(i, :, :) = sm;
        
        % LSWI2
        temp = fn.MCD43_LSWI2(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_LSWI2_monthly(i, :, :) = sm;
        
        % LSWI3
        temp = fn.MCD43_LSWI3(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MCD43_LSWI3_monthly(i, :, :) = sm;
        
    end
end

yr = yrs;
mo = mos;
save('./data/NBAR_monthly.mat','lat','lon','yr','mo','MCD43_NDVI_monthly','MCD43_kNDVI_monthly','MCD43_NIRv_monthly','MCD43_EVI_monthly','MCD43_LSWI1_monthly','MCD43_LSWI2_monthly','MCD43_LSWI3_monthly', '-v7.3');   
