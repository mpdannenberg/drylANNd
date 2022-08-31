% Plot r^2 by variable class
load ./output/validation/monthly/DrylANNd_Ameriflux_validation_variable_importance.mat;
lc = {Ameriflux_monthly.IGBP};
lc{strcmp({Ameriflux_monthly.Site},'US-Mpj')} = 'SAV';
lc = strrep(lc, 'CSH', 'SHB');
lc = strrep(lc, 'OSH', 'SHB');
lc = strrep(lc, 'WSA', 'SAV');

labs = {'VI','LST','SMAP','VI+LST','VI+SMAP','LST+SMAP','All'};

%% overall
GPP_drylannd = NaN(length(labs),1);
NEE_drylannd = NaN(length(labs),1);
ET_drylannd = NaN(length(labs),1);

y1 = extractfield(Ameriflux_monthly,'GPP_DrylANNd_VI_LST');
y2 = extractfield(Ameriflux_monthly,'GPP_DrylANNd_VI_SMAP');
y3 = extractfield(Ameriflux_monthly,'GPP_DrylANNd_LST_SMAP');
idx = ~isnan(y1) & ~isnan(y2) & ~isnan(y3); clear y1 y2 y3;

% partial models
y = extractfield(Ameriflux_monthly,'GPP');
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(1) = r;
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(2) = r;
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(3) = r;
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(4) = r;
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(5) = r;
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(6) = r;

y = extractfield(Ameriflux_monthly,'NEE');
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(1) = r;
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(2) = r;
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(3) = r;
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(4) = r;
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(5) = r;
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(6) = r;

y = extractfield(Ameriflux_monthly,'ET');
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(1) = r;
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(2) = r;
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(3) = r;
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(4) = r;
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(5) = r;
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(6) = r;

% Full model
load ./output/validation/monthly/DrylANNd_Ameriflux_validation.mat;

y = extractfield(Ameriflux_monthly,'GPP');
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(7) = r;

y = extractfield(Ameriflux_monthly,'NEE');
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(7) = r;

y = extractfield(Ameriflux_monthly,'ET');
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(7) = r;

%% ENF
load ./output/validation/monthly/DrylANNd_Ameriflux_validation_variable_importance.mat;
GPP_drylannd_ENF = NaN(length(labs),1);
NEE_drylannd_ENF = NaN(length(labs),1);
ET_drylannd_ENF = NaN(length(labs),1);

y1 = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_VI_LST');
y2 = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_VI_SMAP');
y3 = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_LST_SMAP');
idx = ~isnan(y1) & ~isnan(y2) & ~isnan(y3); clear y1 y2 y3;

% partial models
y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(6) = r;

% Full model
load ./output/validation/monthly/DrylANNd_Ameriflux_validation.mat;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(7) = r;

%% GRA
load ./output/validation/monthly/DrylANNd_Ameriflux_validation_variable_importance.mat;
GPP_drylannd_GRA = NaN(length(labs),1);
NEE_drylannd_GRA = NaN(length(labs),1);
ET_drylannd_GRA = NaN(length(labs),1);

y1 = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_VI_LST');
y2 = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_VI_SMAP');
y3 = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_LST_SMAP');
idx = ~isnan(y1) & ~isnan(y2) & ~isnan(y3); clear y1 y2 y3;

% partial models
y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(6) = r;

% Full model
load ./output/validation/monthly/DrylANNd_Ameriflux_validation.mat;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(7) = r;

%% SAV
load ./output/validation/monthly/DrylANNd_Ameriflux_validation_variable_importance.mat;
GPP_drylannd_SAV = NaN(length(labs),1);
NEE_drylannd_SAV = NaN(length(labs),1);
ET_drylannd_SAV = NaN(length(labs),1);

y1 = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_VI_LST');
y2 = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_VI_SMAP');
y3 = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_LST_SMAP');
idx = ~isnan(y1) & ~isnan(y2) & ~isnan(y3); clear y1 y2 y3;

% partial models
y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(6) = r;

% Full model
load ./output/validation/monthly/DrylANNd_Ameriflux_validation.mat;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(7) = r;

