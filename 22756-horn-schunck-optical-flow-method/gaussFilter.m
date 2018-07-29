function G=gaussFilter(segma,kSize)
% Creates a 1-D Gaussian kernel of a standard deviation 'segma' and a size
% of 'kSize'. 
%
% In theory, the Gaussian distribution is non-zero everywhere. In practice,
% it's effectively zero at places further away from about three standard
% deviations. Hence the reason why the kernel is suggested to be truncated
% at that point.
%
% The 2D Gaussian filter is a complete circular symmetric operator. It can be
% seperated into x and y components. The 2D convolution can be performed by
% first convolving with 1D Gaussian in the x direction and the same in the
% y direction.
%
% Author: Mohd Kharbat at Cranfield Defence and Security
% mkharbat(at)ieee(dot)org , http://mohd.kharbat.com
% Published under a Creative Commons Attribution-Non-Commercial-Share Alike
% 3.0 Unported Licence http://creativecommons.org/licenses/by-nc-sa/3.0/
%
% October 2008

if nargin<1
    segma=1;
end
if nargin<2
    kSize=2*(segma*3);
end

x=-(kSize/2):(1+1/kSize):(kSize/2);
G=(1/(sqrt(2*pi)*segma)) * exp (-(x.^2)/(2*segma^2));