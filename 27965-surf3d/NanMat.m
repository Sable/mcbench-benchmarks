% Surround matrix with NaNs
function [R]=NanMat(Data,GridSize,varargin)  
%Input = Data: a m*n matrix 
% GridSize: Optional, only needed if data is entered as a list
%           a 1x2 vector of size of original grid. (npx,npy)
%output = R: a m+2*n+2 matrix in which Data is preserved and surrounded by
%NaN's

%Reshape the data list to a grid
if (length(varargin) == 2)
L = reshape (Data,GridSize(1),GridSize(2));
else
    L = Data;
end
% create a matrix sames size as L but with 2 extra rows and columns, and
% fill it with NaN
R=zeros((size(L,1)+2),(size(L,2)+2))*NaN;
%Insert L into middle of matrix
R(2:end-1,2:end-1)= L;
end