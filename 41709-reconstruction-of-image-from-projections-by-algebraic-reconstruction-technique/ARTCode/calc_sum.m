function [row_sum,col_sum]=calc_sum(Image,rowsize,z)
col_sum=sum(Image)'/z;
for i=1:rowsize,
row_sum(i)=sum(Image(i,:))/z;
end