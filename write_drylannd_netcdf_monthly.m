% Save DrylANNd model predictions to NetCDF
cd output;
load DrylANNd_monthly_prediction.mat;

% GPP
nccreate('drylannd_v1_monthly_us_gpp_2015_2020.nc','lat','Dimensions',{'lat' length(lat)});
nccreate('drylannd_v1_monthly_us_gpp_2015_2020.nc','lon','Dimensions',{'lon' length(lon)});
nccreate('drylannd_v1_monthly_us_gpp_2015_2020.nc','year','Dimensions',{'time' length(yr)});
nccreate('drylannd_v1_monthly_us_gpp_2015_2020.nc','month','Dimensions',{'time' length(mo)});
nccreate('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp','Dimensions',{'lat' length(lat) 'lon' length(lon) 'time' length(yr)});
nccreate('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp_high','Dimensions',{'lat' length(lat) 'lon' length(lon) 'time' length(yr)});
nccreate('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp_low','Dimensions',{'lat' length(lat) 'lon' length(lon) 'time' length(yr)});

ncwrite('drylannd_v1_monthly_us_gpp_2015_2020.nc','lat',lat);
ncwrite('drylannd_v1_monthly_us_gpp_2015_2020.nc','lon',lon);
ncwrite('drylannd_v1_monthly_us_gpp_2015_2020.nc','year',yr');
ncwrite('drylannd_v1_monthly_us_gpp_2015_2020.nc','month',mo');
ncwrite('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp',permute(GPP, [2 3 1]));
ncwrite('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp_high',permute(GPP_high, [2 3 1]));
ncwrite('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp_low',permute(GPP_low, [2 3 1]));

ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','/','creation_date',datestr(now));
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','/','description','Monthly 0.05 degree DrylANNd GPP estimates (w/ 80% credible interval) for the western U.S.');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','lat','description','centroid latitude');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','lat','units','degrees north');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','lon','description','centroid longitude');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','lon','units','degrees east');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','year','description','year');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','year','units','year');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','month','description','month');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','month','units','month');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp','description','best guess (ensemble median) monthly mean GPP');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp','units','g C m^-2 day^-1');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp_high','description','upper CI (ensemble 90th percentile) monthly mean GPP');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp_high','units','g C m^-2 day^-1');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp_low','description','lower CI (ensemble 10th percentile) monthly mean GPP');
ncwriteatt('drylannd_v1_monthly_us_gpp_2015_2020.nc','gpp_low','units','g C m^-2 day^-1');

% NEE
nccreate('drylannd_v1_monthly_us_nee_2015_2020.nc','lat','Dimensions',{'lat' length(lat)});
nccreate('drylannd_v1_monthly_us_nee_2015_2020.nc','lon','Dimensions',{'lon' length(lon)});
nccreate('drylannd_v1_monthly_us_nee_2015_2020.nc','year','Dimensions',{'time' length(yr)});
nccreate('drylannd_v1_monthly_us_nee_2015_2020.nc','month','Dimensions',{'time' length(mo)});
nccreate('drylannd_v1_monthly_us_nee_2015_2020.nc','nee','Dimensions',{'lat' length(lat) 'lon' length(lon) 'time' length(yr)});
nccreate('drylannd_v1_monthly_us_nee_2015_2020.nc','nee_high','Dimensions',{'lat' length(lat) 'lon' length(lon) 'time' length(yr)});
nccreate('drylannd_v1_monthly_us_nee_2015_2020.nc','nee_low','Dimensions',{'lat' length(lat) 'lon' length(lon) 'time' length(yr)});

