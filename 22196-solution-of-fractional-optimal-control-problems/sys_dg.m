function [J_x0,J_xf,J_t] = sys_Dg(neq,t,x0,xf)

global sys_params A B C D


% J_x0 and J_xf are row vectors of length n.
% J_t is not used.

F_NUM = neq(5); 

J_x0 = zeros(1, length(x0));
J_xf = 0*C;

