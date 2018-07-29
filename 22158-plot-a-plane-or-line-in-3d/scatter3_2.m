function ta = scatter3_2(X,str)
% SCATTER3_2 - scatter plot 3 dimensional data 
% (slight modification of MATLAB's scatter3.m)
%
% First argument - input is an nx3 matrix. output is a scatter plot graph, where each point
% comes from one of the rows of the input matrix. The matrix must have 3
% columns.
%
% Optional second argument - string to determine plotting style, using same
% options as in MATLAB's plot function
%
% EXAMPLE:  >> A = rand(20,3);
%           >> scatter3_2(A);
%

% Motivation: MATLAB's scatter3 requires 3 column vectors, eg, scatter3(x,y,z), where
% each 'row' of (x,y,z) coordinates is plotted. We would instead like to be
% able to just input one nx3 matrix. It will have n points to plot, and
% each point is found in each row. The columns do not need to be separated
% into three different arguments.


if nargin<2
    str='b';
end


scatter3(X(:,1),X(:,2),X(:,3),str);

