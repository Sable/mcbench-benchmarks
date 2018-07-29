function Price = europeanbasket(basketstruct,OptSpec,T,N,n,r,Strike)
%EUROPEANBASKET Price european basket option
%
% basketstruct - basket equity structure returned by BASKETSET
% OptSpec - Specifies whether its a call or put
% T - time to maturity
% N - number of time intervals
% n - number of replications
% Strike - Strike Price
%
% 
% 
%-----------------------------
% Do error checking
%-----------------------------
% 
%         
% calculate expected pay-off at the end
[S,num] = basketsim(basketstruct,T,N,n,r);
S_port = S(:,:,N+1)*num';
if strcmpi(OptSpec,'Call')
    PriceM = max(0,S_port-Strike);
end
if strcmpi(OptSpec,'Put')
    PriceM = max(0,-S_port+Strike);
end
Price = exp(-r*T)*mean(PriceM);