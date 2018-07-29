function [out,Xt,str,ts] = canfisim_art(t,Xt,u,flag,Ita,alpha1,lamda,gamma,rho_a,alpha,beta,NumInVars,NumOutVars,MaxNumInTerms,x0,Xmins,Xin_width,T)

% This program is an implementation of the on-line CANFIS (MIMO) system.
% The structure of the network is automatically determined by the Fuzzy ART algorithm.
% Input space partitioning is performed by the Fuzzy ART algorithm.
% The current number of fuzzy rules is equal to the numbr of fuzzy input categories
% (i.e. input term nodes) recognized by fuzzy ART. This number is common for each input (linguistic) variable.
% The premise parameters are estimated by Gradient Descent (GD) through error backpropagation
% and fuzzy-ART learning during the process of category creation.
% The consequent (linear) parameters are estimated by Recursive Least Squares (RLS) algorithm.
     
   ninp = NumInVars;
   nout = NumOutVars;
   ninps = ninp+nout+1;  % number of inputs to sfunction [ x e LE ]
   MaxNumRules = MaxNumInTerms;
   ns  = 2*NumInVars*MaxNumInTerms + ((NumInVars+1)*MaxNumRules)^2 ...
            + (NumInVars+1)*MaxNumRules*NumOutVars + 1;
   nds = 2*NumInVars*MaxNumInTerms +  (NumInVars+1)*MaxNumRules*NumOutVars;

%  ----------------------- % initial informations --------------
if abs(flag)==0

    out = [0,ns+nds,nout+ns+nds,ninps,0,1,1]; % states, outputs, inputs, ?, df, #ts
     str = [];                                                            % API block consistency
      ts = T;                                                            % sample time
     Xt = x0;

 %  ----------------------- % state derivatives -----------------
elseif abs(flag) == 2
   
          x1 = (u(1:ninp) - Xmins)./Xin_width; % Apply Complement Coding on Input Variables.
            x = [ x1; ones(ninp,1) -  x1]; 

          e = u(ninp+1:ninp+nout);
   learning = u(ninp+nout+1);

if learning == 1 
   
    % Xt = [ NumRules; w_a; P; ThetaL5; du2; dv2; dThetaL4; ];  
   NumRules = Xt(1);
   NumInTerms = NumRules;
  
   off=2;
   off_end = off + 2*NumInVars*NumInTerms-1;
   w_a=reshape(Xt(off:off_end),2*NumInVars,NumInTerms);  
   
   off=off_end+1;
   off_end=off + ((NumInVars+1)*NumRules)^2-1;
   P=reshape(Xt(off:off_end),(NumInVars+1)*NumRules,(NumInVars+1)*NumRules);
   
   off=off_end+1;
   off_end=off + (NumInVars+1)*NumRules*NumOutVars-1;
   ThetaL5 = reshape(Xt(off:off_end),(NumInVars+1)*NumRules,NumOutVars);
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   du2 = reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   dv2 = reshape(Xt(off:off_end),NumInVars,NumInTerms);

   off=off_end+1;
   off_end=off + (NumInVars+1)*NumRules*NumOutVars-1;
    % Present for future growth purposes. Plays no role in this version.
   dThetaL5 = reshape(Xt(off:off_end),(NumInVars+1)*NumRules,NumOutVars); 
   
   
%%%%%%%%%%%     INPUT SPACE FUZZY CLUSTERING PROCESS %%%%%%%%%%%%%       

  Newly_added_node_a = 0;
     
  resonant_a = 0;   % We're not resonating in the ARTa module yet
       
  already_reset_nodes_a = [];  % We haven't rest any ARTa nodes
                                                    % for this input pattern yet
  
 already_disabled_nodes_a = [];
       
      while resonant_a == 0 && NumInTerms<MaxNumInTerms
          %%% In search of a resonating ARTa node...
                
                %%%%%%%%%% Find the winning, matching ARTa node
                N = size(w_a,2); % = NumInTerms; Count how many F2a nodes we have

                A_for_each_F2_node = x * ones(1,N); % Matrix containing a copy of A for
                                                                                    % each F2 node. Useful for Matlab.
                A_AND_w = min(A_for_each_F2_node,w_a);  % Fuzzy AND = min

                Sa = sum(abs(A_AND_w));  % Row vector of signals to F2 nodes

                Ta = Sa ./ (alpha + sum(abs(w_a)));  % Choice function vector for F2

                %%%%%%%%% Set all the reset nodes to zero

                Ta(already_reset_nodes_a)       = zeros(1,length(already_reset_nodes_a));
                Ta(already_disabled_nodes_a) = zeros(1,length(already_disabled_nodes_a));    

                %%%%%%%%%%%% Finding the winning node, J
                [ Tamax, J ] = max(Ta);   % Matlab function max works such that
                                                          % J is the lowest index of max T elements, as
                                                          % desired. J is the winning F2 category node

                w_J = w_a(:,J);                % Weight vector into winning F2 node, J
                xa = min(x,w_J);

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

                if  length(already_reset_nodes_a)== N || length(already_disabled_nodes_a)== N 
                       % If all F2a nodes reset
                       % w_a = [ w_a ones(2*NumInVars,1)];
                        w_a = [ w_a x];
                        
                        Newly_added_node_a = 1;    % Add uncommitted node to ARTa weight vector
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
NumRules     = NumInTerms;

