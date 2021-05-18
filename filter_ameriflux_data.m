% Filter Ameriflux data for outliers

load ./data/Ameriflux_daily.mat;
n = length(Ameriflux);

for i = 1:n
    
    doy = Ameriflux(i).DOY;
    
    % NEE
    y = Ameriflux(i).NEE;
    yf = filtering_outliers(y, doy, 'lwl',3, 'uwl',3, 'thres',2, 'cycles',3, 'winsize',15);
    Ameriflux(i).NEE_f = yf;
    Ameriflux(i).NEE_fqc(isnan(yf)) = NaN;
    
    % Recalculate GPP using daily filtered NEE and Reco
    Ameriflux(i).GPP_f = Ameriflux(i).Reco - Ameriflux(i).NEE_f; 
    
    
end

% Do we want to use this? Seems like some filtering is necessary given
% noise in the gap-filling/partitioning, but also filtering out real values
% during extreme events?
