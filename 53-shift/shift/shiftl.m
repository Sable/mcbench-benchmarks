function y = shiftl(A,row,shift,type)

%  PURPOSE:
%  --------
%  y = shiftl (A, row, shift) moves #row of matrix A to the left 
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
%         then vacated spaces to the right are filled with zeros.
%  
%         The shifted matrix-elements are retained if 'type' is 1 
%         or any other non-zero value,
%         then vacated spaces to the right are filled with the shifted
%         row-elements from the left (i.e. "wraparound").
%
%  EXAMPLES:   A = [1 2 3 4 5;
%  ---------        6 7 8 9 0]
%
%              y = shiftl(A,0,2)   --> [3 4 5 0 0;
%                                       8 9 0 0 0]
%              y = shiftl(A,1,2)   --> [3 4 5 0 0;
%                                       6 7 8 9 0]
%              y = shiftl(A,1,2,0) --> [3 4 5 0 0;
%                                       6 7 8 9 0]
%              y = shiftl(A,1,2,1) --> [3 4 5 1 2;
%                                       6 7 8 9 0]
%              y = shiftl(A,0,2,1) --> [3 4 5 1 2;
%                                       8 9 0 6 7]
%              B = [1 2 3 4 5]
% 
%              z = shiftl(B,1,3)   --> [4 5 0 0 0]
%
%  SEE ALSO:  shiftr, shiftu, shiftd.

[M,N] = size(A);
if row > M | row < 0, error('Invalid Row'); end
if shift < 0, error('Negative shift value - use "shiftr" instead'); end
if shift > N, error('Shift value exceeds number of columns'); end

if row == 0
   if nargin == 4 & type ~= 0
      A = [A(:,1+shift:N) A(:,1:shift)];
   else
      A = [A(:,1+shift:N) zeros(M,shift)];
   end
else
   if nargin == 4 & type ~= 0
      A(row,:) = [A(row,1+shift:N) A(row,1:shift)]; 
   else
      A(row,:) = [A(row,1+shift:N) zeros(1,shift)];
   end
end
y = A;