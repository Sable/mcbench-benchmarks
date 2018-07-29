function y = shiftu(A,column,shift,type)

%  PURPOSE:
%  --------
%  y = shiftu (A, column, shift) moves #column of matrix A upwards
%                                   by #shift positions.
%
%  INPUT ARGUMENTS:
%  ----------------
%  'A' is the input matrix. ('A' can be a vector)
%
%  'column' is the number of the column to be shifted. If 'column'
%  is zero, then all columns in the matrix are shifted.
%
%  'shift' is the number of positions by which the column is shifted
%  vertically.
%
%  'type' is an optional argument.
%
%         The shifted matrix-elements are discarded if this argument
%         is 0 or is omitted,
%         then vacated spaces on the bottom are filled with zeroes.
%
%         The shifted matrix-elements are retained if 'type' is 1
%         or any other non-zero value,
%         then vacated spaces on the bottom are filled with the
%         shifted column-elements from the top (i.e. "wraparound").
%
%  EXAMPLES:   A = [1 2 3;
%  ---------        4 5 6;
%                   7 8 9]
%
%              y = shiftu(A,0,1)   --> [4 5 6;
%                                       7 8 9;
%                                       0 0 0]
%              y = shiftu(A,2,1)   --> [1 5 3;
%                                       4 8 6;
%                                       7 0 9]
%              y = shiftu(A,2,1,0) --> [1 5 3;
%                                       4 8 6;
%                                       7 0 9]
%              y = shiftu(A,2,1,1) --> [1 5 3;
%                                       4 8 6;
%                                       7 2 9]
%              y = shiftu(A,0,1,1) --> [4 5 6;
%                                       7 8 9;
%                                       1 2 3]
%
%              B = [1;       z = shiftu(B,1,3) --> [4;
%                   2;                              5;
%                   3;                              0;
%                   4;                              0;
%                   5]                              0]
%
%  SEE ALSO:  shiftl, shiftr, shiftd.

[M,N] = size(A);
if column > N | column < 0, error('Invalid Column'); end
if shift < 0, error('Negative shift value - use "shiftd" instead'); end
if shift > M, error('Shift value exceeds number of rows'); end

if column == 0
   if nargin == 4 & type ~= 0
       A = [A(1+shift:M,:); A(1:shift,:)];
   else
       A = [A(1+shift:M,:); zeros(shift,N)];
    end
else
   if nargin == 4 & type ~= 0
      A(:,column) = [A(1+shift:M, column); A(1:shift, column)];
   else
      A(:,column) = [A(1+shift:M, column); zeros(shift,1)];
   end
end
y = A;