if Newly_added_node_a == 1
      
      ThetaL5 = [ThetaL5;   zeros(NumInVars+1,NumOutVars);];
    dThetaL5 = [dThetaL5; zeros(NumInVars+1,NumOutVars);];
      
      P  =  [  P                                                                     zeros((NumInVars+1)*(NumRules-1),NumInVars+1);
                  zeros(NumInVars+1,(NumInVars+1)*(NumRules-1))                               1e6*eye(NumInVars+1); ];
           
       du2 = [du2  zeros(NumInVars,1);];      
       dv2 = [dv2  zeros(NumInVars,1);];
       
 end

      
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                                                            FEEDFORWARD PHASE                                                       %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LAYER 2 - INPUT TERM NODES
  Inp2 = x1;
  In2mat = Inp2*ones(1,NumInTerms);
  Out2 = 1 - g(In2mat-v2,gamma) - g(u2-In2mat,gamma);
 
% LAYER 3 - PRECONDITION MATCHING OF FUZZY LOGIC RULES
% RULE NODES == NumInTerms
 Out3 = prod(Out2,1); 
 S_3 = sum(Out3);
 
% LAYER 4 - NORMALIZATION NODES - All Node Activity Adds-up to unity.
if S_3~=0
   Out4 = Out3/S_3;
else 
   Out4 = zeros(1,NumRules); 
end

% LAYER 5: CONSEQUENT NODES - SUMMING NODE
 Aux1 = [Inp2; 1]*Out4;
 a = reshape(Aux1,(NumInVars+1)*NumRules,1); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			 					                PARAMETER LEARNING SECTION	                           			             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Error Backpropagation Algorithm.
% LAYER 5
f = zeros(NumOutVars,NumRules);
for m=1:NumOutVars
    ThetaL5_mat = reshape(ThetaL5(:,m),NumInVars+1,NumRules);
    f(m,:) = [Inp2' 1]*ThetaL5_mat*e(m);
end

% LAYER 4
 e4 = sum(f,1);
denom = S_3*S_3;

% LAYER 3
Theta43 = zeros(NumRules,NumRules);
if denom~=0
    for k1=1:NumRules
         for k2=1:NumRules
              if k1==k2
                Theta43(k1,k2) = ((S_3-Out3(k2))/denom)*e4(k2);
             else
                Theta43(k1,k2) = -(Out3(k2)/denom)*e4(k2);
              end
         end
     end
end
   
e3 = sum(Theta43,2);

% LAYER 2
ThetaE32 = zeros(NumInVars,NumInTerms);  
for i=1:NumInVars
    for j=1:NumInTerms
        if Out2(i,j)~=0
  		     ThetaE32(i,j) = (Out3(j)/Out2(i,j))*e3(j);
        end 
   	 end 
 end

Theta2v2 = zeros(NumInVars,NumInTerms);
Theta2u2 = zeros(NumInVars,NumInTerms);

% LAYER 1
for i=1:NumInVars
    for j=1:NumInTerms
   
         if ((In2mat(i,j)-v2(i,j))*gamma>=0) && ((In2mat(i,j)-v2(i,j))*gamma<=1)
             Theta2v2(i,j) = gamma;
         end
       
         if ((u2(i,j)-In2mat(i,j))*gamma>=0) && ((u2(i,j)-In2mat(i,j))*gamma<=1)
             Theta2u2(i,j) = -gamma;
         end
       
   end
end
  
deltau2 = Theta2u2.*ThetaE32;
      du2 = Ita*deltau2 + alpha1*du2;

deltav2 = Theta2v2.*ThetaE32;
      dv2 = Ita*deltav2 + alpha1*dv2;

v2 = v2 + du2;
u2 = u2 + dv2;

% Do some house-keeping in order u2 to correspond to the 
% lower-left corner of the hyperbox and v2 to correspond
% to the upper-right corner of the hyperbox.
if ~isempty(find(u2>v2))
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

if ~isempty(find(u2<0)) || ~isempty(find(v2>1))
   for i=1:NumInVars
      for j=1:NumInTerms
        if u2(i,j) < 0
           u2(i,j) = 0;
        end
        if v2(i,j) > 1
           v2(i,j) = 1;
        end
      end
   end
end

% Update w_a, after Parameter Learning Section.
 w_a = [u2; 1-v2];

% Fixing of Consequent Parameters at Layer 5 by RLS.
P = (1./lamda).*(P - P*a*a'*P./(lamda+a'*P*a));
ThetaL5 = ThetaL5 + P*a*e';