%% SHB
load ./output/validation/monthly/DrylANNd_Ameriflux_validation_variable_importance.mat;
GPP_drylannd_SHB = NaN(length(labs),1);
NEE_drylannd_SHB = NaN(length(labs),1);
ET_drylannd_SHB = NaN(length(labs),1);

y1 = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_VI_LST');
y2 = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_VI_SMAP');
y3 = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_LST_SMAP');
idx = ~isnan(y1) & ~isnan(y2) & ~isnan(y3); clear y1 y2 y3;

% partial models
y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_VI');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_VI_LST');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_VI_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_LST_SMAP');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(6) = r;

% Full model
load ./output/validation/monthly/DrylANNd_Ameriflux_validation.mat;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(7) = r;

%% Figure
clr = wesanderson('aquatic4'); clr(3,:) = [];

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 6.5 5.5];

ax = tight_subplot(2,3,[0.08 0.02],[0.12 0.08],[0.08 0.04]);
yticks = 0:0.1:0.9;
ydif = max(yticks)-min(yticks);
xlim = [0.25 7.75];

axes(ax(1))
for i = 1:length(yticks)
    plot(xlim, [yticks(i) yticks(i)], '-', 'Color',[0.9 0.9 0.9])
    text(xlim(1)-0.1, yticks(i), num2str(yticks(i)), 'FontSize',8, 'HorizontalAlignment','right')
    hold on;
end
b=bar(GPP_drylannd);
b.EdgeColor = 'none';
b.FaceColor = [0.5 0.5 0.5];
set(gca, 'XTickLabel','', 'TickDir','out', 'TickLength',[0.02 0], 'YLim',[min(yticks) max(yticks)], 'FontSize',8, 'XLim',xlim, 'YColor','w', 'XTick',1:7)
box off;
text(0.5, max(yticks)+ydif*0.05, '{\bfa.} monthly GPP', 'FontSize',10, 'VerticalAlignment','bottom')
text(-1, (max(yticks)-min(yticks))/2, 'R^{2}', 'Rotation',0, 'HorizontalAlignment','right','FontSize',10,'VerticalAlignment','middle')
p1 = scatter(1:7, GPP_drylannd_ENF, 30, clr(1,:), 'filled');
p2 = scatter(1:7, GPP_drylannd_GRA, 30, clr(2,:), 'filled');
p3 = scatter(1:7, GPP_drylannd_SAV, 30, clr(3,:), 'filled');
p4 = scatter(1:7, GPP_drylannd_SHB, 30, clr(4,:), 'filled');
lgd = legend([b p1 p2 p3 p4], 'Overall', 'ENF', 'GRS', 'SAV', 'SHB', 'Orientation','horizontal', 'Location','northoutside');
lgd.Position(1) = (1 - lgd.Position(3))/2;
lgd.Position(2) = 0.97;
legend('boxoff')

axes(ax(2))
for i = 1:length(yticks)
    plot(xlim, [yticks(i) yticks(i)], '-', 'Color',[0.9 0.9 0.9])
    hold on;
end
b=bar(NEE_drylannd);
b.EdgeColor = 'none';
b.FaceColor = [0.5 0.5 0.5];
set(gca, 'XTickLabel','', 'TickDir','out', 'TickLength',[0.02 0], 'YLim',[min(yticks) max(yticks)], 'FontSize',8, 'XLim',xlim, 'YColor','w', 'XTick',1:7)
box off;
text(0.5, max(yticks)+ydif*0.05, '{\bfb.} monthly NEE', 'FontSize',10, 'VerticalAlignment','bottom')
scatter(1:7, NEE_drylannd_ENF, 30, clr(1,:), 'filled')
scatter(1:7, NEE_drylannd_GRA, 30, clr(2,:), 'filled')
scatter(1:7, NEE_drylannd_SAV, 30, clr(3,:), 'filled')
scatter(1:7, NEE_drylannd_SHB, 30, clr(4,:), 'filled')

axes(ax(3))
for i = 1:length(yticks)
    plot(xlim, [yticks(i) yticks(i)], '-', 'Color',[0.9 0.9 0.9])
    hold on;
