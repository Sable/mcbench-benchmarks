function h=vert_slice(xhvect,yhvect,vvect,data)
%FUNCTION H=VERT_SLICE(HVECT,YHVECT,VVECT,DATA)
% plots the 2D data of, say a seismic survey, GPR, 
% resistivity survey in 3D as vertical slices. The slice will be defined
% by its cartesian x-y-z coordinates with the geophysical data projected
% on.
% 
% You have to provide:
% - XHVECT: a vector containing thhe x-coordinates of the survey (do NOT
% have to be evenly sampled).
% - YHVECT: this vector contains the y-coordinates of the survey. It is
% required that the two vectors for the x and y coordinates are of equal
% lengths.
% - VVECT: a vector with values for the vertical axis (for example time for
% GPR data).
% - DATA: the data to be displayed (make sure that the dimensions match with
% the three vectors). These data will be projected on the slice.
%   
% The function returns the handle of the surface plot.
%  
% CAREFUL: Plotting too many slices kills your computer when doing graphical 
%   adjustments (rotation, rescaling, ...) - you will have to be very patient 
%   ... or you need a faster machine.
%
% Example:
%   %--- Create the survey x and y coordintes
%   x=1:50;
%   y=(sin(2*pi/25*x))*10;     % These data do not have to be linear.
%   z=51:100;
%   %--- Create a random data set
%   r=randn(50);
%   h=vert_slice(x,y,z,r);
%   shading interp
%   rotate3d on
%
%
%   Ulrich Theune, 2003

[x,z]=meshgrid(xhvect,vvect);
[y,z]=meshgrid(yhvect,vvect);

h=surf(x,y,z,data);
shading interp
clear x y z
view(3)