% Aggregate SMAP data to 16-day time scale
sampthresh = 8; % minimum number of observations to allow for aggregation
yr = 2015:2020;
mo = 1:12;
yrs = reshape(repmat(yr,length(mo),1),[],1);
mos = reshape(repmat(mo',length(yr),1),[],1);
clear yr mo;

load('X:/SMAP_L4_SM/SMAP_L4SM_WesternUS.mat');
SMAP_RZSM_monthly = NaN(length(yrs), length(lat), length(lon));
SMAP_SFSM_monthly = NaN(length(yrs), length(lat), length(lon));
SMAP_TS_monthly = NaN(length(yrs), length(lat), length(lon));

for i = 1:length(yrs)
    idx = find(yr==yrs(i) & mo==mos(i));
    
    if length(idx)>sampthresh
        
        % Root zone soil moisture
        temp = SMAP_RZSM(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        SMAP_RZSM_monthly(i, :, :) = sm;
        
        % Surface soil moisture
        temp = SMAP_SFSM(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        SMAP_SFSM_monthly(i, :, :) = sm;
        
        % Soil temperature
        temp = SMAP_TS(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        SMAP_TS_monthly(i, :, :) = sm;
        
    end
end

yr = yrs;
mo = mos;
save('./data/SMAP_monthly.mat','lat','lon','yr','mo','SMAP_TS_monthly','SMAP_SFSM_monthly','SMAP_RZSM_monthly', '-v7.3');
