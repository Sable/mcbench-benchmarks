function [ column_mat ] = row_to_column( row_mat,length_row )
% clc;clear all;close all;
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% row_mat=[1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 0 1];
% 
% length_row=2;
n=0;
row_mat_length=length(row_mat);
a=0;
col=0;
n=row_mat_length/length_row;

for i=1:n
    for j=1:length_row
        col(i,j)=row_mat(1,a+j);
    end
    a=a+j;
end
column_mat=col;

end

