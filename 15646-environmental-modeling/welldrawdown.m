function welldrawdown
% Well drawdown - comparison for confined / half-confined / unconfined
% aquifers
%    using analytocal solutions                   
%
%   $Ekkehard Holzbecher  $Date: 2006/04/30 $
%--------------------------------------------------------------------------
K = 1.1e-5;            % hydraulic conductivity
H = 10;                % depth
T = K*H;               % transmissivity
Q = 1.e-4;             % pumping rate
r0 = 0.1;              % well radius
s0 = -1.               % drawdown in well
c = 0.8e8;             % resistance of half-permeable layer
R = 35;                % maximum radius

r = linspace (r0,R,100); 
hc = s0 + (Q/(2*pi*T))*log(r/r0);  
hu = -H + s0 + sqrt(H*H + (Q/(pi*K))*log(r/r0)); 
hh = -(Q/(2*pi*T))*besselk(0,r/sqrt(T*c));  

plot (r,hc,r,hh,r,hu);
legend ('confined','half-confined','unconfined')
xlabel ('distance [m]'); ylabel ('drawdown (neg) [m]');
title('Groundwater Drawdown due to Pumping')