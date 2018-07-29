% This program is an implementation of the on line ANFIS algorithm.
% The structure of the network is determoned by the user.
% The premise (nonlinear) parameters are estimated by Gradient Descent (GD)
% through error backpropagation.
% The consequent (linear) parameters are estimated by Recursive LSE.

clc;
clear;
close all;
colordef black;

NumOfEpochs    = 10;
NumOfSamples  = 600;
Mi                         = 3;
NumInVars          = Mi;
NumOutVars       = 1;
NumInTerms        = 3;
Ita1                       = 0.25;
Ita2                       = 1;
alpha1                  = 0;
alpha2                  = 0;
lamda                   = 1;
rmse                     = zeros(NumOfEpochs,1);

NumRules = NumInTerms;  

% INPUT-OUTPUT training pair construction.
% We will try to teach the ANFIS network the Box-Jenkins CO2 furnace data.

Out1         = zeros(NumInVars,NumInTerms);
Out2         = zeros(NumInVars,NumInTerms);
Out3         = zeros(NumInVars,1);
Out5         = zeros(NumOfSamples,1);
P               = 1e8*eye((NumInVars+1)*NumRules);
ThetaE21 = zeros(NumInVars,NumInTerms);

Process  = mg(10*NumOfSamples);  
% Target Output is formulated as a matrix whose lines represent different
% output variables and its columns different time instants.

TrgtOut       = Process(Mi+1:NumOfSamples+Mi);  
Checkdata = Process(6*NumOfSamples+Mi+1:9*NumOfSamples+Mi);

ThetaL4   = zeros((NumInVars+1)*NumRules,1);  % Consequent Parameters in Layer 4.
dThetaL4 = zeros((NumInVars+1)*NumRules,1); 

In1     = zeros(NumInVars,NumOfSamples);
mean1   = zeros(NumInVars,NumInTerms);
sigma1  = zeros(NumInVars,NumInTerms);
dmean1  = zeros(NumInVars,NumInTerms);
dsigma1 = zeros(NumInVars,NumInTerms);
db1     = zeros(NumInVars,NumInTerms);

% Each row corresponds to a different Input Linguistic Variable Xi.
% Each i-j entry corresponds to a different mean (center) 
% of the bell-shaped function of the j-th Term of the i-th Input Linguistic
% Variable Xi.

for h=Mi:NumOfSamples+NumInVars-1   
   for m=Mi:-1:1
     In1(Mi-m+1,h-Mi+1) = Process(h-Mi+m);
   end              
end

ThetaL4 = zeros((NumInVars+1)*NumRules,1);  % Consequent Parameters in Layer 4.

% Each row corresponds to a different Input Linguistic Variable Xi.
% Each i-j entry corresponds to a different mean (center) 
% of the bell-shaped function of the j-th Term of the i-th Input Linguistic
% Variable Xi.

m1     = linspace(0,1,NumInTerms);  
mean1  = ones(NumInVars,1)*m1; 
sigma1 = 0.2*ones(NumInVars,NumInTerms);   
b1     = 2*ones(NumInVars,NumInTerms);   

