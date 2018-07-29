function [F107A F107 APH] = f107_aph(year,doy,UTseconds)

% INPUTS
% 'year'      : m x 1 array of requested years
% 'doy'       : m x 1 array of requested day of years
% 'UTseconds' : m x 1 array of requested seconds in UTC

% OUTPUTS
% 'F107A'     : m x 1 array of 81-day average solar flux
% 'F107'      : m x 1 array of daily solar flux
% 'APH'       : m x 7 array of magnetic indices

% Computes/retrieves the 7 magnetic indices and two solar flux values
% (previous day and centered 81-day mean) for atmosnrlmsise00

% Author : John A. Smith, CIRES/NOAA, Univ. of Colorado at Boulder

% convert year, doy and UTseconds to column vectors
year=reshape(year,[],1);
doy=reshape(doy,[],1);
UTseconds=reshape(UTseconds,[],1);

% make sure year, doy, and UT second arrays are equal length
if ~isequal(length(year),length(doy),length(UTseconds))
    error('Year, day of year and UT seconds vectors must be equal length')
end

% check for valid time and date
if any(UTseconds>86400) || any(doy>366) || any(UTseconds<0)
    error('Invalid time or date')
end

M = length(year);

% acknowledge file ID #24235 "doy2date.m" for this insert
z = zeros(M,5);
daten = datenum([year z])+doy+UTseconds/86400; % convert doy to datenum

% check that date is not in the future
if any(daten>now)
    error('Invalid time or date')
end

% determine year for 3 days prior (Ap)
[YAp, ~, ~, ~, ~, ~] = datevec(daten-3);

% determine year for 40 days prior
[YSF, ~, ~, ~, ~, ~] = datevec(daten-40);

% check if both Ap and solar flux (SF) data available for year
if min([YAp YSF])<1947
    error('Solar flux data only available from 1947 onward')
end

% convert year to string
yrstr = num2str(unique([YAp year]));
N = size(yrstr,1);

% define remote directories
remote = cellstr(strcat('/STP/GEOMAGNETIC_DATA/INDICES/KP_AP/',yrstr));

% define full local directories
local = cellstr(strcat(pwd,remote));

% determine if needed Ap data already exists in pwd, if not then download
f=ftp('ftp.ngdc.noaa.gov'); % open ftp session
for i=1:N
if ~exist(local{i},'file')
mget(f,remote{i}); % download dataset
end
end
close(f); % close session

X=[];
Y=[];
Z=[];

for j=1:N
    [x y z] = read_magnetic(local{j});
    X=[X;x];
    Y=[Y;y];
    Z=[Z;z];
end

APH=-1*ones(M,7); % preallocate APH matrix

% define and construct APH matrix
for k=1:M
    row=find(X==floor(daten(k)));
    sub=Y(row-3:row,:)';
    ti=ceil(UTseconds(k)/10800+.001);
    APH(k,:)=[Z(row) sub(24+ti) sub(23+ti) sub(22+ti) ... 
        sub(21+ti) nanmean(sub((13:20)+ti)) nanmean(sub((5:12)+ti))];
end

% ----- finished magnetic index, starting solar flux -----

% create tracking file if not present (first time running)
if ~exist('f107.txt','file')
    fid = fopen('f107.txt','a');
    fwrite(fid,'0')
    fclose(fid);
end

% read date of previous file's modification
fid = fopen('f107.txt');update = fscanf(fid,'%f');fclose(fid);

% determine when FTP server file last modified
f=ftp('ftp.ngdc.noaa.gov');
cd(f,'/STP/SOLAR_DATA/SOLAR_RADIO/FLUX/Penticton_Observed/daily/');
latest = dir(f);
close(f);
last = latest.datenum;

filename = [pwd '/STP/SOLAR_DATA/SOLAR_RADIO/FLUX/Penticton_Observed/daily/DAILYPLT.OBS'];

% update if new data available
if ~exist(filename,'file') || last>update
f=ftp('ftp.ngdc.noaa.gov'); % open ftp session
mget(f,'/STP/SOLAR_DATA/SOLAR_RADIO/FLUX/Penticton_Observed/daily/DAILYPLT.OBS');
close(f); % close session
fid = fopen('f107.txt','w');fprintf(fid,'%f',last);fclose(fid);
end

[x y] = read_solarflux(filename); % read solar flux data

if x(end)<(max(daten)+40)
    warning('on')
    warning('81-day centered average not possible using available data')
end

warning('off') % turn off NaN warnings during interp

F107 = interp1(x,y,daten-1,'spline'); % interp F10.7 for requested dates

% calculate F10.7 81-day centered mean about doy
F107A = -1*ones(M,1);
for i=1:M
    index = find(x>(daten(i)-40) & x<(daten(i)+40));
    F107A(i) = nanmean(y(index));
end

end