function x = gendatav(pc,R0,nobs)
%function x = gendatav(pc,R0,nobs)
%
%  Simulates nobs observations of a vector AR-process
%  with partial correlations pc and covariance matrix R0.
%
%  See also FILTERV, RANDN.

%  S. de Waele, FEB 2001.

if ~isstatv(pc), error('Partial correlations non-stationairy!'), end
order = kingsize(pc,3)-1;
dim = size(pc,1);
I = eye(dim);
[rc,rcb] = pc2rcv(pc,R0);
[Pf,Pb] = pc2resv(pc,R0);
par = zeros(dim,dim,order+1);
parb = zeros(dim,dim,order+1);

x = zeros(dim,1,nobs); %The signal in matrix notation
%First observation
innovation = randncov(Pf(:,:,1));
x(:,:,1) = innovation;

par(:,:,1) = I; 
parb(:,:,1)= I; 
if order,
	par(:,:,2) = rc(:,:,2);
	parb(:,:,2)= rcb(:,:,2);
	par_o  = par;
	parb_o = parb;
end   

%observation 2 to order
for obs = 2:order,
   innovation = randncov(Pf(:,:,obs));
   prediction = -prodsumv(flipdim(par(:,:,2:obs),3),x(:,:,1:obs-1));
   x(:,:,obs) = prediction+innovation;
   
   p=obs; %The next observations requires the AR(obs)-model
   %par(:,:,2:p) =  par_o(:,:,2:p) +flipdim(filterv(rc(:,:,p+1),1,parb_o(:,:,2:p)),3);
   par(:,:,2:p) =  par_o(:,:,2:p) +flipdim(armafilterv(parb_o(:,:,2:p),1,rc(:,:,p+1)),3);
   par(:,:,p+1)= rc(:,:,p+1);
   parb(:,:,2:p) =  parb_o(:,:,2:p) +flipdim(armafilterv(par_o(:,:,2:p),1,rcb(:,:,p+1)),3);
   parb(:,:,p+1)= rcb(:,:,p+1);
   
   par_o  = par;
   parb_o = parb;
  
end %for obs = 2:order,

%observations order+1 to nobs
innovation = zeros(dim,1,nobs-order);
for i = 1:nobs-order,
   innovation(:,:,i) = randncov(Pf(:,:,order+1));
end
x(:,:,order+1:end) = armafilterv(innovation,par,I,x(:,:,1:order));
