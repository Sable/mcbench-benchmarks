function [X,names]=toroid
% [X,names]=toroid
% This function defines toroidal coordinates using
% the formulas on page 112 of the 'Field Theory 
% Handbook' by P. Moon and D. E. Spencer
syms e t p real; names=[e,t,p];
d=cosh(e)-cos(t); x=sinh(e)*cos(p)/d;
y=sinh(e)*sin(p)/d; z=sin(t)/d; X=[x;y;z];