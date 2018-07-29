function [f] = eta(z)
%ETA  Dirichlet Eta function
%
%usage: f = eta(z)
%
%tested on version 5.3.1
%
%      This program calculates the Dirichlet Eta function
%      for the elements of Z using the Dirichlet deta function.
%      Z may be complex and any size.
%
%      Has zeros for z=(-even integers),
%      z=1+i*k2Pi/ln(2), and an
%      infinite number of zeros for z=1/2+i*y
%
%
%see also: Zeta, Deta, Etan, Lambda, Betad, Bern, Euler

%Paul Godfrey
%pgodfrey@conexant.com
%3-24-01

f=deta(z,1);

return
