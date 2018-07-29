%% "Spirograph" Code
%  Jonathan Jamieson - September 2013
%  unigamer@gmail.com
%  www.jonathanjamieson.com

% This code basically works out the intersection of a circle.

function [C_x_global,C_y_global] = Calculate_Point_C(A_x_global,B_x_global,A_y_global,B_y_global,L1,L2)

  dx = A_x_global - B_x_global;
  dy = A_y_global - B_y_global;

  d = hypot(dx,dy); 

  a = ((L2*L2) - (L1*L1) + (d*d)) / (2.0 * d) ;

  x2 = B_x_global + (dx * a/d);
  y2 = B_y_global + (dy * a/d);

  h = sqrt((L2*L2) - (a*a));

  rx = -dy * (h/d);
  ry = dx * (h/d);

  C_x_global = x2 + rx;
  xi_prime = x2 - rx; % if other point is needed
  C_y_global = y2 + ry;
  yi_prime = y2 - ry; % if other point is needed

end

