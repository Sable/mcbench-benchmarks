function [nx] = normaliz(x)
% Normalize matrix rows dividing by its norm
% 
% [nx] = normaliz(x)
%
% input:
% x (samples x variables)   data to normalize
%
% output:
% nx (samples x variables)  normalized data
%
% By Cleiton A. Nunes
% UFLA,MG,Brazil

[m,n]=size(x);
nx=x;
nm=zeros(m,1);
for i = 1:m
nm(i)=norm(nx(i,:));
nx(i,:)=nx(i,:)/nm(i);
end