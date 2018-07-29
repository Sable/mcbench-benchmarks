function out=invzigzag(in,num_rows,num_cols)
% Inverse Zig-zag scanning
% This function reorders a 1-D array into a specifiable
% 2-D matrix by implementing the INVERSE ZIG-ZAG SCNANNING procedure.
% IN specifies the input 1-D array or vector
% NUM_ROWS is the number of rows desired in the output matrix
% NUM_COLS is the number of columns desired in the output matrix
% OUT is the resulting inverse zig-zag scanned matrix
% having the same number of elements as vector IN
%
% As an example,
% IN = [1     2     4     7     5     3     6     8    10    11     9    12];
% OUT = INVZIGZAG(IN,4,3)
% OUT=
%	1     2     3
%	4     5     6
%	7     8     9
%	10    11    12

%
%
% Oluwadamilola (Damie) Martins Ogunbiyi
% University of Maryland, College Park
% Department of Electrical and Computer Engineering
% Communications and Signal Processing
% 22-March-2010
% Copyright 2009-2010 Black Ace of Diamonds.

tot_elem=length(in);

if nargin>3
	error('Too many input arguments');
elseif nargin<3
	error('Too few input arguments');
end

% Check if matrix dimensions correspond
if tot_elem~=num_rows*num_cols
	error('Matrix dimensions do not coincide');
end


% Initialise the output matrix
out=zeros(num_rows,num_cols);

cur_row=1;	cur_col=1;	cur_index=1;

% First element
%out(1,1)=in(1);

while cur_index<=tot_elem
	if cur_row==1 & mod(cur_row+cur_col,2)==0 & cur_col~=num_cols
		out(cur_row,cur_col)=in(cur_index);
		cur_col=cur_col+1;							%move right at the top
		cur_index=cur_index+1;
		
	elseif cur_row==num_rows & mod(cur_row+cur_col,2)~=0 & cur_col~=num_cols
		out(cur_row,cur_col)=in(cur_index);
		cur_col=cur_col+1;							%move right at the bottom
		cur_index=cur_index+1;
		
	elseif cur_col==1 & mod(cur_row+cur_col,2)~=0 & cur_row~=num_rows
		out(cur_row,cur_col)=in(cur_index);
		cur_row=cur_row+1;							%move down at the left
		cur_index=cur_index+1;
		
	elseif cur_col==num_cols & mod(cur_row+cur_col,2)==0 & cur_row~=num_rows
		out(cur_row,cur_col)=in(cur_index);
		cur_row=cur_row+1;							%move down at the right
		cur_index=cur_index+1;
		
	elseif cur_col~=1 & cur_row~=num_rows & mod(cur_row+cur_col,2)~=0
		out(cur_row,cur_col)=in(cur_index);
		cur_row=cur_row+1;		cur_col=cur_col-1;	%move diagonally left down
		cur_index=cur_index+1;
		
	elseif cur_row~=1 & cur_col~=num_cols & mod(cur_row+cur_col,2)==0
		out(cur_row,cur_col)=in(cur_index);
		cur_row=cur_row-1;		cur_col=cur_col+1;	%move diagonally right up
		cur_index=cur_index+1;
		
	elseif cur_index==tot_elem						%input the bottom right element
        out(end)=in(end);							%end of the operation
		break										%terminate the operation
    end
end