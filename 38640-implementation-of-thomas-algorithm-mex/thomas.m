function [varargout] = thomas(varargin)
%-------------------------------------------------------------------------%
%	THOMAS - solve tridiagonal linear system using Thomas algorithm.
%
%	Usage: u = thomas(alpha, beta, gamma, d) OR u = thomas(A, d).
%   All input arguments should be of type double (and not single, for
%   instance).
%
%	Input:
%       'alpha', 'beta', 'gamma' - main, upper and lower diagonals of a 
%           square tridiagonal matrix A of size NxN, of sizes Nx1, (N-1)x1
%           and (N-1)x1, respectively (or transposed).
%       OR:
%       'A' - square tridiagonal matrix of size NxN.
%       'd' - vector of size Nx1 or 1xN.
%	Output:
%       'u' - solution of the system Au = d.
%
%	Copyright (c) 2012 Anastasia Dubrovina
%-------------------------------------------------------------------------%

% Parse the input
if (nargin == 2)
    A = varargin{1};
    alpha = diag(A);
    beta = diag(A, 1);
    gamma = diag(A, -1);
    d = varargin{2};
    clear A;
elseif (nargin == 4)
    alpha = varargin{1};
    beta = varargin{2};
    gamma = varargin{3};
    d = varargin{4};
else
    error('Two (A, d) or four (alpha, beta, gamma, d) input arguments required.');
end

% Solve
u = mex_thomas(alpha, beta, gamma, d);

% Assign output 
varargout{1} = u;

end