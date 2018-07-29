function [r,errmax]=beszeros(n,k,iter)
% [r,errmax]=beszeros(n,k,iter)
% This function computes Bessel function
% roots using the formula on page of 260
% of 'A Treatise on Bessel Functions and
% Their Applications to Physics' by Andrew
% Gray and G. B. Mathews.
% n      - vector of function orders. For
%          example, n=0:20 gives roots of
%          besselj(0,x) thru besselj(20,x).
% k      - vector of root indices. k=1:20
%          gives the first 20 positive roots.
% iter   - number of times a Newton iteration
%          is performed to improve accuracy 
%          of the roots. Default value is 5.
% r      - matrix of roots where r(i,j) is
%          the root number k(j) for the 
%          Bessel function of order n(i)
% errmax - maximum of the absolute value of
%          the bessel functions evaluated
%          at the root estimates
%          
if nargin<3, iter=5; end
N=length(n); K=length(k);
n=repmat(n(:),1,K); k=repmat(k(:)',N,1);
b=pi/4*(2*n-1+4*k); m=4*n.^2;

% Starting formula for the roots
r=b-(m-1)./(8*b)-4*(m-1).*(7*m-31)./...
    (3*(8*b).^3)-32*(m-1).*((83*m-982).*m...
    +3779)./(15*(8*b).^5)-64*(m-1).*(((...
    6949*m-153855).*m+1585743).*m-...
    6277237)./(105*(8*b).^7);

% Newton interations to improve accuracy
for j=1:iter
  v=besselj(n,r); vp=(besselj(n-1,r)-...
    besselj(n+1,r))/2; r=r-v./vp;
end

err=bessel(n,r); errmax=max(abs(err(:)));