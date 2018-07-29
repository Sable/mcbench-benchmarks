% GABORFILTER Bi-dimensional Gabor filter with DC component compensation.
%   [G,GABOUT]=GABORFILTER(I,S,F,W,P) filters the input image I with the 2D
%   Gabor filter G described by the parameters S, F, W and P to create the 
%   output filtered image GABOUT.
%   This version of the 2D Gabor filter is basically a bi-dimensional 
%   Gaussian function centered at origin (0,0) with variance S modulated by
%   a complex sinusoid with polar frequency (F,W) and phase P described by 
%   the following equation:
%
%   G(x,y,S,F,W,P)=k*Gaussian(x,y,S)*(Sinusoid(x,y,F,W,P)-DC(F,S,P)),
%   where:                        
%       Gaussian(x,y,S)=exp(-pi*S^2*(x^2+y^2))
%       Sinusoid(x,y,F,W,P)=exp(j*(2*pi*F*(x*cos(W)+y*sin(W))+P)))
%       DC(F,S,P)=exp(-pi*(F/S)^2+j*P)
%
%   PS: The term DC(F,S,P) compensates the inherent DC component produced 
%   by the Gaussian envelop as shown by Movellan in [1].
%
%	Tips:
%       1) To get the real part and the imaginary part of the complex 
%       filter output use real(gabout) and imag(gabout), respectively;
% 
%       2) To get the magnitude and the phase of the complex filter output 
%       use abs(gabout) and angle(gabout), respectively.

%	Author: Stiven Schwanz Dias e-mail: stivendias@gmail.com
%           Cognition Science Group, Informatic Department,
%           University of Espírito Santo, Brazil, January 2007.
%
%   References:
%       [1] Movellan, J. R. - Tutorial on Gabor Filters. Tech. rep., 2002.

function [G,GABOUT]=gaborfilter(I,S,F,W,P);

if isa(I,'double')~=1
    I=double(I);
end
size=fix(1.5/S); % exp(-1.5^2*pi) < 0.1%
%k=2*pi*S^2;
%F=S^2/sqrt(2*pi);
k=1;
for x=-size:size
    for y=-size:size
        G(size+x+1,size+y+1)=k*exp(-pi*S^2*(x*x+y*y))*...
            (exp(j*(2*pi*F*(x*cos(W)+y*sin(W))+P))-exp(-pi*(F/S)^2+j*P));
    end
end

GABOUT=conv2(I,double(G),'same');
