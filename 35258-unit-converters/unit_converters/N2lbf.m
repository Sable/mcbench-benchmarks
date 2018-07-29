function [lbf] = N2lbf(N)
% Convert units of force from newtons to pounds-force.  Yes, pounds-force
% is somewhat redundant.  Just making sure we aren't talking about
% pounds-mass here. 
% Chad Greene 2012
lbf = N/4.4482216152605;