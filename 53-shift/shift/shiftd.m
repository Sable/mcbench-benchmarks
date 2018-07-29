function y = shiftd(A,column,shift,type)

%  PURPOSE:
%  --------
%  y = shiftd (A, column, shift) moves #column of matrix A downwards
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
%  downwards.
%
%  'type' is an optional argument.
%
%         The shifted matrix-elements are discarded if this argument
%         is 0 or is omitted,
%         then vacated spaces at the top are filled with zeroes.
%
%         The shifted matrix-elements are retained if 'type' is 1
%         or any other non-zero value,
%         then vacated spaces at the top are filled with the
%         shifted column-elements from the bottom (i.e. "wraparound").
%
%  EXAMPLES:   A = [1 2 3;
%                   4 5 6;
%                   7 8 9]
%              y = shiftd(A,0,1)   --> [0 0 0;
%                                       1 2 3;
%                                       4 5 6]
%              y = shiftd(A,2,1)   --> [1 0 3;
%                                       4 2 6;
%                                       7 5 9]
%              y = shiftd(A,2,1,0) --> [1 0 3;
%                                       4 2 6;
%                                       7 5 9]
%              y = shiftd(A,2,1,1) --> [1 8 3;
%                                       4 2 6;
%                                       7 5 9]
%              y = shiftd(A,0,1,1) --> [7 8 9;
%                                       1 2 3;
%                                       4 5 6]
%             
%              B = [1;       z = shiftd(B,1,3) --> [0;
%                   2;                              0;
%                   3;                              0;
%                   4;                              1;
%                   5]                              2]
%
%  SEE ALSO:  shiftl, shiftr, shiftu.

[M,N] = size(A);
if column > N | column < 0, error('Invalid Column'); end
if shift < 0, error('Negative shift value - use "shiftu" instead'); end
if shift > M, error('Shift value exceeds number of rows'); end

if column == 0
   if nargin == 4 & type ~= 0
      A = [A(M-shift+1:M,:); A(1:M-shift,:)];
   else
      A = [zeros(shift,N); A(1:M-shift,:)];
   end
else
   if nargin == 4 & type ~= 0
      A(:,column) = [A(M-shift+1:M,column); A(1:M-shift,column)];
   else
      A(:,column) = [zeros(shift,1); A(1:M-shift,column)];
   end
end
y = A;
