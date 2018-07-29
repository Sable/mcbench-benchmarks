function out=zigzag(in)
% Zig-zag scanning
% This function is used to rearrange a matrix of any size into a 1-D array
% by implementing the ZIG-ZAG SCANNING procedure.
% IN specifies the input matrix of any size
% OUT is the resulting zig-zag scanned (1-D) vector
% having length equal to the total number of elements in the 2-D input matrix
%
% As an example,
% IN = [1	2	6	7
%		3	5	8	11
%		4	9	10	12];
% OUT = ZIGZAG(IN)
% OUT=
%	1     2     3     4     5     6     7     8     9    10    11    12

%
%
% Oluwadamilola (Damie) Martins Ogunbiyi
% University of Maryland, College Park
% Department of Electrical and Computer Engineering
% Communications and Signal Processing
% 22-March-2010
% Copyright 2009-2010 Black Ace of Diamonds.

[num_rows num_cols]=size(in);

% Initialise the output vector
out=zeros(1,num_rows*num_cols);

cur_row=1;	cur_col=1;	cur_index=1;

% First element
%out(1)=in(1,1);

while cur_row<=num_rows & cur_col<=num_cols
	if cur_row==1 & mod(cur_row+cur_col,2)==0 & cur_col~=num_cols
		out(cur_index)=in(cur_row,cur_col);
		cur_col=cur_col+1;							%move right at the top
		cur_index=cur_index+1;
		
	elseif cur_row==num_rows & mod(cur_row+cur_col,2)~=0 & cur_col~=num_cols
		out(cur_index)=in(cur_row,cur_col);
		cur_col=cur_col+1;							%move right at the bottom
		cur_index=cur_index+1;
		
	elseif cur_col==1 & mod(cur_row+cur_col,2)~=0 & cur_row~=num_rows
		out(cur_index)=in(cur_row,cur_col);
		cur_row=cur_row+1;							%move down at the left
		cur_index=cur_index+1;
		
	elseif cur_col==num_cols & mod(cur_row+cur_col,2)==0 & cur_row~=num_rows
		out(cur_index)=in(cur_row,cur_col);
		cur_row=cur_row+1;							%move down at the right
		cur_index=cur_index+1;
		
	elseif cur_col~=1 & cur_row~=num_rows & mod(cur_row+cur_col,2)~=0
		out(cur_index)=in(cur_row,cur_col);
		cur_row=cur_row+1;		cur_col=cur_col-1;	%move diagonally left down
		cur_index=cur_index+1;
		
	elseif cur_row~=1 & cur_col~=num_cols & mod(cur_row+cur_col,2)==0
		out(cur_index)=in(cur_row,cur_col);
		cur_row=cur_row-1;		cur_col=cur_col+1;	%move diagonally right up
		cur_index=cur_index+1;
		
	elseif cur_row==num_rows & cur_col==num_cols	%obtain the bottom right element
        out(end)=in(end);							%end of the operation
		break										%terminate the operation
    end
end