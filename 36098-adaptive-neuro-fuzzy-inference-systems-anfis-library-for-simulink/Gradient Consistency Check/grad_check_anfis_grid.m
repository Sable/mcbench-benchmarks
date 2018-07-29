% This program is an implementation of the on line ANFIS algorithm.
% The structure of the network is determoned by the user.
% The premise (nonlinear) parameters are estimated by Gradient Descent (GD)
% through error backpropagation.
% The consequent (linear) parameters are estimated by Recursive LSE.

% BOX-JENKINS furnace data identification. 

clc;
clear;
close all;
colordef black;
close all;

%% ANFIS Parameters Definition.
Samples               = 290;
NumOfEpochs     = 20;
NumOfSamples   = 160;
Mi                          = 4;
NumInVars           = Mi;
NumOutVars        = 1;
NumInTerms        = 2;
Ita1                       = 1;
Ita2                       = 0.5;   
alpha1                  = 0;
alpha2                  = 0;
lamda                   = 1;
rmse                     = zeros(NumOfEpochs,1);

NumRules = NumInTerms^NumInVars;  

% INPUT-OUTPUT training pair construction.
% We will try to teach the ANFIS network the Box-Jenkins CO2 furnace data.

Out1     = zeros(NumInVars,NumInTerms);
Out2     = zeros(NumInVars,NumInTerms);
Out3     = zeros(NumInVars,1);
Out5     = zeros(NumOfSamples,1);
P           = 1e8*eye((NumInVars+1)*NumRules);
ThetaE = zeros(NumInVars,NumInTerms);

bjdata;
%                 [                 y(t-1);                                         y(t-2);                                        u(t-1);                                       u(t-2);               ]    
In1        = [bj(1:NumOfSamples,2)';         bj(1:NumOfSamples,3)';         bj(1:NumOfSamples,6)';         bj(1:NumOfSamples,7)';];
In11      = [bj(NumOfSamples+1:Samples,2)'; bj(NumOfSamples+1:Samples,3)'; bj(NumOfSamples+1:Samples,6)'; bj(NumOfSamples+1:Samples,7)';];

for i=1:NumInVars
     inwidth(i)  = max(In1(i,:))-min(In1(i,:));
     incenterval(i)  = (max(In1(i,:))+min(In1(i,:)))/2;
    min_inval(i) = min(In1(i,:));
end

% Target Vector Formulation. It is the prediction of the Process one step ahead.
     TrgtOut   = bj(1:NumOfSamples,1)';
     TrgtOutCh = bj(NumOfSamples+1:Samples,1)';

for i=1:NumOutVars
    outwidth(i)  = max(TrgtOut)-min(TrgtOut);
    outcenterval(i)  = (max(TrgtOut)+min(TrgtOut))/2;
    min_outval(i) = min(TrgtOut(i,:));
end
     
ThetaL4  = zeros((NumInVars+1)*NumRules,1); 
dThetaL4 = zeros((NumInVars+1)*NumRules,1); 

mean1   = zeros(NumInVars,NumInTerms);
sigma1  = zeros(NumInVars,NumInTerms);
b1           = zeros(NumInVars,NumInTerms);
dmean1 = zeros(NumInVars,NumInTerms);
dsigma1 = zeros(NumInVars,NumInTerms);
db1         = zeros(NumInVars,NumInTerms);

% Each row corresponds to a different Input Linguistic Variable Xi.
% Each i-j entry corresponds to a different mean (center) 
% of the bell-shaped function of the j-th Term of the i-th Input Linguistic
% Variable Xi.

