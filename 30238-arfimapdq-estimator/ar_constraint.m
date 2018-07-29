function [c,ceq]= ar_constraint(params,arma_part)
   phi = params(2:2+arma_part(1)-1);
   %constraint to assure stationarity (invertibility)
   %in hope of a quicker convergence
   %it might also be reasonable to introduce
   %a constraint for assuring causality
   PHI = [phi; eye(length(phi))  ] ; 
   PHI = PHI(1:length(phi),:);
   %the stationarity constraint
   c = abs(eig(PHI)) - 0.999*ones(length(phi),1);
   ceq=[];
end