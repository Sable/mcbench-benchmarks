function [h_x,h_u] = sys_Dh(neq,t,x,u)

global sys_params A B C D


% h_x must be an n by n matrix.
% h_u must be an n by m matrix.


h_u = A+B*(C).*t;

h_x = B;