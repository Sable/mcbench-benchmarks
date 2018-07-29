function [pc,R0,P,Pb]=burgv(x,Lmax)

%BURGV
%   [PC,R0] = BURGV(X,L) estimates autoregressive models from the 
%   data X with the Nuttal-Strand method for model orders 1...L.
%   The estimated partial correlations PC can be transformed into
%   AR parameters with PC2PARV. R0 is the estimate covariance matrix.
%   Note that the mean value of the signal is NOT sutracted.
%
%   See also: FILTERV, PC2PARV.

%   Reference: Marlpe, "Digital spectral analysis" p. 406, eq. 15.98

%Some definitions
dim = size(x,1); nobs = size(x,3);
I = eye(dim);

pc= zeros(dim,dim,Lmax+1); pc(:,:,1) =I;
K = zeros(dim,dim,Lmax+1); K(:,:,1)  =I;
Kb= zeros(dim,dim,Lmax+1); Kb(:,:,1) =I;
P = zeros(dim,dim,Lmax+1);
Pb= zeros(dim,dim,Lmax+1);

%Initialization
x = mat2sig(x);	%rewritten for easy processing
P(:,:,1)= x'*x;
Pb(:,:,1)= P(:,:,1);
f = x;
b = x;

%the recursive algorithm
for i = 1:Lmax,
   v = f(2:end,:);
   w = b(1:end-1,:);
   
   Rvv = v'*v; %Pfhat
   Rww = w'*w; %Pbhat
   Rvw = v'*w; %Pfbhat
   Rwv = w'*v; % = Rvw', written out for symmetry
   
   delta = lyap(Rvv*inv(P(:,:,i)),inv(Pb(:,:,i))*Rww,-2*Rvw);
   
   TsqrtS = chol( P(:,:,i))'; %square root M defined by: M=Tsqrt(M)*Tsqrt(M)'
   TsqrtSb= chol(Pb(:,:,i))'; 
   pc(:,:,i+1) = inv(TsqrtS)*delta*inv(TsqrtSb)';
   
   %The forward and backward reflection coefficient
   K(:,:,i+1) = -TsqrtS *pc(:,:,i+1) *inv(TsqrtSb);
   Kb(:,:,i+1)= -TsqrtSb*pc(:,:,i+1)'*inv(TsqrtS);
   
   %filtering the reflection coefficient out:
   f = (v'+ K(:,:,i+1)*w')';
   b = (w'+Kb(:,:,i+1)*v')';
   
   %The new R and Rb:
   %residual matrices
   P(:,:,i+1)  = (I-TsqrtS *pc(:,:,i+1) *pc(:,:,i+1)'*inv(TsqrtS ))*P(:,:,i); 
   Pb(:,:,i+1) = (I-TsqrtSb*pc(:,:,i+1)'*pc(:,:,i+1) *inv(TsqrtSb))*Pb(:,:,i); 
end %for i = 1:Lmax,
P = P/nobs;
Pb= Pb/nobs;
R0 = P(:,:,1);
