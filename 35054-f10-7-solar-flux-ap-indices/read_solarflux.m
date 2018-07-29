function [ daten f107 ] = read_solarflux( filename )

% INPUT
% 'filename'  : full path of solar flux observation file
% i.e. ...
% \STP\SOLAR_DATA\SOLAR_RADIO\FLUX\Penticton_Observed\daily\DAILYPLT.OBS

% OUTPUTS
% 'daten'     : array of MATLAB datenum dates
% 'f107'      : corresponding solar flux values

% Reads solar flux data files from Penticton Observatory 
% daily F10.7 flux values, downloaded from ftp.ngdc.noaa.gov

% Author : John A. Smith, CIRES/NOAA, Univ. of Colorado at Boulder

fid = fopen(filename,'r','l','US-ASCII'); % open file

% check file open successful
if fid==-1
    error('Could not open file')
end

dat=textscan(fid,'%4d %2d %2d %f','treatasempty','.'); % read file contents

fclose(fid); % close file

% assign year, month and day
year=dat{1};
month=dat{2};
day=dat{3};

daten=datenum(double([year month day])); % convert to MATLAB datenum

f107=dat{4}; % assign f10.7 data

f107(f107==0)=NaN; % NaN empty fields

end