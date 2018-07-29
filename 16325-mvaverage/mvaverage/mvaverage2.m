function y=mvaverage2(x,R,C)

%MVAVERAGE2   Smooths a matrix through the moving average method.
%   Y = MVAVERAGE2(X,F,G) quickly smooths a 2-D signal X via averaging 
%   each sampling point with their surrounding samples that fit in a
%   submatrix (2R+1)x(2C+1).  
%
%   Y = MVAVERAGE(X,R), uses R=C.
%
%   Y = MVAVERAGE(X), uses R=C=1 by default, it means a 3x3 box.
%
%   Example (from M.S. Carlos Adrián Vargas Aguilera)
%      [X,Y] = meshgrid(-2:.2:2,3:-.2:-2);
%      Zi = 5*X.*exp(-X.^2-Y.^2); 
%      Zr = Zi + rand(size(Zi));
%      Zs = mvaverage2(Zr,2,3);
%       subplot(131), surf(X,Y,Zi) 
%       view(2), shading interp, xlabel('Z')
%       subplot(132), surf(X,Y,Zr)
%       view(2), shading interp, xlabel('Z + noise')
%       subplot(133), surf(X,Y,Zs)
%       view(2), shading interp, xlabel('Z smoothed')
%
%   See also MVAVERAGE and MVAVERAGEC

%   by Yi Cao
%   Cranfield University
%   11-09-2007
%   y.cao@cranfield.ac.uk
%

if nargin==1
    R=1;
    C=1;
elseif nargin==2
    C=R;
end
R2=2*R+1;
C2=2*C+1;
N=R2*C2;
M=ones(R2,C2)/N;
y=filter2(M,x);