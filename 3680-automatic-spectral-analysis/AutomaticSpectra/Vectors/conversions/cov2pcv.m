function [pc, Pf, Pb] = cov2pcv(cov)

%function [pc, Pf, Pb] = cov2pcv(cov)
% Transforms a covariancefunction cov into partial correlations pc

%S. de Waele, March 2003.

s = kingsize(cov);
order = s(3)-1;
dim = s(1); I = eye(dim);
rc = zeros(s);  rc(:,:,1)  = I; 
par = zeros(s); par(:,:,1) = I; 
Pf   = zeros(s); Pf(:,:,1) = cov(:,:,1);

rcb = zeros(s); rcb(:,:,1) = I; 
parb= zeros(s); parb(:,:,1)= I; 
Pb  = zeros(s); Pb(:,:,1)  = cov(:,:,1);

%First cov2rcv
par_o  = par;
parb_o = parb;
for p = 1:order,
   %reflection coefficients
   delta = prodsumv(par_o(:,:,1:p),cov(:,:,p+1:-1:2));
   rc(:,:,p+1) = -delta *inv(Pb(:,:,p));
   rcb(:,:,p+1)= -delta'*inv(Pf(:,:,p));   
   
   %parameters
   par(:,:,2:p) = par_o(:,:,2:p) +timesv(rc(:,:,p+1),parb_o(:,:,p:-1:2));
   par(:,:,p+1) = rc(:,:,p+1);
   parb(:,:,2:p)= parb_o(:,:,2:p)+timesv(rcb(:,:,p+1) ,par_o(:,:,p:-1:2));
   parb(:,:,p+1)= rcb(:,:,p+1);
   par_o  = par;
   parb_o = parb;
   
   %residuals
   Pf(:,:,p+1) = (I-rc(:,:,p+1) *rcb(:,:,p+1))*Pf(:,:,p);
   Pb(:,:,p+1)= (I-rcb(:,:,p+1)*rc(:,:,p+1) )*Pb(:,:,p);
end
pc = rc2pcv(rc,cov(:,:,1));
