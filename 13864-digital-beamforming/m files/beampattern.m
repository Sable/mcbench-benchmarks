function beampattern(N,d,w,steer_angle)
% beampattern(N,d,w,steer_angle)
% where:
% N = NO. OF ELEMENTS
% d = INTER-ELEMENT SPACINGS B/W ELEMENTS
% w = WEIGHTINGS
% steer_angle = STEERING ANGLE FOR BEAM PATTERN
% By: Muhammad Fahad
% 2005-MS-E-EE-38
if nargin < 4, steer_angle = 0; end    % for no steering direction
if nargin < 3, w = 1/N*ones(1,N); end   % for uniform linear arrays
if nargin < 2, d = 1/2; end   % for standard linear array

n = (-(N-1)/2:(N-1)/2).'; 
theta = pi*(-1:0.001:1);
u = cos(theta);
vv = exp(j*2*pi*d*n*u);
theta_T = steer_angle/180*pi;
ut=cos(theta_T);
W = w.*exp(j*n*pi*cos(theta_T))';
B = W*vv;
B = 10*log10(abs(B).^2);
figure
polardb(theta,B,-40)
return