function [x,bw,T,fl,rr,it,rv,xr] = vkm(y,f,fs,r,filtord,tol,maxit)
%
% Type: [x,bw,T,fl,rr,it,rv,xr] = vkm(y,f,fs,r,filtord,tol,maxit);
%
% Inputs:
%
% y       := N x 1, data vector
% f       := N x Nord, matrix of frequency vectors for each order in columns [Hz]
%            (y and f have the same number of rows)
% fs      := 1 x 1, sampling frequency [Hz]
% r       := Nord x 1, vector of weighting factors for the structural equations
%            (typical value in 100's or 1000's)
% filtord := 1 x 1, filter order, one less than the number of poles.  Can take values 1 or 2.
% tol     := 1 x 1, specifies the tolerance for rr,
% maxit   := 1 x 1, maximum number of iterations.
%
% Outputs:
%
% x    := N x Nord, output order vectors (in columns)
%         minimizing the multi-order objective function
%         x is the zero-peak complex amplitude envelope
% bw   := Nord x 1, -3 dB filter bandwidth for each filter [Hz]
% T    := Nord x 1, 10% - 90% transition time for each filter
% (additinal output from pcg function)
% fl   := 1 x 1, convergence flag
%         = 0 - converged to tol within maxit iterations
%         = 1 - did not converge in maxit iterations
%         others - see pcg
% rr   := 1 x 1, the relative residual NORM(cy-H*x)/NORM(cy)
% it   := 1 x 1, the iteration number at which x was computed: it <= maxit
% rv   := 1 x 1, vector of the residual norms at each iteration including
%         norm(cy-H*x0)).
% xr   := N x Nord, reconstructed signals for each order
%
% Function for performing second generation Vold-Kalman filtering for multiple simultaneous orders.
%
% References:
%
% J. Tuma, Vold-Kalman order tracking filtration, PDF presentation slides online at
% http://homel.vsb.cz/~tum52/index.php?page=download
%
% C. Feldbauer and R. Holdrich, Realization of a Vold-Kalman filter - A least squares
% approach, Proceedings of the COST G-6 conference on digital audia effects (DAFX-00),
% Verona, Italy, December 7-9, 2000.  Available online at
% http://iem.at/projekte/publications/paper/dafx_feldbauer_hoeldrich2/dafx_feldbauer_hoeldrich2.pdf
%

% Scot McNeill, April 2011.
%
if ~isvector(y)
 error('y must be a vector.');
end
y=y(:); N = length(y);
[N2,Nord] = size(f);
if N2 ~= N
 error('size(f,1) must = length(y).');
end
if ~ismember(filtord,[1,2])
 error('filtord must be element of [1,2].');
end
if ~isvector(r)
 error('r must be a vector.');
end
r=r(:);
Nord2=length(r);
if Nord2 ~= Nord
 error('length(r) must = size(f,2).');
end
%
dt = 1/fs;
% Preconditioning matrices
e = ones(Nord*N,1);
L = spdiags([-e,e],-1:0,Nord*N,Nord*N);
M1 = L^(filtord+1);
M2 = M1';
clear e L;
%
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
clear e;
%
jay = sqrt(-1);
ejth = exp(jay*2*pi*cumsum(f,1)*dt);
H = sparse(Nord*N,Nord*N);
cy = zeros(Nord*N,1);
%
for ii = 1:Nord
 ir = (ii-1)*N+[1:N].'; % row index
 % cy block
 cy(ir) = conj(ejth(:,ii)).*y;
 % Block diagonal element
 B = r(ii)*r(ii)*A'*A + speye(N);
 H(ir,ir) = B;
 for jj = ii+1:Nord
  ic = (jj-1)*N+[1:N].'; % column index
  % Block off-diagonal element
  C = spdiags(conj(ejth(:,ii)).*ejth(:,jj),0,N,N); % diagonal matrix
  H(ir,ic) = C;
  H(ic,ir) = conj(C); % conjugate transpose part
 end
end
clear ir ic B C;
%
% Solve with preconditioned conjugate gradient algorithm
%
x0=std(y)*ones(Nord*N,1);
[tmp,fl,rr,it,rv] = pcg(H,cy,tol,maxit,M1,M2,x0); % matlab version
%[tmp,fl,rr,it,rv] = pcg1(H,cy,tol,maxit,M1,x0); % external m-function
x = 2*reshape(tmp,N,Nord);
xr = real(x.*ejth);
%
%%