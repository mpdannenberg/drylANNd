% Predict GPP, NEE, and ET at gridded scale

% Parameters
ai_threshold = 0.75;
credInt = [0.1 0.9];

% Load model
load ./output/DrylANNd_monthly.mat;
nets = extractfield(DrylANNd, 'NNets');
nets = horzcat(nets{:});
nsims = length(nets);
yscale = DrylANNd.Yscale;
yoffset = DrylANNd.Yoffset;

% Load Aridity data
load ./data/TerraClimate_AridityIndex.mat;

% Load predictor data
load ./data/SMAP_monthly.mat;
load ./data/LST_monthly.mat;
load ./data/NBAR_monthly.mat;
load ./data/RangelandAnalysis.mat;
[nt, ny, nx] = size(SMAP_RZSM_monthly);

% Create empty arrays for response variables
GPP = NaN(nt, ny, nx);
GPP_low = NaN(nt, ny, nx);
GPP_high = NaN(nt, ny, nx);
NEE = NaN(nt, ny, nx);
NEE_low = NaN(nt, ny, nx);
NEE_high = NaN(nt, ny, nx);
ET = NaN(nt, ny, nx);
ET_low = NaN(nt, ny, nx);
ET_high = NaN(nt, ny, nx);

% Loop through each time step and predict
for t = 1:nt
    
    % Arrange predictor data
    X = [MCD43_NDVI_monthly(t, ai <= ai_threshold)
        MCD43_EVI_monthly(t, ai <= ai_threshold)
        MCD43_NIRv_monthly(t, ai <= ai_threshold)
        MCD43_kNDVI_monthly(t, ai <= ai_threshold)
        MCD43_LSWI1_monthly(t, ai <= ai_threshold)
        MCD43_LSWI2_monthly(t, ai <= ai_threshold)
        MCD43_LSWI3_monthly(t, ai <= ai_threshold)
        MOD11_Day_monthly(t, ai <= ai_threshold)
        MOD11_Night_monthly(t, ai <= ai_threshold)
        MYD11_Day_monthly(t, ai <= ai_threshold)
        MYD11_Night_monthly(t, ai <= ai_threshold)
        SMAP_RZSM_monthly(t, ai <= ai_threshold)
        SMAP_SFSM_monthly(t, ai <= ai_threshold)
        SMAP_TS_monthly(t, ai <= ai_threshold)
        AFG(ai <= ai_threshold)'
        PFG(ai <= ai_threshold)'
        SHR(ai <= ai_threshold)'
        TRE(ai <= ai_threshold)'
        LTR(ai <= ai_threshold)'
        BGR(ai <= ai_threshold)'];

    Y = NaN(length(yscale), size(X,2), nsims);
    Ys = repmat(yscale, 1, size(X,2));
    Ym = repmat(yoffset, 1, size(X,2));
    
    for i = 1:nsims

        net = nets{i};
        Y(:,:,i) = net(X) .* Ys + Ym;

    end

    Y_ens = median(Y, 3);
    Y_ens_low = quantile(Y, credInt(1), 3);
    Y_ens_high = quantile(Y, credInt(2), 3);
    
    GPP(t, ai <= ai_threshold) = Y_ens(1,:);
    NEE(t, ai <= ai_threshold) = Y_ens(2,:);
    ET(t, ai <= ai_threshold) = Y_ens(3,:);
    
    GPP_low(t, ai <= ai_threshold) = Y_ens_low(1,:);
    NEE_low(t, ai <= ai_threshold) = Y_ens_low(2,:);
    ET_low(t, ai <= ai_threshold) = Y_ens_low(3,:);
    
    GPP_high(t, ai <= ai_threshold) = Y_ens_high(1,:);
    NEE_high(t, ai <= ai_threshold) = Y_ens_high(2,:);
    ET_high(t, ai <= ai_threshold) = Y_ens_high(3,:);
    
end

save('./output/DrylANNd_monthly_prediction.mat', 'GPP','ET','NEE',...
    'GPP_high','ET_high','NEE_high','GPP_low','ET_low','NEE_low',...
    'lat','lon','yr','mo', '-v7.3');

