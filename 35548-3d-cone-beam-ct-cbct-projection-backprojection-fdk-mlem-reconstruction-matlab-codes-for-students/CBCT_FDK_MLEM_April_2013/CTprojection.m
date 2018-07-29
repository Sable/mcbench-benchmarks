function [ proj ] = CTprojection( img, param )
%CTPROJECTION Summary of this function goes here
%   Detailed explanation goes here

proj = zeros(param.nu, param.nv, param.nProj,'single');

for i = 1:param.nProj
    angle_rad = param.deg(i)/360*2*pi;
    proj(:,:,i) = projection(img,param,angle_rad);
end
    
end

