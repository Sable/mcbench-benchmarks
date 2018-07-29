%Function F(theta,phi)
%
% Recommended equation for the pattern of a rectangular flat array where:
% 
% f1 is the pattern of a single element in the array 1 for isotropic
% N is the number of array elements in the X-Axis
% M is the number of array elements in the Y-Axis
% freq is the operation frequency use to calculate lamda
% lamda is the operation wavelength
% beta is a function of lamda
% d1 is the distance between the array elements in the X-axis
% d2 is the distance between the array elements in the Y-axis
% squiggleC1 is drive currents phase displacement between adjacent elements in the X-axis
% squiggleC2 is drive currents phase displacement between adjacent elements in the y-axis

function F = F(theta,phi)
if theta == 0
    theta = 0.0001;
end
theta = pi/2 + - theta;         % 90 - reference from x plane 
if phi == 0
    phi = 0.0001;
end
f1 = 1;                     %f1 is the pattern of a single element in the array 1 for isotropic
N = 5;                     %N is the number of array elements in the X-Axis
M = 5;                     %M is the number of array elements in the Y-Axis
freq = 150*10^6;            %freq is the operation frequency use to calculate lamda
lamda = 299792458 / freq;   %lamda is the operation wavelength
beta = 2*pi/lamda;          %beta is a function of lamda
d1 = lamda/2;                     %d1 is the distance between the array elements in the X-axis
d2 = lamda/2;                     %d2 is the distance between the array elements in the Y-axis
squiggleC1 = 0;             %squiggleC1 is drive currents phase displacement between adjacent elements in the X-axis
squiggleC2 = 0;             %squiggleC2 is drive currents phase displacement between adjacent elements in the y-axis
F = f1.*sin(N./2.*beta.*d1.*sin(theta).*cos(phi-squiggleC1)).*sin(M./2.*beta.*d2.*sin(theta).*sin(phi-squiggleC2))./sin(1./2.*beta.*d1.*sin(theta).*cos(phi-squiggleC1))./sin(1./2.*beta.*d2.*sin(theta).*sin(phi-squiggleC2));