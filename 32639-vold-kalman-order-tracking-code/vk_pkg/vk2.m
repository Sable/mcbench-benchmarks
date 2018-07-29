function [x,bw,T,xr] = vk2(y,f,fs,r,filtord)
%
% Type: [x,bw,T,xr] = vk2(y,f,fs,r,filtord);
%
% Inputs:
%
% y    := N x 1, data vector
% f    := N x 1, frequency vector [Hz] (y and f have the same length)
% fs   := 1 x 1, sampling frequency [Hz]
% r    := 1 x 1, weighting factor for the structural equation (typical value in 100's or 1000's)
% filtord := 1 x 1, filter order, one less than the number of poles.  Can take values 1 or 2.
%
% Outputs:
%
% x    := N x 1, output order vector minimizing the objective function
%         J=r*r*x'A'*A*x+(y'-x'C')*(y-Cx) (complex)
%         x is the zero-peak complex amplitude envelope
% bw   := Nord x 1, -3 dB filter bandwidth for each filter [Hz]
% T    := Nord x 1, 10% - 90% transition time for each filter
% xr   := N x 1, reconstructed signals for each order (complex)
%
% Function for solving: x=inv(r*r*A'*A+I)*C*y,
% where C = diag(exp(-j*w(1)),...,exp(-j*w(N))),
% w = 2*pi*cumsum(f)*dt.
% This function appears in second generation Vold-Kalman filtering.
% This function is for extracting a single order at a time (not simultaneous orders).
%
% References:
%
% J. Tuma, Vold-Kalman order tracking filtration, PDF presentation slides online at
% http://homel.vsb.cz/~tum52/index.php?page=download

% Original version by J. Tuma
% Modified by Scot McNeill, April 2011.
%
if ~isvector(y)
 error('y must be a vector.');
end
y=y(:); N = length(y);
if ~isvector(f)
 error('f must be a vector.');
end
f=f(:); N2 = length(f);
if N2 ~= N
 error('length(f) must = length(y).');
end
if ~ismember(filtord,[1,2])
 error('filtord must be element of [1,2].');
end
%
dt = 1/fs;
if filtord == 1
 NR = N-2;
 e = ones(NR,1);
 A = spdiags([e -2*e e],0:2,NR,N);
 bw = fs/(2*pi)*(1.58*r.^-0.5);
 T = 2.85*r.^0.5;
elseif filtord == 2
 NR = N-3;
 e = ones(NR,1);
 A = spdiags([e -3*e 3*e -e],0:3,NR,N);
 bw = fs/(2*pi)*(1.70*r.^-(1/3));
 T =  2.80*r.^(1/3);
else
 error('filtord must be element of [1,2].');
end
AA = r*r*A'*A + speye(N);
jay=sqrt(-1);
ejth = exp(jay*2*pi*cumsum(f)*dt);
yy = conj(ejth).*y;
x = 2*(AA\yy);
xr = real(x.*ejth);
%
%%