function [out,Xt,str,ts] = anfisim_scatter(t,Xt,u,flag,Ita,alpha,lamda,NumInVars,NumInTerms,x0,T)

% This program is an implementation of the on line ANFIS (MISO) system.
% The structure of the network is determined by the user.
% The input space is partitioned using the scatter-type method.
% The premise (nonlinear) parameters at Layer 1 are estimated by Gradient Descent (GD) through error backpropagation. 
% The consequent (linear) parameters at Layer 4 are estimated by Recursive Least Squares (RLS) algorithm.

   ninp = NumInVars;
   nout = 1;
   ninps = ninp+nout+1;  % number of inputs to sfunction [ x y LE ]
   NumRules = NumInTerms;
   ns = 3*NumInVars*NumInTerms  + ((NumInVars+1)*NumRules)^2 + (NumInVars+1)*NumRules;
   nds = 3*NumInVars*NumInTerms + (NumInVars+1)*NumRules;

%  ----------------------- % initial informations --------------
if abs(flag)==0

   out = [0,ns+nds,1+ns+nds,ninps,0,1,1];   % states, outputs, inputs, ?, df, #ts
    str = [];                                                         % API block consistency
     ts = T;                                                         % sample time
    Xt = x0;

%  ----------------------- % state derivatives -----------------
elseif abs(flag) == 2
   
          x = u(1:ninp);
          e = u(ninp+1:ninp+nout);
   learning = u(ninp+nout+1);

if learning == 1 
  
   off=1;
   off_end=NumInVars*NumInTerms;
   mean1=reshape(Xt(off:off_end),NumInVars,NumInTerms);  
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   sigma1=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off+NumInVars*NumInTerms-1;
   b1=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + ((NumInVars+1)*NumRules)^2-1;
   P=reshape(Xt(off:off_end),(NumInVars+1)*NumRules,(NumInVars+1)*NumRules);
   
   off=off_end+1;
   off_end=off + (NumInVars+1)*NumRules-1;
   ThetaL4 = Xt(off:off_end);
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   dmean1=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   dsigma1=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   db1=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + (NumInVars+1)*NumRules-1;
   dThetaL4 = Xt(off:off_end);  % Present for future growth purposes. Plays no role in this version.
      
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                                                        FEEDFORWARD PHASE                                                %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LAYER 1 - INPUT TERM NODES
     In1 = x*ones(1,NumInTerms);
  Out1 = 1./(1 + (abs((In1-mean1)./sigma1)).^(2*b1));
      
% LAYER 2 - PRODUCT NODES
    Out2 = prod(Out1,1)';
     S_2 = sum(Out2);

  % LAYER 3 - NORMALIZATION NODES
  if S_2~=0
     Out3 = Out2'/S_2;
  else
      Out3 = zeros(1,NumRules);
  end
      
% LAYER 4: CONSEQUENCES NODES
Aux1 = [x; 1]*Out3;

% New Input Training Data shaped as a column vector.
  a = reshape(Aux1,(NumInVars+1)*NumRules,1);  
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			 					                PARAMETER LEARNING SECTION	                   			              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Error Backpropagation Algorithm.
% LAYER 4.
ThetaL4_mat = reshape(ThetaL4,NumInVars+1,NumRules);

