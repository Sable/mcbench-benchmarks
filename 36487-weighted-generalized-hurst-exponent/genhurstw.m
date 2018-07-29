%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the weighted generalized Hurst exponent H(q) from 
% the scaling of the renormalized q-moments of the distribution 
%
%       <|x(t+r)-x(t)|^q>_w/<x(t)^q>_w ~ r^[qH(q)]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                  
% Here <f>_w are weighted averages of f(t) over 0<= t < T
% with weights 
%       w(t) = w0 exp(-(T-t)/delta)
% and
%       w0 = (1-exp(-1/delta))/(1-exp(-T/delta))  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H = genhurstw(S)
% S is 1xT data series (T>50 recommended)
% calculates unweighted H(q=1)
%
% H = genhurstw(S,q)
% calculates unweighted H(q) specifying the exponent q 
% which can be a vector (default value q=1)
%
% H = genhurstw(S,q,delta)
% calculates weighted H(q) specifying the characteristic time delta 
%  
% H = genhurstw(S,q,delta,maxT)
% calculates weighted H(q) specifying the characteristic time delta 
% and the size of the scaling window maxT
%
% [H,sH]=genhurstw(S,...)
% estimates the standard deviation sH(q)
%
% examples:
%   generalized Hurst exponent for a random gaussian process
%   H=genhurstw(cumsum(randn(10000,1)))
% or 
%   H=genhurstw(cumsum(randn(10000,1)),[1,2]) to calculate H(1) and H(2) 
% or 
%   H=genhurstw(cumsum(randn(10000,1)),[1,2],100) to calculate weighted 
%   H(1) and H(2) with chractreistic time delta = 100  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for the generalized Hurst exponent method please refer to:
%   T. Di Matteo et al. Physica A 324 (2003) 183-188 
%   T. Di Matteo et al. Journal of Banking & Finance 29 (2005) 827-851
%   T. Di Matteo Quantitative Finance, 7 (2007) 21-36
% for the weighted Hurst exponent method please refer to:
%   R. Morales et al. Physica A, 391 (2012) 3180-3189.
%----------------------------------------------------------------------------------------- 
% Tomaso Aste 30/01/2013
%-----------------------------------------------------------------------------------------

function [mH,sH]=genhurstw(S,q,delta,maxT) 
if nargin < 2, q = 1; maxT = 19; delta = Inf; end
if nargin < 3,  maxT = 19; delta = Inf; end
if nargin < 4,  maxT = 19;  end
if size(S,1)==1 & size(S,2)>1
    S = S';
elseif size(S,1)>1 & size(S,2)>1
    fprintf('S must be 1xT  \n')
    return
end
if size(S,1) < (maxT*4 | 60)
    warning('Data serie very short!')
end
L=length(S);
lq = length(q);
H  = [];
k = 0;
aph = 1/delta;
for Tmax=5:maxT
    k = k+1;
    x = 1:Tmax;
    mcord = zeros(Tmax,lq);
 	for tt = 1:Tmax
        dV = S((tt+1):tt:L) - S(((tt+1):tt:L)-tt);
        VV = S(((tt+1):tt:(L+tt))-tt)';
        N = length(dV)+1;
        X = 1:N;
        Y = VV;
        mx = sum(X)/N;
        SSxx = sum(X.^2) - N*mx^2;
        my   = sum(Y)/N;
        SSxy = sum(X.*Y) - N*mx*my;
        cc(1) = SSxy/SSxx;
        cc(2) = my - cc(1)*mx;
        ddVd  = dV - cc(1);
        VVVd  = VV - cc(1).*(1:N) - cc(2);
         %figure
         %plot(X,Y,'o')
         %hold on
         %plot(X,cc(1)*X+cc(2),'-r')
         %figure
         %plot(1:N-1,dV,'ob')
         %hold on
         %plot([1 N-1],mean(dV)*[1 1],'-b')
         %plot(1:N-1,ddVd,'xr')
         %plot([1 N-1],mean(ddVd)*[1 1],'-r')
        if ~isinf(delta)
            w  = exp(-aph*([0:(N-2)]))*(1-exp(-aph))/(1-exp(-aph*(N-1)));
            w1 = exp(-aph*([0:(N-1)]))*(1-exp(-aph))/(1-exp(-aph*N));
            for qq=1:lq
                mcord(tt,qq)=sum(w.*(abs(ddVd').^q(qq)))/sum(w1.*(abs(VVVd).^q(qq)));  
            end
        else
            for qq=1:lq
                mcord(tt,qq)=mean(abs(ddVd).^q(qq))/mean(abs(VVVd).^q(qq));
            end
        end
    end
    mx = mean(log10(x));
    SSxx = sum(log10(x).^2) - Tmax*mx^2;
    for qq=1:lq
        my = mean(log10(mcord(:,qq)));
        SSxy = sum(log10(x).*log10(mcord(:,qq))') - Tmax*mx*my;
        H(k,qq) = SSxy/SSxx;
    end
end
%figure %verify scaling
%loglog(x,mcord,'x-')
mH = mean(H)'./q(:);
if nargout == 2
    sH = std(H)'./q(:);
elseif nargout == 1
    sH = [];
end