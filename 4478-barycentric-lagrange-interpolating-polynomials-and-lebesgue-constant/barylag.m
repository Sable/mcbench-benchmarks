function [p]=barylag(data,x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% barylag.m
%
% Interpolates the given data using the Barycentric
% Lagrange Interpolation formula. Vectorized to remove all loops
%
% data - a two column vector where column one contains the
%        nodes and column two contains the function value 
%        at the nodes
% p - interpolated data. Column one is just the 
%     fine mesh x, and column two is interpolated data 
%
% Reference:
%
% (1) Jean-Paul Berrut & Lloyd N. Trefethen, "Barycentric Lagrange 
%     Interpolation" 
%     http://web.comlab.ox.ac.uk/oucl/work/nick.trefethen/berrut.ps.gz
% (2) Walter Gaustschi, "Numerical Analysis, An Introduction" (1997) pp. 94-95
%
%
% Written by: Greg von Winckel       03/07/04
% Contact:    gregvw@chtm.unm.edu 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M=length(data);     N=length(x);

% Compute the barycentric weights
X=repmat(data(:,1),1,M);

% matrix of weights
W=repmat(1./prod(X-X.'+eye(M),1),N,1);

% Get distances between nodes and interpolation points
xdist=repmat(x,1,M)-repmat(data(:,1).',N,1);

% Find all of the elements where the interpolation point is on a node
[fixi,fixj]=find(xdist==0);

% Use NaNs as a place-holder
xdist(fixi,fixj)=NaN;
H=W./xdist;

% Compute the interpolated polynomial
p=(H*data(:,2))./sum(H,2);

% Replace NaNs with the given exact values. 
p(fixi)=data(fixj,2);

