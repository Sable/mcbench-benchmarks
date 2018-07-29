function[LL] = arfima_exactlik(params,Z,arma_part)
  muZ = params(length(params)-1);
  gamma_s = arfima_covs(length(Z),params,arma_part);
  [v,L] = durlevML(gamma_s);
  L = reshape(L,length(Z),length(Z))';
  e = L*(Z-muZ);
  LL = 0.5*log(v) + 0.5*((e.^2).*((v).^(-1)));
  Nl = isnan(LL);
           for ij = 1:length(LL)
              if Nl(ij) ==1,LL(ij) = Inf;end 
              if isreal(LL(ij)) == 0,LL(ij)=Inf;end
           end
  LL = sum(LL);
  message = sprintf('%s %15.5f','Log-likelihood function value:',-LL);
  disp(message)
end