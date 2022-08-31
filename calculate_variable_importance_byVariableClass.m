% Test DrylANNd model for GPP/ET/NEE prediction at SRM
tic

nnsize = [14 6]; % size of the hidden layer(s)
nsims = 20;
rng(3);
excludeSites = {'MX-EMg','US-CZ4','US-Me2','US-Sne','US-Snf'}; % exclude sites from calibration (not dryland, missing data, or weird site)

load ./data/Ameriflux_monthly;
Ameriflux_monthly = Ameriflux_monthly(~ismember({Ameriflux_monthly.Site}, excludeSites));
n = length(Ameriflux_monthly);

% Convert monthly mean latent heat flux to monthly mean daily ET
for i = 1:n
    Ameriflux_monthly(i).ET = Ameriflux_monthly(i).LE * (1/1000000) * 60 * 60 * 24 * 0.408; % W m-2 --> MJ m-2 day-2 --> mm day-1
end

% Leave one site out at a time
for j = 1:n
    C = Ameriflux_monthly(setdiff(1:n, j)); 
    V = Ameriflux_monthly(j);

    % MODIS VIs + LST
    Xc = [extractfield(C, 'NDVI')' extractfield(C, 'EVI')' extractfield(C, 'NIRv')' ...
        extractfield(C, 'kNDVI')' extractfield(C, 'LSWI1')' extractfield(C, 'LSWI2')' extractfield(C, 'LSWI3')' ...
        extractfield(C, 'MOD11_Day')' extractfield(C, 'MOD11_Night')' extractfield(C, 'MYD11_Day')' extractfield(C, 'MYD11_Night')' ...
        extractfield(C, 'Rangeland_AFG')' extractfield(C, 'Rangeland_PFG')' extractfield(C, 'Rangeland_SHR')' extractfield(C, 'Rangeland_TRE')' extractfield(C, 'Rangeland_LTR')' extractfield(C, 'Rangeland_BGR')']'; % Add more as needed
    Xv = [extractfield(V, 'NDVI')' extractfield(V, 'EVI')' extractfield(V, 'NIRv')' ...
        extractfield(V, 'kNDVI')' extractfield(V, 'LSWI1')' extractfield(V, 'LSWI2')' extractfield(V, 'LSWI3')' ...
        extractfield(V, 'MOD11_Day')' extractfield(V, 'MOD11_Night')' extractfield(V, 'MYD11_Day')' extractfield(V, 'MYD11_Night')' ...
        extractfield(V, 'Rangeland_AFG')' extractfield(V, 'Rangeland_PFG')' extractfield(V, 'Rangeland_SHR')' extractfield(V, 'Rangeland_TRE')' extractfield(V, 'Rangeland_LTR')' extractfield(V, 'Rangeland_BGR')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 
    Yv = NaN(size(Yc,1), size(Xv,2), nsims);
    
    Ycm = zeros(size(Yc,1), size(Yc,2));
    Ycs = ones(size(Yc,1), size(Yc,2));
    Yvm = zeros(size(Yc,1), size(Yv,2));
    Yvs = ones(size(Yc,1), size(Yv,2));
    Yc = (Yc-Ycm) ./ Ycs;
    
    nets = cell(1,nsims);
    trs = cell(1,nsims);

    for i = 1:nsims
        net = feedforwardnet(nnsize);
        net.trainParam.showWindow = false;
        net.divideParam.trainRatio = 0.75;
        net.divideParam.testRatio = 0.;
        net.divideParam.valRatio = 0.25;
        [net, tr] = train(net, Xc, Yc);

        Yv(:,:,i) = net(Xv) .* Yvs + Yvm;

        nets{i} = net;
        trs{i} = tr;
        clear net tr;
    end

    Yv_mean = squeeze(nanmean(Yv(:,:,:), 3));
    Ameriflux_monthly(j).GPP_DrylANNd_VI_LST = Yv_mean(1,:)';
    Ameriflux_monthly(j).NEE_DrylANNd_VI_LST = Yv_mean(2,:)';
    Ameriflux_monthly(j).ET_DrylANNd_VI_LST = Yv_mean(3,:)';
    
    % MODIS VIs + SMAP
    Xc = [extractfield(C, 'NDVI')' extractfield(C, 'EVI')' extractfield(C, 'NIRv')' ...
        extractfield(C, 'kNDVI')' extractfield(C, 'LSWI1')' extractfield(C, 'LSWI2')' extractfield(C, 'LSWI3')' ...
        extractfield(C, 'L4SM_Root')' extractfield(C, 'L4SM_Surf')' extractfield(C, 'L4SM_Tsoil')' ...
        extractfield(C, 'Rangeland_AFG')' extractfield(C, 'Rangeland_PFG')' extractfield(C, 'Rangeland_SHR')' extractfield(C, 'Rangeland_TRE')' extractfield(C, 'Rangeland_LTR')' extractfield(C, 'Rangeland_BGR')']'; % Add more as needed
    Xv = [extractfield(V, 'NDVI')' extractfield(V, 'EVI')' extractfield(V, 'NIRv')' ...
        extractfield(V, 'kNDVI')' extractfield(V, 'LSWI1')' extractfield(V, 'LSWI2')' extractfield(V, 'LSWI3')' ...
        extractfield(V, 'L4SM_Root')' extractfield(V, 'L4SM_Surf')' extractfield(V, 'L4SM_Tsoil')' ...
        extractfield(V, 'Rangeland_AFG')' extractfield(V, 'Rangeland_PFG')' extractfield(V, 'Rangeland_SHR')' extractfield(V, 'Rangeland_TRE')' extractfield(V, 'Rangeland_LTR')' extractfield(V, 'Rangeland_BGR')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 
    Yv = NaN(size(Yc,1), size(Xv,2), nsims);
    
    Ycm = zeros(size(Yc,1), size(Yc,2));
    Ycs = ones(size(Yc,1), size(Yc,2));
    Yvm = zeros(size(Yc,1), size(Yv,2));
    Yvs = ones(size(Yc,1), size(Yv,2));
    Yc = (Yc-Ycm) ./ Ycs;
    
    nets = cell(1,nsims);
    trs = cell(1,nsims);

    for i = 1:nsims
        net = feedforwardnet(nnsize);
        net.trainParam.showWindow = false;
        net.divideParam.trainRatio = 0.75;
        net.divideParam.testRatio = 0.;
        net.divideParam.valRatio = 0.25;
        [net, tr] = train(net, Xc, Yc);

        Yv(:,:,i) = net(Xv) .* Yvs + Yvm;

        nets{i} = net;
        trs{i} = tr;
        clear net tr;
    end

    Yv_mean = squeeze(nanmean(Yv(:,:,:), 3));
    Ameriflux_monthly(j).GPP_DrylANNd_VI_SMAP = Yv_mean(1,:)';
    Ameriflux_monthly(j).NEE_DrylANNd_VI_SMAP = Yv_mean(2,:)';
    Ameriflux_monthly(j).ET_DrylANNd_VI_SMAP = Yv_mean(3,:)';
    
    % MODIS LST + SMAP
    Xc = [extractfield(C, 'MOD11_Day')' extractfield(C, 'MOD11_Night')' extractfield(C, 'MYD11_Day')' extractfield(C, 'MYD11_Night')' ...
        extractfield(C, 'L4SM_Root')' extractfield(C, 'L4SM_Surf')' extractfield(C, 'L4SM_Tsoil')' ...
        extractfield(C, 'Rangeland_AFG')' extractfield(C, 'Rangeland_PFG')' extractfield(C, 'Rangeland_SHR')' extractfield(C, 'Rangeland_TRE')' extractfield(C, 'Rangeland_LTR')' extractfield(C, 'Rangeland_BGR')']'; % Add more as needed
    Xv = [extractfield(V, 'MOD11_Day')' extractfield(V, 'MOD11_Night')' extractfield(V, 'MYD11_Day')' extractfield(V, 'MYD11_Night')' ...
        extractfield(V, 'L4SM_Root')' extractfield(V, 'L4SM_Surf')' extractfield(V, 'L4SM_Tsoil')' ...
        extractfield(V, 'Rangeland_AFG')' extractfield(V, 'Rangeland_PFG')' extractfield(V, 'Rangeland_SHR')' extractfield(V, 'Rangeland_TRE')' extractfield(V, 'Rangeland_LTR')' extractfield(V, 'Rangeland_BGR')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 
    Yv = NaN(size(Yc,1), size(Xv,2), nsims);
    
    Ycm = zeros(size(Yc,1), size(Yc,2));
    Ycs = ones(size(Yc,1), size(Yc,2));
    Yvm = zeros(size(Yc,1), size(Yv,2));
    Yvs = ones(size(Yc,1), size(Yv,2));
    Yc = (Yc-Ycm) ./ Ycs;
    
    nets = cell(1,nsims);
    trs = cell(1,nsims);

    for i = 1:nsims
        net = feedforwardnet(nnsize);
        net.trainParam.showWindow = false;
        net.divideParam.trainRatio = 0.75;
        net.divideParam.testRatio = 0.;
        net.divideParam.valRatio = 0.25;
        [net, tr] = train(net, Xc, Yc);

        Yv(:,:,i) = net(Xv) .* Yvs + Yvm;

        nets{i} = net;
        trs{i} = tr;
        clear net tr;
    end

    Yv_mean = squeeze(nanmean(Yv(:,:,:), 3));
    Ameriflux_monthly(j).GPP_DrylANNd_LST_SMAP = Yv_mean(1,:)';
    Ameriflux_monthly(j).NEE_DrylANNd_LST_SMAP = Yv_mean(2,:)';
    Ameriflux_monthly(j).ET_DrylANNd_LST_SMAP = Yv_mean(3,:)';
    
    % MODIS VIs
    Xc = [extractfield(C, 'NDVI')' extractfield(C, 'EVI')' extractfield(C, 'NIRv')' ...
        extractfield(C, 'kNDVI')' extractfield(C, 'LSWI1')' extractfield(C, 'LSWI2')' extractfield(C, 'LSWI3')' ...
        extractfield(C, 'Rangeland_AFG')' extractfield(C, 'Rangeland_PFG')' extractfield(C, 'Rangeland_SHR')' extractfield(C, 'Rangeland_TRE')' extractfield(C, 'Rangeland_LTR')' extractfield(C, 'Rangeland_BGR')']'; % Add more as needed
    Xv = [extractfield(V, 'NDVI')' extractfield(V, 'EVI')' extractfield(V, 'NIRv')' ...
        extractfield(V, 'kNDVI')' extractfield(V, 'LSWI1')' extractfield(V, 'LSWI2')' extractfield(V, 'LSWI3')' ...
        extractfield(V, 'Rangeland_AFG')' extractfield(V, 'Rangeland_PFG')' extractfield(V, 'Rangeland_SHR')' extractfield(V, 'Rangeland_TRE')' extractfield(V, 'Rangeland_LTR')' extractfield(V, 'Rangeland_BGR')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 
    Yv = NaN(size(Yc,1), size(Xv,2), nsims);
    
    Ycm = zeros(size(Yc,1), size(Yc,2));
    Ycs = ones(size(Yc,1), size(Yc,2));
    Yvm = zeros(size(Yc,1), size(Yv,2));
    Yvs = ones(size(Yc,1), size(Yv,2));
    Yc = (Yc-Ycm) ./ Ycs;
    
    nets = cell(1,nsims);
    trs = cell(1,nsims);

    for i = 1:nsims
        net = feedforwardnet(nnsize);
        net.trainParam.showWindow = false;
        net.divideParam.trainRatio = 0.75;
        net.divideParam.testRatio = 0.;
        net.divideParam.valRatio = 0.25;
        [net, tr] = train(net, Xc, Yc);

        Yv(:,:,i) = net(Xv) .* Yvs + Yvm;

        nets{i} = net;
        trs{i} = tr;
        clear net tr;
    end

    Yv_mean = squeeze(nanmean(Yv(:,:,:), 3));
    Ameriflux_monthly(j).GPP_DrylANNd_VI = Yv_mean(1,:)';
    Ameriflux_monthly(j).NEE_DrylANNd_VI = Yv_mean(2,:)';
    Ameriflux_monthly(j).ET_DrylANNd_VI = Yv_mean(3,:)';
    
    % MODIS SMAP
    Xc = [extractfield(C, 'L4SM_Root')' extractfield(C, 'L4SM_Surf')' extractfield(C, 'L4SM_Tsoil')' ...
        extractfield(C, 'Rangeland_AFG')' extractfield(C, 'Rangeland_PFG')' extractfield(C, 'Rangeland_SHR')' extractfield(C, 'Rangeland_TRE')' extractfield(C, 'Rangeland_LTR')' extractfield(C, 'Rangeland_BGR')']'; % Add more as needed
    Xv = [extractfield(V, 'L4SM_Root')' extractfield(V, 'L4SM_Surf')' extractfield(V, 'L4SM_Tsoil')' ...
        extractfield(V, 'Rangeland_AFG')' extractfield(V, 'Rangeland_PFG')' extractfield(V, 'Rangeland_SHR')' extractfield(V, 'Rangeland_TRE')' extractfield(V, 'Rangeland_LTR')' extractfield(V, 'Rangeland_BGR')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 
    Yv = NaN(size(Yc,1), size(Xv,2), nsims);
    
    Ycm = zeros(size(Yc,1), size(Yc,2));
    Ycs = ones(size(Yc,1), size(Yc,2));
    Yvm = zeros(size(Yc,1), size(Yv,2));
    Yvs = ones(size(Yc,1), size(Yv,2));
    Yc = (Yc-Ycm) ./ Ycs;
    
    nets = cell(1,nsims);
    trs = cell(1,nsims);

    for i = 1:nsims
        net = feedforwardnet(nnsize);
        net.trainParam.showWindow = false;
        net.divideParam.trainRatio = 0.75;
        net.divideParam.testRatio = 0.;
        net.divideParam.valRatio = 0.25;
        [net, tr] = train(net, Xc, Yc);

        Yv(:,:,i) = net(Xv) .* Yvs + Yvm;

        nets{i} = net;
        trs{i} = tr;
        clear net tr;
    end

    Yv_mean = squeeze(nanmean(Yv(:,:,:), 3));
    Ameriflux_monthly(j).GPP_DrylANNd_SMAP = Yv_mean(1,:)';
    Ameriflux_monthly(j).NEE_DrylANNd_SMAP = Yv_mean(2,:)';
    Ameriflux_monthly(j).ET_DrylANNd_SMAP = Yv_mean(3,:)';
    
    % MODIS LST
    Xc = [extractfield(C, 'MOD11_Day')' extractfield(C, 'MOD11_Night')' extractfield(C, 'MYD11_Day')' extractfield(C, 'MYD11_Night')' ...
        extractfield(C, 'Rangeland_AFG')' extractfield(C, 'Rangeland_PFG')' extractfield(C, 'Rangeland_SHR')' extractfield(C, 'Rangeland_TRE')' extractfield(C, 'Rangeland_LTR')' extractfield(C, 'Rangeland_BGR')']'; % Add more as needed
    Xv = [extractfield(V, 'MOD11_Day')' extractfield(V, 'MOD11_Night')' extractfield(V, 'MYD11_Day')' extractfield(V, 'MYD11_Night')' ...
        extractfield(V, 'Rangeland_AFG')' extractfield(V, 'Rangeland_PFG')' extractfield(V, 'Rangeland_SHR')' extractfield(V, 'Rangeland_TRE')' extractfield(V, 'Rangeland_LTR')' extractfield(V, 'Rangeland_BGR')']'; % Add more as needed
    Yc = [extractfield(C, 'GPP')' extractfield(C, 'NEE')' extractfield(C, 'ET')']'; 
    Yv = NaN(size(Yc,1), size(Xv,2), nsims);
    
    Ycm = zeros(size(Yc,1), size(Yc,2));
    Ycs = ones(size(Yc,1), size(Yc,2));
    Yvm = zeros(size(Yc,1), size(Yv,2));
    Yvs = ones(size(Yc,1), size(Yv,2));
    Yc = (Yc-Ycm) ./ Ycs;
    
    nets = cell(1,nsims);
    trs = cell(1,nsims);

    for i = 1:nsims
        net = feedforwardnet(nnsize);
        net.trainParam.showWindow = false;
        net.divideParam.trainRatio = 0.75;
        net.divideParam.testRatio = 0.;
        net.divideParam.valRatio = 0.25;
        [net, tr] = train(net, Xc, Yc);

        Yv(:,:,i) = net(Xv) .* Yvs + Yvm;

        nets{i} = net;
        trs{i} = tr;
        clear net tr;
    end

    Yv_mean = squeeze(nanmean(Yv(:,:,:), 3));
    Ameriflux_monthly(j).GPP_DrylANNd_LST = Yv_mean(1,:)';
    Ameriflux_monthly(j).NEE_DrylANNd_LST = Yv_mean(2,:)';
    Ameriflux_monthly(j).ET_DrylANNd_LST = Yv_mean(3,:)';
    
end

toc

save('output/validation/monthly/DrylANNd_Ameriflux_validation_variable_importance.mat', 'Ameriflux_monthly', '-v7.3');

