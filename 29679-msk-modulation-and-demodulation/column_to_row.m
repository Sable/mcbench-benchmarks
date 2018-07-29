function [ output_matrix ] =column_to_row( input_matrix )
% Converts a column matrix to row matrix
% Ex: [1 2 3 4; 2 3 4 5; 9 8 7 6]
% will be converted to [1 2 3 4 2 3 4 5 9 8 7 6]

[a,b]=size(input_matrix);
count=-b;
for i=1:a
    count=count+b;
    for j=1:b
        op(count+j)=input_matrix(i,j);
    end
end
output_matrix=op;
end
