% quadr.m - Gauss-Legendre quadrature weights and evaluation points
%
% Usage: [w,x] = quadr(a,b,N)
%        [w,x] = quadr(a,b)   (equivalent to N=16)
%
% a,b = integration interval [a,b]
% N   = number of weights in quadrature formula (default N=16, even N avoids x=0)
%
% w = length-N column vector of (symmetric) weights
% x = length-N column vector of shifted/scaled Legendre evaluation points 
%
% notes: J = \int_a^b f(t) dt is approximated by J = w'*f(x), where f(x) is   
%        the column vector of values of f(t) evaluated at the Legendre points x.
%        The weights w have been pre-multiplied by the scale factor (b-a)/2
%
%        for double integration of f(t1,t2) over the intervals [a1,b1] and [a2,b2], use
%        [w1,x1] = quadr(a1,b1,N1), [w2,x2] = quadr(a2,b2,N2), J = w1'*f(x1,x2)*w2
%        where f(x1,x2) is an N1xN2 matrix of values of f(t1,t2)
%
% construction method: use LEGENDRE to calculate the coefficients of the
%        order-N Legendre polynomial, then find its N roots z, and construct x
%        by shifting and scaling, x = (z*(b-a) + a+b)/2, or, z = (2*x-a-b)/(b-a),
%        and finally, solve for w by matching the quadrature integration formula   
%        exactly at the polynomial powers f(t) = t^k, k=0,1,...,N
%
% example: f(t) = e^t + 1/t has J0 = \int_1^2 f(t)dt = e^2-e^1+ln(2) = 5.36392145
%          percent error of different methods, 100*abs(J-J0)/J0, is as follows:
%          method:  quad(f,1,2)    quad8(f,1,2)    quadr(1,2,5)    quadr(1,2,15)
%          error:   2.5492e-004    3.0302e-012     4.2336e-007     1.6558e-014
%
%        see also QUADRS for splitting the integration interval into subintervals

% Sophocles J. Orfanidis - 1999-2008 - www.ece.rutgers.edu/~orfanidi/ewa       

function [w,x] = quadr(a,b,N)

if nargin==0;return; end
if nargin==2, N=16; end

P = legendre(N,0);                      % evaluate Legendre functions at x=0
m = (0:N)';                             % coefficient index
P = (-1).^m .* P ./ gamma(m+1);         % order-N Legendre polynomial coefficients

z = sort( roots(P) );                     % sort roots in increasing magnitude

x = (z*(b-a) + a + b)/2;                % shifted Legendre roots

k = (0:N-1)';

c = (1 + (-1).^k) ./ (k+1);             % this is \int_{-1}^1 t^k dt

A = [];                                 % coefficient matrix of the system A*w = c

for m=1:N,
    A = [A, z(m).^k];                   % build the columns of A
end

w = A\c * (b-a)/2;

% The weights w can also be computed more simply, but less accurately, as follows:
%
% P = legendre(N,z);                      % Legendre functions evaluated at the roots z
% w = (b-a) ./ (P(2,:)').^2;              % 2nd row of P is (1-z.^2).^(1/2) .* P'_N(z)
%
% the unscaled weights are w(m) = 2/[(1-z(m)^2)*P'_N(z(m))^2], m=0,1,...,N,
% where P'_N(z(m)) are the derivatives of the order-N Legendre polynomial, evaluated
% at the Legendre zeros. The second row of LEGENDRE(N,z) contains these derivatives.

