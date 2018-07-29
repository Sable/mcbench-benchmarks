function [y,coef,window,Cx,Ff] = lanczosfilter(x,varargin)
%LANCZOSFILTER   Filters a time series via Lanczos method (cosine filter).  
%   [Y,coef,window,Cx,Ff] = LANCZOSFILTER(X,dT,Cf,M,pass) Filters the time
%   series via the Lanczos filter in the frequency space (FFT), where
%
%   INPUTS:
%      X    - Time series
%      dT   - Sampling interval       (default: 1)
%      Cf   - Cut-off frequency       (default: half Nyquist)
%      M    - Number of coefficients  (default: 100)
%      pass - Low or high-pass filter (default: 'low')
%
%   OUTPUTS:
%      Y      - Filtered time series
%      coef   - Coefficients of the time window (cosine)
%      window - Frequency window (aprox. ones for Ff lower(greater) than Fc 
%               if low(high)-pass filter and ceros otherwise)
%      Cx     - Complex Fourier Transform of X for Ff frequencies
%      Ff     - Fourier frequencies, from 0 to the Nyquist frequency.
%  
%   The program removes from the time series the frequencies greater than   
%   the cut off frequency if "pass" is 'low', i.e., low-pass filter .
%   Otherwise, if pass is 'high', frequencies from zero to Cf are removed,
%   i.e., a high-pass filter. Units of the cut-off frequency, [Cf], must be
%   [dT]^{-1}. 
%  
%   In consequence, when used as a low-pass the time series is smoothed   
%   like a cosine filter in time space with M coefficients where greater is
%   better (see the reference).    
%  
%   If any option is empty, defaults are used.  
%
%   Note: NaN's elements are replaced by the mean of the time series and
%         ignored. If you have a better idea, just let me know.
%  
%   Reference:  
%   Emery, W. J. and R. E. Thomson. "Data Analysis Methods in Physical  
%     Oceanography". Elsevier, 2d ed., 2004. On pages 533-539.  
%  
%   Example:
%      dT = 30; % min 
%      N = 7*24*60/dT; t = (0:N-1)*dT; % data for 7 days
%      pnoise = 0.30;
%      T1 = 12.4*60; T2 = 24*60; T3 = 15*24*60; Tc = 10*60; % min
%      xn = 5 + 3*cos(2*pi*t/T1) + 2*cos(2*pi*t/T2) + 1*cos(2*pi*t/T3);
%      xn = xn + pnoise*max(xn-mean(xn))*(0.5 - rand(size(xn)));   
%      [xs,c,h,Cx,f] = lanczosfilter(xn,dT,1/Tc,[],'low');  
%      subplot(211), plot(t,xn,t,xs), legend('noisy','smooth'), axis tight
%      subplot(212), plot(f,h,f,abs(Cx)/max(abs(Cx)),...
%         [1 1]/Tc,[min(h) max(h)],'-.',...
%         [1/T1 1/T2 1/T3],([1/T1 1/T2 1/T3]<=1/Tc),'o'), axis tight  
%  
%   See also FILTER, FFT, IFFT

%   Written by
%   Lic. on Physics Carlos Adrián Vargas Aguilera
%   Physical Oceanography MS candidate
%   UNIVERSIDAD DE GUADALAJARA 
%   Mexico, 2004
%
%   nubeobscura@hotmail.com

% Check arguments:
if nargin<1 || nargin>5
 error('Lanczosfilter:ArgumentNumber','Incorrect number of arguments.')
elseif ~isvector(x) || ~isreal(x)
 error('Lanczosfilter:ArgumentType','Incorrect time series.')
end
if nargin<2 || isempty(varargin{1})
  dT = 1;
elseif ~(numel(varargin{1})==1) || ~isreal(varargin{1})
 error('Lanczosfilter:ArgumentType','Incorrect time interval.')
else
 dT = varargin{1};
end
Nf = 1/(2*dT); % Nyquist frequency
if nargin<3 || isempty(varargin{2})
 Cf = Nf/2;
elseif ~(numel(varargin{2})==1) || ~isreal(varargin{2}) || varargin{2}<=0 || varargin{2}>Nf 
 error('Lanczosfilter:ArgumentType','Incorrect cut-off frequency.')
else
 Cf = varargin{2};
end
if nargin<4 || isempty(varargin{3})
 M = 100;
elseif ~(numel(varargin{3})==1) || ~isreal(varargin{3}) || (varargin{3}==round(varargin{3}))
 error('Lanczosfilter:ArgumentType','Incorrect Number of coeffients.')
else
 M = varargin{3};
end
if nargin<5 || isempty(varargin{4})
 LoH = 'l';
elseif ~ischar(varargin{4}) || isempty(strfind('lh',lower(varargin{4}(1))))
 error('Lanczosfilter:ArgumentType','Incorrect filter pass type.')
else
 LoH = varargin{4};
end
if strcmpi(LoH(1),'h')
 LoH = 2;
else
 LoH = 1;
end

% Normalize the cut off frequency with the Nyquist frequency:
Cf = Cf/Nf;

% Lanczos cosine coeficients:
coef = lanczos_filter_coef(Cf,M); coef = coef(:,LoH);

% Filter in frequency space:
[window,Ff] = spectral_window(coef,length(x)); Ff = Ff*Nf;

% Replace NaN's with the mean (ideas?):
inan = isnan(x); 
xmean = mean(x(~inan)); 
x(inan) = xmean;

% Filtering:
[y,Cx] = spectral_filtering(x,window);

function coef = lanczos_filter_coef(Cf,M)
% Positive coeficients of Lanczos [low high]-pass.
hkcs = lowpass_cosine_filter_coef(Cf,M);
sigma = [1 sin(pi*(1:M)/M)./(pi*(1:M)/M)];
hkB = hkcs.*sigma;
hkA = -hkB; hkA(1) = hkA(1)+1;
coef = [hkB(:) hkA(:)];

function coef = lowpass_cosine_filter_coef(Cf,M)
% Positive coeficients of cosine filter low-pass.
coef = Cf*[1 sin(pi*(1:M)*Cf)./(pi*(1:M)*Cf)];

function [window,Ff] = spectral_window(coef,N)
% Window of cosine filter in frequency space.
Ff = 0:2/N:1; window = zeros(length(Ff),1);
for i = 1:length(Ff)
 window(i) = coef(1) + 2*sum(coef(2:end).*cos((1:length(coef)-1)'*pi*Ff(i)));
end

function [y,Cx] = spectral_filtering(x,window)
% Filtering in frequency space is multiplication, (convolution in time 
% space).
Nx  = length(x);
Cx  = fft(x(:)); Cx = Cx(1:floor(Nx/2)+1);
CxH = Cx.*window(:);
CxH(length(CxH)+1:Nx) = conj(CxH(Nx-length(CxH)+1:-1:2)); 
y = real(ifft(CxH));


% Carlos Adrián Vargas Aguilera. nubeobscura@hotmail.com