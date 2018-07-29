function [thetalim,N] = get_limits(CP)
% given projection constraints in CP, compute the 2D nullspace defining
% matrices that satisfy the projection constraints exactly. Each matrix can
% then be parameterized by the vector 
%   [r.cos(t) r.sin(t)] = r.cos(t)*[1 tan(t)]
% 
% Finding value of t where the resulting Omega is singular partitions
% the range [0,2*pi) into six intervals, only one of which corresponds to a
% positive definite Omega. This interval is what we return in 'thetalim'
% 
% What follows is a slightly long-winded way of expressing det(Omega) as a
% cubic in t that can be solved using 'roots'
%
% © Copyright Phil Tresadern, University of Oxford, 2006

N		= null(CP);

m 	= N(:,1);	n = N(:,2);

% bilinear products of m and n
mm	= kron(m,m);	nn	= kron(n,n);

% trilinear products of m and n
% i.e. mmn(a,b,c) = m(a)*m(b)*n(c)
nnn = reshape(kron(n,nn),[6,6,6]);
nnm = reshape(kron(m,nn),[6,6,6]);
mmn = reshape(kron(n,mm),[6,6,6]);
mmm = reshape(kron(m,mm),[6,6,6]);

% define coefficients of cubic
a3	=  nnn(1,3,6) + 2*nnn(2,4,5) - ...
			(nnn(1,5,5) + nnn(6,2,2) + nnn(3,4,4));

a2	= 	 nnm(1,3,6) + nnm(6,1,3) + nnm(3,6,1) + ...
			2*(nnm(2,5,4) + nnm(5,4,2) + nnm(4,2,5)) - ...
				(nnm(5,5,1) + nnm(2,2,6) + nnm(4,4,3) + ...
			2*(nnm(1,5,5) + nnm(6,2,2) + nnm(3,4,4)));

a1	= 	 mmn(1,3,6) + mmn(6,1,3) + mmn(3,6,1) + ...
			2*(mmn(2,5,4) + mmn(5,4,2) + mmn(4,2,5)) - ...
				(mmn(5,5,1) + mmn(2,2,6) + mmn(4,4,3) + ...
			2*(mmn(1,5,5) + mmn(6,2,2) + mmn(3,4,4)));

a0	=  mmm(1,3,6) + 2*mmm(2,4,5) - ...
			(mmm(1,5,5) + mmm(6,2,2) + mmm(3,4,4));

coeffs 	= [a3; a2; a1; a0];

% solve for tan(t) in range [0,pi), get t, and sort
% there should be 3 solutions
thetas	= sort(atan(roots(coeffs)));
thetas	= thetas(:)'; % row vector

% now get all solutions in range [0,2*pi)
res			= sort([thetas thetas+pi]);

% stack so that columns are of form [t(i); t(i+1)]
lims		= [ res; 
						res(2:6) res(1)+(2*pi) ];
					
% get midpoints of intervals
tests		= sum(lims) / 2;

% compute smallest eigenvalue of corresponding Omega
% only the positive definite Omega will have a smallest eigenvalue > 0
E = zeros(6,1);
for t = 1:6
	Omega = vec2sym(N*[cos(tests(t)); sin(tests(t))]);
	e			= eig(Omega);
	E(t)	= e(1);
end

% get limits of corresponding interval
min_t 		= find(E > 0);
thetalim 	= lims(:,min_t)';

% if interval spans the 2*pi mark then wrap around (though it shouldn't)
if (thetalim(2) < thetalim(1))
	thetalim(2) = thetalim(2) + (2*pi);
end
