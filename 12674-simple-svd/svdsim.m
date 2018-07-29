function [u,s,v] = svdsim(a,tol)
%SVDSIM  simple SVD program
%
% A simple program that demonstrates how to use the
% QR decomposition to perform the SVD of a matrix.
% A may be rectangular and complex.
%
% usage: [U,S,V]= SVDSIM(A)
%     or      S = SVDSIM(A)
%
% with A = U*S*V' , S>=0 , U'*U = Iu  , and V'*V = Iv
%
% The idea is to use the QR decomposition on A to gradually "pull" U out from
% the left and then use QR on A transposed to "pull" V out from the right.
% This process makes A lower triangular and then upper triangular alternately.
% Eventually, A becomes both upper and lower triangular at the same time,
% (i.e. Diagonal) with the singular values on the diagonal.
%
% Matlab's own SVD routine should always be the first choice to use,
% but this routine provides a simple "algorithmic alternative"
% depending on the users' needs.
% 
%see also: SVD, EIG, QR, BIDIAG, HESS
%

% Paul Godfrey
% October 23, 2006

if ~exist('tol','var')
   tol=eps*1024;
end
   
%reserve space in advance
sizea=size(a);
loopmax=100*max(sizea);
loopcount=0;

% or use Bidiag(A) to initialize U, S, and V
u=eye(sizea(1));
s=a';
v=eye(sizea(2));

Err=realmax;
while Err>tol & loopcount<loopmax ;
%   log10([Err tol loopcount loopmax]); pause
    [q,s]=qr(s'); u=u*q;
    [q,s]=qr(s'); v=v*q;

% exit when we get "close"
    e=triu(s,1);
    E=norm(e(:));
    F=norm(diag(s));
    if F==0, F=1;end
    Err=E/F;
    loopcount=loopcount+1;
end
% [Err/tol loopcount/loopmax]

%fix the signs in S
ss=diag(s);
s=zeros(sizea);
for n=1:length(ss)
    ssn=ss(n);
    s(n,n)=abs(ssn);
    if ssn<0
       u(:,n)=-u(:,n);
    end
end

if nargout<=1
   u=diag(s);
end

return
