%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimators for linear stationary AR(FI)MA(p,d,q)
% processes. 
%
% Input arguments:
%
%   Z          : the time series input for the estimation
%
%   modeltype  : 'FWHI' or 'FML' for arfima(p,d,q) model estimation
%                 NOTE: it is currently implemented assuming that
%                       the noise sequence is gaussian 
%
%   arma_part  : the AR and MA lag respectively, eg.[1 2]
%                for ARFIMA(1,d,2) 
%
% Output arguments: 
%
%   model      : parameters and descriptive statistics returned
%                in a data structure
%                
%                mean : sample mean 
%          
%                   d : the fractional differencing parameter
%
%                  AR : AR(1 ... p) parameters
%
%                  MA : MA(1 ... q) parameters
%
%              sigma2 : the gaussian noise seq.'s variance
%
%        loglikelihood: the log likelihood function value @params
% 
%              akaike : the Akaike information criterion
%
%              errors : the estimated noise sequence (for further
%                       investigation)
%
%            fit_stas : the goodness of fit statistic - see: 
%                       help arfima_gof 
% 
% Note: the Whittle estimator is very sensitive to the starting 
%       value, so for lag selection, it is better to use the 
%       exact maximum likelihood method. 
%
% (c) György Inzelt 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [model] = arfima_estimate(Z,modeltype,arma_part)

model = struct('mean',[],'d',[],'AR',[],'MA',[],'sigma2',[],'loglikelihood',[],'akaike',[],'errors',[],'fit_stats',[]);

