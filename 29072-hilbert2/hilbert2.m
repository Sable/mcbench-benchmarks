function [env freq] = hilbert2(x,Fs)
% HILBERT2 Extract instantaneous envelope and frequency from a bandlimited
% signal via Hilbert transform. 
% 
% [ENV FREQ] = HILBERT2(X,FS), for vectors X, returns estimates of the
% instantaneous envelope and frequency. X is assumed to be a
% band-limited signal sampled at a rate specified by FS (in units of Hz).
% If FS is not specified, HILBERT2 uses a sampling rate of 1 Hz.
%
% If X is a matrix, HILBERT2 operates along the columns of X. 
% If the input X is complex, then only the real part is used: X=real(X)
% 
% HILBERT2 returns the magnitude (ENV) and rate of change of the argument
% (FREQ) of the complex analytic signal corresponding to X. For a
% theoretical explication of this techinque and the formulas employed here,
% see: Ktonas & Papp (1980) Instantaneous envelope and phase extraction
% from real signals. Signal Processing 2:373-385.
% 
% Be sure to visualize your results, as this technique may produce
% distortions when estimating the instantaneous envelope and frequency at
% the edges of the waveform.
%
% EXAMPLE: 
% 
% %Create signal
% Fs = 500; T = 10; N = Fs*T;
% t = linspace(0,T,N)';
% g = 2*pi*3*t + 75*normcdf(t,5,1);
% A = 5 - 15*normpdf(t,5,1.5);
% x = A.*cos(g);
% 
% %Extract instantaneous envelope and frequency
% [env freq] = hilbert2(x,Fs);
% 
% %Plot results
% figure(1); clf; subplot(2,1,1)
% plot(t,x,'LineWidth',2); hold on
% plot(t,[env -env],'LineWidth',2,'Color',[0 1 0.5])
% xlim([1 9]); ylabel('Signal amplitude')
% title('Original signal with instantaneous envelope')
% subplot(2,1,2); plot(t,freq,'k','LineWidth',2); 
% axis([1 9 0 10]); xlabel('Time (sec)'); ylabel('Hz')
% title('Instantaneous frequency'); 
%
% Created by Scott McKinney, October 2010
% http://www.mathworks.com/matlabcentral/fileexchange/authors/110216
%
% See also HILBERT



if nargin<2
   Fs = 1; %default to 1 Hz
else           
    if ~isscalar(Fs) || Fs<=0;
        error('Fs must be a positive scalar!')
    end
end

X = hilbert(x); %analytic signal corresponding to real input signal x
env = abs(X); %instantaneous envelope of x is the magnitude of X
h = imag(X); %hilbert transform of input

dh = derivative(h);
dx = derivative(x);

w = (x.*dh - h.*dx)./(env.^2); %instantaneous radian frequency
freq = w*Fs/(2*pi); %convert to Hz

function dx = derivative(x,N,dim) 
% DERIVATIVE also available as stand-alone function. 
% Visit my author page: 
% http://www.mathworks.com/matlabcentral/fileexchange/authors/110216

%set DIM
if nargin<3  
   if size(x,1)==1 %if row vector        
       dim = 2;
   else
       dim = 1; %default to computing along the columns, unless input is a row vector
   end
else           
    if ~isscalar(dim) || ~ismember(dim,[1 2])    
        error('dim must be 1 or 2!')
    end
end

%set N
if nargin<2 || isempty(N) %allows for letting N = [] as placeholder
    N = 1; %default to first derivative    
else        
    if ~isscalar(N) || N~=round(N)
        error('N must be a scalar integer!')
    end
end

if size(x,dim)<=1 && N
    error('X cannot be singleton along dimension DIM')
elseif N>=size(x,dim)
    warning('Computing derivative of order longer than or equal to size(x,dim). Results may not be valid...')
end

dx = x; %'Zeroth' derivative
for n = 1:N % Apply iteratively

    dif = diff(dx,1,dim);

    if dim==1
        first = [dif(1,:) ; dif];
        last = [dif; dif(end,:)];
    elseif dim==2;
        first = [dif(:,1) dif];
        last = [dif dif(:,end)];
    end
    
    dx = (first+last)/2;
end