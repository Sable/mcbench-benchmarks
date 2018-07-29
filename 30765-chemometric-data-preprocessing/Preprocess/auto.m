function [ax,mx,stdx] = auto(x)
% Autoscales matrix to zero mean and unit variance
%
% [ax,mx,stdx] = auto(x)
%
% input:
% x 	data to autoscale
%
% output:
% ax	autoscaled data
% mx	means of data
% stdx	stantard deviations of data
%
% By Cleiton A. Nunes
% UFLA,MG,Brazil



[m,n] = size(x);
mx    = mean(x);
stdx  = std(x);
ax    = (x-mx(ones(m,1),:))./stdx(ones(m,1),:);


