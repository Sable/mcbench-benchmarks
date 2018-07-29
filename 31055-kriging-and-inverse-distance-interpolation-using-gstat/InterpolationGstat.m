function [xi,yi,zi]=InterpolationGstat(x,y,z,res,radius,method,uselog,name,varargin)
% InterpolationGstat(x,y,z,res,radius,method,uselog,name,S,useloc)
% performs inverse distance or kriging interpolation using gstat.
% INVERSE DISTANCE:
% INPUTS:
% x      :: sample locations in x 
% y      :: sample locations in y
% z      :: sample data   
% res    :: resolution of interpolation grid
% radius :: maximum search radius for interpolation
% method = 'invdist'
% uselog :: 1 if z values should be log transformed, 0 if not
% name   :: name of output file without extension. e.g. 'predictions'.
% (file is given extension '.grd')
% useloc (OPTIONAL) :: if 1, will use file 'locations.dat' if it exist for
% interpolation locations. If 0, will prompt user to choose whether to use
% locations.dat (if it exists) or rewrite. Useful when calling the
% interpolation routine in a loop.
% S is not required for inverse distance
%
% KRIGING:
% INPUTS:
% x,y,z,res,radius :: as for inverse distance
% method           = 'kriging'
% uselog           :: as for inverse distance
% name             :: as for inverse distance
% S                :: Structure containing variogram information as output
% by the variogramfit function.
% useloc (OPTIONAL):: as for inverse distance
%
% OUTPUTS:
% xi :: the prediction locations in x
% yi :: the prediction locations in y
% zi :: the predicted result
% pcolor can be used to visualise. e.g. pcolor(xi,yi,zi); shading interp;
% This routine is a simple matlab interface to gstat to enable easy
% ordinary kriging or inverse distance interpolation. It does not and is
% not intended to take advantage of all the capabilities of gstat
%
% How to set up an inverse distance interpolation.
% - your sample points and their locations should be vectors of the same
% length.
% - The radius is the search distance for the interpolation to find
% neighbours. If you are unsure, a good starting point is the max distance
% between adjacent locations.
% - Do not choose meaningless resolutions. e.g is your locations are ~1km
% apart, a resolution of 10m is unneccessary. 
% - set 'uselog' to 1 if your sample data has a skew>1 (use 'skewness' and
% 'hist')
%
% Kriging interpolation.
% The above points are also valid for kriging. 
% Kriging also requires a variogram model to calculate its weights. A
% variogram model is a function that has been fitted to an experimental
% variogram of the data. Use SampleVarioGstat.m to calculate the
% experimental variogram. use variogramfit to find the variogram model.
%



if nargin<8
    error('InterpolationGstat:wrongInput','Too few inputs');
elseif nargin == 8
    if strcmpi(method,'kriging')
         error('InterpolationGstat:wrongInput','Too few inputs to use kriging');
    else 
        useloc = 0;
    end
elseif nargin == 9
    if strcmpi(method,'kriging')
    S=varargin{1};
    useloc=0;
    elseif strcmpi(method,'invdist')
        useloc = varargin{1};
    end
elseif nargin == 10
    S=varargin{1};
    useloc=varargin{2};
elseif nargin > 10
    error('InterpolationGstat:wrongInput','Too many inputs');
end

if exist('SampleData.dat','file')
    delete('SampleData.dat')
end
if exist('GstatInterp.cmd','file')
    delete('GstatInterp.cmd')
end
if useloc
    use='y';
elseif ~useloc;
if exist('locations.grd','file')
    fprintf(1,'found ''locations.grd''\n');
    use=input('use these locations for interpolation? (y/n): ','s');
    if strcmpi(use,'n')
        delete('locations.grd')
    end
else
    use='n';
end
end

