function [yf, qa] = filtering_outliers(y, doy, varargin)
% Filter outliers in time series
%   Based on Hwang et al. (2011), Dannenberg et al. (2015), and Dannenberg
%   et al. (2018)

% Optional inputs and defaults
if nargin > 2 % read in advanced options if user-specified:
    % first fill values in with defaults:
    thres = 0.05; % only if outliers are located this difference from mean values then excluded
    winsize = 30; % grouping size for outlier analysis
    cycles = 3; % number of outlier filtering cycles
    uwl = 2; % upper whisker length for outlier analysis
    lwl = 2; % lower whisker length for outlier analysis
    qa = ~isnan(y);
    nmin = 15; % minimum number of points for running the analysis
    % then over-write defaults if user-specified:
    Nvararg = length(varargin);
    for i = 1:Nvararg/2
        namein = varargin{2*(i-1)+1};
        valin = varargin{2*i};
        switch namein
            case 'thres'
                thres = valin;
            case 'winsize'
                winsize = valin;
            case 'cycles'
                cycles = valin;
            case 'wl'
                wl = valin;
            case 'qa'
                qa = valin;
            case 'nmin'
                nmin = valin;
            
        end
    end
else % otherwise, read in defaults:
    thres = 0.05; % only if outliers are located this difference from mean values then excluded
    winsize = 30; % grouping size for outlier analysis
    cycles = 3; % number of outlier filtering cycles
    wl = 2; % whisker length for outlier analysis
    qa = ~isnan(y); % logical index for good-quality observations
    nmin = 15;
end

% Filtering outliers
qa_temp = qa;
yearday = doy;
doys = sort(unique(doy));

for j = 1:cycles
    
    % Find values between their neighbors (don't filter these)
    y_temp = y; y_temp(qa_temp==0) = NaN;
    ya = lagmatrix(y_temp, [-1 -2]); ya = fillmissing(ya, 'next', 1);
    yb = lagmatrix(y_temp, [1 2]); yb = fillmissing(yb, 'previous', 1);
    monoidx = (y_temp >= yb(:,1) & y_temp <= ya(:,1)) | ...
        (y_temp <= yb(:,1) & y_temp >= ya(:,1)) | ...
        (y_temp >= yb(:,2) & y_temp <= ya(:,1)) | ...
        (y_temp <= yb(:,2) & y_temp >= ya(:,1)) | ...
        (y_temp >= yb(:,1) & y_temp <= ya(:,2)) | ...
        (y_temp <= yb(:,1) & y_temp >= ya(:,2)) | ...
        (y_temp >= yb(:,2) & y_temp <= ya(:,2)) | ...
        (y_temp <= yb(:,2) & y_temp >= ya(:,2));

    for k = 1:length(doys)
        clear idx before after NDVI_idx qa_idx yearday_idx
        
        % find start and end DOY for filtering
        before = doys(k) - winsize/2;
        after = doys(k) + winsize/2;

        % extract time series values within the window (before ~ after)
        if (before < 0)  
            idx = (((yearday <= after) | (yearday > (before + 365))) & qa_temp & ~isnan(y));
        elseif (after > 365)
            idx = (((yearday > before) | (yearday <= (after - 365))) & qa_temp & ~isnan(y));
        else
            idx = (((yearday > before) & (yearday <= after)) & qa_temp & ~isnan(y));
        end

        % Outlier filtering 
        if (sum(idx) > nmin) % statiscally significant number of points
            mu = mean(y(idx)); 

            Qs = quantile(y(idx), [0.25 0.75]); % get quantiles from the group
            iqr = Qs(2) - Qs(1);
            out_idx = idx & (y<(Qs(1)-lwl*iqr) | y>(Qs(2)+uwl*iqr)) & (abs(y - mu) > thres);
            qa_temp(out_idx & ~monoidx) = 0;
        end
    end
    
end

% update variables 
qa = qa_temp;
yf = y;
yf(~qa) = NaN;

end

