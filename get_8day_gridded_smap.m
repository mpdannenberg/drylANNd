% Aggregate SMAP data to 8-day, 16-day, and monthly time scales
sampthresh = 2; % minimum number of observations to allow for aggregation
yr = 2015:2020;
doy = 1:8:366;
yrs = reshape(repmat(yr,length(doy),1),[],1);
doys = reshape(repmat(doy',length(yr),1),[],1);
clear yr doy;

load('X:/SMAP_L4_SM/SMAP_L4SM_WesternUS.mat');
SMAP_RZSM_8day = NaN(length(yrs), length(lat), length(lon));
SMAP_SFSM_8day = NaN(length(yrs), length(lat), length(lon));
SMAP_TS_8day = NaN(length(yrs), length(lat), length(lon));

for i = 1:length(yrs)
    idx = find(yr==yrs(i) & doy>=doys(i) & doy<=(doys(i)+7));
    
    if length(idx)>sampthresh
        
        % Root zone soil moisture
        temp = SMAP_RZSM(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        SMAP_RZSM_8day(i, :, :) = sm;
        
        % Surface soil moisture
        temp = SMAP_SFSM(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        SMAP_SFSM_8day(i, :, :) = sm;
        
        % Soil temperature
        temp = SMAP_TS(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        SMAP_TS_8day(i, :, :) = sm;
        
    end
end

yr = yrs;
doy = doys;
save('./data/SMAP_8day.mat','lat','lon','yr','doy','SMAP_TS_8day','SMAP_SFSM_8day','SMAP_RZSM_8day', '-v7.3');
