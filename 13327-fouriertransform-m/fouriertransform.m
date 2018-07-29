function [rc,ic,Ft] = fouriertransform(x,varargin)  
%FOURIERTRANSFORM   Performs the Fourier Complex Transform of real series.  
%   [RC,IC,Ft] = FOURIERTRANSFORM(X,dT) Performs the Fourier Complex   
%   Transform:  
%                CX(Ft) = RC(Ft) + i*IC(Ft) = COMPLEX(RC,IC) 
%   via Fast Fourier Transform from zero to Nyquist frequencies of the real 
%   time series X taken at sampling interval dT.
%
%   [RC,IC,Ft] = FOURIERTRANSFORM(X,dT,'exp') Performs the Fourier Complex   
%   Transform via complex exponentials (not so fast as FFT).
%
%   [RC,IC,Ft] = FOURIERTRANSFORM(X,dT,'trig') Performs the Fourier Complex   
%   Transform via cosine-sine series (not so fast as FFT).
%
%   Note: because the transform of real series is conjugate even (the real 
%   part even and the imaginary part odd) the output is only for the 
%   positive Fourier frequencies:  
%                        Ft = (0:1/N:1/2)/dT  
%   i.e., from zero to the Nyquist frequency. So, it has floor(N/2)+1 
%   elements, where N = length(X).   
%
%   Note: the whole transform from negative to positive frequencies is  
%        N2 = length(RC);   %   Other ways:    N2 = floor(N/2)+1;  
%        N  = length(X);    %                  N = 2*N2-1-(IC(end)==0);  
%        RC(N2+1:N) =  RC(N-N2+1:-1:2); RC = fftshift(RC);   
%        IC(N2+1:N) = -IC(N-N2+1:-1:2); IC = fftshift(IC);  
%        Ft(N2+1:N) = -Ft(N-N2+1:-1:2); Ft = fftshift(Ft);
%     
%   Note: if the sampling interval is 2 minutes, for example, and the X   
%   units, [X], are meters, then:  
%   a) PERCIVAL & WALDEN (normal usage)  
%       if  dT=120          =>  [RC,IC]=m*sec,   [Ft]=cycle/sec    
%   b) BLOOMFIELD (normalized time interval)  
%       if  dT=1/N          =>  [RC,IC]=m,       [Ft]=1 (adimentional)  
%   c) MATLAB (no dT input) (normalized frequency interval)  
%       if  dT=1 or empty   =>  [RC,IC]=m*2min,  [Ft]=cycle/2min  
%     
%   Note: to get a) from b), multiply RC,IC and divide Ft by the total   
%   sample interval. In this example, Tt = N*120 sec.  
%  
%   Note: the components of the zero frequency are RC(1)=mean(x)*Tt and   
%   IC(1)=0. That's why it is recommended to use X with zero mean, to avoid   
%   a huge peak at this null frequency.    
%  
%   Note: the relation between the complex transform and the Fourier series  
%   (sines and cosines) are:  
%        Tt = N*dT;          % total interval  
%        RC =  (AN/2)*Tt;    % real components  
%        IC = -(BN/2)*Tt;    % imaginary components  
%        RC(1) = RC(1)*2;    % zero component (whole, not half)  
%        if IC(end) == 0     % Nyquist component (whole, not half)  
%         RC(end) = RC(end)*2;     
%        end  
%   The inverses are:  
%        Tt = N*dT;          % total interval  
%        AN =  2*RC/Tt;      % cosine components  
%        BN = -2*IC/Tt;      % sine components  
%        AN(1) = AN(1)/2;    % zero component (single, not double)  
%        if BN(end) == 0     % Nyquist component (single, not double)  
%         AN(end) = AN(end)/2;        
%        end  
%  
%   Note: This program was created for teaching purposes. That's the reason 
%   of the 'exp' and 'trig' methods.  
%  
%   Example:  
%      N = 100; dT = 120; t = (0:N-1)*dT; f1 = 0.0007; f2 = 0.0013;  
%      x = 20*sin(2*pi*f1*t) + 30*cos(2*pi*f2*t) + rand(size(t));  
%      x = x-mean(x);  
%      [rc,ic,Ff] = fouriertransform(x,dT);  
%      subplot(211), plot(t,x), xlabel('time, sec'), ylabel('x, m')  
%      title('Complex Fourier transform example')
%      subplot(212), plot(Ff,rc,Ff,ic,[f1 f2],[0 0],'ro')  
%      xlabel('frequency, cycle/sec'), ylabel('Cx, m sec')  
%      legend('Real part','Imaginary Part','Natural Frequencies',4)
%  
%   See also INVERSEFOURIERTRANSFORM, FFT, IFFT  
  
