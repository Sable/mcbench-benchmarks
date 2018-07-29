%
% BEZIER
%
% ger en bezierkurza mellan p1 och p2, med styrpunkter b och c. n stycken
% punkter, inkluderar p1, men inte p2.

function r=bezier(p1,b,c,p2,n)

t=(0:1/n:1-(1/n)/2)';
r=(1-t).^3*p1+3*t.*(1-t).^2*b+3*t.^2.*(1-t)*c+t.^3*p2;

