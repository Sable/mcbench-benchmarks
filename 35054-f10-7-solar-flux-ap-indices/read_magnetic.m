function [ daten magnetic_indices daily_average ] = read_magnetic( filename )

% INPUTS
% 'filename'            : full path of magnetic index observation file
% i.e. ...\STP\GEOMAGNETIC_DATA\INDICES\KP_AP\2011

% OUTPUTS
% 'daten'               : array of MATLAB datenum dates
% 'magnetic_indices'    : 8 x array of 3-hourly magnetic indices
% 'daily_average'       : 1 x array of daily magnetic index arith. mean

%READ_MAGNETIC Reads magnetic index data files from ftp.ngdc.noaa.gov

% Author : John A. Smith, CIRES/NOAA, Univ. of Colorado at Boulder

[~,y] = fileparts(filename); % determine year from filename

fid = fopen(filename); % open file

% check file open successful
if fid==-1
    error('Could not open file')
end

strmat=[]; % initialize string matrix

% read fixed-width ascii file

while ~feof(fid)
    strmat=char(strmat,fgetl(fid));
end

fclose(fid); % close file

strmat(1,:)=[]; % eliminate first row (empty)
strmat(:,59:end)=[]; % eliminate unneeded data

width = [2 2 2 4 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3]; % define ascii widths

N=size(strmat,1); % get size of char array

s1=mat2cell(strmat,N,width); % convert char array to cell array
s2=strtrim(s1); % trim whitespace
s3=cellfun(@str2num,s2,'un',0); % operate str2num on each cell element
s4=cell2mat(s3); % convert result to matrix

yr=str2double(y);
year = repmat(yr,N,1); % convert year string to double

daten = datenum([year s4(:,2:3)]); % calculate datenum

magnetic_indices = s4(:,15:22); % separate 3 hour magnetic indices

daily_average = s4(:,23); % separate daily average magnetic index

end