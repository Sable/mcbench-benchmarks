function y = snakeindex(IDX)
% SNAKEINDEX  Create index for adpative interpolating the snake 
%     y = snakeindex(IDX)
%

N = length(IDX);
y=1:0.5:N+0.5;
x=1:N;
y(2*x(IDX==0))=[];
