% Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
% 
% You are free to use this software for academic purposes if you cite our paper: 
% Quan Wang, Kim L. Boyer, 
% The active geometric shape model: A new robust deformable shape model and its applications, 
% Computer Vision and Image Understanding, Volume 116, Issue 12, December 2012, Pages 1178-1194, 
% ISSN 1077-3142, 10.1016/j.cviu.2012.08.004. 
% 
% For commercial use, please contact the authors. 

function M = gaussianMask(k,s)
%%  generate Gaussian mask
%   k: the scaling factor
%   s: standard variance
%   M: mask

M=[];
if s==0
    M=1;
    return;
end
R = ceil(3*s); % cutoff radius of the gaussian kernal  
for i = -R:R,
    for j = -R:R,
        M(i+R+1,j+R+1) = k * exp(-(i*i+j*j)/2/s/s)/(2*pi*s*s);
    end
end

