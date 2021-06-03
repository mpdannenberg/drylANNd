% Aggregate SMAP GPP and SM from daily to monthly
parpool local;

% Time setup
mo = [4:12 repmat(1:12,1,5)]';
yr = [repmat(2015,9,1)
    repmat(2016,12,1)
    repmat(2017,12,1)
    repmat(2018,12,1)
    repmat(2019,12,1)
    repmat(2020,12,1)];
nt = length(yr);

% Space setup
latlim = [-60 60];
lonlim = [-180 180];

cd('R:\data archive\SMAP_L4_SM');
fns = glob('*.h5');

glat = h5read(fns{1}, '/cell_lat');
glon = h5read(fns{1}, '/cell_lon');

latidx = find(glat(1,:) >= min(latlim) & glat(1,:) <= max(latlim)); ny = length(latidx);
lonidx = find(glon(:,1) >= min(lonlim) & glon(:,1) <= max(lonlim)); nx = length(lonidx);

% Loop through daily data and calculate monthly mean
RootSM_monthly = NaN(ny, nx, nt);
SurfSM_monthly = NaN(ny, nx, nt);
Tsoil_monthly = NaN(ny, nx, nt);
parfor i = 1:nt
    
    fns = sprintf('SMAP_L4_SM_aup_%04d%02d*.h5',yr(i),mo(i));
    fns = glob(fns);
    
    RootSM_daily = NaN(ny, nx, length(fns));
    SurfSM_daily = NaN(ny, nx, length(fns));
    Tsoil_daily = NaN(ny, nx, length(fns));

    for j = 1:length(fns)
        
        sm = double(h5read(fns{j}, '/Analysis_Data/sm_rootzone_analysis')); sm(sm==-9999) = NaN;
        sm = sm(lonidx, latidx)';
        RootSM_daily(:,:,j) = sm;
        
        sm = double(h5read(fns{j}, '/Analysis_Data/sm_surface_analysis')); sm(sm==-9999) = NaN;
        sm = sm(lonidx, latidx)';
        SurfSM_daily(:,:,j) = sm;
        
        sm = double(h5read(fns{j}, '/Analysis_Data/soil_temp_layer1_analysis')); sm(sm==-9999) = NaN;
        sm = sm(lonidx, latidx)';
        Tsoil_daily(:,:,j) = sm;
        
    end
    
    RootSM_monthly(:,:,i) = nanmean(RootSM_daily, 3);
    SurfSM_monthly(:,:,i) = nanmean(SurfSM_daily, 3);
    Tsoil_monthly(:,:,i) = nanmean(Tsoil_daily, 3);
    
end

cd('D:\Publications\NASA_SMAP_DrylANNd');

lat = glat(1,latidx)';
lon = glon(lonidx,1);

save('./data/SMAP_L4_SM_monthly.mat', 'RootSM_monthly','SurfSM_monthly','Tsoil_monthly','yr','mo','lat','lon', '-v7.3');