ncwrite('drylannd_v1_monthly_us_nee_2015_2020.nc','lat',lat);
ncwrite('drylannd_v1_monthly_us_nee_2015_2020.nc','lon',lon);
ncwrite('drylannd_v1_monthly_us_nee_2015_2020.nc','year',yr');
ncwrite('drylannd_v1_monthly_us_nee_2015_2020.nc','month',mo');
ncwrite('drylannd_v1_monthly_us_nee_2015_2020.nc','nee',permute(NEE, [2 3 1]));
ncwrite('drylannd_v1_monthly_us_nee_2015_2020.nc','nee_high',permute(NEE_high, [2 3 1]));
ncwrite('drylannd_v1_monthly_us_nee_2015_2020.nc','nee_low',permute(NEE_low, [2 3 1]));

ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','/','creation_date',datestr(now));
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','/','description','Monthly 0.05 degree DrylANNd NEE estimates (w/ 80% credible interval) for the western U.S.');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','lat','description','centroid latitude');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','lat','units','degrees north');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','lon','description','centroid longitude');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','lon','units','degrees east');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','year','description','year');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','year','units','year');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','month','description','month');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','month','units','month');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','nee','description','best guess (ensemble median) monthly mean NEE');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','nee','units','g C m^-2 day^-1');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','nee_high','description','upper CI (ensemble 90th percentile) monthly mean NEE');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','nee_high','units','g C m^-2 day^-1');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','nee_low','description','lower CI (ensemble 10th percentile) monthly mean NEE');
ncwriteatt('drylannd_v1_monthly_us_nee_2015_2020.nc','nee_low','units','g C m^-2 day^-1');

% ET
nccreate('drylannd_v1_monthly_us_et_2015_2020.nc','lat','Dimensions',{'lat' length(lat)});
nccreate('drylannd_v1_monthly_us_et_2015_2020.nc','lon','Dimensions',{'lon' length(lon)});
nccreate('drylannd_v1_monthly_us_et_2015_2020.nc','year','Dimensions',{'time' length(yr)});
nccreate('drylannd_v1_monthly_us_et_2015_2020.nc','month','Dimensions',{'time' length(mo)});
nccreate('drylannd_v1_monthly_us_et_2015_2020.nc','et','Dimensions',{'lat' length(lat) 'lon' length(lon) 'time' length(yr)});
nccreate('drylannd_v1_monthly_us_et_2015_2020.nc','et_high','Dimensions',{'lat' length(lat) 'lon' length(lon) 'time' length(yr)});
nccreate('drylannd_v1_monthly_us_et_2015_2020.nc','et_low','Dimensions',{'lat' length(lat) 'lon' length(lon) 'time' length(yr)});

ncwrite('drylannd_v1_monthly_us_et_2015_2020.nc','lat',lat);
ncwrite('drylannd_v1_monthly_us_et_2015_2020.nc','lon',lon);
ncwrite('drylannd_v1_monthly_us_et_2015_2020.nc','year',yr');
ncwrite('drylannd_v1_monthly_us_et_2015_2020.nc','month',mo');
ncwrite('drylannd_v1_monthly_us_et_2015_2020.nc','et',permute(ET, [2 3 1]));
ncwrite('drylannd_v1_monthly_us_et_2015_2020.nc','et_high',permute(ET_high, [2 3 1]));
ncwrite('drylannd_v1_monthly_us_et_2015_2020.nc','et_low',permute(ET_low, [2 3 1]));

ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','/','creation_date',datestr(now));
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','/','description','Monthly 0.05 degree DrylANNd ET estimates (w/ 80% credible interval) for the western U.S.');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','lat','description','centroid latitude');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','lat','units','degrees north');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','lon','description','centroid longitude');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','lon','units','degrees east');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','year','description','year');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','year','units','year');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','month','description','month');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','month','units','month');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','et','description','best guess (ensemble median) monthly mean ET');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','et','units','mm day^-1');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','et_high','description','upper CI (ensemble 90th percentile) monthly mean ET');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','et_high','units','mm day^-1');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','et_low','description','lower CI (ensemble 10th percentile) monthly mean ET');
ncwriteatt('drylannd_v1_monthly_us_et_2015_2020.nc','et_low','units','mm day^-1');

cd ..;
