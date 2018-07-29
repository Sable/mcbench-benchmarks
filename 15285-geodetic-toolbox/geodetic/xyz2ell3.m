function [lat,lon,h]=xyz2ell3(X,Y,Z,a,b,e2)
% XYZ2ELL3  Converts cartesian coordinates to ellipsoidal.
%   Uses direct algorithm in B.R. Bowring, "The accuracy of
%   geodetic latitude and height equations", Survey
%   Review, v28 #218, October 1985, pp.202-206.  Vectorized.
%   See also XYZ2ELL, XYZ2ELL2.
% Version: 2011-02-19
% Useage:  [lat,lon,h]=xyz2ell3(X,Y,Z,a,b,e2)
%          [lat,lon,h]=xyz2ell3(X,Y,Z)
% Input:   X \
%          Y  > vectors of cartesian coordinates in CT system (m)
%          Z /
%          a   - ref. ellipsoid major semi-axis (m); default GRS80
%          b   - ref. ellipsoid minor semi-axis (m); default GRS80
%          e2  - ref. ellipsoid eccentricity squared; default GRS80
% Output:  lat - vector of ellipsoidal latitudes (radians)
%          lon - vector of ellipsoidal longitudes (radians)
%          h   - vector of ellipsoidal heights (m)

% Copyright (c) 2011, Michael R. Craymer
% All rights reserved.
% Email: mike@craymer.com

if nargin ~= 3 & nargin ~= 6
  warning('Incorrect number of input arguments');
  return
end
if nargin == 3
  [a,b,e2]=refell('grs80');
end

lon=atan2(Y,X);
e=e2*(a/b)^2;
p=sqrt(X.*X+Y.*Y);
r=sqrt(p.*p+Z.*Z);
u=atan(b.*Z.*(1+e.*b./r)./(a.*p));
lat=atan((Z+e.*b.*sin(u).^3)./(p-e2.*a.*cos(u).^3));
v=a./sqrt(1-e2.*sin(lat).^2);
h=p.*cos(lat)+Z.*sin(lat)-a*a./v;
