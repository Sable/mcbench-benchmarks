% This program is an implementation of the on line ANFIS-ART algorithm.
% The structure of the network is determoned by the Fuzzy ART clustering method.
% The premise (nonlinear) parameters are estimated by Gradient Descent (GD)
% through error backpropagation.
% The consequent (linear) parameters are estimated by Recursive LSE.

clc;
clear;
close all;
colordef black;

NumOfEpochs   = 5;
NumOfSamples = 500;
NumInVars          = 2;
NumOutVars       = 1;
NumInTerms        = 1;
NumOutTerms     = 1;
NumRules            = NumInTerms;
Ita1                       = 1;
Ita2                       = 0.05;
alpha1                  = 0; 
alpha2                  = 0.01; 
lamda                   = 1;
gamma                 = 2;
Mi                          = NumInVars;
Ni                           = NumOutVars;
                                                    
% INPUT-OUTPUT training pair construction.
% We will try to teach the ANFIS network the chaotic
% Mackey-Glass time series.                                                                                                                             

Out1         = zeros(NumInVars,NumInTerms);
Out2         = zeros(NumRules,1);
Out3         = zeros(1,NumRules);
Out5         = zeros(NumOfSamples,1);
P               = 1e6*eye((NumInVars+1)*NumRules);
ThetaE21 = zeros(NumInVars,NumInTerms);
ThetaE32 = zeros(NumRules,NumRules);
ThetaL4    = zeros((NumInVars+1)*NumRules,1);  % Consequent Parameters in Layer 4.
dThetaL4  = zeros((NumInVars+1)*NumRules,1); 

Process  = mg(10*NumOfSamples);  
% Target Output is formulated as a matrix whose lines represent different
% output variables and its columns different time instants.
for h=Mi:NumOfSamples+NumInVars-1   
   for m=Mi:-1:1
         In1(Mi-m+1,h-Mi+1) = Process(h-Mi+m);
       In11(Mi-m+1,h-Mi+1) = Process(6*NumOfSamples+h-Mi+m);
   end              
end

inwidth   = max(In1,[],2) - min(In1,[],2);
min_inval = min(In1,[],2);

% Target Vector Formulation. It is the prediction of the Process six steps ahead.
steps_ahead = 1; % This input data formulation is valid only for NumInVars = 2.
for h=Ni:NumOfSamples+NumOutVars-1   
     for m=Ni:-1:1
          TrgtOut(Ni-m+1,h-Ni+1)      = Process(h-Ni+m+1+steps_ahead);
          TrgtOutCh(Ni-m+1,h-Ni+1) = Process(6*NumOfSamples+h-Ni+m+1+steps_ahead);
     end              
end

% outwidth   = max(TrgtOut)-min(TrgtOut);
% min_outval = min(TrgtOut);

% Training Data Normalization and Complement Coding to be ready for Fuzzy ART.
A_train = [(In1 - min_inval*ones(1,NumOfSamples))./(inwidth*ones(1,NumOfSamples)); 
                  1 - (In1 - min_inval*ones(1,NumOfSamples))./(inwidth*ones(1,NumOfSamples))]; 

% B_train = [(TrgtOut - min_outval*ones(1,NumOfSamples))./(outwidth*ones(1,NumOfSamples));
%                 1 - (TrgtOut - min_outval*ones(1,NumOfSamples))./(outwidth*ones(1,NumOfSamples))];

% Checking Data Normalization and Complement Coding.
A_check = [(In11 - min_inval*ones(1,NumOfSamples))./(inwidth*ones(1,NumOfSamples)); 
                    1 - (In11 - min_inval*ones(1,NumOfSamples))./(inwidth*ones(1,NumOfSamples))]; 

%B_check = [(TrgtOutCh - min_outval*ones(1,NumOfSamples))./(outwidth*ones(1,NumOfSamples));
%                     1 - (TrgtOutCh - min_outval*ones(1,NumOfSamples))./(outwidth*ones(1,NumOfSamples))];
   
