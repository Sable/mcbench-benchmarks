% funJn calculates and returns the In integral (eq (15) in [1])
% Jn=funJn(Tn,betaConst,n,numbMC)
% Jn is the J_{n,\beta} integral (scalar) value
% T_n is the n-based SINR threshold value (eq (17) in [1])
% betaConstant is path-loss exponent
% n is integer parameter
% betaConst, n, and numbMC are scalars. T_n can be a vector
% numbMc is number of sample (Sobol) points for  quasi-MC integration
%
% Author: H.P. Keeler, Inria Paris/ENS, 2013
%
% References
% [1] H.P. Keeler, B. Błaszczyszyn and M. Karray,
% 'SINR-based k-coverage probability in cellular networks with arbitrary
% shadowing', accepted at ISIT, 2013 


function Jn=funJn(Tn,betaConst,n,numbMC)
% Calculates Jn with various integration methods
% n =2 and 3 uses quad and dblquad respectively
% n>3 uses quasi Monte Carlo based on Sobol points
% function is called by funProbCov; see Corollary 7 in [1]
if nargin==3
    numbMC=10^3; %set default number of qMC sample points
end
if n<=3
    numbMC=0; %monte carlo not used
end

Jn=zeros(size(Tn));
for k=1:length(Tn)
    %%% Use  quadrature methods for n=2 and n=3 cases
    if n==3
        fv=@(v1,v2)(1./((v1.*v2)+Tn(k))).*(1./((v1.*(1-v2))+Tn(k))).*(v1.*v2.*(1-v2).*(1-v1)).^(2/betaConst).*v1.^(2/betaConst+1);
        Jn(k)=dblquad(fv,0,1,0,1); %perform double qudarature
    elseif n==2
        
        fv=@(v1)(v1.*(1-v1)).^(2/betaConst)./(v1+Tn(k));
        Jn(k)=quad(fv,0,1); %perform single qudarature
        
    elseif n==1
        Jn=ones(size(Tn)); %return ones since J_1=1;
    else
        %%% Use QMC method
        numbMCn=(n-1)*numbMC; %scale number of points by dimension
        cubeVol=1; %hyper-cube volume
        eta_i=cell(1,n);
        %Use sobol points (can also use 'halton')
        q = qrandstream('halton',n-1,'Skip',1e3,'Leap',1e2);
        qRandAll=qrand(q,numbMCn);
        
        %create eta_i values
        eta_i{1}=prod((qRandAll(:,1:end)),2);
        for i=2:n-1
            eta_i{i}=(1-qRandAll(:,i-1)).*prod((qRandAll(:,i:end)),2);
        end
        eta_i{n}=(1-qRandAll(:,n-1));
        
        %create/sample nominator and denominator of integral kernel
        numProdv_i=ones(numbMCn,1);
        denomProdv_i=ones(numbMCn,1);
        for i=1:n-1
            viRand=qRandAll(:,i);
            numProdv_i=(viRand).^(i*(2/betaConst+1)-1).*(1-viRand).^(2/betaConst).*numProdv_i; %numerator
            denomProdv_i=(eta_i{i}+Tn(k)).*denomProdv_i; %denominator term
        end
        denomProdv_i=(eta_i{n}+Tn(k)).*denomProdv_i;
        
        %factor out one term, arbitrarily choose the j-th term
        j=n-1;
        denomProdv_i=(eta_i{j}+Tn(k))./denomProdv_i;
        
        kernelInt=numProdv_i.*denomProdv_i; %integral kernerl
        Jn(k)=mean(kernelInt)*cubeVol; % perform (q)MC step
        
    end
    
end
