function cspec(B,A,Fs); 
% CSPEC  Plots a filter characteristics vs. C-weighting specifications. 
%    CSPEC(B,A,Fs) plots the attenuation of the filter defined by B and A 
%    with sampling frequency Fs against the specifications for class 1 and 
%    class 2 C-weighting filters. 
%
%    See also CDSGN, ADSGN, ASPEC. 

% Author: Christophe Couvreur, Faculte Polytechnique de Mons (Belgium)
%         couvreur@thor.fpms.ac.be
% Last modification: Aug. 26, 1997, 10:00am.

% References: 
%    [1] IEC/CD 1672: Electroacoustics-Sound Level Meters, Nov. 1996. 


if (nargin ~= 3) 
  error('Invalide number of arguments.');
end

N = 512; 
W = 2*pi*logspace(log10(10),log10(Fs/2),N);
H = freqz(B,A,W/Fs);
fref = [10, 12.5 16 20, 25 31.5 40, 50 63 80, 100 125 160, 200 250 315, ...
    400 500 630, 800 1000 1250, 1600 2000 2500, 3150 4000 5000, ...
	6300 8000 10000, 12500 16000 20000 ];
Cgoal = [ -14.3, -11.2 -8.5 -6.2, -4.4 -3.0 -2.0, -1.3 -.8 -.5, ...
    -.3 -.2 -.1, 0 0 0, 0 0 0, 0 0 0, -.1 -.2 -.3, -.5 -.8 -1.3, ...
    -2.0 -3.0 -4.4, -6.2 -8.5 -11.2 ];
up1 = [ 3, .25 2 2, 2 1.5 1, 1 1 1, 1 1 1, 1 1 1, 1 1 1, 1 0.7 1, ...
	1 1 1, 1 1 1.5, 1.5 1.5 2, 2 2.5 3 ];
low1 = [ inf, inf 4 2, 1.5 1.5 1, 1 1 1, 1 1 1, 1 1 1, 1 1 1, 1 0.7 1, ...
	1 1 1, 1 1 1.5, 2 2.5 3, 5 8 inf ];
up2 = [ 5, 5 5 3, 3 3 2, 2 2 2, 1.5 1.5 1.5, 1.5 1.5 1.5, 1.5 1.5 1.5, ...
	1.5 1 1.5, 2 2 2.5, 2.5 3 3.5, 4.5 5 5, 5 5 5 ];
low2 = [ inf, inf inf 3, 3 3 2, 2 2 2, 1.5 1.5 1.5, 1.5 1.5 1.5, ...
    1.5 1.5 1.5, 1.5 1 1.5, 2,2 2.5, 2.5 3 3.5, 4.5 5 inf, inf inf inf ];
clf;
semilogx(W/2/pi,20*log10(abs(H)),'-',fref,Cgoal+up1,'--',fref,Cgoal+up2,':'); 
hold on 
semilogx(W/2/pi,20*log10(abs(H)),'-',fref,Cgoal-low1,'--',fref,Cgoal-low2,':'); 
hold off
xlabel('Frequency [Hz]'); ylabel('Gain [dB]');
title(['C-weighting, Fs = ',int2str(Fs),' Hz']);
axis([fref(1) max(fref(34),Fs/2) -20 5]);
legend('Filter','Class 1','Class 2',0); 