% Parameters
alpha = 0.005;          % "Choice" parameter > 0. Set small for the
                                   % conservative limit (Fuzzy ART paper, Sect.3)
beta  = 1;                   % Learning rate. Set to 1 for fast learning
rho_a = .75;               % Baseline vigilance for ARTa, in range [0,1]

%%%%%%%%%%%%%%%%% Initial Set up of weights %%%%%%%%%%%%%%%%%%%%%%
w_a = ones(2*NumInVars,NumInTerms);    
u2  = zeros(NumInVars,NumInTerms);
v2  = zeros(NumInVars,NumInTerms);

du2  = zeros(NumInVars,NumInTerms);
dv2  = zeros(NumInVars,NumInTerms);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              Beginning of the Main "for" loop of the ANFIS  program.                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tic
counter1 = 0;
for ne=1:NumOfEpochs
    
e = zeros(NumOutVars,NumOfSamples);

for n=1:NumOfSamples   

      Newly_added_node_a = 0;
     
       resonant_a = 0;
               % We're not resonating in the ARTa module yet
       already_reset_nodes_a = [];  % We haven't rest any ARTa nodes
                                                    % for this input pattern yet
       already_disabled_nodes_a = [];
      
%%%%%%%%%%%%%  INPUT SPACE FUZZY CLUSTERING PROCESS %%%%%%%%%%%%%%      
      
      A = A_train(:,n);
  
      while resonant_a == 0,
                %%% In search of a resonating ARTa node...
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%% Find the winning, matching ARTa node
                N = size(w_a,2); % = NumInTerms; Count how many F2a nodes we have

                A_for_each_F2_node = A * ones(1,N); % Matrix containing a copy of A for
                                                    % each F2 node. Useful for Matlab.
                A_AND_w = min(A_for_each_F2_node,w_a);  % Fuzzy AND = min

                Sa = sum(abs(A_AND_w));  % Row vector of signals to F2 nodes

                Ta = Sa ./ (alpha + sum(abs(w_a)));  % Choice function vector for F2

                %%%%%%%%% Set all the reset nodes to zero

                Ta(already_reset_nodes_a) = zeros(1,length(already_reset_nodes_a));

                Ta(already_disabled_nodes_a) = zeros(1,length(already_disabled_nodes_a));    

                %%%%%%%%%%%% Finding the winning node, J
                [ Tamax, J ] = max(Ta);   % Matlab function max works such that
                                          % J is the lowest index of max T elements, as
                                          % desired. J is the winning F2 category node

                w_J = w_a(:,J);           % Weight vector into winning F2 node, J
                xa = min(A,w_J);

                %%%%%%%% Testing if the winning node resonates in ARTa

                if sum(abs(xa))./NumInVars >= rho_a,
                                           % If a match, we're done
                        resonant_a = 1;    % ARTa resonates
                        w_a(:,J) = beta*xa + (1-beta)*w_a(:,J);
               
                elseif sum(abs(xa))/NumInVars < rho_a,
                        % If mismatch then we reset
                        resonant_a = 0;     % So, still not resonating
                        already_reset_nodes_a = [already_reset_nodes_a  J ];
                end;            % Record that node J has been reset already.

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Creating a new node if we've reset all of them

                if length(already_reset_nodes_a)== N|length(already_disabled_nodes_a)== N,
                       % If all F2a nodes reset
                       % w_a = [ w_a ones(2*NumInVars,1)];
                        w_a = [ w_a A_train(:,n)];
                        
                        Newly_added_node_a = 1;
                        % Add uncommitted node to ARTa weight vector
                        resonant_a = 0;   
                end;    % Now go back and this new node should win
             
        end;    % End of the while loop searching for ARTa resonance
                   % If resonant_a = 0, we pick the next highest Tj
                   % and see if *that* node resonates, i.e. goto "while"
                   % If resonant_a = 1, we have found an ARTa resonance,
                   % namely node J. So we go on to see if we get Fab match with node J.

% Updating Hyperbox corners (u2, v2 matrices).
u2 = w_a(1:NumInVars,:);
v2 = 1 - w_a(NumInVars+1:2*NumInVars,:);
NumInTerms  = size(u2,2);
NumRules    = NumInTerms;

