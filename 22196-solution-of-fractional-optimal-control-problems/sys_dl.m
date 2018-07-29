function [l_x,l_u,l_t] = sys_Dl(neq,t,x,u)

global sys_params A B C D


% l_x should be a row vector of length n.
% l_u should be a row vector of length m.
% l_t is not used.

F_NUM = neq(5);

l_x = 2*C'*C*x;
l_u = 2*D'*D*u + 2*u;
