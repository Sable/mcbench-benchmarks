function h=hor_slice(xvect,yvect,data,const)
%FUNCTION H=VERT_SLICE(HVECT,VVECT,DATA,CONST)
% plots the 2D data of, say a seismic survey, GPR, 
% resistivity survey in 3D as vertical slices
% For multiple vertical slice note that this only work 
% for surveys that are mutually perpendicular.
% You have to provide:
% - HVECT: a vector with the 1st horizontal data (say offset in GPR)
% - VVECT: a vector with values for the 2nd horizontal axis.
% - DATA: the data to be displayed (make sure that the dimensions 
%   match with the two vectors
% - CONST: a constant defining the depth of the slice (intersection point
%   with the z-axis.
%   
% The function returns the handle of the surface plot.
%  
% CAREFUL: Plotting too many slices kills your computer when dong graphical
% adjustments (rotation rescaling, ...) - you will have to be very patient 
% ... or you need a faster machine.
%
% Ulrich Theune, 2003
%
%

if ~ishold
    hold on
end

[m,n]=size(data);

z=const*ones(m,n);
[x,y]=meshgrid(xvect,yvect);
h=surf(x,y,z,data);
plot3([min(xvect) min(xvect) max(xvect) max(xvect) min(xvect)],...        
    [min(yvect) max(yvect) max(yvect) min(yvect) min(yvect)],...
    [const const const const const],'k','linewidth',0.1);    
shading interp


clear x y z
view(3)