% ARGMAXMIN_MEX    This function computes argument of maximum/minimum for
%   vectors and matrices (but not for N-D arrays).
%   I=ARGMAXMIN_MEX(X, DIM, max_NOT_MIN) computes the indices of minima 
%   in case max_NOT_MIN == 0 and the indices of the maxima otherwise.
%
%   I=ARGMAXMIN_MEX(X, DIM, max_NOT_MIN) operates along the dimension DIM.
%
%   This function performs very fast, since it does not do any check 
%   on the input X and is writted in C (SEE ARGMAXMIN_MEX.C).
%
%   Examples
%       X = [2 8 6 1; 
%            6 3 4 7; 
%            9 1 8 4]
%       disp('The indices of maxima columnwise are:');
%       Ic_max = argmaxmin_mex(X,1,1); 
%       disp(Ic_max);
%       disp('The indices of minima columnwise are:');
%       Ic_min = argmaxmin_mex(X,1,0);
%       disp(Ic_min);
%       disp('The indices of maxima rowwise are:');
%       Ir_max = argmaxmin_mex(X,2,1); 
%       disp(Ir_max);
%       disp('The indices of minima rowwise are:');
%       Ir_min = argmaxmin_mex(X,2,0);
%       disp(Ir_min);

%   See also ARGMIN, ARGMAX, ARGMAX_DEMO, MIN, MAX, MEDIAN, MEAN, SORT.

% Copyright 2009, Marco Cococcioni
% $Revision: 1.0 $  $Date: 2009/02/16 19:24:01 $