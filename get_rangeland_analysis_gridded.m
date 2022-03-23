[~, R] = readgeoraster("D:/Data_Analysis/RangelandAnalysis/vegetation-cover-v3-2020-resample-clip.tif", 'Bands',1);
latlim = R.LatitudeLimits;
lonlim = R.LongitudeLimits;
res = R.CellExtentInLatitude;
nlat = (latlim(2)-res/2):(-res):(latlim(1)+res/2);
nlon = (lonlim(1)+res/2):res:(lonlim(2)-res/2);

load('./data/TerraClimate_AridityIndex.mat');
ny = length(lat); nx = length(lon);

RangelandAnalysis = NaN(ny, nx, 6);

for k = 2:6
    [dat, ~] = readgeoraster("D:/Data_Analysis/RangelandAnalysis/vegetation-cover-v3-2020-resample-clip.tif", 'Bands',k);
    dat = double(dat);
    dat(dat == 255) = NaN;
    for i = 1:ny
        for j = 1:nx
            
            latidx = find(nlat > (lat(i)-0.025) & nlat < (lat(i)+0.025));
            lonidx = find(nlon > (lon(j)-0.025) & nlon < (lon(j)+0.025));
            temp = dat(latidx, lonidx);
            RangelandAnalysis(i, j, k) = mean(reshape(temp,1,[]), 'omitnan');
        end
    end
end

AFG = RangelandAnalysis(:,:,1);
BGR = RangelandAnalysis(:,:,2);
LTR = RangelandAnalysis(:,:,3);
PFG = RangelandAnalysis(:,:,4);
SHR = RangelandAnalysis(:,:,5);
TRE = RangelandAnalysis(:,:,6);

save('./data/RangelandAnalysis.mat', 'lat','lon','AFG','BGR','LTR','PFG','SHR','TRE');
