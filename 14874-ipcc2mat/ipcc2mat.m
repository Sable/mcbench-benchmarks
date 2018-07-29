function [data,header] = ipcc2mat(fname,r)
% PURPOSE: Import IPCC climate observation data into Matlab (3D) matrix
% -------------------------------------------------------------------
% USAGE: [data,header] = ipcc2mat(fname,r)
% where: fname = filename of ipcc climate observation file in ascii .dat
%                format as provided at http://www.ipcc-data.org
%        r = optional flag to rotate& flip data matrix for pretty printing in
%            mat format (1) or not (0). Default is 1 (rotate), 
% Output:
%        data = 3D matrix in format (rows/cols/month) usually (360,720,12)
%
% Note: 
%
% Example: [data,header]=ipcc2mat('ctmp8190.dat',1);
%          figure, imagesc(data)
%
% Felix Hebeler, Geography Dept., University Zurich, May 2007.

if ~exist('r','var')
    r=1;
end
nodata = -9999;

%% open file
fid = fopen(fname);
if fid==-1
  error('File not found or permission denied');
end

%% read header ifno and data
h1= fgetl(fid); % this should be text
h2= fgetl(fid); % this the info
data = [];
data = [data; fscanf(fid, '%f')];
fclose(fid);

%% make a nice header
strs = {'grd_sz','xmin','ymin','xmax','ymax','n_cols','n_rows','n_months'};
header={};
for i = 1:length(strs)
    [t,h2]=strtok(h2);
    eval(['header.',strs{i},'=str2num(t);'])
end

%% replace NaN and reshape data
data(data==nodata)=NaN;
data=reshape(data,header.n_cols,header.n_rows,header.n_months);

%% rotate (only works for 2D matrices)
if r==1
    t=nan(header.n_rows,header.n_cols,header.n_months);
    for d = 1:size(data,3)
        t(:,:,d)=fliplr(rot90(data(:,:,d),3));
    end
end
data=t;
clear t;