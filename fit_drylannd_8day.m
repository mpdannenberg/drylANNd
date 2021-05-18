% Fit full DrylANNd model for each PFT

nsims = 20;
rng(3);

load ./data/Ameriflux_8day;
n = length(Ameriflux_8day);

% Single savanna and shrub classes
lc = {Ameriflux_8day.IGBP}; 
[Ameriflux_8day(strcmp(lc, 'WSA')).IGBP] = deal('SAV');
[Ameriflux_8day(strcmp(lc, 'OSH')|strcmp(lc, 'CSH')).IGBP] = deal('SHB');
[Ameriflux_8day(strcmp({Ameriflux_8day.Site}, 'US-Mpj')).IGBP] = deal('SAV');
lc = {Ameriflux_8day.IGBP}; 
lcs = unique(lc);
k = length(lcs);

% Convert monthly mean latent heat flux to monthly mean daily ET
for i = 1:n
    Ameriflux_8day(i).ET = Ameriflux_8day(i).LE * (1/1000000) * 60 * 60 * 24 * 0.408; % W m-2 --> MJ m-2 day-2 --> mm day-1
end

% Loop through each cover type and fit DrylANNd model
for j = 1:k
    
    C = Ameriflux_8day(strcmp(lc, lcs{j}));
    Xc = [extractfield(C, 'NDVI')' extractfield(C, 'EVI')' extractfield(C, 'NIRv')' ...
        extractfield(C, 'kNDVI')' ...
        extractfield(C, 'LSWI3')' extractfield(C, 'MOD11_Day')' extractfield(C, 'MOD11_Night')' ...
        extractfield(C, 'MYD11_Day')' extractfield(C, 'MYD11_Night')' extractfield(C, 'L4SM_Root')' ...
        extractfield(C, 'L4SM_Surf')' extractfield(C, 'L4SM_Tsoil')' extractfield(C, 'L3SM_VegOpacity')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 
    Yv = NaN(3, size(Xc,2), nsims);

    nets = cell(1,nsims);
    trs = cell(1,nsims);
    
    for i = 1:nsims
        net = feedforwardnet(12);
        net.trainParam.showWindow = false;
        [net, tr] = train(net, Xc, Yc);

        Yv(:,:,i) = net(Xc);

        nets{i} = net;
        trs{i} = tr;
        clear net tr;
    end
    Yv_mean = squeeze(nanmean(Yv(:,:,:), 3));
    
    DrylANNd(j).IGBP = lcs{j};
    DrylANNd(j).NNets = nets;
    DrylANNd(j).TrainingRecord = trs;
    DrylANNd(j).TrainingSites = {C.Site};
    DrylANNd(j).Xtraining = Xc;
    DrylANNd(j).Ytraining = Yc;
    DrylANNd(j).Ypredicted = Yv;
    DrylANNd(j).Xnames = {'NDVI','EVI','NIRv','kNDVI',...
        'LSWI','MOD11_Day','MOD11_Night','MYD11_Day','MYD11_Night',...
        'L4SM_Root','L4SM_Surf','L4SM_TSoil','L3SM_VegOpacity'};
    DrylANNd(j).Ynames = {'GPP','NEE','ET'};
    
end

save('./output/DrylANNd_8day.mat', 'DrylANNd');


