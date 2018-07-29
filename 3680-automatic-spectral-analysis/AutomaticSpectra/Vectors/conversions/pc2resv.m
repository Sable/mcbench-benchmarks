function [Pf,Pb] = pc2resv(pc,R0)

%function [Pf,Pb] = pc2resv(pc,R0)
% Transforms normalized correlation matrices pc into 
% residual matrices Pf and Pb.

% S.de Waele, March 2003.

if ~isstatv(pc), error('Partial correlations non-stationairy!'), end

s = kingsize(pc); order = s(3)-1; dim = s(1); I = eye(dim);

Pf   = zeros(s); Pf(:,:,1)   = R0;
Pb   = zeros(s); Pb(:,:,1)  = R0;
for p = 1:order,
   TsqrtPf = Tsqrt( Pf(:,:,p)); %square root M defined by: M=Tsqrt(M)*Tsqrt(M)'
   TsqrtPb= Tsqrt(Pb(:,:,p)); 
   Pf(:,:,p+1)  = (I-TsqrtPf *pc(:,:,p+1) *pc(:,:,p+1)'*inv(TsqrtPf ))*Pf(:,:,p); 
   Pb(:,:,p+1) = (I-TsqrtPb*pc(:,:,p+1)'*pc(:,:,p+1) *inv(TsqrtPb))*Pb(:,:,p); 
end %for p = 2:order,
      
