function [pc,Pf,Pb] = rc2pcv(rc,R0)

%function [pc,Pf,Pb] = rc2pcv(rc,R0)
% Transforms forward reflection coefficients rcb into 
% normalized correlation matrices pc.

%S. de Waele, March 2003.

s = kingsize(rc);
order = s(3)-1;
dim = s(1); I = eye(dim);
%if nargin == 1, R0 = I; end

pc = zeros(s);  pc(:,:,1)  = I; 

Pf   = zeros(s); Pf(:,:,1)   = R0;
Pb   = zeros(s); Pb(:,:,1)  = R0;

for p = 1:order,
   TsqrtPf = Tsqrt(Pf(:,:,p)); %square root M defined by: M=Tsqrt(M)*Tsqrt(M)'
   TsqrtPb= Tsqrt(Pb(:,:,p)); 
   %partial correlation
   pc(:,:,p+1) = -inv(TsqrtPf)*rc(:,:,p+1)*TsqrtPb;
   %residual matrices
   Pf(:,:,p+1)  = (I-TsqrtPf *pc(:,:,p+1) *pc(:,:,p+1)'*inv(TsqrtPf ))*Pf(:,:,p); 
   Pb(:,:,p+1) = (I-TsqrtPb*pc(:,:,p+1)'*pc(:,:,p+1) *inv(TsqrtPb))*Pb(:,:,p); 
end %for p = 2:order,
