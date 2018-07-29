function [tfr, t, f] = wv(x, t, N)
%WVCH Wigner-Ville distribution
%	[TFR,T,F]=WVCH(X,T,N) computes the Wigner-Ville distribution
%	of a discrete-time signal X, which is given in the form (1xN), 
%   or the cross Wigner-Ville representation between two signals. 
% 
%	X     : signal if auto-WV, or [X1,X2] if cross-WV.
%	T     : time instant(s)          (default : 1:length(X)).
%	N     : number of frequency bins (default : length(X)).
%	TFR   : time-frequency representation.
%	F     : vector of normalized frequencies.

if (nargin == 0),
 error('At least one parameter required');
end;

[xrow,xcol] = size(x);
if xrow ~= 1,
    error('X must have one row, (1xN) form');
end;

if (nargin == 1),
 t=1:xcol; N=xcol ;
elseif (nargin == 2),
 N=xcol ;
end;

if (N<0),
 error('N must be greater than zero');
end;

[trow,tcol] = size(t);
if (trow~=1),
  error('T must only have one row'); 
end; 

N1 = length(x)+rem(N,2);
length_FFT = N1; % Take an even value of N
R = zeros(N,N);  
for n = 0:N-1
    M = min(n, N-1-n);
    for k = 0:M
        R(n+1, k+1) = x(n+k+1) * conj(x(n-k+1));
    end
    for k = N-1 : -1 : N-M
        R(n+1, k+1) = conj(R(n+1, N-k+1));
    end
end
tfr = zeros(N1, N1);
for n = 0: N-1
    temp = fft(R(n+1,:), length_FFT)/(2*length_FFT);
%     temp = fftshift(temp);
    tfr(n+1, :) = temp;
end 

f = 0 : N1-1;
t = 0 : N1-1;