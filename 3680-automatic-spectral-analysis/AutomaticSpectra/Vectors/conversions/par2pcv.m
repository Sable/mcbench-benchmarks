function [pc,Pf,Pb] = par2pcv(par,parb,R0)

%function [pc,Pf,Pb] = par2pcv(par,parb,R0)
% Transforms parameters par an parb into partial correlations pc
% If R0 is left out, it is considered to be unity.
%
% OR [pc,Pf,Pb] = par2pcv(par,[],Peps)
% If parb is left out or set to [], the pc's are calculated
%    in a fundamentally different way, via the Yule-Walker equations
%
% Notations are the same as in ARMAFILTERV.

s = kingsize(par);
order = s(3)-1;
dim = s(1); I = eye(dim);

if isempty(parb)
	Peps = R0; clear R0;
	cov = par2covv(par,[],Peps);
	[pc,Pf,Pb] = cov2pcv(cov);
else
	rc = zeros(s);  rc(:,:,1)  = I; 
	Pf   = zeros(s); Pf(:,:,1)   = R0;

	rcb = zeros(s); rcb(:,:,1) = I; 
	Pb  = zeros(s); Pb(:,:,1)  = R0;

	%First par2rcv
	par_o  = par;
	parb_o = parb;
	for p = order:-1:1,
	   %reflection coefficients
	   rc(:,:,p+1) = par_o(:,:,p+1);
   	rcb(:,:,p+1)= parb_o(:,:,p+1);   
   
   	%parameters
   	M = inv(I-rc(:,:,p+1) *rcb(:,:,p+1));
      par(:,:,2:p) = timesv(M ,(par_o(:,:,2:p) -timesv( rc(:,:,p+1),parb_o(:,:,p:-1:2))));
      Mb = inv(I-rcb(:,:,p+1) *rc(:,:,p+1));
      parb(:,:,2:p)= timesv(Mb,(parb_o(:,:,2:p)-timesv(rcb(:,:,p+1),par_o(:,:,p:-1:2))));
      par_o  = par;
      parb_o = parb;
   end
   pc = rc2pcv(rc,R0);
end
