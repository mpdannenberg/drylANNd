% Fit full DrylANNd model for each PFT

nsims = 20;
rng(3);

load ./data/Ameriflux_monthly;
n = length(Ameriflux_monthly);

% Single savanna and shrub classes
lc = {Ameriflux_monthly.IGBP}; 
[Ameriflux_monthly(strcmp(lc, 'WSA')).IGBP] = deal('SAV');
[Ameriflux_monthly(strcmp(lc, 'OSH')|strcmp(lc, 'CSH')).IGBP] = deal('SHB');
[Ameriflux_monthly(strcmp({Ameriflux_monthly.Site}, 'US-Mpj')).IGBP] = deal('SAV');
lc = {Ameriflux_monthly.IGBP}; 
lcs = unique(lc);
k = length(lcs);

% Convert monthly mean latent heat flux to monthly mean daily ET
for i = 1:n
    Ameriflux_monthly(i).ET = Ameriflux_monthly(i).LE * (1/1000000) * 60 * 60 * 24 * 0.408; % W m-2 --> MJ m-2 day-2 --> mm day-1
end

% Loop through each cover type and fit DrylANNd model
for j = 1:k
    
    C = Ameriflux_monthly(strcmp(lc, lcs{j}));

    % Get calibration data
    Xc = [extractfield(C, 'NDVI')' extractfield(C, 'EVI')' extractfield(C, 'NIRv')' ...
        extractfield(C, 'kNDVI')' ...
        extractfield(C, 'LSWI3')' extractfield(C, 'MOD11_Day')' extractfield(C, 'MOD11_Night')' ...
        extractfield(C, 'MYD11_Day')' extractfield(C, 'MYD11_Night')' ...
        extractfield(C, 'MOD11_Tdif')' extractfield(C, 'MYD11_Tdif')' extractfield(C, 'L4SM_Root')' ...
        extractfield(C, 'L4SM_Surf')' extractfield(C, 'L4SM_Tsoil')' extractfield(C, 'L3SM_VegOpacity')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')' extractfield(C, 'iWUE')']'; 

    % put all y variables on common scale (so that variance doesn't overfit
    % to WUE, which is ~1 order of magnitude greater than other variables
    Ycm = repmat(mean(Yc, 2, 'omitnan'), 1, size(Yc, 2));
    Ycs = repmat(std(Yc, 0, 2, 'omitnan'), 1, size(Yc, 2));
    Yc = (Yc-Ycm) ./ Ycs;

    % Initialize validation matrix
    Yv = NaN(size(Yc,1), size(Xc,2), nsims);

    nets = cell(1,nsims);
    trs = cell(1,nsims);
    
    for i = 1:nsims
        net = feedforwardnet(12);
        net.trainParam.showWindow = false;
        [net, tr] = train(net, Xc, Yc);

        Yv(:,:,i) = net(Xc) .* Ycs + Ycm;

        nets{i} = net;
        trs{i} = tr;
        clear net tr;
    end
    Yv_mean = squeeze(nanmean(Yv(:,:,:), 3));
    Yc = Yc .* Ycs + Ycm;
    
    DrylANNd(j).IGBP = lcs{j};
    DrylANNd(j).NNets = nets;
    DrylANNd(j).TrainingRecord = trs;
    DrylANNd(j).TrainingSites = {C.Site};
    DrylANNd(j).Xtraining = Xc;
    DrylANNd(j).Ytraining = Yc;
    DrylANNd(j).Ypredicted = Yv;
    DrylANNd(j).Xnames = {'NDVI','EVI','NIRv','kNDVI',...
        'LSWI','MOD11_Day','MOD11_Night','MYD11_Day','MYD11_Night',...
        'MOD11_Tdif','MYD11_Tdif','L4SM_Root','L4SM_Surf','L4SM_TSoil','L3SM_VegOpacity'};
    DrylANNd(j).Ynames = {'GPP','NEE','ET','iWUE'};
    
end

save('./output/DrylANNd_monthly.mat', 'DrylANNd');