% plotgenbell(mean1,sigma1,b1,[-2,2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                			Beginning of the Main "for" loop of the ANFIS  program.        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
counter1 = 0;
for ne=1:NumOfEpochs
e = zeros(NumOutVars,NumOfSamples);

for n=1:NumOfSamples   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        								 							     				   %
%   			                  	NETWORK FUNCTIONALITY SECTION						   %
%      																					   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LAYER 1 - INPUT TERM NODES
In2 = In1(:,n)*ones(1,NumInTerms);
Out1 = 1./(1 + (abs((In2-mean1)./sigma1)).^(2*b1));
 
% LAYER 2 - PRODUCT NODES
Out2 = prod(Out1,1);
 S_2 = sum(Out2);

 % LAYER 3 - NORMALIZATION NODES
 Out3 = Out2.'/S_2;
    
% LAYERSS 4 - 5: CONSEQUENT NODES - SUMMING NODE
 Aux1 = [In1(:,n); 1]*Out3';

  % New Input Training Data shaped as a column vector.
 a = reshape(Aux1,(NumInVars+1)*NumRules,1); 

Out5(n) = a'*ThetaL4; 
 
 e(n) = TrgtOut(n)- Out5(n);

%%%%%%%% END OF NETWORK FUNCTIONALITY SECTION %%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			 					PARAMETER LEARNING SECTION	                    			 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BACKWARD PASS. Error Backpropagation
% deltaThetaL4 = a*e(n);
% dThetaL4 = Ita1*deltaThetaL4 + alpha1*dThetaL4;

% LAYER 4
ThetaL4_mat = reshape(ThetaL4,NumInVars+1,NumRules);

% LAYER 3
e3 = [In1(:,n)' 1]*ThetaL4_mat.*e(n);

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
ThetaE21 = zeros(NumInVars,NumInTerms);  
for i=1:NumInVars
     for j=1:NumInTerms
       		  ThetaE21(i,j) = (Out2(j)/Out1(i,j))*e2(j);
     end 
 end

% LAYER 1 PARAMETER ADJUSTMENT BY GRADIENT DESCENT.  
deltamean1  = - ThetaE21.*(2*b1./(In2-mean1)).*Out1.*(1-Out1);
deltab1         = - ThetaE21.*(-2).*log(abs((In2-mean1)./sigma1)).*Out1.*(1-Out1);
deltasigma1 = - ThetaE21.*(2*b1./sigma1).*Out1.*(1-Out1);                

% dmean1 = -Ita2*deltamean1 + alpha2*dmean1;
% mean1 = mean1 + dmean1;
% 
% dsigma1 = -Ita2*deltasigma1 + alpha2*dsigma1;
% sigma1 = sigma1 + dsigma1;
% 
% db1 = -Ita2*deltab1 + alpha2*db1;
% b1 = b1 + db1;

% Now update the Layer 4 linear parameters.
 ThetaL4_old = ThetaL4;  % Keep here the old values of ThetaL4.

 % Fixing of Consequent Parameters by Recursive LMS.
%ThetaL4  = ThetaL4 + dThetaL4;

% Fixing of Consequent Parameters by Recursive LSE
 P = (1./lamda).*(P - P*a*a'*P./(lamda+a'*P*a));
 ThetaL4 = ThetaL4 + P*a.*e(n);

% Sort the terms in Layer 1.
% for i=1:NumInTerms-1
%     if ~isempty(find(mean1(:,i)>mean1(:,i+1)))
%          counter1 = counter1 + 1;
%         for i=1:NumInVars
%            [mean1(i,:) index1] = sort(mean1(i,:));
%            sigma1(i,:) = sigma1(i,index1);
%            b1(i,:) = b1(i,index1);
%         end
%     end
% end

%%%%%%%%%%% END OF PARAMETER LEARNING PROCESS %%%%%%%%%%
% plotbell(mean1,sigma1,[-2,2]);

end %Of for i=1:NumOfSamples loop.

rmse(ne,1) = norm(e)/sqrt(NumOfSamples);
rmse(ne,1)

end   %Of for i=1:NumOfEpochs loop.

figure
subplot(3,1,1),semilogy(rmse,'*r');
title('RMSE');
grid on

X = 1:NumOfSamples;
subplot(3,1,2)
plot(X,TrgtOut,'b',X,Out5,'g')
title('Target Output(Blue) VS Actual Output(Green)') 
grid on

subplot(3,1,3),plot(e,'y')
title('Approximation Error(n)') 
grid on

% plotgenbell(mean1,sigma1,b1,[-2,2]);


%% %%%%%%%  Gradient Checking Section  %%%%%%%%%%%%%%
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
        
        J_up_mean = 1/2*(TrgtOut(n) - anfis_scatter_forward(In1(:,n),mean1_up,sigma1,b1,ThetaL4_old))^2;
        J_do_mean = 1/2*(TrgtOut(n) - anfis_scatter_forward(In1(:,n),mean1_do,sigma1,b1,ThetaL4_old))^2;

        ThetaJ_mean(i,j) = (J_up_mean - J_do_mean)/2/epsilon;
      
        sigma1_up = sigma1;
        sigma1_do = sigma1;
        
        sigma1_up(i,j) = sigma1(i,j) + epsilon; 
        sigma1_do(i,j) = sigma1(i,j) - epsilon;
        
        J_up_sigma = 1/2*(TrgtOut(n) - anfis_scatter_forward(In1(:,n),mean1,sigma1_up,b1,ThetaL4_old))^2;
        J_do_sigma = 1/2*(TrgtOut(n) - anfis_scatter_forward(In1(:,n),mean1,sigma1_do,b1,ThetaL4_old))^2;

        ThetaJ_sigma(i,j) = (J_up_sigma - J_do_sigma)/2/epsilon;

        b1_up = b1;
        b1_do = b1;

        b1_up(i,j) = b1(i,j) + epsilon; 
        b1_do(i,j) = b1(i,j) - epsilon;
        
        J_up_b = 1/2*(TrgtOut(n) - anfis_scatter_forward(In1(:,n),mean1,sigma1,b1_up,ThetaL4_old))^2;
        J_do_b = 1/2*(TrgtOut(n) - anfis_scatter_forward(In1(:,n),mean1,sigma1,b1_do,ThetaL4_old))^2;

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