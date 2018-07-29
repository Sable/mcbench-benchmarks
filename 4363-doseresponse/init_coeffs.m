function init_params = init_coeffs(x,y)
% INIT_COEFFS Function to generate the initial parameters for the 4
% parameter dose response curve.
% Requires an array of doses and an array of responses
% This function is used by sigmoid.m and ec50.m
%
% Copyright 2004 Carlos Evangelista 
% send comments to CCEvangelista@aol.com
% Version 1.0    01/07/2004

parms=ones(1,4);
parms(1)=min(y);
parms(2)=max(y);
parms(3)=(min(x)+max(x))/2;
sizey=size(y);
sizex=size(x);
if (y(1)-y(sizey))./(x(2)-x(sizex))>0
    parms(4)=(y(1)-y(sizey))./(x(2)-x(sizex));
else
    parms(4)=1;
end
init_params=parms;