% Fit full DrylANNd model for each PFT

nsims = 20;
rng(3);

load ./data/Ameriflux_monthly;
n = length(Ameriflux_monthly);

% Convert monthly mean latent heat flux to monthly mean daily ET
for i = 1:n
    Ameriflux_monthly(i).ET = Ameriflux_monthly(i).LE * (1/1000000) * 60 * 60 * 24 * 0.408; % W m-2 --> MJ m-2 day-2 --> mm day-1
end

% Get calibration data
C = Ameriflux_monthly;
Xc = [extractfield(C, 'NDVI')' extractfield(C, 'EVI')' extractfield(C, 'NIRv')' ...
    extractfield(C, 'kNDVI')' extractfield(C, 'LSWI1')' extractfield(C, 'LSWI2')' extractfield(C, 'LSWI3')' ...
    extractfield(C, 'MOD11_Day')' extractfield(C, 'MOD11_Night')' extractfield(C, 'MYD11_Day')' extractfield(C, 'MYD11_Night')' ...
    extractfield(C, 'L4SM_Root')' extractfield(C, 'L4SM_Surf')' extractfield(C, 'L4SM_Tsoil')' ...
    extractfield(C, 'MCD12_FOR')' extractfield(C, 'MCD12_GRS')' extractfield(C, 'MCD12_SAV')' extractfield(C, 'MCD12_SHB')']'; % Add more as needed
Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 

% put all y variables on common scale (so that variance doesn't overfit
% to WUE, which is ~1 order of magnitude greater than other variables
% Ycm = repmat(mean(Yc, 2, 'omitnan'), 1, size(Yc, 2));
% Ycs = repmat(std(Yc, 0, 2, 'omitnan'), 1, size(Yc, 2));
Ycm = zeros(size(Yc,1), size(Yc,2));
Ycs = ones(size(Yc,1), size(Yc,2));
Yc = (Yc-Ycm) ./ Ycs;

% Initialize validation matrix
Yv = NaN(size(Yc,1), size(Xc,2), nsims);

% loop through N simulations
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

% Save output
DrylANNd.NNets = nets;
DrylANNd.TrainingRecord = trs;
DrylANNd.TrainingSites = {C.Site};
DrylANNd.Xtraining = Xc;
DrylANNd.Ytraining = Yc;
DrylANNd.Ypredicted = Yv;
DrylANNd.Yscale = Ycs(:, 1);
DrylANNd.Yoffset = Ycm(:, 1);
DrylANNd.Xnames = {'NDVI','EVI','NIRv','kNDVI',...
    'LSWI1','LSWI2','LSWI3','MOD11_Day','MOD11_Night','MYD11_Day','MYD11_Night',...
    'L4SM_Root','L4SM_Surf','L4SM_TSoil','MCD12_FOR','MCD12_GRS','MCD12_SAV','MCD12_SHB'};
DrylANNd.Ynames = {'GPP','NEE','ET'};

save('./output/DrylANNd_monthly.mat', 'DrylANNd');


