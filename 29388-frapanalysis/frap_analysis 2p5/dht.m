% dht - calculates a numerical Hankel transform
%   The program is based on the method proposed by Guizar-Sicairos and
%   Gutierrez-Vega in:
%   M. Guizar-Sicairos and J. C. Gutierrez-Vega, Computation of
%   quasi-discrete Hankel transforms of integer order for propagating
%   optical wave fields,J. Opt. Soc. Am. A 21, 53-58 (2004).
%
%   [k,f,T]=dht(r,I,T,R,kmin,kmax) where:
%
%   k = the spatial frequencies [um^-1]
%   f = the Hankel transform at the values of k
%   T = a transformation matrix for the Hankel transform
%
%   r = radial distances
%   I = values (given at the radial distances) to be Hankel transformed
%   T = a transformation matrix for the Hankel transform that should be
%       passed as [] if not known in advance
%   kmin = the smallest value of k at which f is calculated
%   kmax = the largest value of k at which f is calculated

function [k,f,T]=dht(r,I,T,R,kmin,kmax,N)

% Calculates the first N+1 zeros of the zeroth order Besselfunction
m=[6:1:N+1];
alpha_t=[2.404825558,5.520078110,8.653727913,11.79153444,14.93091771];
c=[alpha_t,pi/4*(4*m-1)+1./(2*pi*(4*m-1))-31./(6*pi^3*(4*m-1).^3)+3779./(15*pi^5*(4*m-1).^5)];

% Determines the interval of the values of k
x=kmin*2*pi*R/2.404825558;
alpha_M=kmax*2*pi*R/x;
M=find(c>alpha_M,1,'first');
if isempty(M) || M>N
    M=N;
end
    
% Specifies variours parameters 
alpha=c(1,1:N);
V=c(1,N+1)/(2*pi*R);
k=alpha(1:M)'/(2*pi*R)*x;
S=2*pi*R*V/x;

% Creates the transformation matrix
if isempty(T)
    T=2*besselj(0,alpha(1:M)'*alpha/S)./(abs(besselj(1,alpha(1:M)'))*abs(besselj(1,alpha))*S);
end

% Calculates the Hankel transform
I2=I./abs(besselj(1,alpha'))*R;
f=(1/x*T*I2).*abs(besselj(1,alpha(1:M)'))/V;
