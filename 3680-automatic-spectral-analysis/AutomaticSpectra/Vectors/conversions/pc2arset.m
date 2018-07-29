function [par, parb, Pf, Pb] = pc2arset(pc,R0,req_order)

%PC2ARSET AR partial correlations to AR models
%   [AR, ARB] = PC2ARSET(PC,R0) converts AR-partial correlations PC into an AR-
%   model of order SIZE(PC,3)-1, with parameter vector AR. The procedure 
%   implements the parameter relations of the Levinson-Durbin recursion.
%    
%   [SET_AR, SET_ARB] = PC2ARSET(PC,R0,REQ_ORDER) returns intermediate AR 
%   parameter vectors in the cell array SET_AR and an array SET_PC of 
%   partial correlations, both corresponding to orders requested by 
%   REQ_ORDER. REQ_ORDER must be either a row of ascending AR-orders, or 
%   a single AR-order.

%S. de Waele, March 2003.

if ~isstatv(pc), error('Partial correlations non-stationairy!'), end

s = kingsize(pc);
order = s(3)-1;
dim = s(1); I = eye(dim);

[rc,rcb,Pf,Pb] = pc2rcv(pc,R0);

par = zeros(dim,dim,order+1);
parb = zeros(dim,dim,order+1);

p = 0;
par(:,:,1) = I;
parb(:,:,1)= I; 

store = exist('req_order');
if store
   counter = 1;
   max_counter = length(req_order);
   max_p = req_order(max_counter);
   ar_stack = cell(max_counter,1);
   arb_stack = cell(max_counter,1);
   if req_order(counter)==p
      ar_stack{counter} = par(:,:,1:p+1);
      arb_stack{counter}= parb(:,:,1:p+1);
      counter = counter+1;
   end
else
   req_order = [];
   max_p = order;
end

if max_p,
   p = 1;
   par(:,:,2) = rc(:,:,2);
	parb(:,:,2)= rcb(:,:,2);
   if store & req_order(counter)==p
      ar_stack{counter} = par(:,:,1:p+1);
      arb_stack{counter}= parb(:,:,1:p+1);
      counter = counter+1;
   end
end
par_o  = par;
parb_o = parb;

for p = 2:max_p,
%   par(:,:,2:p) =  par_o(:,:,2:p) +flipdim(filterv(rc(:,:,p+1),1,parb_o(:,:,2:p)),3);
   par(:,:,2:p) =  par_o(:,:,2:p) +flipdim(armafilterv(parb_o(:,:,2:p),1,rc(:,:,p+1)),3);
   par(:,:,p+1)= rc(:,:,p+1);
%   parb(:,:,2:p) =  parb_o(:,:,2:p) +flipdim(filterv(rcb(:,:,p+1) ,1,par_o(:,:,2:p)),3);
   parb(:,:,2:p) =  parb_o(:,:,2:p) +flipdim(armafilterv(par_o(:,:,2:p),1,rcb(:,:,p+1)),3);
   parb(:,:,p+1)= rcb(:,:,p+1);
   
   if store & req_order(counter)==p
      ar_stack{counter} = par(:,:,1:p+1);
      arb_stack{counter}= parb(:,:,1:p+1);
      counter = counter+1;
   end
   
   par_o  = par;
   parb_o = parb;
end %for p = 2:order,

%Output argument arrangement
%---------------------------

if store
   par = ar_stack;
	parb= arb_stack;	   
end
