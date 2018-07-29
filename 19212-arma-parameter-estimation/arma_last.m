%--------------------------------------------------------------------------
%
%   ARMA_LAST.M
%
%   This function provides an ARMA spectral estimate which is maximum
% entropy satisfying correlation constraint (number of poles)and cepstrum 
% constrains (number of ceros)
%
%   [sigma,outn,outd]=arma_last(xinf,np,nq)
%
% The function requires:
%
%   xinf(nsam)  Input signal (real valued) of nsam samples
%   nq          Order of the denominator (# of poles)
%   np          Order of the numerator (# of ceros)
%
% The function provides:
%
%   outd(nq)    The numerator coefficients outn(1)=1
%   outn(np)    The denominator coefficients outd(1)=1
%   sigma       The square-root of input noise power
%
% The function requires spa_corc.m to compute the autocorrealtion matrix
% estimate
%
% Example:
%           Generate 512 samples (x(1:512)) of an ARMA model with noise input
%           power 1 and coefficients equal to:
%           Numerator=[1 0.316 1.316 0.316 1]
%           Denominator=[1 -2.5068 3.4618 -2.4569 0.9606]
%           Call the routine as:
%                   [sigma,outn,outd]=arma_last[x,5,5];
%           The output is:
%                   sigma=1
%                   outn=[1 0.3547 1.3213 0.316 1]
%                   outd=[1 -2.5128 3.4488 -2.4365 0.9380]
% Reference:
%               M.A. Lagunas, P. Stoica, M.A. Rojas. "ARMA Parameter
%               Estimation: Revisiting a Cepstrum-Based Method".
%               Available at Proceedings IEEE-ICASSP 2008 Conference,
%               April 1-4, Las Vegas, USA.
%               Also available on request to: m.a.lagunas@cttc.es
%
%   Miguel Angel LAGUNAS and Petre STOICA                June 2007
%
%--------------------------------------------------------------------------
function [sigma,outn,outd]=arma_last(xinf,np,nq);
nsam=length(xinf);
% Computes correlation matrix order nq
ra1=spa_corc(xinf,nq);
% Computes cepstrum from log(.) of lengthly acf matrix
nle=(nsam/2);ra2=spa_corc(xinf,nle);[u d]=eig(ra2);
d1=diag(log(diag(d)));ca1=u*d1*u';clear u d1 d ra2 nsam;
for i=1:np
  cuso(i)=0;
  for j=1:nle-i;
    cuso(i)=cuso(i)+ca1(j,i+j);
  end;cuso(i)=cuso(i)/(nle);
end;
% Computes minimum phase impulse response from cepstrum estimate
cep=(1:1:np).*cuso(1:np);clear ca1 nle cuso;
i=2;h(1)=1;
while i<np+0.5;
  h(i)=0;
  for k=1:i-1;
    h(i)=h(i)+h(k)*cep(i-k);
  end;
  h(i)=h(i)/(i-1);i=i+1;
end;
% Forms impulse response matrix
hh=flipud(hankel(fliplr(h)));clear h cep;
if nq>np;
   hh=[hh zeros(np,nq-np)];
else;
   hh=hh(1:np,1:nq);
end;
% Finds minimum generalized eigenvalue and associated 
% eigenvector
[u d]=eig(ra1,hh'*hh);sas=diag(d);ua=[];sasn=[];
for j=1:nq;
  [auso luso]=min(sas);sasn=[sasn;sas(luso)];
  sas(luso)=10e9;ua=[ua u(:,luso)];
end;
% Output parameters
outd=real(ua(:,1)');outd=outd/outd(1);sigma=1/sqrt(sasn(1));
hha=hh/sigma;outn=outd*hha';sigma=sigma*outn(1);outn=outn/outn(1);
clear hh auso luso sas sasn u d ua ra1;
%---------------------------------------------------------------------
%----------------------------------------------------
%
%       SPA_CORC.M
%
% Computes the autocorrelation matrix using forward
% and backward snapshots from signal x and order nq
% for the matrix.
%
%   Requires:
%
% From the main program -The vector of data signal x
%                       - The order nq of the matrix
%   Provides:
%
%   ra(nq,nq) the correlation matrix estimate order nq
%
%   Miguel Angel Lagunas              Feb 1995
%------------------------------------------------------
function ra=spa_corc(x,nq);
n=length(x);l1=nq;isum=0;ra=zeros(nq,nq);
for i=nq:n;
    auso=zeros(nq,1);auso=x(l1-nq+1:l1)';l1=l1+1;
    buso=flipud(auso);
    ra=ra+(auso*auso'+buso*buso');isum=isum+2;
end;ra=ra/(isum);
%------------------------------------------------------