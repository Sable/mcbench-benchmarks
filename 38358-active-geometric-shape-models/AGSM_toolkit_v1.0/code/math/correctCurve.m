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

function R=correctCurve(r,sigma,iter)
%%  correct for the radius of curvature
%   r: detected radius
%   R: corrected radius
%   sigma: std of Gaussian PSF
%   iter: number of iterations

R=r;
for it=1:iter
    x=r*R/(sigma^2);
    if x<100
        R=(r+sigma^2/r)*besseli(1,x)/besseli(0,x);
    else
        R=(r+sigma^2/r)*(128*x*x-48*x-15)/(128*x*x+16*x+9);
    end
end