end
b=bar(ET_drylannd);
b.EdgeColor = 'none';
b.FaceColor = [0.5 0.5 0.5];
set(gca, 'XTickLabel','', 'TickDir','out', 'TickLength',[0.02 0], 'YLim',[min(yticks) max(yticks)], 'FontSize',8, 'XLim',xlim, 'YColor','w', 'XTick',1:7)
box off;
text(0.5, max(yticks)+ydif*0.05, '{\bfc.} monthly ET', 'FontSize',10, 'VerticalAlignment','bottom')
scatter(1:7, ET_drylannd_ENF, 30, clr(1,:), 'filled')
scatter(1:7, ET_drylannd_GRA, 30, clr(2,:), 'filled')
scatter(1:7, ET_drylannd_SAV, 30, clr(3,:), 'filled')
scatter(1:7, ET_drylannd_SHB, 30, clr(4,:), 'filled')

%% Monthly anomalies
load ./output/validation/monthly/DrylANNd_Ameriflux_validation_variable_importance.mat;
includeSites = {'Me6','Mpj','Rls','Rms','Rws','SRG','SRM','Seg','Ses','Ton','Var','Vcm','Vcp','Whs','Wjs','Wkg'};
Ameriflux_monthly = Ameriflux_monthly(contains({Ameriflux_monthly.Site}, includeSites));
lc = {Ameriflux_monthly.IGBP};
lc{strcmp({Ameriflux_monthly.Site},'US-Mpj')} = 'SAV';
lc = strrep(lc, 'CSH', 'SHB');
lc = strrep(lc, 'OSH', 'SHB');
lc = strrep(lc, 'WSA', 'SAV');
ulc = unique(lc);
n = length(Ameriflux_monthly);
for i = 1:n
    
    yr = Ameriflux_monthly(i).Year;
    mo = Ameriflux_monthly(i).Month;

    % observed
    g = fillmissing(Ameriflux_monthly(i).GPP, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).GPP_anom = Ameriflux_monthly(i).GPP - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).NEE, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).NEE_anom = Ameriflux_monthly(i).NEE - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).ET, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).ET_anom = Ameriflux_monthly(i).ET - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    
    % VIs
    g = fillmissing(Ameriflux_monthly(i).GPP_DrylANNd_VI, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).GPP_DrylANNd_VI_anom = Ameriflux_monthly(i).GPP_DrylANNd_VI - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).NEE_DrylANNd_VI, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).NEE_DrylANNd_VI_anom = Ameriflux_monthly(i).NEE_DrylANNd_VI - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).ET_DrylANNd_VI, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).ET_DrylANNd_VI_anom = Ameriflux_monthly(i).ET_DrylANNd_VI - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    
    % LST
    g = fillmissing(Ameriflux_monthly(i).GPP_DrylANNd_LST, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).GPP_DrylANNd_LST_anom = Ameriflux_monthly(i).GPP_DrylANNd_LST - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).NEE_DrylANNd_LST, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).NEE_DrylANNd_LST_anom = Ameriflux_monthly(i).NEE_DrylANNd_LST - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).ET_DrylANNd_LST, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).ET_DrylANNd_LST_anom = Ameriflux_monthly(i).ET_DrylANNd_LST - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    
    % SMAP
    g = fillmissing(Ameriflux_monthly(i).GPP_DrylANNd_SMAP, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).GPP_DrylANNd_SMAP_anom = Ameriflux_monthly(i).GPP_DrylANNd_SMAP - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).NEE_DrylANNd_SMAP, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).NEE_DrylANNd_SMAP_anom = Ameriflux_monthly(i).NEE_DrylANNd_SMAP - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).ET_DrylANNd_SMAP, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).ET_DrylANNd_SMAP_anom = Ameriflux_monthly(i).ET_DrylANNd_SMAP - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    
    % VI + LST
    g = fillmissing(Ameriflux_monthly(i).GPP_DrylANNd_VI_LST, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).GPP_DrylANNd_VI_LST_anom = Ameriflux_monthly(i).GPP_DrylANNd_VI_LST - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).NEE_DrylANNd_VI_LST, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).NEE_DrylANNd_VI_LST_anom = Ameriflux_monthly(i).NEE_DrylANNd_VI_LST - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).ET_DrylANNd_VI_LST, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).ET_DrylANNd_VI_LST_anom = Ameriflux_monthly(i).ET_DrylANNd_VI_LST - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    
    % VI + SMAP
    g = fillmissing(Ameriflux_monthly(i).GPP_DrylANNd_VI_SMAP, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).GPP_DrylANNd_VI_SMAP_anom = Ameriflux_monthly(i).GPP_DrylANNd_VI_SMAP - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).NEE_DrylANNd_VI_SMAP, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).NEE_DrylANNd_VI_SMAP_anom = Ameriflux_monthly(i).NEE_DrylANNd_VI_SMAP - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).ET_DrylANNd_VI_SMAP, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).ET_DrylANNd_VI_SMAP_anom = Ameriflux_monthly(i).ET_DrylANNd_VI_SMAP - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    
    % LST + SMAP
    g = fillmissing(Ameriflux_monthly(i).GPP_DrylANNd_LST_SMAP, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).GPP_DrylANNd_LST_SMAP_anom = Ameriflux_monthly(i).GPP_DrylANNd_LST_SMAP - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).NEE_DrylANNd_LST_SMAP, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).NEE_DrylANNd_LST_SMAP_anom = Ameriflux_monthly(i).NEE_DrylANNd_LST_SMAP - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).ET_DrylANNd_LST_SMAP, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).ET_DrylANNd_LST_SMAP_anom = Ameriflux_monthly(i).ET_DrylANNd_LST_SMAP - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    
    
