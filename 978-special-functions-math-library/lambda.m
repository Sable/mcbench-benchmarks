function [f] = lambda(z)
%LAMBDA  Dirichlet Lambda function
%
%usage: f = lambda(z)
%
%tested on version 5.3.1
%
%      This program calculates the Dirichlet Lambda function
%      for the elements of Z using the Dirichlet deta function.
%      Z may be complex and any size.
%
%      Has a pole at z=1, zeros for z=(-even integers),
%      z=0+i*k2Pi/ln(2), and an
%      infinite number of zeros for z=1/2+i*y
%
%
%see also: Zeta, Eta, Betad, Bern, Euler

%Paul Godfrey
%pgodfrey@conexant.com
%3-24-01

zz=2.^z;
k = (zz-1)./(zz-2);

f=k.*deta(z,1);

p=find(z==1);
if ~isempty(p)
   f(p)=Inf;
end
 
return
