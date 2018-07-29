function index = find_index(num,table)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%       Name: find_index.m                                              %
%%                                                                       %
%%       Description: It receives a table and a number to look for in    %
%%        first column.                                                  %
%%                                                                       %
%%       Result: It gives back the corresponding value of the second     %
%%        column.                                                        %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim = size(table);
num_col = dim(1);

for i=1:num_col
    if num==table(i,1);
        index = table(i,2);
        return
    end
end