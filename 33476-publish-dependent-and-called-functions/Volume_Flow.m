function [ Q ] = Volume_Flow( r0 )
%%
% Compuation of volume flow rate in a pipe as a function of radius.
% 
% Syntax: [ Q ] = Volume_Flow( r0 )
%
% input: r0 = radium (cm)
%
% output: Q = volume flow rate (cm^3/s)      

v = @(r) 2*(1 - r./r0).^(1/6);
f = @(r) v(r).*2*pi.*r;

Q = quad(f,0,r0);
