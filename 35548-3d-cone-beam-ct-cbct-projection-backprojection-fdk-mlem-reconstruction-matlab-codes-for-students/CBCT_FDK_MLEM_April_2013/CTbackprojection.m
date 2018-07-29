function [ img ] = CTbackprojection( proj, param )
%CTBACKPROJECTION Summary of this function goes here
%   Detailed explanation goes here

img = zeros(param.nx, param.ny, param.nz, 'single');

for i = 1:param.nProj
    angle_rad = param.deg(i)/360*2*pi;
    img = img + backprojection(proj(:,:,i),param,angle_rad);
end


end

