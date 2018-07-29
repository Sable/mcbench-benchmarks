function H=sirkl(center,radius)
%......................................................................
% H=SIRKL(CENTER,RADIUS)
% This routine draws a circle with center defined as
% a vector CENTER, radius as a scaler RADIUS. 
%
%   Usage Examples,
%
%   sirkl([1,3],3); 
%
%   Kaushik Kandakatla <kkaushik@ymail.com>
%   Version 1.00
%   May, 2011
%give center as a array for example [1 3].
%radius is simply a non-negative number.
%......................................................................
rad=2*radius;
n_coor=center-[radius radius];
H=rectangle ('position', [n_coor, rad, rad], 'curvature', [1, 1]);
daspect([1 1 1]);