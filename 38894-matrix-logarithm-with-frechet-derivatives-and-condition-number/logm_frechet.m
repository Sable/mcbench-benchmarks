function [ varargout ] = logm_frechet( varargin )
%LOGM_FRECHET Matrix logarithm and its Frechet derivative in direction E.
%   This code computes the matrix logarithm log(A), 
%   its Frechet derivative in a particular direction E and the condition
%   number of the logarithm. This function will automatically choose
%   between versions optimized for real or complex matrices.
%
%   This code can be called in the following ways:
%   
%   X = logm_frechet(A)
%   L = logm_frechet(A,E)
%   [X, cond] = logm_frechet(A)
%   [X, L] = logm_frechet(A,E)
%   [X, L, cond] = logm_frechet(A,E)
%
%   where X = log(A), cond is an estimate of the associated condition
%   number and L is the Frechet derivative in the direction E.
%    
%   This code is intended for double precision.
%
%   Reference: A. H. Al-Mohy, N. J. Higham and S. D. Relton, Computing the 
%   Frechet Derivative of the Matrix Logarithm and Estimating the Condition 
%   Number, MIMS EPrint 2012.72,
%   The University of Manchester, July 2012.  
%   Name of corresponding algorithms in that paper: Algorithms 5.1/6.1
%
%   Awad H. Al-Mohy, Nicholas J. Higham and S. D. Relton, October 3, 2012.

% Check whether all inputs are matrices
lenv = length(varargin);
for k = 1:lenv
    if ~ismatrix(varargin{k})
        error(strcat('Inputs to logm_frechet must be matrices.',... 
            ' Use help logm_frechet for a list of possible inputs.'));
    end
end

s = size(varargin{1});
for k = 1:lenv
    % Check sizes match
    s2 = size(varargin{k});
    if ~isequal(s, s2)
        error('Matrices must be of the same size. Please check input.')
    end
    % Check matrices are square
    if ~isequal(s2(1), s2(2))
        error('Matrices must be square. Please check input.')
    end
end

% Entries are matrices of the correst sizes, check which function to use
if lenv < 1 || lenv > 2
   error(strcat('Wrong number of inputs to logm_frechet.',...
        'Please use help logm_frechet for a list of possible inputs.'))
end

if ~isreal(varargin{1}) || (lenv == 2 && ~isreal(varargin{2}))
   [varargout{1:nargout}] = logm_frechet_complex(varargin{:});
else
   [varargout{1:nargout}] = logm_frechet_real(varargin{:});
end

