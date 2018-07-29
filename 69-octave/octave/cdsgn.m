function [B,A] = cdsgn(Fs); 
% CDSGN  Design of a A-weighting filter.
%    [B,A] = CDSGN(Fs) designs a digital A-weighting filter for 
%    sampling frequency Fs. Usage: Y = FILTER(B,A,X). 
%    Warning: Fs should normally be higher than 20 kHz. For example, 
%    Fs = 48000 yields a class 1-compliant filter.
%
%    Requires the Signal Processing Toolbox. 
%
%    See also CSPEC, ADSGN, ASPEC. 

% Author: Christophe Couvreur, Faculte Polytechnique de Mons (Belgium)
%         couvreur@thor.fpms.ac.be
% Last modification: Aug. 20, 1997, 10:10am.

% References: 
%    [1] IEC/CD 1672: Electroacoustics-Sound Level Meters, Nov. 1996. 


% Definition of analog C-weighting filter according to IEC/CD 1672.
f1 = 20.598997; 
f4 = 12194.217;
C1000 = 0.0619;
pi = 3.14159265358979;
NUMs = [ (2*pi*f4)^2*(10^(C1000/20)) 0 0 ];
DENs = conv([1 +4*pi*f4 (2*pi*f4)^2],[1 +4*pi*f1 (2*pi*f1)^2]); 

% Use the bilinear transformation to get the digital filter. 
[B,A] = bilinear(NUMs,DENs,Fs); 