if Newly_added_node_a == 1
    ThetaL4   = [ThetaL4; zeros(NumInVars+1,1)];
    dThetaL4 = [dThetaL4; zeros(NumInVars+1,1)];
    P  =  [ P                                                                   zeros((NumInVars+1)*(NumRules-1),NumInVars+1);
               zeros(NumInVars+1,(NumInVars+1)*(NumRules-1))                              1e8*eye(NumInVars+1); ];
           
     du2 = [du2 zeros(NumInVars,1);];      
     dv2 = [dv2 zeros(NumInVars,1);];
end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        								 							     				                                                                   %
%   			                  	NETWORK FUNCTIONALITY SECTION				                                   %
%      																					                                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LAYER 1 - INPUT TERM NODES
Inp1 = A_train(1:NumInVars,n);
 
% LAYER 1 - MF NODES
% Each node in this layer acts as a one-dimensional membership function.  
 In1mat = Inp1*ones(1,NumInTerms); 
 % Matrix containing a copy of Out1 for each Layer 2 Term Node.
 Out1 = 1 - g(In1mat-v2,gamma) - g(u2-In1mat,gamma);
 
% LAYER 2 - PRECONDITION MATCHING OF FUZZY LOGIC RULES
% Rule Nodes = NumInTerms
 Out2 = prod(Out1,1); 
 S_2 = sum(Out2);
 
% LAYER 3 - NORMALIZATION NODES - All Node Activity Adds-up to unity.
if S_2~=0
   Out3 = Out2/S_2;
else
    continue;
end
 
% LAYERS 4 - 5: CONSEQUENT NODES - SUMMING NODE
 Aux1 = [Inp1; 1]*Out3;

 % New Input Training Data shaped as a column vector.
 a = reshape(Aux1,(NumInVars+1)*NumRules,1);

Out5(n) = a'*ThetaL4; 
 e(n) = TrgtOut(n) - Out5(n);
 
%%%%%%%%%%%%%% END OF NETWORK FUNCTIONALITY SECTION %%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			 				                           	PARAMETER LEARNING SECTION	                                       			   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BACKWARD PASS. Error Backpropagation
% deltaThetaL4 = a*e(n);
% dThetaL4       = Ita1*deltaThetaL4 + alpha1*dThetaL4;

 % LAYER 4
 ThetaL4_mat = reshape(ThetaL4,NumInVars+1,NumRules);

% LAYER 3
 e3 = [Inp1' 1]*ThetaL4_mat*e(n);

denom = S_2*S_2;

% LAYER 2
ThetaE32 = zeros(NumRules,NumRules);
if denom~=0
    for k1=1:NumRules
         for k2=1:NumRules
              if k1==k2
                 ThetaE32(k1,k2) = ((S_2-Out2(k2))/denom)*e3(k2);
              else
                 ThetaE32(k1,k2) = -(Out2(k2)/denom)*e3(k2);
              end
         end
    end
    
else
    continue;
end

e2 = sum(ThetaE32,2);

ThetaE21 = zeros(NumInVars,NumInTerms);  
for i=1:NumInVars
      for j=1:NumInTerms
           if Out1(i,j)~=0
      		     ThetaE21(i,j) = (Out2(j)/Out1(i,j))*e2(j);
           end
       end 
end 

Theta2v2 = zeros(NumInVars,NumInTerms);
Theta2u2 = zeros(NumInVars,NumInTerms);

for i=1:NumInVars
    for j=1:NumInTerms
   
         if ((In1mat(i,j)-v2(i,j))*gamma>=0) && ((In1mat(i,j)-v2(i,j))*gamma<=1)
            Theta2v2(i,j) = gamma;
         end
       
         if ((u2(i,j)-In1mat(i,j))*gamma>=0) && ((u2(i,j)-In1mat(i,j))*gamma<=1)
            Theta2u2(i,j) = -gamma;
         end
       
   end
end
  
deltau2 = -Theta2u2.*ThetaE21;
      du2 = -Ita2*deltau2 + alpha2*du2;

deltav2 = -Theta2v2.*ThetaE21;
      dv2 = -Ita2*deltav2 + alpha2*dv2;

% v2 = v2 + du2;
% u2 = u2 + dv2;

% Now update the Layer 4 linear parameters.
ThetaL4_old = ThetaL4;  % Keep here the old values of ThetaL4.

% Fixing of Consequent Parameters by LMS.
% ThetaL4        = ThetaL4 + dThetaL4;

% Fixing of Consequent Parameters by RLS.
P = (1/lamda)*(P - P*a*a'*P/(lamda+a'*P*a));
ThetaL4 = ThetaL4 + P*a*e(n);

% Do some house-keeping in order u2 to correspond to the 
% lower-left corner of the hyperbox and v2 to correspond
% to the upper-right corner of the hyperbox.
if ~isempty(find(u2>v2))
   counter1 = counter1 + 1;
   for i=1:NumInVars
     for j=1:NumInTerms
        if u2(i,j) > v2(i,j)
            temp = v2(i,j);
            v2(i,j) = u2(i,j);
            u2(i,j) = temp;
        end
     end
   end
end

% Update w_a, after Parameter Learning Section.
 w_a = [u2; 1-v2];

%%%%%%%%%% END OF PARAMETER LEARNING PROCESS %%%%%%%%%%%%
end %Of for i=1:NumOfSamples loop.

rmse(ne,1) = norm(e)/sqrt(NumOfSamples); % Root Mean-Squared Error.

[rmse(ne) size(w_a,2) ne]

end   %Of for i=1:NumOfEpochs loop.

figure
subplot(3,1,1)
plot(rmse,'*r');
title('RMSE');
axis tight
grid on

X = 1:NumOfSamples;
subplot(3,1,2)
plot(X,TrgtOut(1,:),'b',X,Out5,'g')
title('Target Output(Blue) VS Actual Output(Green)') 
axis tight
grid on

subplot(3,1,3),plot(e,'y')
title('Approximation Error(n)')
axis tight
grid on

%% %%% %%%%%%% Gradient Checking Section %%%%%%%%%%%%%
ThetaJ_u2 = zeros(NumInVars,NumInTerms);
ThetaJ_v2 = zeros(NumInVars,NumInTerms);
epsilon      = 1e-4;

for i=1:NumInVars
     for j=1:NumInTerms
        
        u2_up = u2; 
        u2_do = u2;

        u2_up(i,j) = u2(i,j) + epsilon; 
        u2_do(i,j) = u2(i,j) - epsilon;
        
        J_up_u2 = 1/2*(TrgtOut(n) - anfis_art_forward(Inp1,u2_up,v2,gamma,ThetaL4_old))^2;
        J_do_u2 = 1/2*(TrgtOut(n) - anfis_art_forward(Inp1,u2_do,v2,gamma,ThetaL4_old))^2;

        ThetaJ_u2(i,j) = (J_up_u2 - J_do_u2)/2/epsilon;
      
        v2_up = v2;
        v2_do = v2;

        v2_up(i,j) = v2(i,j) + epsilon; 
        v2_do(i,j) = v2(i,j) - epsilon;
        
        J_up_v2 = 1/2*(TrgtOut(n) - anfis_art_forward(Inp1,u2,v2_up,gamma,ThetaL4_old))^2;
        J_do_v2 = 1/2*(TrgtOut(n) - anfis_art_forward(Inp1,u2,v2_do,gamma,ThetaL4_old))^2;
        
        ThetaJ_v2(i,j) = (J_up_v2 - J_do_v2)/2/epsilon;

       end
end


rel_diff_u2  = deltau2(:) - ThetaJ_u2(:);
rel_diff_v2  = deltav2(:) - ThetaJ_v2(:);

[rel_diff_u2 rel_diff_v2]

[deltau2(:)   ThetaJ_u2(:) ]

[deltav2(:)  ThetaJ_v2(:)]