end

% Plot r^2 by variable class
labs = {'VI','LST','SMAP','VI+LST','VI+SMAP','LST+SMAP','All'};
GPP_drylannd = NaN(length(labs),1);
NEE_drylannd = NaN(length(labs),1);
ET_drylannd = NaN(length(labs),1);

%% partial models
y1 = extractfield(Ameriflux_monthly,'GPP_DrylANNd_VI_LST_anom');
y2 = extractfield(Ameriflux_monthly,'GPP_DrylANNd_VI_SMAP_anom');
y3 = extractfield(Ameriflux_monthly,'GPP_DrylANNd_LST_SMAP_anom');
idx = ~isnan(y1) & ~isnan(y2) & ~isnan(y3); clear y1 y2 y3;

% overall
y = extractfield(Ameriflux_monthly,'GPP_anom');
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(1) = r;
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(2) = r;
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(3) = r;
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(4) = r;
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(5) = r;
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd(6) = r;

y = extractfield(Ameriflux_monthly,'NEE_anom');
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(1) = r;
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(2) = r;
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(3) = r;
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(4) = r;
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(5) = r;
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd(6) = r;

y = extractfield(Ameriflux_monthly,'ET_anom');
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(1) = r;
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(2) = r;
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(3) = r;
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(4) = r;
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(5) = r;
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd(6) = r;

% ENF
GPP_drylannd_ENF = NaN(length(labs),1);
NEE_drylannd_ENF = NaN(length(labs),1);
ET_drylannd_ENF = NaN(length(labs),1);

