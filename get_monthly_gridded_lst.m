% Aggregate LST data to 8-day, 16-day, and monthly time scales
sampthresh = 8; % minimum number of observations to allow for aggregation
yr = 2015:2020;
mo = 1:12;
yrs = reshape(repmat(yr,length(mo),1),[],1);
mos = reshape(repmat(mo',length(yr),1),[],1);
clear yr mo;

%% MOD11
load('X:/MOD11C1/MOD11_WesternUS.mat');
MOD11_Day_monthly = NaN(length(yrs), length(lat), length(lon));
MOD11_Night_monthly = NaN(length(yrs), length(lat), length(lon));

for i = 1:length(yrs)
    idx = find(yr==yrs(i) & mo==mos(i));
    
    if length(idx)>sampthresh
        
        % Daytime
        temp = MOD11_Day(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MOD11_Day_monthly(i, :, :) = sm;
        
        % Surface soil moisture
        temp = MOD11_Night(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MOD11_Night_monthly(i, :, :) = sm;
        
    end
end

%% MYD11
load('X:/MYD11C1/MYD11_WesternUS.mat');
MYD11_Day_monthly = NaN(length(yrs), length(lat), length(lon));
MYD11_Night_monthly = NaN(length(yrs), length(lat), length(lon));

for i = 1:length(yrs)
    idx = find(yr==yrs(i) & mo==mos(i));
    
    if length(idx)>sampthresh
        
        % Daytime
        temp = MYD11_Day(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MYD11_Day_monthly(i, :, :) = sm;
        
        % Surface soil moisture
        temp = MYD11_Night(idx, :, :);
        sm = squeeze(mean(temp, 1, "omitnan"));
        obs = squeeze(sum(~isnan(temp), 1));
        sm(obs < sampthresh) = NaN;
        MYD11_Night_monthly(i, :, :) = sm;
        
    end
end

yr = yrs;
mo = mos;
save('./data/LST_monthly.mat','lat','lon','yr','mo','MOD11_Day_monthly','MOD11_Night_monthly','MYD11_Day_monthly','MYD11_Night_monthly', '-v7.3');   
