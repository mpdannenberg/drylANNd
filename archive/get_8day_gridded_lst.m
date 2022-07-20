% Aggregate LST data to 8-day, 16-day, and monthly time scales
sampthresh = 2; % minimum number of observations to allow for aggregation
yr = 2015:2020;
doy = 1:8:366;
yrs = reshape(repmat(yr,length(doy),1),[],1);
doys = reshape(repmat(doy',length(yr),1),[],1);
clear yr doy;

%% MOD11
load('X:/MOD11C1/MOD11_WesternUS.mat');
MOD11_Day_8day = NaN(length(yrs), length(lat), length(lon));
MOD11_Night_8day = NaN(length(yrs), length(lat), length(lon));

for i = 1:length(yrs)
    idx = find(yr==yrs(i) & doy>=doys(i) & doy<=(doys(i)+7));
    
    if length(idx)>sampthresh
        
        % Daytime
        temp = MOD11_Day(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MOD11_Day_8day(i, :, :) = sm;
        
        % Surface soil moisture
        temp = MOD11_Night(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MOD11_Night_8day(i, :, :) = sm;
        
    end
end

%% MYD11
load('X:/MYD11C1/MYD11_WesternUS.mat');
MYD11_Day_8day = NaN(length(yrs), length(lat), length(lon));
MYD11_Night_8day = NaN(length(yrs), length(lat), length(lon));

for i = 1:length(yrs)
    idx = find(yr==yrs(i) & doy>=doys(i) & doy<=(doys(i)+7));
    
    if length(idx)>sampthresh
        
        % Daytime
        temp = MYD11_Day(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MYD11_Day_8day(i, :, :) = sm;
        
        % Surface soil moisture
        temp = MYD11_Night(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MYD11_Night_8day(i, :, :) = sm;
        
    end
end

yr = yrs;
doy = doys;
save('./data/LST_8day.mat','lat','lon','yr','doy','MOD11_Day_8day','MOD11_Night_8day','MYD11_Day_8day','MYD11_Night_8day', '-v7.3');   
