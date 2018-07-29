function nrbplot(nurbs,subd,p1,v1) 
%  
% Function Name: 
%  
%   nrbplot - Plot a NURBS curve or surface. 
%  
% Calling Sequence: 
%  
%   nrbplot(nrb,subd) 
%   nrbplot(nrb,subd,p,v) 
%  
% Parameters: 
%  
%  
%   nrb		: NURBS curve or surface, see nrbmak. 
%  
%   npnts	: Number of evaluation points, for a surface a row vector 
% 		with two elements for the number of points along the U and 
% 		V directions respectively. 
%  
%   [p,v]       : property/value options 
% 
%               Valid property/value pairs include: 
% 
%               Property        Value/{Default} 
%               ----------------------------------- 
%               light           {off} | true   
%               colormap        {'copper'} 
% 
% Example: 
% 
%   Plot the test surface with 20 points along the U direction 
%   and 30 along the V direction 
% 
%   plot(nrbtestsrf, [20 30]) 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
nargs = nargin; 
if nargs < 2 
  error('Need a NURBS to plot and the number of subdivisions!'); 
elseif rem(nargs+2,2) 
  error('Param value pairs expected') 
end 
 
% Default values 
light='off'; 
cmap='copper'; 
 
% Recover Param/Value pairs from argument list 
for i=3:2:nargs 
  Param = eval(['p' int2str((i-3)/2 +1)]); 
  Value = eval(['v' int2str((i-3)/2 +1)]); 
  if ~isstr(Param) 
    error('Parameter must be a string') 
  elseif size(Param,1)~=1 
    error('Parameter must be a non-empty single row string.') 
  end 
  switch lower(Param) 
  case 'light' 
    light = lower(Value); 
    if ~isstr(light) 
      error('light must be a string.') 
    elseif ~(strcmp(light,'off') | strcmp(light,'on')) 
      error('light must be off | on') 
    end 
  case 'colormap' 
    if isstr(Value) 
      cmap = lower(Value); 
    elseif size(Value,2) ~= 3 
      error('colormap must be a string or have exactly three columns.') 
    else 
      cmap=Value; 
    end 
  otherwise 
    error(['Unknown parameter: ' Param]) 
  end 
end 
 
colormap('default'); 
 
% convert the number of subdivisions in number of points 
subd = subd+1; 
 
% plot the curve or surface 
if iscell(nurbs.knots) 
  % plot a NURBS surface 
  p = nrbeval(nurbs,{linspace(0.0,1.0,subd(1)) linspace(0.0,1.0,subd(2))}); 
  if strcmp(light,'on')  
    % light surface 
    surfl(squeeze(p(1,:,:)),squeeze(p(2,:,:)),squeeze(p(3,:,:))); 
    shading interp; 
    colormap(cmap); 
  else  
    surf(squeeze(p(1,:,:)),squeeze(p(2,:,:)),squeeze(p(3,:,:))); 
    shading faceted; 
  end 
else 
  % plot a NURBS curve 
  p = nrbeval(nurbs,linspace(0.0,1.0,subd)); 
 
  if any(nurbs.coefs(3,:)) 
    % 3D curve 
    plot3(p(1,:),p(2,:),p(3,:));  
    grid on; 
  else 
    % 2D curve 
    plot(p(1,:),p(2,:)); 
  end 
end 
axis equal; 
 
% plot the control surface 
% hold on; 
% mesh(squeeze(pnts(1,:,:)),squeeze(pnts(2,:,:)),squeeze(pnts(3,:,:))); 
% hold off; 
