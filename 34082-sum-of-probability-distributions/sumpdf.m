function [S,P,C]=sumpdf(varargin)
% SUMPDF Probability distribution of the sum of distributions
%   [S,P,C]=SUMPDF(X1,P1,N1,X2,P2,N2,...) will return the distribution of
%   the sum of distribution P1, at values at X1, N1 times plus the
%   distribution P2, at values in X2, N2 times...
%
%   The output vectors, S, P, and C, are respectively the list of unique
%   outcomes, probability of yielding that outcome, and the total number
%   of ways of obtaining that outcome among all combinations.
%
%   EXAMPLE (Discrete)
%     Distribution of the total value when choosing 10 values from
%     distribution (A) and 7 values from distribution (B).
%
%        X1=[-1 0 2]; P1=[.1 .2 .7]; N1=10;    %(A)
%        X2=[ 0 1 2]; P2=[.3 .5 .2]; N2=7;     %(B)
%        [S,P,C]=sumpdf(X1,P1,N1,X2,P2,N2);
%
%        subplot(2,1,1), plot(S,P), grid on
%        title('Probability distribution of total value')
%        subplot(2,1,2), plot(S,C), grid on
%        title('Number of combinations possible to obtain each outcome')
%
%     This illustrates that while an outcome of 10 has the most
%     combinations of ways to happen, it is actually a total of 20 which is
%     the most likely to happen due to the given probabilities of values.
%
%   EXAMPLE (Continuous)
%     Note: Program assumes discrete distribution. If using continuous
%     distributions, and using densities as inputs, a normalization must 
%     be made afterwards. Also, as only a finite number of points are
%     used the results are an approximation to the actual value on 
%     a valid domain. 
%
%     The sum of gamma distributions with the same scale parameter is
%     another gamma distribution with the overall shape parameter being
%     the sum of the individual shape parameters. Verify for a specific
%     case.(This example requires the statistics toolbox)
%       X1=linspace(0,10); Y1=gampdf(X1,2,1/2); N1=2;    %(A)  
%       X2=linspace(0,10); Y2=gampdf(X2,3,1/2); N2=3;    %(B)  
%       [XT,YT,CT]=sumpdf(X1,Y1,N1,X2,Y2,N2);
%       YT=YT./trapz(XT,YT); %Convert to density
%       plot(XT,YT,XT,gampdf(XT,N1*2+N2*3,1/2)); 
%       axis([0 10 0 1/4])
%


%   Mike Sheppard
%   Last Modified: 9-Dec-2011



%ERROR CHECKING
ninputs=numel(varargin); num=ninputs/3;
if mod(ninputs,3)~=0
    error('sumpdf:Inputs','Requires inputs to be in [Vector],[Probability],[Number] order');
else
    for k=1:num
        ALLVEC{k}=varargin{3*k-2}; ALLPROB{k}=varargin{3*k-1}; ALLNUMR{k}=varargin{3*k};
        numr=ALLNUMR{k};
        if any(~isfinite(ALLVEC{k}))||any(~isfinite(ALLPROB{k}))
            error('sumpdf:Inputs','Requires all input vectors to be numeric');
        end
        if length(ALLVEC{k})~=length(ALLPROB{k})
            error('sumpdf:Inputs','Requires all length of input vector and probability vector to be equal');
        end
        if any([~isfinite(numr) ~isscalar(numr) numr~=round(numr) numr<0])
            error('sumpdf:Inputs','Requires number of repetitions to be a positive scalar integer');
        end
    end
end



%ALGORITHM
S=0; P=1; C=1;
for k=1:num
    VEC=ALLVEC{k}; VEC=VEC(:); PROB=ALLPROB{k}; PROB=PROB(:); numr=ALLNUMR{k};
    indx=(PROB==0); VEC(indx)=[]; PROB(indx)=[]; %Ignore zero probabilities
    for n=1:numr
        tempv=bsxfun(@plus,S',VEC); tempp=bsxfun(@times,P',PROB);
        tempc=repmat(C',length(VEC),1); [S,ign,indx]=unique(tempv(:));
        P=accumarray(indx,tempp(:)); C=accumarray(indx,tempc(:));
    end
end


%Due to round-off error, totals may be ungroup that should otherwise
%be identical. Erase possible duplicates, while conserving count and
%probabilities.
ind=1;
while ~isempty(ind)
    ind=find(abs(diff(S))<(100*eps));
    if length(ind)>1
        ind=ind(diff(ind)>1);
    end
    C(ind+1)=C(ind+1)+C(ind); P(ind+1)=P(ind+1)+P(ind);
    S(ind)=[]; P(ind)=[]; C(ind)=[];
end

indx=(P==0); S(indx)=[]; P(indx)=[]; C(indx)=[]; %Ignore zero probabilities
    
end