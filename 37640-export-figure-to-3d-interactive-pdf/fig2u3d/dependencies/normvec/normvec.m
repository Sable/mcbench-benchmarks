function [varargout] = normvec(varargin)
%NORMVEC    normalize vector(s).
%   NORMVEC computes the unit vectors in the direction of the vectors
%   provided. It can process two types of arguments:
%
%       1) single matrix of vectors
%       2) multiple matrices of vector components
%          (as those returned by MESHGRID and NDGRID)
%
%   In both cases, the p-norm to be used can be specified.
%   The default is the 2-norm (Euclidean).
%
%   Only in the first case, the matrix dimension along which the vectors
%   are defined can be defined. The default is the first non-singleton
%   This behavior is derived from VNORM (FEX id=#10708, by Winston Smith),
%   which is called by this function.
%
%   Zero vectors are normalized to 0 and NOT to NaN.
%
%% usage
%
% Case A: matrix of N-dimensional column vectors
%   [v] = NORMVEC(v)
%   [v] = NORMVEC(v, 'p', n)
%   [v] = NORMVEC(v, 'p', n, 'dim', d)
% 
%   v = matrix of column vectors
%     = [#dimensions x #vectors]
%   n = p-norm selected (e.g. 2 is the Euclidean norm ||.||_2)
%   d = norm for vectors defined along dimension d of matrix v
%     >= 1
%     or [] (vectors along first non-singleton dimension)
% 
% Case B: 2 component matrices of 2-dimensional vectors
%   [px, py] = NORMVEC(px, py)
%   [px, py] = NORMVEC(px, py, 'p', n)
% 
%   px = matrix [M x N] of x vector components
%   py = matrix [M x N] of y vector components
%   n = 'p' norm selected
% 
% Case C: 3 component matrices of 3-dimensional vectors
%   [px, py, pz] = NORMVEC(px, py, pz)
%   [px, py, pz] = NORMVEC(px, py, pz, 'p', n)
% 
%   px = matrix [M x N x L] of x vector components
%   py = matrix [M x N x L] of y vector components
%   pz = matrix [M x N x L] of z vector components
%   n = 'p' norm selected
% 
% Case D: N component matrices of N-dimensional vectors
%   [px1, px2, ..., pxN] = NORMVEC(px1, px2, ..., pxN)
%   [px1, px2, ..., pxN] = NORMVEC(px1, px2, ..., pxN, 'p', n)
% 
%   pxi = matrix [M1 x M2 x ... x MN] of xi vector components
%   n = 'p' norm selected
%
%% dependency
%   vnorm, File Exchange ID = 10708, (c) 2006 by Winston Smith
%   http://www.mathworks.com/matlabcentral/fileexchange/10708-vector-norm
%
%   See also: VNORM, NORM, NORMC, NORMR, MESHGRID, NDGRID.
%
% File:      normvec.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2011.01.04 - 2012.04.17
% Language:  MATLAB R2012a
% Purpose:   normalized vector(s) (p norm selectable)
% Depends:   vnorm (FEX ID = 10708, (c) 2006 by Winston Smith)
% Copyright: Ioannis Filippidis, 2011-

%   Related FEX functions:
%       1) unit(a, dim) (in #8782, Vector algebra for arrays of any size,
%                                  with array expansion enabled)
%          (normalize matrix of vectors, dim-wise)
%          http://www.mathworks.fr/matlabcentral/fileexchange/8782-vector-algebra-for-arrays-of-any-size-with-array-expansion-enabled
%
%       2) unitize(A, dim, normclass) (id #10751)
%          (normalize matrix of vectors, dim-wise, p-norm)
%
%       3) Normalize_Columns(A) (id #26416, Function to normalize 
%                                           columns of given matrix)
%          (normalize matrix of column vectors, column-wise)
%          http://www.mathworks.com/matlabcentral/fileexchange/26416-function-to-normalize-columns-of-given-matrix
%
%       4) createUnitVector(vector) (id #28605, Take a vector and convert
%                                       it to a unit vector (normalize) )
%          (normalize single row or column vector)
%          http://www.mathworks.com/matlabcentral/fileexchange/28605-take-a-vector-and-convert-it-to-a-unit-vector-normalize

%% input

% defaults
p = 2; % Euclidean norm
dim = []; % first non-singleton
n = nargin;

if n == 0
    error('No input arguments!')
end

% extract properties
% (should be last arguments, at most 2 property-value pairs)
while n > 2
    property = varargin{n -1};
    
    % any more properties ?
    if ~ischar(property)
        break;
    end
    
    % yes
    switch property
        case 'p'
            p = varargin{n};
        case 'dim'
            dim = varargin{n};
        otherwise
            warning('normvec:property',...
                    ['Unknown property: ', property, ' provided.'] )
    end
    n = n -2;
end

% dim property redundant ?
if (n > 1) && (~isempty(dim) )
    warning('normvec:dim', 'dim property unused for component matrices.')
end

%% compute

% matrix of column vectors
if n == 1
    v = varargin{1};
    
    vn = vnorm(v, dim, p);
    vn(vn == 0) = 1;
    v = bsxfun(@rdivide, v, vn);
    
    varargout{1} = v;
% 2 matrices for 2D vector components (seperately implemented for speed)
elseif n == 2
    px = varargin{1};
    py = varargin{2};
    
    vn = (px.^p +py.^p).^(1 /p);
    
    vn(vn == 0) = 1;
    
    varargout{1} = bsxfun(@rdivide, px, vn);
    varargout{2} = bsxfun(@rdivide, py, vn);
% 3 matrices for 3D vector components (seperately implemented for speed)
elseif n == 3
    px = varargin{1};
    py = varargin{2};
    pz = varargin{3};
    
    vn = (px.^p +py.^p +pz.^p).^(1 /p);
    
    vn(vn == 0) = 1;
    
    varargout{1} = bsxfun(@rdivide, px, vn);
    varargout{2} = bsxfun(@rdivide, py, vn);
    varargout{3} = bsxfun(@rdivide, pz, vn);
% n matrices for nD vector components
else
    vn = zeros(size(varargin{1}) );

    for i=1:n
        vn = vn +varargin{i}.^p;
    end
    vn = vn.^(1 /p);
    
    vn(vn == 0) = 1;
    
    varargout = cell(1, n);
    for i=1:n
        varargout{i} = bsxfun(@rdivide, varargin{i}, vn);
    end
end
