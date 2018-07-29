% quadrs.m - Gauss-Legendre quadrature weights and evaluation points on subintervals
%
% Usage: [w,x] = quadrs(ab,N)
%        [w,x] = quadrs(ab)         (equivalent to N=16)
%
% ab = integration subintervals = [a0,a1,a2,...,aM]
% N  = number of weights in quadrature formula (default N=16), per subinterval
%
% w = length-(N*M) column vector of (symmetric) weights
% x = length-(N*M) column vector of shifted/scaled Legendre evaluation points 
%
% notes: the desired interval [a,b]=[a0,aM] is divided into M subintervals [a0,a1,...,aM]
%        and the weights/evaluation points of each subinterval are computed by QUADR 
%        and concatenated together, that is, 
%
%        w = [w1; w2; ...; wM], x = [x1; x2; ..., xM]
%
%        the desired integral over [a,b] is J = w'*f(x) = w1'*f(x1) + ... + wM'*f(xM)
%
% examples: [w,x] = quadrs([1,2], 5);
%           [w,x] = quadrs([1,1.5,2], 5);           
%           [w,x] = quadrs(linspace(1,2,9), 5);
%
%           the operation: [w,x] = quadrs([1,1.5,2], 5) is equivalent to:
%           [w1,x1] = quadr(1,1.5,5); [w2,x2]=quadr(1.5,2,5); w=[w1;w2]; x=[x1;x2]
%
%        see also QUADR, QUADR2, QUADRS2

% Sophocles J. Orfanidis - 1999-2008 - www.ece.rutgers.edu/~orfanidi/ewa      

function [w,x] = quadrs(ab,N)

if nargin==0; return; end
if nargin==1, N=16; end

M = length(ab) - 1;

w = [];
x = [];

for i=1:M,
    [wi,xi] = quadr(ab(i), ab(i+1), N);
    w = [w; wi];
    x = [x; xi];
end


