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

function GI = gaussianBlur(I,s)
%%  perform Gaussian blur
%   I: input image
%   s: standard deviation
%   GI: blurred image

M = gaussianMask(1,s);
if max(size(M))==0
    GI=I;
    return;
end
M = M/sum(sum(M));   % normalize the gaussian mask
GI=I;
for i=1:(2*s+1)
    GI=BoundMirrorExpand(GI);
end
GI = conv2(GI,M,'same');
for i=1:(2*s+1)
    GI=BoundMirrorShrink(GI);
end