% Input Scaling
In1 = 2*(In1-repmat(incenterval.',1,NumOfSamples))./repmat(inwidth.',1,NumOfSamples);

% Output Scaling
TrgtOut = 2*(TrgtOut-repmat(outcenterval.',1,NumOfSamples))./repmat(outwidth.',1,NumOfSamples);

for i=1:NumInVars
   mean1(i,:) = linspace(min(In1(i,:)),max(In1(i,:)),NumInTerms);  
   sigma1(i,:) = ((mean1(i,2) - mean1(i,1))/2)*ones(1,NumInTerms);   
end
    b1 = 2*ones(NumInVars,NumInTerms);   

 % plotgenbell(mean1,sigma1,b1,[-5,5]);

% Keep initial parameter values.
mean1ini = mean1;
sigma1ini = sigma1;
b1ini = b1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                			Beginning of the Main "for" loop of the ANFIS  program.        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
counter1 = 0;
for ne=1:NumOfEpochs

    e = zeros(NumOutVars,NumOfSamples);

for n=1:NumOfSamples   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        								 							     				                                              %
%   			                  	NETWORK FUNCTIONALITY SECTION						      %
%      																					                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LAYER 1 - INPUT TERM NODES
In2 = In1(:,n)*ones(1,NumInTerms);
Out1 = 1./(1 + (abs((In2-mean1)./sigma1)).^(2*b1));

% LAYER 2 - PRODUCT NODES
 precond = comb(Out1); 
 Out2 = prod(precond,2);
 S_2 = sum(Out2);

 % LAYER 3 - NORMALIZATION NODES
 Out3 = Out2'/S_2;
    
% LAYERS 4 - 5: CONSEQUENT NODES - SUMMING NODE
 Aux1 = [In1(:,n); 1]*Out3;
 
% New Input Training Data shaped as a column vector.
 a = reshape(Aux1,(NumInVars+1)*NumRules,1);  

Out5(n) = a'*ThetaL4; 
e(n) = TrgtOut(n) - Out5(n);
 
%%%%%%% END OF NETWORK FUNCTIONALITY SECTION %%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			 					PARAMETER LEARNING SECTION	                    			 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BACKWARD PASS. Error Backpropagation
% Fixing of Consequent Parameters by LMS.
% deltaThetaL4 = a*e(n);
% dThetaL4 = Ita1*deltaThetaL4 + alpha1*dThetaL4;

% LAYER 4
ThetaL4_mat = reshape(ThetaL4,NumInVars+1,NumRules);

% LAYER 3
e3 = [In1(:,n)' 1]*ThetaL4_mat*e(n);

denom = S_2*S_2;
% LAYER 2
 ThetaE32 = zeros(NumRules,NumRules);
for k1=1:NumRules
     for k2=1:NumRules
           if k1==k2
              ThetaE32(k1,k2) = ((S_2-Out2(k2))/denom)*e3(k2);
           else
              ThetaE32(k1,k2) = -(Out2(k2)/denom)*e3(k2);
           end
      end
end

% Sum Theta32 along rows to find the contribution of each L3 node
% (indexed by k2) to a single L2 node (indexed by k1).
e2 = sum(ThetaE32,2);

% LAYER 1
Q = zeros(NumInVars,NumInTerms,NumRules);  
for i=1:NumInVars
     for j=1:NumInTerms
          for k=1:NumRules  
                if Out1(i,j)== precond(k,i)  && Out1(i,j)~=0
      			    Q(i,j,k) = (Out2(k)/Out1(i,j))*e2(k);
                end
          end 
   	  end 
 end

ThetaE21 = sum(Q,3);
              
% LAYER 1 PARAMETER ADJUSTMENT BY GRADIENT DESCENT.  
deltamean1   = -ThetaE21.*(2*b1./(In2-mean1)).*Out1.*(1-Out1);
deltab1          = -ThetaE21.*(-2).*log(abs((In2-mean1)./sigma1)).*Out1.*(1-Out1);
deltasigma1  = -ThetaE21.*(2*b1./sigma1).*Out1.*(1-Out1);                
 
% dmean1 = -Ita2*deltamean1 + alpha2*dmean1
% mean1 = mean1 + dmean1;
% 
% dsigma1 = -Ita2*deltasigma1 + alpha2*dsigma1;
% sigma1 = sigma1 + dsigma1;
% 
% db1 = -Ita2*deltab1 + alpha2*db1;
% b1 = b1 + db1;

% Now update the Layer 4 linear parameters.
ThetaL4_old = ThetaL4;  % Keep here the old values of ThetaL4.
% Fixing of Consequent Parameters by LMS.
% ThetaL4  = ThetaL4 + dThetaL4;

% Fixing of Consequent Parameters by RLS.
P = (1./lamda).*(P - P*a*a'*P./(lamda+a'*P*a));
ThetaL4 = ThetaL4 + P*a*e(n);

% Sort the terms in Layer 1.
% for i=1:NumInTerms-1
%     if ~isempty(find(mean1(:,i)>mean1(:,i+1)))
%         counter1 = counter1 + 1;
%         for i=1:NumInVars
%            [mean1(i,:) index1] = sort(mean1(i,:));
%            sigma1(i,:) = sigma1(i,index1);
%            b1(i,:) = b1(i,index1);
%         end
%     end
% end

%%%%%%%%%%%% END OF PARAMETER LEARNING PROCESS %%%%%%%%%%%%
% plotbell(mean1,sigma1,[-2,2]);

end %Of for i=1:NumOfSamples loop.

rmse(ne,1) = norm(e)/sqrt(NumOfSamples);

rmse(ne,1)

end   %Of for i=1:NumOfEpochs loop.

%% Plot the results.
figure;
subplot(3,1,1),
plot(rmse,'*r');
title('RMSE');
grid on

X = 1:NumOfSamples;
subplot(3,1,2)
plot(X,TrgtOut,'b',X,Out5,'g')
axis tight;
title('Target Output(Blue) VS Actual Output(Green)') 
grid on

subplot(3,1,3),plot(e,'y')
axis tight;
title('Approximation Error(n)') 
grid on



%% %%% %%%%%%% Gradient Checking Section %%%%%%%%%%%%%
ThetaJ_mean = zeros(NumInVars,NumInTerms);
ThetaJ_sigma = zeros(NumInVars,NumInTerms);
ThetaJ_b         = zeros(NumInVars,NumInTerms);
epsilon             = 1e-5;

for i=1:NumInVars
    for j=1:NumInTerms
        
        mean1_up = mean1;
        mean1_do = mean1;

        mean1_up(i,j) = mean1(i,j) + epsilon; 
        mean1_do(i,j) = mean1(i,j) - epsilon;
        
        J_up_mean = 1/2*(TrgtOut(n) - anfis_grid_forward(In1(:,n),mean1_up,sigma1,b1,ThetaL4_old))^2;
        J_do_mean = 1/2*(TrgtOut(n) - anfis_grid_forward(In1(:,n),mean1_do,sigma1,b1,ThetaL4_old))^2;

        ThetaJ_mean(i,j) = (J_up_mean - J_do_mean)/2/epsilon;
      
        sigma1_up = sigma1;
        sigma1_do = sigma1;
        
        sigma1_up(i,j) = sigma1(i,j) + epsilon; 
        sigma1_do(i,j) = sigma1(i,j) - epsilon;
        
        J_up_sigma = 1/2*(TrgtOut(n) - anfis_grid_forward(In1(:,n),mean1,sigma1_up,b1,ThetaL4_old))^2;
        J_do_sigma = 1/2*(TrgtOut(n) - anfis_grid_forward(In1(:,n),mean1,sigma1_do,b1,ThetaL4_old))^2;

        ThetaJ_sigma(i,j) = (J_up_sigma - J_do_sigma)/2/epsilon;

        b1_up = b1;
        b1_do = b1;

        b1_up(i,j) = b1(i,j) + epsilon; 
        b1_do(i,j) = b1(i,j) - epsilon;
        
        J_up_b = 1/2*(TrgtOut(n) - anfis_grid_forward(In1(:,n),mean1,sigma1,b1_up,ThetaL4_old))^2;
        J_do_b = 1/2*(TrgtOut(n) - anfis_grid_forward(In1(:,n),mean1,sigma1,b1_do,ThetaL4_old))^2;

        ThetaJ_b(i,j) = (J_up_b - J_do_b)/2/epsilon;

    end
end


rel_diff_mean  = deltamean1(:) - ThetaJ_mean(:);
rel_diff_sigma = deltasigma1(:) - ThetaJ_sigma(:);
rel_diff_b         = deltab1(:) - ThetaJ_b(:);

[rel_diff_mean rel_diff_sigma rel_diff_b]

[deltamean1(:)   ThetaJ_mean(:) ]

[deltasigma1(:)  ThetaJ_sigma(:)]

[deltab1(:)           ThetaJ_b(:)        ]