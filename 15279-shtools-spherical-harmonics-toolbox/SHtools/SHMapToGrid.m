function [r,lon,lat] = SHMapToGrid(vec,res,lmax,location)

% [r,lon,lat] = SHMapToGrid(vec,res[,lmax,location])
%
% Maps a vector of spherical harmonic coefficients to grid.
% To use with multi-layer vectors, specify the array lmax.
% Grid is generated with the default resolution 10 degrees.
% By default, the spherical harmonics are computed at the
% centers of the cells. This behaviour can be modified by
% setting location='corner' and any value of res in degrees

if nargin < 2
    res = 10;
end

if nargin < 3
    lmax = SHn2lm(length(vec));
end

if nargin < 4
    location = 'center';
end
    
if strcmp(location,'center')
    shift = res/2;
    lon=linspace(shift,360-shift,360/res); 
    lat=linspace(90-shift,-90+shift,180/res)';
    colat = 90 - lat;
elseif strcmp(location,'corner')
    lon=linspace(0,360,360/res+1); 
    lat=linspace(90,-90,180/res+1)'; 
    colat = 90 - lat;
else
    error('location argument must be "center" or "corner"');
end

nlon=length(lon); 
nlat=length(lat);
nrad=length(lmax);

r=zeros(nlat,nlon,nrad);

for i=1:nlon
    for j=1:nlat
        [SHvec,i1,i2] = SHCreateYVec(lmax,lon(i),colat(j),'deg');
        for k=1:nrad
            r(j,i,k)= vec(i1(k):i2(k))'*SHvec(i1(k):i2(k));
        end
    end
end

% if nargout > 1
%     [lon,lat] = meshgrid(lon,lat);
% end