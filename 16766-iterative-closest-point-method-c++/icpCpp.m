function [TR, TT] = icpCpp(model,data,weights,randvec,sizerand,treeptr,iter)
% ICP - Iterative Closest Point algorithm, c++ implementation.
% Handles only points in R^3.
% Makes use of a kd-tree for closest-point search.
%
%   Usage:
%
%   [R, T] = icpCpp(model,data,weights,randvec,sizerand,treeptr,max_iter)
%
%   ICP finds the transformation of points in data to fit points in model.
%   Fit with respect to minimize a weighted sum of squares
%   for distances between the data points and the corresponding closest model points.
% 
%   INPUT:
% 
%   model - matrix with model points, [Pm_1 Pm_2 ... Pm_nmod]
%   data - matrix with data points,   [Pd_1 Pd_2 ... Pd_ndat]
%   weights - weights (>0) corresponding to points in data
%   randvec - uint32(randperm(size(data,2))-1)
%   sizerand - number of matched points in each iteration
%   treeptr - pointer to the kd-tree. Notice that model must be in
%             transpose when the kd-tree is created.
%   iter - Number of iterations.
%
%   OUTPUT:
%
%   R - rotation matrix and
%   T - translation vector so
%
%           newdata = R*data + T ,
%
%   where newdata is the transformed data points.
%
%   Compile c++ files first by running make. 
%   Run icp_demo for an example.
%
%   Written by Per Bergström 2007-10-09