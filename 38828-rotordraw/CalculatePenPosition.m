%% "Spirograph" Code
%  Jonathan Jamieson - September 2013
%  unigamer@gmail.com
%  www.jonathanjamieson.com

function [P_x_global,P_y_global ] = CalculatePenPosition(A_x_global,A_y_global,C_x_global,C_y_global,extension  )

dx = C_x_global-A_x_global;
dy = C_y_global-A_y_global;

theta = atan2(dy,dx);

P_x_global = extension*cos(theta)+C_x_global;
P_y_global = extension*sin(theta)+C_y_global;

end

