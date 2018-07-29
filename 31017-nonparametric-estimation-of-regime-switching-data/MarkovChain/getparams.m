function [alpha,beta]=getparams(c,st)
%standard deviation
d=st*c;


d=d^2;

alpha=(c^2*(1-c)/d)-c;
beta=(alpha-c*alpha)/c;