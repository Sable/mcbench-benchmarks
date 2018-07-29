function c=call(S,K,r,sigma,t,T,q)
    if nargin>6
        c=exp(-q.*(T-t)).*call(S,K,r-q,sigma,t,T);
    else
        c=S.*Phi(d1(S,K,r,sigma,t,T))-K.*exp(-r.*(T-t)).*Phi(d2(S,K,r,sigma,t,T));
    end
end