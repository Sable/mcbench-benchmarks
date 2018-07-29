function [p,f] = filtbank(x,Fs,T,arg4); 
% FILTBANK One-third-octave band frequency analyser. 
%    [P,F] = FILTBANK(X,Fs) computes the one-third-octave spectrum 
%    of X, assuming sampling frequency Fs (in Hz). P is a row vector  
%    containing RMS powers computed for each 1/3-octave band and expressed 
%    in dB with 1 as reference level. F contains the corresponding preferred  
%    labeling frequencies (standard ANSI S1.6-1984). 
%
%    Plots can be obtained, e.g., with BANKDISP. 
%    Example: (spectrum of white noise)
%               X = rand(1,100000); 
%		[P,F] = filtbank(X,44100);
% 		bankdisp(P,F,-40,-20);
%
%    The frequency range covered is the standard 'restricted' audio range:
%    from 100 Hz to 5000 Hz. 
%
%    [P,F] = FILTBANK(X,Fs,T) computes a sequence of one-third-octave 
%    spectra with integration time T (in s). P is a matrix of size
%    (LENGTH(X)/(T*Fs)) x LENGTH(F). If T = [] (default), the integration 
%    time is equal to the length of X. 
%
%    [P,F] = FILTBANK(X,Fs,T,'extended') covers the 'extended' audio range:
%    from 25 Hz to 20 000 Hz. Note that depending on the value of Fs 
%    the frequency range might be automatically reduced. Warnings will be 
%    issued if this is the case. 	
%			
%    See also BANKDISP, LEQ.		 

% Author: Christophe Couvreur, Faculte Polytechnique de Mons (Belgium)
%         couvreur@thor.fpms.ac.be
% Last modification: Aug. 26, 1997, 3:30pm.

% References: 
%    [1] ANSI S1.1-1986 (ASA 65-1986): Specifications for
%        Octave-Band and Fractional-Octave-Band Analog and
%        Digital Filters, Acoustical Society of America, NY, 1993.
%    [2] S. J. Orfanidis, Introduction to Signal Processing, 
%        Prentice Hall, Englewood Cliffs, 1996.

if (nargin < 2) | (nargin > 4)
   error('Invalid number of arguments'); 
end

pi = 3.14159265358979; 
Fref = [ 25 31.5 40, 50 63 80, 100 125 160, 200 250 315, 400 500 630, ... 
         800 1000 1250, 1600 2000 2500, 3150 4000 5000, 6300 8000 10000, ... 
         12500 16000 20000 ];             % Preferred labeling freq. 
Fc = 1000*((2^(1/3)).^[-16:1:13]);        % Exact center freq. 	
N = 3;  				  % Order of analysis filters. 
extended = 0; 
U = 2^(1/3); 

% Integration time. 
if (nargin>=3)
  if isempty(T) 
    T = length(x); 
    P = zeros(1,length(Fref));
  else 					% Convert T to number of samples. 
    T = floor(Fs*T); 
    P = zeros(floor(length(x)/T),length(Fref));
  end
else
    T = length(x); 
    P = zeros(1,length(Fref));
end  
  
if (nargin >= 4)
  if strcmp(lower(arg4),'extended')  % Extended (25 Hz to 20000 Hz)
      extended = 1; 
  end
end

% Frequency range.
if (extended) 				% extended (25 Hz to 20 000 Hz).
  i_up = 30;
  i_low = 1;
else 					% restricted (100 Hz to 5000 Hz).
  i_up = 24; 				
  i_low = 7;
end
  
% Check sampling frequencies and issue warnings.  
if (Fs/2) < Fref(i_low)*1.5 
  error('Sampling frequency Fs too low.'); 
elseif (Fs/2) < Fref(i_up)*1.5
  disp('Warning: frequency range must be reduced (Fs too low).'); 
  i_up = max(find(Fc<=Fs/3));
end
% Compute 'pivot' frequency for multirate filter implementation
% All filters below Fs/20 will be implemented after a decimation. 
if (Fc(i_low) > Fs/20)
  i_dec = 0; 
else
  i_dec = max(find(Fc<=Fs/20)); 
end

% Design filters and compute RMS powers in 1/3-oct. bands.
% Higher frequencies, direct implementation of filters. 
for i = i_up:-1:i_dec+1
  [B,A] = oct3dsgn(Fc(i),Fs,N);
  y = filter(B,A,x); 
  P(:,i) = leq(y,T);
end
% Lower frequencies, decimation by series of 3 bands.
if (i_dec > 0)
  [Bu,Au] = oct3dsgn(Fc(i_dec),Fs/2,N); % Upper 1/3-oct. band in last octave. 
  [Bc,Ac] = oct3dsgn(Fc(i_dec)/U,Fs/2,N); % Center 1/3-oct. band in last octave. 
  [Bl,Al] = oct3dsgn(Fc(i_dec)/(U^2),Fs/2,N); % Lower 1/3-oct. band in last octave. 
  i = i_dec; 
  while  i >= i_low+2
     x = decimate(x,2); 
     T = T/2;
     y = filter(Bu,Au,x); 
     P(:,i) =  leq(y,T);    
     y = filter(Bc,Ac,x); 
     P(:,i-1) =  leq(y,T);    
     y = filter(Bl,Al,x); 
     P(:,i-2) =  leq(y,T); 
     i = i-3; 
  end 
  if (i == (i_low+1))
     x = decimate(x,2); 
     T = T/2;
     y = filter(Bu,Au,x); 
     P(:,i) =  leq(y,T);    
     y = filter(Bc,Ac,x); 
     P(:,i-1) =  leq(y,T);    
  elseif (i == (i_low))
     x = decimate(x,2); 
     T = T/2;
     y = filter(Bu,Au,x); 
     P(:,i) =  leq(y,T);    
  end
end

f = Fref(i_low:i_up);
p = P(:,i_low:i_up);






