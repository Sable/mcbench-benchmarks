function arcgridwrite(fileName,X,Y,Z,varargin)
%ARCGRIDWRITE- Write gridded data set in Arc ASCII Grid Format
%
%   arcgridwrite(fileName,X,Y,Z)- converts data in a matlab
%   grid (as produced by eg. meshgrid and griddata) into a text file
%   in Arc ASCII Grid Format. The file can also be automatically
%   converted to raster on PC's with ARCINFO installed.
%
%   INPUTS
%       fileName:  output filename including extension
%       X:         X coordinates (m x n) 
%       Y:         Y coordinates (m x n) 
%       Z:         gridded data (m x n) 
%
%   SYNTAX AND OPTIONS
%       arcgridwrite('D:\tools\bathyGrid.asc',X,Y,Z)
%
%       arcgridwrite('D:\tools\bathyGrid.asc',X,Y,Z,...
%           'precision',5) - changes default floating point output
%           from 3 to 5 decimal places.
%
%        arcgridwrite('D:\tools\bathyGrid.asc',X,Y,Z,'convert') -
%           attempts to convert the ASCII text file to raster using
%           the ARCINFO command ASCIIGRID.  This option currently 
%           only works on a pc with ARCINFO installed.  
%
%   EXAMPLE - create a raster grid of the peaks function
%       [X,Y,Z]=peaks(100);
%       arcgridwrite('peaksArc.asc',X,Y,Z,'precision',3,...
%           'convert')
%
%   NOTES 
%   1) Because the Arc ASCII format has only one parameter for cell size,
%   both X and Y must have the same, non-varying grid spacing.  
%
% A.Stevens @ USGS 7/18/2007
% astevens@usgs.gov

%check number of inputs
if nargin < 4
    error('Not enough input arguments');
end

[mz,nz,zz]=size(Z);
[mx]=size(X);
[my]=size(Y);

minX=min(X(:));
minY=min(Y(:));
dx=abs(diff(X(1,:)));
dy=abs(diff(Y(:,1)));

maxDiff=0.01; %threshold for varying dx and dy.  increase or
%decrease this parameter if necessary.  

%check input dimensions and make sure x and y 
%spacing are the same. 
if any(diff(dx)>maxDiff) || any(diff(dy)>maxDiff)
     error('X- and Y- grid spacing should be non-varying');
else
    dx=dx(1); 
    dy=dy(1);
end

if ischar(fileName)~=1
    error('First input must be a string')
elseif zz>1
    error('Z must be 2-dimensional');
elseif mx~=mz
     error('X, Y and Z should be same size');
elseif my~=mz
    error('X, Y and Z should be same size');
elseif abs(dx-dy)>maxDiff;
    error('X- and Y- grid spacing should be equal');   
end


convert=0;
dc=3; %default number of decimals to output
if isempty(varargin)~=1
    [m1,n1]=size(varargin);
    opts={'precision';'convert'};

    for i=1:n1;
        indi=strcmpi(varargin{i},opts);
        ind=find(indi==1);
        if isempty(ind)~=1
            switch ind
                case 1
                    dc=varargin{i+1};
                case 2
                    convert=1;
            end
        else
        end
    end
end


%replace NaNs with NODATA value 
Z(isnan(Z))=-9999;
Z=flipud(Z);

%define precision of output file
if isnumeric(dc)
    dc=['%.',sprintf('%d',dc),'f'];
elseif isnumeric(dc) && dc==0
    dc=['%.',sprintf('%d',dc),'d'];
end

fid=fopen(fileName,'wt');

%write header
fprintf(fid,'%s\t','ncols');
fprintf(fid,'%d\n',nz);
fprintf(fid,'%s\t','nrows');
fprintf(fid,'%d\n',mz);
fprintf(fid,'%s\t','xllcorner');
fprintf(fid,[dc,'\n'],minX);
fprintf(fid,'%s\t','yllcorner');
fprintf(fid,[dc,'\n'],minY);
fprintf(fid,'%s\t','cellsize');
fprintf(fid,[dc,'\n'],dx);
fprintf(fid,'%s\t','NODATA_value');
fprintf(fid,[dc,'\n'],-9999);

%configure filename and path
[pname,fname,ext] = fileparts(fileName);
if isempty(pname)==1;
    pname=pwd;
end

if strcmpi(pname(end),filesep)~=1
    pname=[pname,filesep];
end

%wait bar
h = waitbar(0,['Writing file: ',fname,ext...
    ', Please wait...']);

%write data
for i=1:mz
    for j=1:nz

        if j==nz
            fprintf(fid,[dc,'\n'],Z(i,j));
        else
            fprintf(fid,[dc,'\t'],Z(i,j));
        end
    end
    %update waitbar
    waitbar(i/mz,h,['Writing file: ',[fname,ext],...
    sprintf('  %d%% complete...',round(i/mz*100))])
end


close(h)
fclose(fid);

%if requested, try to convert to raster using ARCINFO command ASCIIGRID
if convert==1 
    if ispc~=1;
        disp('"Convert" option only works on a pc')
        return
    end
        dos(['ARC ASCIIGRID ',pname,fname,ext, ' ',...
            pname,fname, ' FLOAT']);
end

        
