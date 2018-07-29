function [x_msc]=msc(x,xref)
% Multiplicative Scatter Correction
%
% [x_msc]=msc(x,xref)
%
% input 
% x (samples x variables)      spectra to correct
% xref (1 x variables)         reference spectra (in general mean(x) is used)
%
% Output
% x_msc (samples x variables)  corrected spectra  
%
% By Cleiton A. Nunes
% UFLA,MG,Brazil

[m n]=size(x);
rs=xref;cw=ones(1,n);
mz=[];mz=[mz ones(1,n)'];mz=[mz rs'];
[mm,nm]=size(mz);
wmz=mz.*(cw'*ones(1,nm));
wz=x.*(ones(m,1)*cw);
z=wmz'*wmz;
[u,s,v]=svd(z);sd=diag(s)'; 
cn=10^12;
ms=sd(1)/sqrt(cn);
cs=max(sd,ms ); 
cz=u*(diag(cs))*v';  
zi=inv(cz);
b=zi*wmz'*wz';B=b';
x_msc=x; 
p=B(:,1);x_msc=x_msc-(p*ones(1,mm));
p=B(:,2);x_msc=x_msc./(p*ones(mm,1)');