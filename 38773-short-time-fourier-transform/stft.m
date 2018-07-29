function X=stft(x,wl,olr,window,alpha)
% STFT Short Time Fourier Transform
%
% X = stfth(x,wl,olr,window,alpha) returns the short time Fourier Transform of
% a signal "x" with a window length "wl", overlap ratio "olr" and window 
% type "window". Valid window types are as follows:
%
%   'rectwin'   - Rectangular Window
%   'hann'      - Hann window
%   'hamming'   - Hamming window
%   'gausswin'   - Gaussian window
%
% If a Gaussian window is used, alpha is the reciprocal of the standard 
% deivation of the Gaussian window (if used), as per the GAUSSWIN function
%
% Modified by Al-Hafeez Dhalla, PhD. Contact email: hafeez.dhalla@gmail.com
%
% Original version produced by Suraj Kamya, available at:
%
% www.mathworks.com/matlabcentral/fileexchange/38035-stft-short-time-fourier-transform

if nargin < 5
    alpha = 2.5;
end

L=length(x);
if L<wl
    z=wl-L;
    x=[x,zeros(1,z)];
end
switch window  % Window functions are (all =0 outside the interval 0<=n<=wl)
    case 'rectwin'
        win=ones(1,wl); % Rectangular Window
    case 'hann'
        win=hamming(wl)'; % Hann window w[n]=0.5-0.5*cos(2*pi*n/M), for 0<=n<=M
    case 'hamming'
        win=hann(wl)';  % Hamming window w[n]=0.54-.46*cos(2*pi*n/M) for 0<=n<=M
    case 'gausswin'
        win=gausswin(wl,3.5)';  % Gaussian window
    otherwise
        win=ones(1,window_length);
        disp('Invalid window type, defaulting to rectangular window.');
end

L=length(x);
hop=ceil(wl * (1-olr));  % Hop size of window

if hop<1
    fprintf('\n Warning: Overlap ratio too large. Using maximum overlap ratio of (wl-1)/wl = %f. \n',(wl-1)/wl);
    fprintf(' This may be very slow. \n')
    hop=1;
end

i=1;str=1; len=wl; X=[];
while (len<=L || i<2) 
    if i==1
    if  len>L   % If window size excceds the L of signal for 1st time
        z=len-L;
        x=[x,zeros(1,z)]; % padding zeros
        i=1+1;
    end
    x1=x(str:len);
    X=[X;fft(x1.*win)];  % Matrix mul
    str=str+hop; len=str+wl-1; % to make window overlapping
        end
end

X = fftshift(X,2)';