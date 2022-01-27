% Calculate 8-day fluxes from daily fluxes

load ./data/Ameriflux_daily.mat;
n = length(Ameriflux);
sampthresh = 2;

doys = 1:8:366;

for i = 1:n
    
    Ameriflux_8day(i).Site = Ameriflux(i).Site;
    Ameriflux_8day(i).Lat = Ameriflux(i).Lat;
    Ameriflux_8day(i).Lon = Ameriflux(i).Lon;
    Ameriflux_8day(i).Elevation = Ameriflux(i).Elevation;
    Ameriflux_8day(i).Name = Ameriflux(i).Name;
    Ameriflux_8day(i).IGBP = Ameriflux(i).IGBP;
    Ameriflux_8day(i).Koeppen = Ameriflux(i).Koeppen;
    
    yrs = unique(Ameriflux(i).Year);
    nt = length(yrs)*length(doys);
    
    yr = reshape(repmat(yrs',length(doys),1),[],1);
    dy = reshape(repmat(doys',length(yrs),1),[],1);
    
    Ameriflux_8day(i).Year = yr;
    Ameriflux_8day(i).Day = dy;
    
    % Initialize empty arrays
    Ameriflux_8day(i).NEE = NaN(nt, 1);
    Ameriflux_8day(i).Reco = NaN(nt, 1);
    Ameriflux_8day(i).GPP = NaN(nt, 1);
    Ameriflux_8day(i).LE = NaN(nt, 1);
    Ameriflux_8day(i).iWUE = NaN(nt, 1);
    Ameriflux_8day(i).H = NaN(nt, 1);
    Ameriflux_8day(i).Rg = NaN(nt, 1);
    Ameriflux_8day(i).Tair = NaN(nt, 1);
    Ameriflux_8day(i).Tmin = NaN(nt, 1);
    Ameriflux_8day(i).VPD = NaN(nt, 1);
    Ameriflux_8day(i).VPDmax = NaN(nt, 1);
    Ameriflux_8day(i).NDVI = NaN(nt, 1);
    Ameriflux_8day(i).EVI = NaN(nt, 1);
    Ameriflux_8day(i).NIRv = NaN(nt, 1);
    Ameriflux_8day(i).kNDVI = NaN(nt, 1);
    Ameriflux_8day(i).LSWI1 = NaN(nt, 1);
    Ameriflux_8day(i).LSWI2 = NaN(nt, 1);
    Ameriflux_8day(i).LSWI3 = NaN(nt, 1);
    Ameriflux_8day(i).MOD11_Day = NaN(nt, 1);
    Ameriflux_8day(i).MOD11_Night = NaN(nt, 1);
    Ameriflux_8day(i).MYD11_Day = NaN(nt, 1);
    Ameriflux_8day(i).MYD11_Night = NaN(nt, 1);
    Ameriflux_8day(i).L4SM_Root = NaN(nt, 1);
    Ameriflux_8day(i).L4SM_Surf = NaN(nt, 1);
    Ameriflux_8day(i).L4SM_Tsoil = NaN(nt, 1);
    Ameriflux_8day(i).L3SM_VegOpacity = NaN(nt, 1);
    Ameriflux_8day(i).L3SM_VegWater = NaN(nt, 1);
    Ameriflux_8day(i).MCD12_BSV = NaN(nt, 1);
    Ameriflux_8day(i).MCD12_CRP = NaN(nt, 1);
    Ameriflux_8day(i).MCD12_FOR = NaN(nt, 1);
    Ameriflux_8day(i).MCD12_GRS = NaN(nt, 1);
    Ameriflux_8day(i).MCD12_SAV = NaN(nt, 1);
    Ameriflux_8day(i).MCD12_SHB = NaN(nt, 1);

    for y = 1:length(yrs)
        for d = 1:length(doys)
            
            idx = Ameriflux(i).Year==yrs(y) & Ameriflux(i).DOY>=doys(d) & Ameriflux(i).DOY<=(doys(d)+7);
            
            % NEE
            temp = Ameriflux(i).NEE(idx); 
            w = (1 - Ameriflux(i).NEE_fqc(idx)/3) .^ 2;
            nm = ~isnan(temp);
            mu = sum(temp(nm) .* w(nm)) ./ sum(w(nm));
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).NEE(yr==yrs(y) & dy==doys(d)) = mu;
            end
            
            % Reco
            temp = Ameriflux(i).Reco(idx); 
            w = (1 - Ameriflux(i).NEE_fqc(idx)/3) .^ 2;
            nm = ~isnan(temp);
            mu = sum(temp(nm) .* w(nm)) ./ sum(w(nm));
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).Reco(yr==yrs(y) & dy==doys(d)) = mu;
            end
            
            % GPP
            temp = Ameriflux(i).GPP(idx); 
            w = (1 - Ameriflux(i).GPP_fqc(idx)/3) .^ 2;
            nm = ~isnan(temp);
            mu = sum(temp(nm) .* w(nm)) ./ sum(w(nm));
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).GPP(yr==yrs(y) & dy==doys(d)) = mu;
            end
            
            % iWUE
            temp = Ameriflux(i).iWUE(idx); 
            w = (1 - Ameriflux(i).GPP_fqc(idx)/3) .^ 2;
            nm = ~isnan(temp);
            mu = sum(temp(nm) .* w(nm)) ./ sum(w(nm));
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).iWUE(yr==yrs(y) & dy==doys(d)) = mu;
            end
            
            % LE
            temp = Ameriflux(i).LE(idx); 
            w = (1 - Ameriflux(i).LE_fqc(idx)/3) .^ 2;
            nm = ~isnan(temp);
            mu = sum(temp(nm) .* w(nm)) ./ sum(w(nm));
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).LE(yr==yrs(y) & dy==doys(d)) = mu;
            end
            
            % H
            temp = Ameriflux(i).H(idx); 
            w = (1 - Ameriflux(i).H_fqc(idx)/3) .^ 2;
            nm = ~isnan(temp);
            mu = sum(temp(nm) .* w(nm)) ./ sum(w(nm));
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).H(yr==yrs(y) & dy==doys(d)) = mu;
            end
            
            % Rg
            temp = Ameriflux(i).Rg(idx); 
            w = (1 - Ameriflux(i).Rg_fqc(idx)/3) .^ 2;
            nm = ~isnan(temp);
            mu = sum(temp(nm) .* w(nm)) ./ sum(w(nm));
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).Rg(yr==yrs(y) & dy==doys(d)) = mu;
            end
            
            % Tair
            temp = Ameriflux(i).Tair(idx); 
            w = (1 - Ameriflux(i).Tair_fqc(idx)/3) .^ 2;
            nm = ~isnan(temp);
            mu = sum(temp(nm) .* w(nm)) ./ sum(w(nm));
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).Tair(yr==yrs(y) & dy==doys(d)) = mu;
            end
            
            % Tmin
            temp = Ameriflux(i).Tmin(idx); 
            w = (1 - Ameriflux(i).Tair_fqc(idx)/3) .^ 2;
            nm = ~isnan(temp);
            mu = sum(temp(nm) .* w(nm)) ./ sum(w(nm));
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).Tmin(yr==yrs(y) & dy==doys(d)) = mu;
            end
            
            % VPD
            temp = Ameriflux(i).VPD(idx); 
            w = (1 - Ameriflux(i).VPD_fqc(idx)/3) .^ 2;
            nm = ~isnan(temp);
            mu = sum(temp(nm) .* w(nm)) ./ sum(w(nm));
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).VPD(yr==yrs(y) & dy==doys(d)) = mu;
            end
            
            % VPDmax
            temp = Ameriflux(i).VPDmax(idx); 
            w = (1 - Ameriflux(i).VPD_fqc(idx)/3) .^ 2;
            nm = ~isnan(temp);
            mu = sum(temp(nm) .* w(nm)) ./ sum(w(nm));
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).VPDmax(yr==yrs(y) & dy==doys(d)) = mu;
            end
            
            % NDVI
            temp = Ameriflux(i).NDVI(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).NDVI(yr==yrs(y) & dy==doys(d)) = max(temp, [], 'omitnan');
            end
            
            % EVI
            temp = Ameriflux(i).EVI(idx); temp(temp > 1 | temp < -0.2) = NaN;
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).EVI(yr==yrs(y) & dy==doys(d)) = max(temp, [], 'omitnan');
            end
            
            % NIRv
            temp = Ameriflux(i).NIRv(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).NIRv(yr==yrs(y) & dy==doys(d)) = max(temp, [], 'omitnan');
            end
            
            % kNDVI
            temp = Ameriflux(i).kNDVI(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).kNDVI(yr==yrs(y) & dy==doys(d)) = max(temp, [], 'omitnan');
            end
            
            % LSWI1
            temp = Ameriflux(i).LSWI1(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).LSWI1(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % LSWI2
            temp = Ameriflux(i).LSWI2(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).LSWI2(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % LSWI3
            temp = Ameriflux(i).LSWI3(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).LSWI3(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % MOD11_Day
            temp = Ameriflux(i).MOD11_Day(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).MOD11_Day(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % MOD11_Night
            temp = Ameriflux(i).MOD11_Night(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).MOD11_Night(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % MYD11_Day
            temp = Ameriflux(i).MYD11_Day(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).MYD11_Day(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % MYD11_Night
            temp = Ameriflux(i).MYD11_Night(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).MYD11_Night(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % L4SM_Root
            temp = Ameriflux(i).L4SM_Root(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).L4SM_Root(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % L4SM_Surf
            temp = Ameriflux(i).L4SM_Surf(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).L4SM_Surf(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % L4SM_Tsoil
            temp = Ameriflux(i).L4SM_Tsoil(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).L4SM_Tsoil(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % L3SM_VegOpacity
            temp = Ameriflux(i).L3SM_VegOpacity(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).L3SM_VegOpacity(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % L3SM_VegWater
            temp = Ameriflux(i).L3SM_VegWater(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).L3SM_VegWater(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % MCD12_BSV
            temp = Ameriflux(i).MCD12_BSV(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).MCD12_BSV(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % MCD12_CRP
            temp = Ameriflux(i).MCD12_CRP(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).MCD12_CRP(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % MCD12_FOR
            temp = Ameriflux(i).MCD12_FOR(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).MCD12_FOR(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % MCD12_GRS
            temp = Ameriflux(i).MCD12_GRS(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).MCD12_GRS(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % MCD12_SAV
            temp = Ameriflux(i).MCD12_SAV(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).MCD12_SAV(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            % MCD12_SHB
            temp = Ameriflux(i).MCD12_SHB(idx); 
            if sum(~isnan(temp)) >= sampthresh
                Ameriflux_8day(i).MCD12_SHB(yr==yrs(y) & dy==doys(d)) = nanmean(temp);
            end
            
            
        end
    end
    
end

save('./data/Ameriflux_8day.mat', 'Ameriflux_8day');
