function rrefmovie(A,tol)
%RREFMOVIE Movie of the computation of the reduced row echelon form.
%   RREFMOVIE(A) produces the reduced row echelon form of A.
%   RREFMOVIE, by itself, supplies its own 8-by-6 matrix with rank 4.
%   RREFMOVIE(A,tol) uses the given tolerance in the rank tests.

%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $

% Sample matrix if none was provided.

Old_Format=get(0,'Format');
if nargin < 1

    A = [ 9     4     1     6    12     7
          4     0     4    15     1    14
          7     0     7     8    10     9
         16     0    16     3    13     2
          0     2    -4     0     0     0
          0     6   -12     0     0     0
          9     0     9     6    12     7
          5     0     5    10     8    11];
end
format rat
more off
clc
home
disp('  Original matrix')
A
disp('Press any key to continue. . .'), pause(0.1)
[m,n] = size(A);

% Compute the default tolerance if none was provided.
if (nargin < 2), tol = max([m,n])*eps*norm(A,'inf'); end

% Loop over the entire matrix.
i = 1;
j = 1;
k = 0;
while (i <= m) & (j <= n)
   % Find value and index of largest element in the remainder of column j.
   [p,k] = max(abs(A(i:m,j))); k = k+i-1;
   if (p <= tol)
      % The column is negligible, zero it out.
      home
      disp(['  column ' int2str(j) ' is negligible'])
      A(i:m,j) = zeros(m-i+1,1)
      disp('Press any key to continue. . .'), pause(0.1)
      j = j + 1;
   else
      if i ~= k
         % Swap i-th and k-th rows.
         home
         disp(['  swap rows ' int2str(i) ' and ' int2str(k) blanks(10)])
         A([i k],:) = A([k i],:)
         disp('Press any key to continue. . .'), pause(0.1)
      end
      % Divide the pivot row by the pivot element.
      home
      disp(['  pivot = A(' int2str(i) ',' int2str(j) ')' blanks(10)])
      A(i,j:n) = A(i,j:n)/A(i,j)
      disp('Press any key to continue. . .'), pause(0.1)
      home
      % Subtract multiples of the pivot row from all the other rows.
      disp(['  eliminate in column ' int2str(j) blanks(10)])
      A
      disp('Press any key to continue. . .'), pause(0.1)
      for k = 1:m
         if k ~= i
            home
            disp(' ')
            A(k,j:n) = A(k,j:n) - A(k,j)*A(i,j:n)
         end
      end
      disp('Press any key to continue. . .'), pause(0.1)
      i = i + 1;
      j = j + 1;
   end
end
%  Restore Format
set(0,'Format',Old_Format)

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $
