% This program is an implementation of the on-line 
% Co-Active Neuro-Fuzzy Inference System (CANFIS) algorithm. 
% The structure of the network is determoned by the user.
% The premise (nonlinear) parameters are estimated by Gradient Descent (GD)
% through error backpropagation.
% The consequent (linear) parameters are estimated by Recursive LSE.

clc;
clear;
colordef black;

NumOfEpochs   = 10;
NumOfSamples = 600;
NumInVars         = 6;
NumOutVars      = 3;
NumInTerms      = 3;
lamda                 = 1;
rmse                   = zeros(NumOutVars,NumOfEpochs);
NumRules          = NumInTerms;  
Ita1                      = .00025;
Ita2                      = .0025;
alpha1                =  0.00;
alpha2                =  0.00;
P                         = 1e8*eye((NumInVars+1)*NumRules);

% INPUT-OUTPUT training pair construction.
% We will try to teach the ANFIS network the chaotic

load lorenz_data.mat;
Process  = lorenz_dat; % a (3 X 8056) Lorenz Attractor Solution [X Y Z]' Points Data Matrix. 

% Target Output is formulated as a matrix whose lines represent different
% output variables and its columns different time instants.

e         = zeros(NumOutVars,NumOfSamples);
TrgtOut   = zeros(NumOutVars,NumOfSamples);
TrgtOutCh = zeros(NumOutVars,NumOfSamples);

ThetaL4   = zeros((NumInVars+1)*NumRules,NumOutVars);  % Consequent Parameters in Layer 4.
dThetaL4 = zeros((NumInVars+1)*NumRules,NumOutVars);  

In1           = zeros(NumInVars,NumOfSamples);
In11         = zeros(NumInVars,NumOfSamples);
Out5        = zeros(NumOutVars,NumOfSamples);
ThetaE21  = zeros(NumInVars,NumInTerms);
ThetaE32  = zeros(NumRules,NumRules);
mean1    = zeros(NumInVars,NumInTerms);
sigma1   = zeros(NumInVars,NumInTerms);
dmean1  = zeros(NumInVars,NumInTerms);
dsigma1 = zeros(NumInVars,NumInTerms);
db1          = zeros(NumInVars,NumInTerms);

% Each row corresponds to a different Input Linguistic Variable Xi.
% Each i-j entry corresponds to a different mean (center) 
% of the bell-shaped function of the j-th Term of the i-th Input Linguistic
% Variable Xi.

Process0 = Process(:,1:NumOfSamples);
Process1 = Process(:,2:NumOfSamples+1);
Process2 = Process(:,3:NumOfSamples+2);

In1 = [Process1; Process0;];
%In1 = Process1;
TrgtOut = Process2;

Process0ch = Process(:,5*NumOfSamples+1:6*NumOfSamples);
Process1ch = Process(:,5*NumOfSamples+2:6*NumOfSamples+1);
Process2ch = Process(:,5*NumOfSamples+3:6*NumOfSamples+2);

%In11 = [Process1ch; Process0ch;];
In11 = Process1ch;
TrgtOutCh = Process2ch;

for i=1:NumInVars
	 mean1(i,:) = linspace(min(In1(i,:)), max(In1(i,:)),NumInTerms);  
	 sigma1(i,:) = ((mean1(i,2)-mean1(i,1))/2)*ones(1,NumInTerms);   
end
b1     = 2*ones(NumInVars,NumInTerms);   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                			Beginning of the Main "for" loop of the ANFIS  program.        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ne=1:NumOfEpochs
    
for n=1:NumOfSamples   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        								 							     				                                              %
%   			                  	NETWORK FUNCTIONALITY SECTION						      %
%      																					                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LAYER 1 - INPUT TERM NODES
In2 = In1(:,n)*ones(1,NumInTerms);
Out1 = 1./(1 + (abs((In2-mean1)./sigma1)).^(2*b1));
%precond = Out1';

% LAYER 2 - PRODUCT NODES
% Out2 = prod(precond,2);
Out2 = prod(Out1,1);
S_2 = sum(Out2);

% LAYER 3 - NORMALIZATION NODES
 Out3 = Out2/S_2;

% LAYERS 4 - 5: CONSEQUENT NODES - SUMMING NODE
Aux1 = [In1(:,n); 1]*Out3;

% New Input Training Data shaped as a column vector.
a = reshape(Aux1,(NumInVars+1)*NumRules,1);  

Out5(:,n) = ThetaL4'*a; 

e(:,n) = TrgtOut(:,n)-Out5(:,n); 

%%%%%%%%%%% END OF NETWORK FUNCTIONALITY SECTION %%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			 					PARAMETER LEARNING SECTION	                    			 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BACKWARD PASS. Error Backpropagation
% Alternatively, we may adjust the Consequent Parameters by LMS.
 for m=1:NumOutVars
       deltaThetaL4 = a*e(m,n);
     dThetaL4(:,m) = Ita1*deltaThetaL4 + alpha1*dThetaL4(:,m);           % Classic LMS.
 end
  
  % LAYER 4
