function [semimajor_axis, semiminor_axis, x0, y0, phi] = ellipse_fit(x, y)
%
% ellipse_fit - Given a set of points (x,y), ellipse_fit returns the
% best-fit ellipse (in the Least Squares sense) 
%
% Input:                  
%                       x - a vector of x measurements
%                       y - a vector of y measurements
%
% Output:
%
%                   semimajor_axis - Magnitude of ellipse longer axis
%                   semiminor_axis - Magnitude of ellipse shorter axis
%                   x0 - x coordinate of ellipse center 
%                   y0-  y coordinate of ellipse center 
%                   phi - Angle of rotation in radians with respect to
%                   the x-axis
%
% Algorithm used:
%
% Given the quadratic form of an ellipse: 
%  
%       a*x^2 + 2*b*x*y + c*y^2  + 2*d*x + 2*f*y + g = 0   (1)
%                          
%  we need to find the best (in the Least Square sense) parameters a,b,c,d,f,g. 
%  To transform this into the usual way in which such estimation problems are presented,
%  divide both sides of equation (1) by a and then move x^2 to the
% other side. This gives us:
%
%       2*b'*x*y + c'*y^2  + 2*d'*x + 2*f'*y + g' = -x^2            (2)
%  
%   where the primed parametes are the original ones divided by a.
%  Now the usual estimation technique is used where the problem is
%  presented as:
%
%    M * p = b,  where M = [2*x*y y^2 2*x 2*y ones(size(x))], 
%    p = [b c d e f g], and b = -x^2. We seek the vector p, given by:
%    
%    p = pseudoinverse(M) * b.
%  
%    From here on I used formulas (19) - (24) in Wolfram Mathworld:
%    http://mathworld.wolfram.com/Ellipse.html
%
%
% Programmed by: Tal Hendel <thendel@tx.technion.ac.il>
% Faculty of Biomedical Engineering, Technion- Israel Institute of Technology     
% 12-Dec-2008
%
%--------------------------------------------------------------------------


x = x(:);
y = y(:);

%Construct M
M = [2*x.*y y.^2 2*x 2*y ones(size(x))];

% Multiply (-X.^2) by pseudoinverse(M)
e = M\(-x.^2);

%Extract parameters from vector e
a = 1;
b = e(1);
c = e(2);
d = e(3);
f = e(4);
g = e(5);

%Use Formulas from Mathworld to find semimajor_axis, semiminor_axis, x0, y0
%, and phi

delta = b^2-a*c;

x0 = (c*d - b*f)/delta;
y0 = (a*f - b*d)/delta;

phi = 0.5 * acot((c-a)/(2*b));

nom = 2 * (a*f^2 + c*d^2 + g*b^2 - 2*b*d*f - a*c*g);
s = sqrt(1 + (4*b^2)/(a-c)^2);

a_prime = sqrt(nom/(delta* ( (c-a)*s -(c+a))));

b_prime = sqrt(nom/(delta* ( (a-c)*s -(c+a))));

semimajor_axis = max(a_prime, b_prime);
semiminor_axis = min(a_prime, b_prime);

if (a_prime < b_prime)
    phi = pi/2 - phi;
end