function [out SRTM] = GetSRTMDatainterp2(LON,LAT,method)
% General:
%
% This code is based on a function written by Sebastian Hölz ->
% http://www.mathworks.com/matlabcentral/fileexchange/5544-getsrtmdata
% The file was modified to interpolat between the diskret Data of SRTM30
%
% The function retrieves SRTM-Data from the according SRTM-files (3 arcsecond resolution only !),
% which need to be supplied by the user. The path to the unzipped SRTM-files
% (.hgt-format) needs to be specified in the variable 'path'.
% SRTM-files can be downloaded for free -> ftp://e0dps01u.ecs.nasa.gov/srtm/
% 
% Input Arguments:
% LON - logitude
% LAT - latitude
% method - see MATLAB function interp2
% negative values for western longitudes resp. southern latitudes.
%
% Output Arguments:
% out - structure containing Point(s)/profiles with [lon / lat / height].
% SRTM - SRTM-image in uint16
%
% Examples:
% 1: [out SRTM] = GetSRTMData(13,15);
%
% Author
% Michael Melzer, TU Dresden, Germany
% michael.melzer@tu-dresden.de
% If you find any bugs, let me know ...

%% 1. Loading SRTM-files
LON=LON(:);
LAT=LAT(:);
p1=[LON,LAT];
[SRTM, lon, lat, fehler] = LoadSRTM(p1);
SRTM=int16(SRTM).*int16(SRTM<9000);
[rows cols]=size(p1);

%% 2. in case of failur return a zero height file
if fehler==1
    out=p1;
    out(:,3)=0;
    SRTM(1:1201,1:1201)=0;
    SRTM=int16(SRTM);
    ind=0;
    return
end;

%% Interpolation of the SRTM Data
[m n]=size(SRTM);
[x,y]=meshgrid(linspace(lon(1,1),lon(1,2),n),linspace(lat(1,1),lat(1,2),m));
switch lower(method)
    case 'linear' 
        h=interp2(x,y,single(SRTM),LON,LAT,'linear');
    case 'spline'
        h=interp2(x,y,single(SRTM),LON,LAT,'spline');
    case 'nearest'
        h=interp2(x,y,single(SRTM),LON,LAT,'nearest');
    case 'cubic'
        h=interp2(x,y,single(SRTM),LON,LAT,'cubic');
end;

%% Output
out=[p1 h];

% -----------------------------------------
function [SRTM, lon, lat, fehler] = LoadSRTM(p1)

SRTM=[];
SRTM_tmp=[];
%path = 'http://dds.cr.usgs.gov/srtm/version2_1/SRTM3/Eurasia/';
path = 'D:\Downloads\SRTM\EURASIA\';
tmp = p1;

lon(1) = floor(min(tmp(:,1)));
lon(2) = ceil(max(tmp(:,1)));
lat(1) = floor(min(tmp(:,2)));
lat(2) = ceil(max(tmp(:,2)));
if lon(2)==lon(1); lon(2)=lon(2)+1; end
if lat(2)==lat(1); lat(2)=lat(2)+1; end

for x = lon(1):lon(2)-1
    for y = lat(1):lat(2)-1
        if x<=-100; LON = 'W';
        elseif x>-100 && x<=-10; LON = 'W0';
        elseif x>-10 && x<0; LON = 'W00';
        elseif x>=0 && x<10; LON = 'E00';
        elseif x>=10 && x<100; LON = 'E0';
        else LON ='E';
        end
        if y<=-10; LAT = 'S';
        elseif y>-10 && y<0; LAT = 'S0';
        elseif y>=0 && y<10; LAT = 'N0';
        else LAT = 'N';
        end
        file=[pwd '\' LAT num2str(abs(y)) LON num2str(abs(x)) '.hgt'];      % setzt Dateinamen der notwendigen Datei
        if ~exist(file,'file')                                              % wenn die Datei im aktuellen Ordner nicht existiert entpackt er die Datei aus dem Internet
            if ~exist([path LAT num2str(abs(y)) LON num2str(abs(x)) '.hgt.zip'],'file')
                fehler=1;
                display('SRTM Data not available')
                return
            else
                unzip([path LAT num2str(abs(y)) LON num2str(abs(x)) '.hgt.zip'])
            end;
        end;
        fehler=0;
        fid=fopen(file,'r','b');
        
        if isempty(SRTM_tmp)
            SRTM_tmp = rot90(fread(fid,[1201 1201],'*int16'));
        else
            SRTM_tmp = [SRTM_tmp(1:end-1,:); rot90(fread(fid,[1201 1201],'*int16'))];
        end
        fclose(fid);
    end
    if isempty(SRTM)
        SRTM = SRTM_tmp;
    else
        SRTM = [SRTM(:,1:end-1) SRTM_tmp];
    end
    SRTM_tmp = [];
end