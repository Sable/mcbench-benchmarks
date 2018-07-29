function v=call_vega(S,K,r,sigma,t,T,q)
    if nargin>6
        v=exp(-q.*(T-t)).*call_vega(S,K,r-q,sigma,t,T);
    else
        v=S.*PhiPrime(d1(S,K,r,sigma,t,T)).*sqrt(T-t);
    end
end