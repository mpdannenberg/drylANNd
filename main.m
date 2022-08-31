% Main file for DrylANNd modeling

% Subset TerraClimate aridity index and Rangeland Analysis vegetation fraction
get_terraclimate_aridity;
get_rangeland_analysis;

% Read in and QC-filter Ameriflux data
read_ameriflux_data;

% Read in NBAR data, and calculate/filter vegetation indices
read_modis_nbar; % Site-level
read_gridded_mcd43; % Full western U.S.

% Read in MODIS LST
read_modis_lst; % Site-level
read_gridded_mod11; % Full western U.S.
read_gridded_myd11; % Full western U.S.

% Read in SMAP L4 soil moisture/temperature
read_smap_l4sm; % Site-level
read_gridded_sm; % Full western U.S.

% Read in Rangeland Analysis vegetation fraction
read_rangeland_lc; % Site-level

% Aggregate daily variables to 8-day, 16-day, and monthly
get_monthly_ameriflux;
get_monthly_gridded_smap;
get_monthly_gridded_lst;
get_monthly_gridded_nbar;

% Cross-validate DrylANNd model on each site (i.e., leave-one-site-out)
validate_drylannd_monthly;

% Predict GPP, NEE, and ET with calibrated DrylANNd model
predict_drylannd_monthly;
write_drylannd_netcdf_monthly;

% Test variable importance
calculate_variable_importance_monthly;
calculate_variable_importance_byVariableClass;

%% Figures
% Make map of Ameriflux sites
make_ameriflux_map;

% Plots of R^2 (overall and by site)
plot_r2_monthly;

% Map of mean DrylANNd GPP, NEE, and ET (w/ scatterplot comparison to
% AmeriFlux
map_drylannd_mean;

% Plots of mean seasonal cycles
plot_seasonality;

% Plots of (inter)annual variability
plot_annual;

% Plots of variable importance
plot_variable_importance_byVariableClass;

