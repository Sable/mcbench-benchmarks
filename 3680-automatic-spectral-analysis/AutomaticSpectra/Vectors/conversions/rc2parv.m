function [par, parb, Pf, Pb] = rc2parv(rc,rcb)

%function [par, parb, Pf, Pb] = rc2parv(rc,rcb)
%  Transforms forward and backward reflection matrices rc and rcb 
%  into parameters.

%S. de Waele, March 2003.

s = kingsize(rc);
order = s(3)-1;
dim = s(1); I = eye(dim);

par = zeros(dim,dim,order+1);
parb = zeros(dim,dim,order+1);

par(:,:,1) = I; 
parb(:,:,1)= I; 
if order,
	par(:,:,2) = rc(:,:,2);
	parb(:,:,2)= rcb(:,:,2);
	par_o  = par;
	parb_o = parb;
end   
for p = 2:order,
   par(:,:,2:p) =  par_o(:,:,2:p) +fliptime(filterv(rc(:,:,p+1),1,parb_o(:,:,2:p)));
   par(:,:,p+1)= rc(:,:,p+1);
   parb(:,:,2:p) =  parb_o(:,:,2:p) +fliptime(filterv(rcb(:,:,p+1) ,1,par_o(:,:,2:p)));
   parb(:,:,p+1)= rcb(:,:,p+1);
   
   par_o  = par;
   parb_o = parb;
end %for p = 2:order,
      