%%%%%%%%%%%%%   END OF PARAMETER LEARNING PROCESS %%%%%%%%%%%
% State Vector Storage.
% Xt1 = [Num_Rules w_a; P; ThetaL5 du2; dv2; dThetaL4;];

Xt1 = [ NumRules;
            reshape(w_a,2*NumInVars*NumInTerms,1);
            reshape(P,((NumInVars+1)*NumRules)^2,1); 
            reshape(ThetaL5,(NumInVars+1)*NumRules*NumOutVars,1);
            reshape(du2,NumInVars*NumInTerms,1);
            reshape(dv2,NumInVars*NumInTerms,1);
            reshape(dThetaL5,(NumInVars+1)*NumRules*NumOutVars,1);];
       
 ns1 = size(Xt1,1);
       
Xt = [Xt1; zeros(ns+nds-ns1,1);];       
end % of "if learning ==1" loop

out=Xt;

%  --------------------------------------------------  outputs -----------------------------------------------------
elseif flag == 3
   
  % Xt = [NumRules; w_a; P; ThetaL5; du2; dv2; dThetaL5;];  
   
   NumRules = Xt(1);
   NumInTerms = NumRules;
    
   off=2;
   off_end=off + 2*NumInVars*NumInTerms -1;
   w_a=reshape(Xt(off:off_end),2*NumInVars,NumInTerms);  
   
   off=off_end+1;
   off_end=off + ((NumInVars+1)*NumRules)^2-1;
   P=reshape(Xt(off:off_end),(NumInVars+1)*NumRules,(NumInVars+1)*NumRules);
   
   off=off_end+1;
   off_end=off + (NumInVars+1)*NumRules*NumOutVars-1;
   ThetaL5 = reshape(Xt(off:off_end),(NumInVars+1)*NumRules,NumOutVars);
   
   u2 = w_a(1:NumInVars,:);
   v2 = 1 - w_a(NumInVars+1:2*NumInVars,:);
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %                                                      FEEDFORWARD OPERATION                                                       %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % LAYER 1 - INPUT TERM NODES
 x1 = (u(1:ninp) - Xmins)./Xin_width;  % Apply Complement Coding on Inputs.
   
 % LAYER 2         
 Inp2  = x1;
% Each node in this layer acts as a one-dimensional membership function.  
 In2mat = Inp2*ones(1,NumInTerms); 
 Out2 = 1 - g(In2mat-v2,gamma) - g(u2-In2mat,gamma);
 
% LAYER 3 - PRECONDITION MATCHING OF FUZZY LOGIC RULES
% RULE NODES == NumInTerms
 Out3 = prod(Out2,1); 
 S_3 = sum(Out3);
 
% LAYER 4 - NORMALIZATION NODES - All Node Activity Adds-up to unity.
if S_3~=0
   Out4 = Out3/S_3;
else 
   Out4 = zeros(1,NumRules); 
end
 
% LAYER 5: CONSEQUENCES NODES
Aux1 = [Inp2; 1]*Out4;
% New Input Training Data shaped as a column vector.
a = reshape(Aux1,(NumInVars+1)*NumRules,1);

% LAYER 6: SUMMING NODE
outact = ThetaL5'*a;
  
% Block Outputs Vector Formation.
 out=[outact;Xt];               
   
else
   out=[];
end