function [f] = betad(z)
%BETAD Dirichlet Beta function
%
%usage: f = betad(z)
%
%tested on version 5.3.1
%
%      This program calculates the Dirichlet Beta function
%      for the elements of Z using the Dirichlet deta function.
%      Z may be complex and any size.
%
%      Note: this is NOT the beta function defined by
%            Gamma(x)*Gamma(y)/Gamma(x+y)
%
%      Has zeros for z=(-odd integers),
%      and infinite number of zeros for z=1/2+i*y
%
%
%see also: Zeta, Deta, Eta, Lambda, Bern, Euler

%Paul Godfrey
%pgodfrey@conexant.com
%3-24-01

f=deta(z,2);

return
