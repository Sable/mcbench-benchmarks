function curve = nrbcirc(radius,center,sang,eang) 
%  
% Function Name: 
%  
%   nrbcirc - Construct a circular arc. 
%  
% Calling Sequence: 
%  
%   crv = nrbarc() 
%   crv = nrbarc(radius) 
%   crv = nrbarc(radius,center) 
%   crv = nrbarc(radius,center,sang,eang) 
%  
% Parameters: 
%  
%   radius	: Radius of the circle, default 1.0 
%  
%   center	: Center of the circle, default (0,0,0) 
%  
%   sang	: Start angle, default 0 degrees 
%  
%   eang	: End angle 360 degrees 
%  
%   crv		: NURBS curve for a circular arc. 
%  
% Description: 
%  
%   Constructs NURBS data structure for a circular arc in the x-y plane. If 
%   no rhs arguments are supplied a unit circle with center (0.0,0.0) is 
%   constructed.  
%  
%   Angles are defined as positive in the anti-clockwise direction. 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if nargin < 1 
  radius = 1; 
end 
 
if nargin < 2 
  center = []; 
end 
    
if nargin < 4 
  sang = 0; 
  eang = 2*pi; 
end 
 
sweep = eang - sang;       % sweep angle of arc 
if sweep < 0 
  sweep = 2*pi + sweep; 
end 
      
if abs(sweep) <= pi/2 
  narcs = 1;                % number of arc segments 
  knots = [0 0 0 1 1 1]; 
elseif abs(sweep) <= pi 
  narcs = 2; 
  knots = [0 0 0 0.5 0.5 1 1 1]; 
elseif abs(sweep) <= 3*pi/2 
  narcs = 3; 
  knots = [0 0 0 1/3 1/3 2/3 2/3 1 1 1]; 
else 
  narcs = 4; 
  knots = [0 0 0 0.25 0.25 0.5 0.5 0.75 0.75 1 1 1]; 
end 
 
dsweep = sweep/(2*narcs);     % arc segment sweep angle/2 
 
% determine middle control point and weight 
wm = cos(dsweep); 
x  = radius*wm; 
y  = radius*sin(dsweep); 
xm = x+y*tan(dsweep); 
 
% arc segment control points 
ctrlpt = [ x wm*xm x;    % w*x - coordinate 
          -y 0     y;    % w*y - coordinate 
           0 0     0;    % w*z - coordinate 
           1 wm    1];   % w   - coordinate 
       
% build up complete arc from rotated segments 
coefs = zeros(4,2*narcs+1);   % nurbs control points of arc 
xx = vecrotz(sang + dsweep); 
coefs(:,1:3) = xx*ctrlpt;     % rotate to start angle 
xx = vecrotz(2*dsweep); 
for n = 2:narcs 
   m = 2*n+[0 1]; 
   coefs(:,m) = xx*coefs(:,m-2); 
end 
 
% vectrans arc if necessary 
if ~isempty(center)  
  xx = vectrans(center); 
  coefs = xx*coefs; 
end 
 
curve = nrbmak(coefs,knots); 
