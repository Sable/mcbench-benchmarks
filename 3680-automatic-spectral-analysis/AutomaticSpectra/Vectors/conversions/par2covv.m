function [cov,Pf,Pb] = par2covv(par,parb,R0)

%function [cov Pf Pb] = par2covv(par,parb,R0)
% Transforms parameters into acovariancefunction cov
% 
% OR
% [COV PF PB] = PAR2COVV(par,[],PEPS)
% If parb is set to [], the covs are calculated in a fundamentally
% different way, via the Yule-Walker equations. Note that in this
% case the covariance matrix of the generating noise PEPS is used.
%
% Notations are the same as in ARMAFILTERV.
%
% Used in  PAR2PCV.

%S. de Waele, March 2003.

s = kingsize(par);
order = s(3)-1;
dim = s(1); I = eye(dim);

if isempty(parb)
    %NO Backward parameters
    Peps = R0; clear R0;
    LTIm = matmat('YWoutput(A,varargin{1})',[dim dim order+1],par);
    rhs = zeros(dim,dim,order+1);
    rhs(:,:,1) = Peps;
    cov = reshape(LTIm\rhs(:),dim,dim,order+1);
else
    %Backward parameters are given
    [pc,Pf,Pb] = par2pcv(par,parb,R0);
    cov = pc2covv(pc,R0);
end

