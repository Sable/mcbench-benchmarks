function [par, parb, Pf, Pb] = pc2parv(pc,R0)

%function [par, parb, Pf, Pb] = pc2parv(pc,R0)
% Transforms reflection matrices rc into parameters

%S. de Waele, March 2003.

if ~isstatv(pc), error('Partial correlations non-stationairy!'), end

s = kingsize(pc);
order = s(3)-1;
dim = s(1); I = eye(dim);

par = zeros(dim,dim,order+1);
parb = zeros(dim,dim,order+1);

[rc,rcb,Pf,Pb] = pc2rcv(pc,R0);

par(:,:,1) = I;
parb(:,:,1)= I; 
if order,
	par(:,:,2) = rc(:,:,2);
	parb(:,:,2)= rcb(:,:,2);
end
par_o  = par;
parb_o = parb;
for p = 2:order,
%   par(:,:,2:p) =  par_o(:,:,2:p) +flipdim(filterv(rc(:,:,p+1),1,parb_o(:,:,2:p)),3);
   par(:,:,2:p) =  par_o(:,:,2:p) +flipdim(armafilterv(parb_o(:,:,2:p),1,rc(:,:,p+1)),3);
   par(:,:,p+1)= rc(:,:,p+1);
%   parb(:,:,2:p) =  parb_o(:,:,2:p) +flipdim(filterv(rcb(:,:,p+1) ,1,par_o(:,:,2:p)),3);
   parb(:,:,2:p) =  parb_o(:,:,2:p) +flipdim(armafilterv(par_o(:,:,2:p),1,rcb(:,:,p+1)),3);
   parb(:,:,p+1)= rcb(:,:,p+1);
   
   par_o  = par;
   parb_o = parb;
end %for p = 2:order,
      