switch(modeltype)
    case('FWHI')
       %computing starting values: d 
       d = arfima_perreg(Z);
       Uhat = d_filter(d,Z);
       
       startingval = armaxfilter(Uhat,1,(1:arma_part(1)),(1:arma_part(2)));
       s = size(startingval);
       
       if length(startingval)==s(1) , startingval = startingval';end
       startingval = [d startingval(2:length(startingval))]; 
       
       Lb = -1.99*ones(1,1+sum(arma_part));
       Ub =  1.99*ones(1,1+sum(arma_part));%works even with d > 0.5 (the non-stationary case)
       Lb(1) = -1;
       Ub(1) = 0.4999;
       
       if arma_part(2) ~=0
       Lb(arma_part(1)+2:length(Lb)) = -Inf;
       Ub(arma_part(1)+2:length(Ub)) = Inf;
       end
       
       opt1 = optimset('Algorithm','active-set');
       if arma_part(1)==0
            [params_WHI,wn_var,EFLAG,OUTPUT,LAMBDA,GRAD,D2LL] = fmincon(@(params) arfima_whittle(params,Z-mean(Z),arma_part),startingval,[],[],[],[],Lb,Ub,[],opt1); 
            %if the algorithm got stuck at a suboptimal value
            if sum(LAMBDA.upper)~=0 || sum(LAMBDA.lower)~=0    
            [params_WHI,wn_var,EFLAG,OUTPUT,LAMBDA,GRAD,D2LL] = fmincon(@(params) arfima_whittle(params,Z-mean(Z),arma_part),[0 startingval(2:length(startingval))],[],[],[],[],Lb,Ub,[],opt1); 
            end
       elseif arma_part(1)~=0
            [params_WHI,wn_var,EFLAG,OUTPUT,LAMBDA,GRAD,D2LL] = fmincon(@(params) arfima_whittle(params,Z-mean(Z),arma_part),startingval,[],[],[],[],Lb,Ub,@(params) ar_constraint(params,arma_part),opt1); 
            %if the algorithm got stuck at a suboptimal value
            if sum(LAMBDA.upper)~=0 || sum(LAMBDA.lower)~=0    
            [params_WHI,wn_var,EFLAG,OUTPUT,LAMBDA,GRAD,D2LL] = fmincon(@(params) arfima_whittle(params,Z-mean(Z),arma_part),[0 startingval(2:length(startingval))],[],[],[],[],Lb,Ub,@(params) ar_constraint(params,arma_part),opt1); 
            end
       end
      
      %calculating the white noise variance and the MLE parameter estimates' std errors
      params_WHI_stds =  diag(sqrt((1/length(Z))*inv(D2LL)));
      
      params_WHI = [params_WHI; params_WHI_stds'];
      
      [pval,Tn] = arfima_gof(Z-mean(Z),params_WHI(1,:),arma_part,wn_var);
      
      model.fit_stats = [pval;Tn];
      
      model.mean = mean(Z);
      model.d = params_WHI(:,1);
      
      if arma_part(1) > 0
      model.AR = params_WHI(:,2:2+arma_part(1)-1) ;
      else
      model.AR = [];
      end    
      
      if arma_part(2) > 0
      model.MA = params_WHI(:,2+arma_part(1):1+sum(arma_part)) ;
      else
      model.MA = [];
      end
      
      model.sigma2 = wn_var;
      
      gamma_s = arfima_covs(length(Z),[params_WHI(1,:) model.sigma2(1)],arma_part);
     [v,L] = durlevML(gamma_s);
      L = reshape(L,length(Z),length(Z))';
      e = L*(Z-model.mean(1));
      
      model.errors = e;
      
      model.loglikelihood = -arfima_exactlik([params_WHI(1,:) mean(Z) wn_var],Z,arma_part);
      
      AIC = @(vars) ( -2*vars(1)/vars(2) + 2*vars(3)/vars(2) );
      
      model.akaike = AIC([model.loglikelihood length(Z) (sum(arma_part) + 3 ) ]);
      
      if sum(LAMBDA.upper)~=0 || sum(LAMBDA.lower)~=0 || model.loglikelihood == -Inf,...
              fprintf('\nAlgorithm did not converge,possibly due to model mis-specification'),return,end
      
    case('FML')
       d = arfima_perreg(Z);
       Uhat = d_filter(d,Z);
       %ARMA parameters
       [startingval,ll,ers] = armaxfilter(Uhat,1,(1:arma_part(1)),(1:arma_part(2)));
       s = size(startingval);
       
       if length(startingval)==s(1) , startingval = startingval';end
       startingval = [ d startingval(2:length(startingval)) mean(Z) var(ers)]; 
       
       opt1 = optimset('Algorithm','active-set','MaxFunEvals',length(Z));
           
        Lb = zeros(1,1 + sum(arma_part)  + 2);
        Ub = zeros(1,1 + sum(arma_part)  + 2);

        Lb(1,1) = -1;%d bounds
        Ub(1,1) = 0.5;%
         
        Lb(1,2:length(Lb)-1) = -1.99;%ARMA bounds
        Ub(1,2:length(Lb)-1) = 1.99;

        if arma_part(2) ~=0
        Lb(arma_part(1)+2:length(Lb)-2) = -Inf;
        Ub(arma_part(1)+2:length(Lb)-2) = Inf;
        end
        
        Lb(1,2:length(Lb)-1) = -Inf;%mean bounds 
        Ub(1,2:length(Ub)-1) = Inf;

        Lb(1,length(Lb)) = 0;%noise var bounds
        Ub(1,length(Ub)) = Inf;

        startingval = startingval(1,:);
        startingval(1,1) = min(0.4999,startingval(1,1));

        out1=0;out2=0;count=0;

        while(out1==0 || out2==0)
            if arma_part(1) ==0
                [params_MLExact,LL,EFLAG,OUTPUT,LAMBDA,GRAD,D2LL] = fmincon(@(params) arfima_exactlik(params,Z,arma_part),startingval ,[],[],[],[],Lb,Ub,[],opt1);
            elseif arma_part(1)~=0 
                [params_MLExact,LL,EFLAG,OUTPUT,LAMBDA,GRAD,D2LL] = fmincon(@(params) arfima_exactlik(params,Z,arma_part),startingval ,[],[],[],[],Lb,Ub,@(params) ar_constraint(params,arma_part) ,opt1); 
            end
            out1=(sum(LAMBDA.upper)==0);out2=(sum(LAMBDA.lower)==0);
            startingval = 0.1*rand(1,1+sum(arma_part));
            count=count+1;
            if count ==10,break,end %to avoid an infinite cycle
        end
    
        params_MLExact = [params_MLExact; diag(sqrt(inv(D2LL)))'];
    
        model.mean = params_MLExact(:,length(params_MLExact)-1);
        
      [pval,Tn] = arfima_gof(Z-model.mean(1),params_MLExact(1,1:length(params_MLExact)-2),arma_part,params_MLExact(1,length(params_MLExact)));
      
      model.fit_stats = [pval;Tn];
      
      model.d = params_MLExact(:,1);
      
      if arma_part(1) > 0
      model.AR = params_MLExact(:,2:2+arma_part(1)-1) ;
      else
      model.AR = [];
      end    
      
      if arma_part(2) > 0
      model.MA = params_MLExact(:,2+arma_part(1):1+sum(arma_part)) ;
      else
      model.MA = [];
      end
     
      model.sigma2 = params_MLExact(:,length(params_MLExact));
      
      %calculating the estimated noise sequence for further investigation
      gamma_s = arfima_covs(length(Z),params_MLExact(1,:),arma_part);
     [v,L] = durlevML(gamma_s);
      L = reshape(L,length(Z),length(Z))';
      e = L*(Z-model.mean(1));
      
      model.errors = e;
      
      model.loglikelihood = -LL;
      
      AIC = @(vars) ( -2*vars(1)/vars(2) + 2*vars(3)/vars(2) );
      
      model.akaike = AIC([model.loglikelihood length(Z) (sum(arma_part) + 3 ) ]);
      
      if sum(LAMBDA.upper)~=0 || sum(LAMBDA.lower)~=0 || model.loglikelihood == -Inf,...
              fprintf('\nAlgorithm did not converge,possibly due to model mis-specification'),return,end
    otherwise
    disp('Unknown modeltype');
    return;    
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[d] = arfima_perreg(Z)
  % the periodogram regression does not yield satisfactory 
  % results, so this time it is used as a helping function 
  [Pxx,w] = periodogram(Z-mean(Z));
  Y = log(Pxx);
  w(1,1) = w(2,1)/2;
  %preliminary calculations
  x = exp(-sqrt(-1)*w);  
  x = abs(1-x);
  %zero should not be there
  x(1,1) = abs(1-exp(-sqrt(-1)*w(1,1)));
  x(2:length(x),1) = x(2:length(x),1).^2;
  x(1,1) = log(x(1,1)^2);
  x(2:length(x),1) = log(x(2:length(x),1));
  xj = [ones(length(x),1)  x];
  ind_d = ceil(length(Z)^0.8);%you can select the bandwidth here
 [B] = regress(Y(1:ind_d,1),xj(1:ind_d,1:2));
  d = -B(2);
  %vard = (imag(log(-1))^2)/(6*sum((x(1:ind_d,1) - mean(x(1:ind_d,1))).^2));  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

