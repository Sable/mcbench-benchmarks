function y = shiftr(A,row,shift,type)

%  PURPOSE:
%  --------
%  y = shiftr (A, row, shift) moves #row of matrix A to the right
%                                by #shift positions. 
%
%  INPUT ARGUMENTS:
%  ----------------
%  'A' is the input matrix. ('A' can be a vector)
%
%  'row' is the number of the row to be shifted. If 'row' is zero,
%  then all rows in the matrix are shifted.
%
%  'shift' is the number of positions by which the row is shifted
%  to the right.
%
%  'type' is an optional argument.
%
%         The shifted matrix-elements are discarded if this argument 
%         is 0 or is omitted,
%         then vacated spaces to the left are filled with zeroes.
%  
%         The shifted matrix-elements are retained if 'type' is 1 
%         or any other non-zero value,
%         then vacated spaces to the left are filled with the shifted
%         row-elements from the right (i.e. "wraparound").
%
%  EXAMPLES:   A = [1 2 3 4 5;
%  ---------        6 7 8 9 0]
%
%              y = shiftr(A,0,2)   --> [0 0 1 2 3;
%                                       0 0 6 7 8]
%              y = shiftr(A,1,2)   --> [0 0 1 2 3;
%                                       6 7 8 9 0]
%              y = shiftr(A,1,2,0) --> [0 0 1 2 3;
%                                       6 7 8 9 0]
%              y = shiftr(A,1,2,1) --> [4 5 1 2 3;
%                                       6 7 8 9 0]
%              y = shiftr(A,0,2,1) --> [4 5 1 2 3;
%                                       9 0 6 7 8]
%              B = [1 2 3 4 5]
%
%              z = shiftr(B,1,3)   --> [0 0 0 1 2]
%
%  SEE ALSO:  shiftl, shiftu, shiftd.

[M,N] = size(A);
if row > M | row < 0, error('Invalid Row'); end
if shift < 0, error('Negative shift value - use "shiftl" instead'); end
if shift > N, error('Shift value exceeds number of columns'); end

if row == 0
   if nargin == 4 & type ~= 0
      A = [A(:,N-shift+1:N)  A(:,1:N-shift)];
   else
      A = [zeros(M,shift) A(:,1:N-shift)];
   end
else
   if nargin == 4 & type ~= 0
      A(row,:) = [A(row,N-shift+1:N)  A(row,1:N-shift)];
   else
      A(row,:) = [zeros(1,shift) A(row,1:N-shift)];
   end
end
y = A;