for m=1:NumOutVars
        ThetaL4_mat = reshape(ThetaL4(:,m),NumInVars+1,NumRules);
        f(m,:) = [In1(:,n)' 1]*ThetaL4_mat.*e(m,n);
end

% LAYER 3
e3 = sum(f,1);

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
         if Out1(i,j)~=0
       		  ThetaE21(i,j) = (Out2(j)/Out1(i,j))*e2(j);
         end
     end 
 end
 
% LAYER 1 PARAMETER ADJUSTMENT BY GRADIENT DESCENT.  
deltamean1   = -ThetaE21.*(2*b1./(In2-mean1)).*Out1.*(1-Out1);
deltab1          = -ThetaE21.*(-2).*log(abs((In2-mean1)./sigma1)).*Out1.*(1-Out1);
deltasigma1  = -ThetaE21.*(2*b1./sigma1).*Out1.*(1-Out1);                
 
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
ThetaL4  = ThetaL4 + dThetaL4;

% Fixing of Consequent Parameters by Recursive LSE
% P = (1./lamda).*(P - P*a*a'*P./(lamda+a'*P*a));
% ThetaL4 = ThetaL4 + P*a*e(:,n)';

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

%%%%%%%%%%%% END OF PARAMETER LEARNING PROCESS %%%%%%%%%%%%

end %Of for i=1:NumOfSamples loop.

for m=1:NumOutVars
    rmse(m,ne) = norm(e(m,:))/sqrt(NumOfSamples);
end

rmse(:,ne)

end   %Of for i=1:NumOfEpochs loop.

figure
subplot(3,1,1),plot(rmse(1,:),'*r');
title('RMSE for X-coordinate');
grid on;

subplot(3,1,2),plot(rmse(2,:),'*g');
title('RMSE for Y-coordinate');
grid on;

subplot(3,1,3),plot(rmse(3,:),'*b');
title('RMSE for Z-coordinate');
grid on;

X = 1:NumOfSamples;
figure;
subplot(3,2,1)
plot(X,TrgtOut(1,:),'r',X,Out5(1,:),'m');
title('Training Target X-coordinate (Red) VS ANFIS X Output (Magenta)')
grid on;

subplot(3,2,2)
plot(X,e(1,:),'r')
title('Training Error(n) for X-coordinate') 
grid on;

subplot(3,2,3)
plot(X,TrgtOut(2,:),'b',X,Out5(2,:),'c');
title('Training Target Y-coordinate (Blue) VS ANFIS Y Output (Cyan)')
grid on;

subplot(3,2,4)
plot(X,e(2,:),'b')
title('Training Error(n) for Y-coordinate') 
grid on;

subplot(3,2,5)
plot(X,TrgtOut(3,:),'g',X,Out5(3,:),'y');
title('Training Target Z-coordinate (Green) VS ANFIS Z Output (Yellow)')
grid on;

subplot(3,2,6)
plot(X,e(3,:),'g')
title('Training Error(n) for Z-coordinate') 
grid on

%% %%% %%%%%%% Gradient Checking Section %%%%%%%%%%%%%
ThetaJ_mean = zeros(NumInVars,NumInTerms);
ThetaJ_sigma = zeros(NumInVars,NumInTerms);
ThetaJ_b         = zeros(NumInVars,NumInTerms);
epsilon             = 1e-4;

for i=1:NumInVars
    for j=1:NumInTerms
        
        mean1_up = mean1;
        mean1_do = mean1;

        mean1_up(i,j) = mean1(i,j) + epsilon; 
        mean1_do(i,j) = mean1(i,j) - epsilon;
        
        J_up_mean = sum(1/2*(TrgtOut(:,n) - canfis_scatter_forward(In1(:,n),mean1_up,sigma1,b1,ThetaL4_old)).^2);
        J_do_mean = sum(1/2*(TrgtOut(:,n) - canfis_scatter_forward(In1(:,n),mean1_do,sigma1,b1,ThetaL4_old)).^2);

        ThetaJ_mean(i,j) = (J_up_mean - J_do_mean)/2/epsilon;
      
        sigma1_up = sigma1;
        sigma1_do = sigma1;
        
        sigma1_up(i,j) = sigma1(i,j) + epsilon; 
        sigma1_do(i,j) = sigma1(i,j) - epsilon;
        
        J_up_sigma = sum(1/2*(TrgtOut(:,n) - canfis_scatter_forward(In1(:,n),mean1,sigma1_up,b1,ThetaL4_old)).^2);
        J_do_sigma = sum(1/2*(TrgtOut(:,n) - canfis_scatter_forward(In1(:,n),mean1,sigma1_do,b1,ThetaL4_old)).^2);

        ThetaJ_sigma(i,j) = (J_up_sigma - J_do_sigma)/2/epsilon;

        b1_up = b1;
        b1_do = b1;

        b1_up(i,j) = b1(i,j) + epsilon; 
        b1_do(i,j) = b1(i,j) - epsilon;
        
        J_up_b = sum(1/2*(TrgtOut(:,n) - canfis_scatter_forward(In1(:,n),mean1,sigma1,b1_up,ThetaL4_old)).^2);
        J_do_b = sum(1/2*(TrgtOut(:,n) - canfis_scatter_forward(In1(:,n),mean1,sigma1,b1_do,ThetaL4_old)).^2);

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













