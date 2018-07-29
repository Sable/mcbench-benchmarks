function T = sptoeplitz(col,row)
% SPTOEPLITZ Sparse Toeplitz matrix.
%    SPTOEPLITZ(C,R) produces a sparse nonsymmetric Toeplitz matrix having
%    C as its first column and R as its first row. Neither C nor R needs to
%    be sparse. No full-size dense matrices are formed.
%
%    SPTOEPLITZ(R) is a sparse symmetric/Hermitian Toeplitz matrix.
%
%    Examples:
%       sptoeplitz( real( (1i).^(0:8) ) )   % 9x9, 41 nonzeros
%       sptoeplitz( [-2 1 zeros(1,9998)] ); % classic 2nd difference
%
%    See also TOEPLITZ, SPDIAGS.

%    Copyright (c) 2006 by Tobin Driscoll (tobin.driscoll@gmail.com).
%    First version, 11 December 2006.

% This part is borrowed from built-in Toeplitz.
if nargin < 2  % symmetric case
  col(1) = conj(col(1)); row = col; col = conj(col); 
else
  if col(1)~=row(1)
    warning('MATLAB:sptoeplitz:DiagonalConflict',['First element of ' ...
      'input column does not match first element of input row. ' ...
      '\n         Column wins diagonal conflict.'])
  end
end

% Size of result.
m = length(col(:));  n = length(row(:));

% Locate the nonzero diagonals.
[ic,jc,sc] = find(col(:));
row(1) = 0;  % not used
[ir,jr,sr] = find(row(:));

% Use spdiags for construction.
d = [ ir-1; 1-ic ];
B = repmat( [ sr; sc ].', min(m,n),1 );
T = spdiags( B,d,m,n );
