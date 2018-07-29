function [g,f] = oct3spec(B,A,Fs,Fc,s,n); 
% OCT3SPEC Plots a one-third-octave filter characteristics. 
%    OCT3SPEC(B,A,Fs,Fc) plots the attenuation of the filter defined by 
%    B and A at sampling frequency Fs. Fc is the center frequency of 
%    the one-third-octave filter. The plot covers one decade on both sides 
%    of Fc.
%
%    OCT3SPEC(B,A,Fs,Fc,'ANSI',N) superposes the ANSI Order-N analog
%    specification for comparison. Default is N = 3.
%
%    OCT3SPEC(B,A,Fs,Fc,'IEC',N) superposes the characteristics of the 
%    IEC 61260 class N specification for comparison. Default is N = 1. 
%
%    [G,F] = OCT3SPEC(B,A,Fs,Fc) returns two 512-point vectors with 
%    the gain (in dB) in G and logarithmically spaced frequencies in F. 
%    The plot can then be obtained by SEMILOGX(F,G) 
% 					
%    See also OCT3DSGN, OCTSPEC, OCTDSGN.

% Author: Christophe Couvreur, Faculte Polytechnique de Mons (Belgium)
%         couvreur@thor.fpms.ac.be
% Last modification: Sept. 4, 1997, 11:00am.

% References: 
%    [1] ANSI S1.1-1986 (ASA 65-1986): Specifications for
%        Octave-Band and Fractional-Octave-Band Analog and
%        Digital Filters, 1993.
%    [2] IEC 61260 (1995-08):  Electroacoustics -- Octave-Band and 
%        Fractional-Octave-Band Filters, 1995.    

if (nargin < 4) | (nargin > 6)  
  error('Invalide number of input arguments.');
end

ansi = 0; 
iec = 0; 
if nargin > 4 
  if strcmp(lower(s),'ansi')
    ansi = 1; 
    if nargin == 5
      n = 3; 
    end
  elseif strcmp(lower(s),'cei') | strcmp(lower(s),'iec')
    iec = 1; 
     if nargin == 5
      n = 1
    end
    if (n < 0) | (n > 3) 
      error('IEC class must be 0, 1, or 2');
    end
  end
end

N = 512; 
pi = 3.14159265358979; 
F = logspace(log10(Fc/10),log10(min(Fc*10,Fs/2)),N);
H = freqz(B,A,2*pi*F/Fs);
G = 20*log10(abs(H));

% Set output variables
if nargout ~= 0
  g = G; f = F; 
  return
end

% Generate the plot
if (ansi) 				% ANSI Order-n specification
  f = logspace(log10(Fc/10),log10(Fc*10),N);
  f1 = Fc/(2^(1/6)); 
  f2 = Fc*(2^(1/6)); 
  Qr = Fc/(f2-f1); 
  Qd = (pi/2/n)/(sin(pi/2/n))*Qr; 
  Af = 10*log10(1+Qd^(2*n)*((f/Fc)-(Fc./f)).^(2*n));
  semilogx(F,G,f,-Af,'--');
  legend('Filter',['ANSI order-' int2str(n)],0);
elseif (iec) 					% CEI specification
  semilogx(F,G);
  hold on
  if n == 0 
    tolup =  [ .15 .15 .15 .15 .15 -2.3 -18.0 -42.5 -62 -75 -75 ];
    tollow = [ -.15 -.2 -.4 -1.1 -4.5 -realmax -inf -inf -inf -inf -inf ];
  elseif n == 1
    tolup =  [ .3 .3 .3 .3 .3 -2 -17.5 -42 -61 -70 -70 ];
    tollow = [ -.3 -.4 -.6 -1.3 -5 -realmax -inf -inf -inf -inf -inf ];
  elseif n == 2
    tolup =  [ .5 .5 .5 .5 .5 -1.6 -16.5 -41 -55 -60 -60  ];
    tollow = [ -.5 -.6 -.8 -1.6 -5.5 -realmax -inf -inf -inf -inf -inf ];
  end
  % Reference frequencies in base 2 system 
  f = Fc * [1 1.02676 1.05594 1.08776 1.12246 1.12246 1.29565 1.88695 ... 
	  3.06955 5.43474 NaN ];   
  f(length(f)) = realmax; 
  ff = Fc * [1 0.97394 0.94702 0.91932 0.89090 0.89090 0.77181 0.52996 ...
	  0.32578 0.18400 NaN ];   
  ff(length(ff)) = realmin; 
  semilogx(F,G,f,tolup,'--');
  semilogx(F,G,f,tollow,'--');
  semilogx(F,G,ff,tolup,'--');
  semilogx(F,G,ff,tollow,'--');
  hold off
  legend('Filter',['IEC class ' int2str(n)],0); 
else
  semilogx(F,G); 
end
xlabel('Frequency [Hz]'); ylabel('Gain [dB]');
title(['One-third-octave filter: Fc =',int2str(Fc),' Hz, Fs = ',int2str(Fs),' Hz']);
axis([Fc/10 Fc*10 -80 5]);
grid on







