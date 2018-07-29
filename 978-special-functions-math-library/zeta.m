function [f] = zeta(z)
%ZETA  Riemann Zeta function
%
%usage: f = zeta(z)
%
%tested on version 5.3.1
%
%      This program calculates the Riemann Zeta function
%      for the elements of Z using the Dirichlet deta function.
%      Z may be complex and any size. Best accuracy for abs(z)<80.
%
%      Has a pole at z=1, zeros for z=(-even integers),
%      infinite number of zeros for z=1/2+i*y
%
%
%see also: Eta, Deta, Lambda, Betad, Bern, Euler
%see also: mhelp zeta

%Paul Godfrey
%pgodfrey@conexant.com
%3-24-01

zz=2.^z;
k = zz./(zz-2);

f=k.*deta(z,1);

p=find(z==1);
if ~isempty(p)
   f(p)=Inf;
end

return

%a demo of this function is

ezplot zeta
grid on

figure(2)
ezmesh('abs(zeta(x+i*y))',[0 1 .5 30])
view(75, 4)
