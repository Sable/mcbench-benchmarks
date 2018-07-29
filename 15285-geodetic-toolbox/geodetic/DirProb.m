echo on
%--------------------------------------------------
% DirProb
%   Example direct geodetic problem.  Computes
%   lat,lon,ht of 2nd point from distance,azimuth,
%   vertical angle from 1st point.
% 7 Jul 96
%
% M-files:  dms2rad, rad2dms, inverse, direct,
%           refell
%--------------------------------------------------
%clear

%---------- Define lat,lon,ht of 1st (from) point(s)

lat1=dms2rad([50 15 31.67214]);     % Enter latitude
lon1=dms2rad([-95 51 58.18951]);    % Enter longitude
h1=248.39;                          % Enter ell. height
n=max(size(lat1));

%---------- Define az,va,dist to 2nd point(s)

azdms=[100 30 10];       % Enter azimuth
vadms=[10 45 05];        % Enter vertical angle
d=1500;                  % Enter distance
az=dms2rad(azdms);
va=dms2rad(vadms);

%---------- Compute lat,lon,ht of 2nd point(s)

[a,b,e2,finv]=refell('NAD83');
[lat2,lon2,h2]=direct(lat1,lon1,h1,az,va,d,a,e2);
latdms=rad2dms(lat2);
londms=rad2dms(lon2);

%---------- List results

for i=1:n
  fprintf('\nPoint      %4.0f\n',i);
  fprintf('Latitude   %4.0f %2.0f %9.6f\n',latdms(i,1),latdms(i,2),latdms(i,3));
  fprintf('Longitude  %4.0f %2.0f %9.6f\n',londms(i,1),londms(i,2),londms(i,3));
  fprintf('Height     %9.4f\n',h2(i));
end
