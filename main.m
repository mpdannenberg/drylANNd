% Main file for DrylANNd modeling

% Subset TerraClimate aridity index and MODIS LC fraction
get_terraclimate_aridity;
get_modis_lc;

% Read in and QC-filter Ameriflux data
read_ameriflux_data;

% Read in NBAR data, and calculate/filter vegetation indices
read_modis_nbar; % Site-level
read_gridded_mcd43; % Full western U.S.

% Read in MODIS LST
read_modis_lst; % Site-level
read_gridded_lst; % Full western U.S.

% Read in SMAP L4 soil moisture/temperature
read_smap_l4sm; % Site-level
read_gridded_sm; % Full western U.S.

% Read in MODIS land cover fraction
read_modis_lc; % Site-level

% Read in SMAP L3 VOD/vegetation water content - NOT USED FOR NOW
% read_smap_l3vod;

% Filter out outlier NEE and recalculate GPP - NOT USED FOR NOW
%filter_ameriflux_data;

% Aggregate daily variables to 8- and 16-day and monthly
get_8day_ameriflux;
get_16day_ameriflux;
get_monthly_ameriflux;

get_8day_gridded_smap;
get_16day_gridded_smap;
get_monthly_gridded_smap;

get_8day_gridded_lst;
get_16day_gridded_lst;
get_monthly_gridded_lst;

get_8day_gridded_nbar;
get_16day_gridded_nbar;
get_monthly_gridded_nbar;

% Fit DrylANNd model for each temporal interval
fit_drylannd_8day;
fit_drylannd_16day;
fit_drylannd_monthly;

% Cross-validate DrylANNd model on each site (i.e., leave-one-site-out)
validate_drylannd_8day;
validate_drylannd_16day;
validate_drylannd_monthly;

% Test variable importance
calculate_variable_importance_8day;
calculate_variable_importance_16day;
calculate_variable_importance_monthly;

%% Figures
% Make map of Ameriflux sites
make_ameriflux_map;