%   Written by  
%   Lic. on Physics Carlos Adrián Vargas Aguilera  
%   Physical Oceanography MS candidate  
%   UNIVERSIDAD DE GUADALAJARA   
%   Mexico, 2004  
%  
%   nubeobscura@hotmail.com  
  
% Time series information:  
[dT,N,Method] = check_arguments(x,varargin,nargin);  
  
% Complex Fourier transform:
switch lower(Method)
 case 'fft'
  [rc,ic] = fouriertransform_fft(x,dT,N);
 case 'exp'
  [rc,ic] = fouriertransform_exponential(x,dT,N);
 case 'trig'
  [rc,ic] = fouriertransform_trigonometric(x,dT,N); 
 otherwise
  error('Method unknown. Must be one of ''fft'', ''exp'' or ''trig''.')
end
  
% Fourier frequencies:  
Ft = (0:1/N:1/2)/dT;     Ft = reshape(Ft,size(rc));  

% Ensures null Nyquist imaginary component:  
if (ic(end)==0) && rem(N,2)  
 warning('Fourier:Nyquist', ...
  'The last imaginary component is zero but the series is odd.')  
else
 ic(end) = 0;
end  
  

function [rc,ic] = fouriertransform_fft(x,dT,N)  
% Complex Fourier transform via FFT.  
Cx = fft(x)*dT;   Cx = Cx(1:floor(N/2)+1);   
rc = real(Cx);    ic = imag(Cx);              
  
function [rc,ic] = fouriertransform_exponential(xn,dT,N)  
% Complex Fourier transform via complex series.  
n  = 0:N-1;       m  =  n(1:floor(N/2)+1);  
tn = n;           % tn*dT:  time    
fm = m/N;         % fm/dT:  Fourier frequency  
wm = 2*pi*fm;     % angular Fourier frequency  
Cx = zeros(floor(size(xn)/2)+1);  
for m = 1:length(wm)  
 Cx(m) = sum( xn(:) .* exp(-i*wm(m)*tn(:)) ) * dT;  
end  
rc = real(Cx);    ic = imag(Cx);  
  
function [rc,ic] = fouriertransform_trigonometric(xn,dT,N)  
% Complex Fourier transform via cosine-sine series.  
n  = 0:N-1;       m  =  n(1:floor(N/2)+1);  
tn = n;           % tn*dT:  time    
fm = m/N;         % fm/dT:  Fourier frequency  
wm = 2*pi*fm;     % angular Fourier frequency  
am = zeros(floor(size(xn)/2)+1); bm = am;    
am(1) = mean(xn);  
bm(1) = 0;  
for m = 2:length(wm)  
 am(m) = 2 * mean( xn(:) .* cos(wm(m)*tn(:)) );  
 bm(m) = 2 * mean( xn(:) .* sin(wm(m)*tn(:)) );  
end  
if ~rem(N,2)   % even series  
 am(end) = am(end)/2;  
 bm(end) = 0;  
end  
% Translation to complex transform:  
Tt = N*dT;   
rc =  (am/2)*Tt;  
ic = -(bm/2)*Tt;  
rc(1) = rc(1)*2;  
if ic(end) == 0   
 rc(end) = rc(end)*2;     
end  
  
function [dT,N,Method] = check_arguments(x,Ventries,Nentries)  
% Is vector?  
N = length(x);  
if N~=numel(x)  
 error('Entry must be a vector.')  
end  
% Sampling interval?  
dT = 1;           % Default (MATLAB way)
Method = 'fft';   % Default (MATLAB way)
if Nentries > 1
 if ~ischar(Ventries{1})
  dT = Ventries{1};
 else
  Method = Ventries{1};
 end
end
if Nentries > 2
 if ~ischar(Ventries{2})
  dT = Ventries{2};
 else
  Method = Ventries{2};
 end
end
  
  
% Carlos Adrián. nubeobscura@hotmail.com