y1 = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_VI_LST_anom');
y2 = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_VI_SMAP_anom');
y3 = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_LST_SMAP_anom');
idx = ~isnan(y1) & ~isnan(y2) & ~isnan(y3); clear y1 y2 y3;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_ENF(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_ENF(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_ENF(6) = r;

% GRA
GPP_drylannd_GRA = NaN(length(labs),1);
NEE_drylannd_GRA = NaN(length(labs),1);
ET_drylannd_GRA = NaN(length(labs),1);

y1 = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_VI_LST_anom');
y2 = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_VI_SMAP_anom');
y3 = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_LST_SMAP_anom');
idx = ~isnan(y1) & ~isnan(y2) & ~isnan(y3); clear y1 y2 y3;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_GRA(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_GRA(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_GRA(6) = r;

% SAV
GPP_drylannd_SAV = NaN(length(labs),1);
NEE_drylannd_SAV = NaN(length(labs),1);
ET_drylannd_SAV = NaN(length(labs),1);

y1 = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_VI_LST_anom');
y2 = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_VI_SMAP_anom');
y3 = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_LST_SMAP_anom');
idx = ~isnan(y1) & ~isnan(y2) & ~isnan(y3); clear y1 y2 y3;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SAV(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SAV(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SAV(6) = r;

% SHB
GPP_drylannd_SHB = NaN(length(labs),1);
NEE_drylannd_SHB = NaN(length(labs),1);
ET_drylannd_SHB = NaN(length(labs),1);

y1 = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_VI_LST_anom');
y2 = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_VI_SMAP_anom');
y3 = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_LST_SMAP_anom');
idx = ~isnan(y1) & ~isnan(y2) & ~isnan(y3); clear y1 y2 y3;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
GPP_drylannd_SHB(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
NEE_drylannd_SHB(6) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_VI_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(1) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(2) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(3) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_VI_LST_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(4) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_VI_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(5) = r;
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_LST_SMAP_anom');
r = corr(y(idx)', yhat(idx)', 'rows','pairwise')^2;
ET_drylannd_SHB(6) = r;

%% Full model
load ./output/validation/monthly/DrylANNd_Ameriflux_validation.mat;
includeSites = {'Me6','Mpj','Rls','Rms','Rws','SRG','SRM','Seg','Ses','Ton','Var','Vcm','Vcp','Whs','Wjs','Wkg'};
Ameriflux_monthly = Ameriflux_monthly(contains({Ameriflux_monthly.Site}, includeSites));
n = length(Ameriflux_monthly);
for i = 1:n
    
    yr = Ameriflux_monthly(i).Year;
    mo = Ameriflux_monthly(i).Month;

    % observed
    g = fillmissing(Ameriflux_monthly(i).GPP, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).GPP_anom = Ameriflux_monthly(i).GPP - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).NEE, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).NEE_anom = Ameriflux_monthly(i).NEE - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).ET, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).ET_anom = Ameriflux_monthly(i).ET - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    
    % full model
    g = fillmissing(Ameriflux_monthly(i).GPP_DrylANNd, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).GPP_DrylANNd_anom = Ameriflux_monthly(i).GPP_DrylANNd - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).NEE_DrylANNd, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).NEE_DrylANNd_anom = Ameriflux_monthly(i).NEE_DrylANNd - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    g = fillmissing(Ameriflux_monthly(i).ET_DrylANNd, "spline", 1, "EndValues","none");
    Ameriflux_monthly(i).ET_DrylANNd_anom = Ameriflux_monthly(i).ET_DrylANNd - repmat(mean(reshape(g(yr >= 2015 & yr <= 2020), 12, []), 2), length(yr)/12, 1);
    
end

% overall
y = extractfield(Ameriflux_monthly,'GPP_anom');
yhat = extractfield(Ameriflux_monthly,'GPP_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
GPP_drylannd(7) = r;

y = extractfield(Ameriflux_monthly,'NEE_anom');
yhat = extractfield(Ameriflux_monthly,'NEE_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
NEE_drylannd(7) = r;

y = extractfield(Ameriflux_monthly,'ET_anom');
yhat = extractfield(Ameriflux_monthly,'ET_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
ET_drylannd(7) = r;

% ENF
y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'GPP_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
GPP_drylannd_ENF(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'NEE_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
NEE_drylannd_ENF(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'ENF')),'ET_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
ET_drylannd_ENF(7) = r;

% GRA
y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'GPP_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
GPP_drylannd_GRA(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'NEE_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
NEE_drylannd_GRA(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'GRA')),'ET_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
ET_drylannd_GRA(7) = r;

% SAV
y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'GPP_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
GPP_drylannd_SAV(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'NEE_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
NEE_drylannd_SAV(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SAV')),'ET_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
ET_drylannd_SAV(7) = r;

% SHB
y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'GPP_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
GPP_drylannd_SHB(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'NEE_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
NEE_drylannd_SHB(7) = r;

y = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_anom');
yhat = extractfield(Ameriflux_monthly(strcmp(lc, 'SHB')),'ET_DrylANNd_anom');
r = corr(y', yhat', 'rows','pairwise')^2;
ET_drylannd_SHB(7) = r;

% add to plot
yticks = 0:0.1:0.6;
ydif = max(yticks)-min(yticks);
xlim = [0.25 7.75];

axes(ax(4))
for i = 1:length(yticks)
    plot(xlim, [yticks(i) yticks(i)], '-', 'Color',[0.9 0.9 0.9])
    text(xlim(1)-0.1, yticks(i), num2str(yticks(i)), 'FontSize',8, 'HorizontalAlignment','right')
    hold on;
end
b=bar(GPP_drylannd);
b.EdgeColor = 'none';
b.FaceColor = [0.5 0.5 0.5];
set(gca, 'XTickLabel',labs, 'TickDir','out', 'TickLength',[0.02 0], 'YLim',[min(yticks) max(yticks)], 'FontSize',8, 'XLim',xlim, 'YColor','w', 'XTick',1:7)
box off;
text(0.5, max(yticks)+ydif*0.05, '{\bfd.} monthly GPP anomaly', 'FontSize',10, 'VerticalAlignment','bottom')
text(-1, (max(yticks)-min(yticks))/2, 'R^{2}', 'Rotation',0, 'HorizontalAlignment','right','FontSize',10,'VerticalAlignment','middle')
scatter(1:7, GPP_drylannd_ENF, 30, clr(1,:), 'filled')
scatter(1:7, GPP_drylannd_GRA, 30, clr(2,:), 'filled')
scatter(1:7, GPP_drylannd_SAV, 30, clr(3,:), 'filled')
scatter(1:7, GPP_drylannd_SHB, 30, clr(4,:), 'filled')

axes(ax(5))
for i = 1:length(yticks)
    plot(xlim, [yticks(i) yticks(i)], '-', 'Color',[0.9 0.9 0.9])
    hold on;
end
b=bar(NEE_drylannd);
b.EdgeColor = 'none';
b.FaceColor = [0.5 0.5 0.5];
set(gca, 'XTickLabel',labs, 'TickDir','out', 'TickLength',[0.02 0], 'YLim',[min(yticks) max(yticks)], 'FontSize',8, 'XLim',xlim, 'YColor','w', 'XTick',1:7)
box off;
text(0.5, max(yticks)+ydif*0.05, '{\bfe.} monthly NEE anomaly', 'FontSize',10, 'VerticalAlignment','bottom')
scatter(1:7, NEE_drylannd_ENF, 30, clr(1,:), 'filled')
scatter(1:7, NEE_drylannd_GRA, 30, clr(2,:), 'filled')
scatter(1:7, NEE_drylannd_SAV, 30, clr(3,:), 'filled')
scatter(1:7, NEE_drylannd_SHB, 30, clr(4,:), 'filled')

axes(ax(6))
for i = 1:length(yticks)
    plot(xlim, [yticks(i) yticks(i)], '-', 'Color',[0.9 0.9 0.9])
    hold on;
end
b=bar(ET_drylannd);
b.EdgeColor = 'none';
b.FaceColor = [0.5 0.5 0.5];
set(gca, 'XTickLabel',labs, 'TickDir','out', 'TickLength',[0.02 0], 'YLim',[min(yticks) max(yticks)], 'FontSize',8, 'XLim',xlim, 'YColor','w', 'XTick',1:7)
box off;
text(0.5, max(yticks)+ydif*0.05, '{\bff.} monthly ET anomaly', 'FontSize',10, 'VerticalAlignment','bottom')
scatter(1:7, ET_drylannd_ENF, 30, clr(1,:), 'filled')
scatter(1:7, ET_drylannd_GRA, 30, clr(2,:), 'filled')
scatter(1:7, ET_drylannd_SAV, 30, clr(3,:), 'filled')
scatter(1:7, ET_drylannd_SHB, 30, clr(4,:), 'filled')

set(gcf,'PaperPositionMode','auto','InvertHardCopy','off')
print('-dtiff','-f1','-r300','./output/validation/variables-r2.tif')
close all;
