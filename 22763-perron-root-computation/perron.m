function varargout = perron(varargin)
% Function perron(A) computes the perron root of the given square,
% non-negative irreducible matrix.
%
% [r,v] = perron(A, 'right') returns the value of perron root in r and the
% right perron vector in v. Additionally the left perron vector can be
% obtained by passing the string 'left'.
%
% [r,v] = perron(A) returns the perron root and the right perron vector.
%
% [r,v] = perron(A, 'normalized') returns the perron root and perron vector
% of a matrix B = A*inv(D(A)), where D(A) is a diagonal matrix with the
% diagonal entries being the diagonal entries of the matrix A.
%
% [r,v] = perron(A, 'left', 'normalized') returns the perron root and
% perron left vector of a matrix B = A*inv(D(A)), where D(A) is a diagonal
% matric with the diagonal entries being the diagonal entries of the matrix
% A.
%
% Perron root computation is based on the algorithm described in
% PRAKASH CHANCHANA, ``AN ALGORITHM FOR COMPUTING THE PERRON ROOT OF A
% NONNEGATIVE IRREDUCIBLE MATRIX'' Ph.D. Dissertation, North Carolina
% State University, Raleigh, 2007
% Last modified 23-Jan-2009 10:48:43
%
 
%  Copyright (c) 2009, Aravind Seshadri
%  All rights reserved.
%
%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:
%
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%      
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.

normalized = 0;
if nargin < 1
    error('Not enough input arguments')
elseif nargin == 1
    A = varargin{1};
    flag = 'right';
elseif nargin == 2
    A = varargin{1};
    if (strcmp(varargin{2}, 'normalized') || strcmp(varargin{2}, 'Normalized'))
        normalized = 1;
        flag = 'right';
    else
        flag = varargin{2};
    end
elseif nargin == 3
    A = varargin{1};
    flag = varargin{2};
    if (strcmp(varargin{3}, 'normalized') || strcmp(varargin{3}, 'Normalized'))
        normalized = 1;
    else
        error('The third input argument should be the string "normalized"')
    end
else
    error('Too many input arguments')
end

%% Check to see if the input is a square matrix
if ndims(A) > 2
    error('Input to this function should be a n x n square matrix')
else
    [row,column] = size(A);
    if row ~= column
        error('Input to this function should be a n x n square matrix')
    end
end

%% Check if A is non-negative
if max(max(A < 0))
    error('The input matrix should be non-negative')
end

%% Check if A is reducible
% The perron-frobenius theorem is applicable only for nonnegative irreducible matrices
if max(max((A+eye(row))^(row-1) <= 0))
    error('The input matrix is reducible')
end

%% Algorithm to find Perron-Vector

switch flag
    case 'right'
    case 'left'
        A = A.';
end

iterated = rand(row,1);
% Normalize the matrix
if normalized
    A = inv(diag(diag(A)))*A;       
end
lambda = max(sum(A));
err = 1;
% This algorithm will fail if A is scalar and of course if A is scalar then
% the perron root is A
if row > 1
    while err > eps
        B = inv(lambda*eye(row) - A);
        [L, U] = lu(lambda*eye(row) - A);
        iterated = L*U\iterated;
        p = iterated./(B*iterated);
        lambda_max = lambda - min(p);
        lambda_min = lambda - max(p);
        err = (lambda_max - lambda_min)/lambda_max;
        iterated = L*U\iterated;
        lambda = lambda_max;
    end
end
perron_root = lambda;
perron_vector = iterated/sum(iterated);

switch nargout
    case 0
        disp(perron_root)
    case 1
        varargout{1} = perron_root;
    case 2
        varargout{1} = perron_root;
        varargout{2} = perron_vector;
    otherwise
        error('Too many output arguments')
end
