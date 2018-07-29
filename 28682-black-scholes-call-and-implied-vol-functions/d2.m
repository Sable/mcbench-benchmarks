function d=d2(S,K,r,sigma,t,T)
   d=(log(S./K)+(r-sigma.^2*0.5).*(T-t))./(sigma.*sqrt(T-t));
end