%% Gabor Filter Design by Dzhg www.jxdw.com
%% Here Gabor parameters 1. 2*pi*f = w£»2. w = 2*pi/s; 3. f = 1/s; 
%% 4.sigma = Sx = Sy = 2/w = s/pi 

function [G,gabout] = gabordzhg(I,Sx,Sy,f,theta)

for x = -fix(Sx):fix(Sx)
    for y = -fix(Sy):fix(Sy)
        M = cos(2*pi*f*(x*cos(theta)+y*sin(theta)));
        G(fix(Sx)+x+1,fix(Sy)+y+1) = (1/(2*pi*Sx*Sy)) * exp(-.5*((x/Sx)^2+(y/Sy)^2))*M;
    end
end

if isa(I,'double')~=1 
    I = double(I);
end

Imgabout = conv2(I,double(imag(G)),'same');
Regabout = conv2(I,double(real(G)),'same');

gabout = sqrt(Imgabout.*Imgabout + Regabout.*Regabout);