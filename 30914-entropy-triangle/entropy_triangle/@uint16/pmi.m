function [PI,Pxy,MI,Hxy] = pmi(N)
% pointwise mutual information operator [I,Pxy] = pmi(N)
%
% From a count matrix, N, describing the occurrence of joint events of two
% different phenomena, this obtains the pointwise mutual information (I) in bits of
% those events, which is the logarithm (base 2) of the quotiens of the joint
% probability by the marginals. This is considered a maxplus matrix. When N
% is sparse, the result is maxplus sparsely encoded.
% The MLE of the joint probability distribution [Pxy] can also be requested
% 
% The weighted pointwise mutual information (WI) can be easily calculated
% from these, as well as other statistics. Remember that 0*log 0 = 0 by
% convention.
%  WPI = Pxy.*I;
%  WPI(Pxy==0)=0;
% Hence the average mutual information MI is:
%  MI = sum(sum(WPI))
%
% THis works for either sparse of full N matrices.

%Build the contingency matrix, then the MLE estimate of the joint
%probabilites.

Ni = sum(N,2);%column of row marginal counts
Nj = sum(N,1);%row of column marginal counts
Nt = sum(Ni);%either the sum of the row or columns marginal counts.
NiNj = Ni* Nj;
PI = (double(N) * Nt)./ NiNj;%pointwise quotient of probs.
if nargout > 1, Pxy=double(N)/Nt; end%Store for calculating average

%When nans are generated, some adjustements are required
%Consider Nij=1, Ni=1, Nj=1, Nt -> Inf. The quotient goes to Inf, and the
%counts are indiscernible from as many zeroes. However, when only two of
%the counts go to zero, Nij must vanish more quickly than Ni (or Nj), hence
%the quotient goes to zero.

mynans = isnan(PI);%This should be sparse!
if any(any(mynans))
    [in,jn]=find(mynans);
    both = (Ni(in,1) + Nj(jn)')==0;%both counts are zero: these go to Inf.
    sP = size(PI);
    PI(sub2ind(sP,in(both),jn(both)))=Inf;
    PI(sub2ind(sP,in(~both),jn(~both)))=0;%otherwise, the quotienf goes to 0.
end
%Now work out the real matrix

if issparse(N)
    myeps=(PI==1);
    PI = spfun(@log2,PI);
    PI(myeps)=eps;
else
    PI = log2(PI);%This is bad for sparse matrices.
end
if nargout > 2%Calculate also MI
    nulls = sparse(Pxy == 0);
    MI = Pxy.*PI;%Weighed pointwise mutual info
    MI(nulls)=0;%Dispose of 0*log 0
    MI = sum(sum(MI));%The average of PMI is MI
    if nargout > 3%Calculate also joint entropy
        % 1. Calculate the joint entropy
        Hxy = Pxy .* log2(Pxy);
        Hxy(nulls) = 0;
        Hxy = -sum(sum(Hxy));
    end
end
return