%create interpolation locations
if strcmp(use,'n')
    fprintf(1,'\tCreating Mask Grid\n')
    xx=(min(x)-res):res:(max(x)+res);
    yy=(min(y)-res):res:(max(y)+res);
    [xi,yi]=meshgrid(xx,yy);
    clear xx yy
    
    %write locations to mask file
    fid = fopen('locations.grd','w');
    fprintf(fid,'%s\n','DSAA');
    fprintf(fid,'%i %i\n',size(xi,2),size(xi,1));
    fprintf(fid,'%.3f %.3f\n',min(min(xi)),max(max(xi)));
    fprintf(fid,'%.3f %.3f\n',min(min(yi)),max(max(yi)));
    fprintf(fid,'%.3f %.3f\n',0,0);
    mask=zeros(size(xi));
    fprintf(fid,[repmat('%.3f ', 1, size(mask, 2)), '\n'],mask);
    fclose(fid);
end
%write data
fprintf(1,'\tWriting Data File\n');
fid = fopen('SampleData.dat','w');
x=x(:); y=y(:); z=z(:);
Points=[x y z];
fprintf(fid,'%.3f %.3f %.3f\n',Points.');
fclose(fid);

method=lower(method);

fprintf(1,'\tInvoking Gstat...\n')
fid=fopen('GstatInterp.cmd','w');

% Write commmand file for inverse distance if chosen
if strcmp(method,'invdist')
    if uselog
        fprintf(fid,['data(InvDist): ''SampleData.dat'', x=1, y=2, v=3,',...
            'min=3, max=10, radius=%.3f, log;\nmask: ''locations'';',...
            '\npredictions(InvDist): ''%s'';'],radius,name);
    else
        fprintf(fid,['data(InvDist): ''SampleData.dat'', x=1, y=2, v=3,',...
            'min=3, max=10, radius=%.3f;\nmask: ''locations'';',...
            '\npredictions(InvDist): ''%s'';'],radius,name);
    end
elseif strcmp(method,'kriging');
    if ~exist(S.nugget)
        S.nugget=0;
    end
    % check to see if log transform is required
    switch(uselog)
        case{1}
            datastr = sprintf(['data(Krig): ''SampleData.dat'','...
                'x=1, y=2, v=3, radius=%.3f, log;\n'],radius);
        case{0}
            datastr = sprintf(['data(Krig): ''SampleData.dat'','...
                'x=1, y=2, v=3, radius=%.3f;\n'],radius);
        otherwise
            error('InterpolationGstat:badFormat','uselog incorrectly specified');
    end
    %check which variogram model is used
    switch lower(S.model)
        case{'spherical'}
            vario=sprintf('%.3fNug()+%.3fSph(%.3f)',S.nugget,S.sill,S.range);
        case{'exponential'}
            vario=sprintf('%.3fNug()+%.3fExp(%.3f)',S.nugget,S.sill,S.range);
        case{'blinear'}
            vario=sprintf('%.3fNug()+%.3fLin(%.3f)',S.nugget,S.sill,S.range);
        case{'circular'}
            vario=sprintf('%.3fNug()+%.3fCir(%.3f)',S.nugget,S.sill,S.range);    
        case{'pentaspherical'}
            vario=sprintf('%.3fNug()+%.3fPen(%.3f)',S.nugget,S.sill,S.range);
        case{'gaussian'}
            vario=sprintf('%.3fNug()+%.3fGau(%.3f)',S.nugget,S.sill,S.range);
        otherwise
            error('InterpolationGstat:badFormat','unknown variogram model type');
    end
    %write the command file
    fprintf(fid,['%smask: ''locations'';\nvariogram(Krig): %s;',...
        '\npredictions(Krig): ''%s'';'],datastr,vario,name);
else
    error('InterpolationGstat:Unknown','Unknown method')
end
fclose('all');
%dos('gstat.exe GstatInterp.cmd','-echo')
[s,w]=system('gstat.exe GstatInterp.cmd','-echo');
zi=ImportSurferGrd([name,'.grd']);
end
