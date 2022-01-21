% Aggregate SMAP data to 16-day time scale
sampthresh = 4; % minimum number of observations to allow for aggregation
yr = 2015:2020;
doy = 1:16:366;
yrs = reshape(repmat(yr,length(doy),1),[],1);
doys = reshape(repmat(doy',length(yr),1),[],1);
clear yr doy;

load('X:/SMAP_L4_SM/SMAP_L4SM_WesternUS.mat');
SMAP_RZSM_16day = NaN(length(yrs), length(lat), length(lon));
SMAP_SFSM_16day = NaN(length(yrs), length(lat), length(lon));
SMAP_TS_16day = NaN(length(yrs), length(lat), length(lon));

for i = 1:length(yrs)
    idx = find(yr==yrs(i) & doy>=doys(i) & doy<=(doys(i)+15));
    
    if length(idx)>sampthresh
        
        % Root zone soil moisture
        temp = SMAP_RZSM(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        SMAP_RZSM_16day(i, :, :) = sm;
        
        % Surface soil moisture
        temp = SMAP_SFSM(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        SMAP_SFSM_16day(i, :, :) = sm;
        
        % Soil temperature
        temp = SMAP_TS(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        SMAP_TS_16day(i, :, :) = sm;
        
    end
end

yr = yrs;
doy = doys;
save('./data/SMAP_16day.mat','lat','lon','yr','doy','SMAP_TS_16day','SMAP_SFSM_16day','SMAP_RZSM_16day', '-v7.3');