% LAYER 3
e3 = [x' 1]*ThetaL4_mat*e;
 
denom = S_2*S_2;
  
% LAYER 2
Theta32 = zeros(NumRules,NumRules);

if denom~=0
   for k1=1:NumRules
        for k2=1:NumRules
             if k1==k2 
                Theta32(k1,k2) = ((S_2-Out2(k2))/denom)*e3(k2);
             else
                Theta32(k1,k2) = -(Out2(k2)/denom)*e3(k2);
             end
        end
   end
end

% Sum Theta32 along rows to find the contribution of each L3 node
% (indexed by k2) to a single L2 node (indexed by k1).
e2 = sum(Theta32,2);

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
if isempty(find(In1==mean1))
    
 deltamean1 = ThetaE21.*(2*b1./(In1-mean1)).*Out1.*(1-Out1);
        deltab1  = ThetaE21.*(-2).*log(abs((In1-mean1)./sigma1)).*Out1.*(1-Out1);
deltasigma1 = ThetaE21.*(2*b1./sigma1).*Out1.*(1-Out1);                

       dmean1 = Ita*deltamean1 + alpha*dmean1;
         mean1 = mean1 + dmean1;

       dsigma1 = Ita*deltasigma1 + alpha*dsigma1;
         sigma1 = sigma1 + dsigma1;

             db1 = Ita*deltab1 + alpha*db1;
               b1 = b1 + db1;
               
% Sort the terms in Layer 1.
    for i=1:NumInTerms-1
          if ~isempty(find(mean1(:,i)>mean1(:,i+1)))
             for i=1:NumInVars
                  [mean1(i,:) index1] = sort(mean1(i,:));
                   sigma1(i,:) = sigma1(i,index1);
                         b1(i,:) = b1(i,index1);
             end
          end
     end

end

% Fixing of Consequent Parameters by RLS.
P = (1./lamda).*(P - P*a*a'*P./(lamda+a'*P*a));
ThetaL4 = ThetaL4 + P*a.*e;

%%%%%%%%%%%%%   END OF PARAMETER LEARNING PROCESS %%%%%%%%%%%
% State Vector Storage.
% Xt = [mean1 sigma1 b1 P ThetaL4 dmean1 dsigma1 db1 dThetaL4];

Xt = [reshape(mean1,NumInVars*NumInTerms,1);
         reshape(sigma1,NumInVars*NumInTerms,1);
         reshape(b1,NumInVars*NumInTerms,1);
         reshape(P,((NumInVars+1)*NumRules)^2,1);
         ThetaL4;
         reshape(dmean1,NumInVars*NumInTerms,1);
         reshape(dsigma1,NumInVars*NumInTerms,1);
         reshape(db1,NumInVars*NumInTerms,1);
         dThetaL4;];
end

out=Xt;

%  ----------------------- % outputs -------------------------
elseif flag == 3
   
    % Unpack the ANFIS-Scatter network parameters...
    off=1;
   off_end=NumInVars*NumInTerms;
   mean1=reshape(Xt(off:off_end),NumInVars,NumInTerms);  
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   sigma1=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off+NumInVars*NumInTerms-1;
   b1 =reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + ((NumInVars+1)*NumRules)^2 - 1;
   P = reshape(Xt(off:off_end),(NumInVars+1)*NumRules,(NumInVars+1)*NumRules);
   
   off=off_end+1;
   off_end=off + (NumInVars+1)*NumRules - 1;
   ThetaL4 = Xt(off:off_end);
   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                                                      FEEDFORWARD OPERATION                                                       %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LAYER 1 - INPUT TERM NODES
        x = u(1:ninp);
     In1 = x*ones(1,NumInTerms);
  Out1 = 1./(1 + (abs((In1-mean1)./sigma1)).^(2*b1));
      
% LAYER 2 - PRODUCT NODES
    Out2 = prod(Out1)';
    S_2 = sum(Out2);

% LAYER 3 - NORMALIZATION NODES
  if S_2~=0
     Out3 = Out2'./S_2;
  else
      Out3 = zeros(1,NumRules);
  end
    
% LAYER 4: CONSEQUENCES NODES
    Aux1 = [x; 1]*Out3;
  % New Input Training Data shaped as a column vector.
    a = reshape(Aux1,(NumInVars+1)*NumRules,1);  
   
% LAYER 5: SUMMING NODE
    outact = a'*ThetaL4;
  
  % Block Outputs Vector Formation.
   out=[outact;Xt];             
     
else
   out=[];
end