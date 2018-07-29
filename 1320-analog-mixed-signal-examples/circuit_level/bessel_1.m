% maximally flat delay LC filter pp 323 A. I. Zveref 
% Copyright 2004-2013 The MathWorks, Inc.
R=8;      % load resistance
fc=80e3;  % bandpass corner

w=2*pi*fc;

c1=1.5012; l2=0.978; c3=.612;l4=.211;  % Rs=inf,  Rl = 1  
% scale for freq and impedance ...
C1=c1/(R*w)
L2=l2*R/w
C3=c3/(R*w)
L4=l4*R/w
