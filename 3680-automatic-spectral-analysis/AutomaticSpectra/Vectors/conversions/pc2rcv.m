function [rc,rcb,Pf,Pb] = pc2rcv(pc,R0)

%function [rc,rcb] = pc2rcv(pc,R0)
% Transforms normalized correlation matrices pc into 
% forward and backward reflection coefficients rc and rcb.

% S. de Waele, March 2003.

if ~isstatv(pc), error('Partial correlations non-stationairy!'), end

s = kingsize(pc);
order = s(3)-1;
dim = s(1); I = eye(dim);
%if nargin == 1, R0 = I; end

rc = zeros(s);  rc(:,:,1)  = I; 
Pf   = zeros(s); Pf(:,:,1)   = R0;

rcb = zeros(s);  rcb(:,:,1) = I; 
Pb   = zeros(s); Pb(:,:,1)  = R0;

for p = 1:order,
   TsqrtPf = Tsqrt( Pf(:,:,p)); %square root M defined by: M=Tsqrt(M)*Tsqrt(M)'
   TsqrtPb= Tsqrt(Pb(:,:,p)); 
   %reflection coefficients
   rc(:,:,p+1) = -TsqrtPf *pc(:,:,p+1) *inv(TsqrtPb);	
   rcb(:,:,p+1)= -TsqrtPb*pc(:,:,p+1)'*inv(TsqrtPf );   
   %residual matrices
   Pf(:,:,p+1)  = (I-TsqrtPf *pc(:,:,p+1) *pc(:,:,p+1)'*inv(TsqrtPf ))*Pf(:,:,p); 
   Pb(:,:,p+1) = (I-TsqrtPb*pc(:,:,p+1)'*pc(:,:,p+1) *inv(TsqrtPb))*Pb(:,:,p); 
end %for p = 2:order,
      
