function [out,Xt,str,ts] = canfisim_grid(t,Xt,u,flag,Ita,alpha,lamda,NumInVars,NumInTerms,NumOutVars,x0,T)

% This program is an implementation of the on line CANFIS (MIMO) system.
% The structure of the network is determined by the user.
% The input space is partitioned using the grid-type method.
% The premise (nonlinear) parameters at Layer 1 are estimated by Gradient Descent (GD) through error
% backpropagation. 
% The consequent (linear) parameters at Layer 4 are estimated by Recursive Least Squares (RLS) algorithm.

ninp = NumInVars;
nout = NumOutVars;
ninps = ninp+nout+1;              % number of inputs to sfunction = length[ x  e  LE ].
NumRules = NumInTerms^NumInVars;
ns = 3*NumInVars*NumInTerms + ((NumInVars+1)*NumRules)^2 + (NumInVars+1)*NumRules*NumOutVars;
nds = 3*NumInVars*NumInTerms + (NumInVars+1)*NumRules*NumOutVars;

%  ----------------------- % initial informations --------------
if abs(flag)==0

    out = [0,ns+nds,nout+ns+nds,ninps,0,1,1];   % states, outputs, inputs, ?, df, #ts
    str = [];                                                               % API block consistency
     ts = T;                                                               % sample time
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
   off_end=off + NumInVars*NumInTerms - 1;
   sigma1=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off+NumInVars*NumInTerms - 1;
   b1=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + ((NumInVars+1)*NumRules)^2 - 1;
   P=reshape(Xt(off:off_end),(NumInVars+1)*NumRules,(NumInVars+1)*NumRules);
   
   off=off_end+1;
   off_end=off + (NumInVars+1)*NumRules*NumOutVars - 1;
   ThetaL4=reshape(Xt(off:off_end),(NumInVars+1)*NumRules,NumOutVars);
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms - 1;
   dmean1=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms - 1;
   dsigma1=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms - 1;
   db1=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + (NumInVars+1)*NumRules*NumOutVars - 1;
    % Present for future growth purposes. Plays no role in this version.
   dThetaL4 = reshape(Xt(off:off_end),(NumInVars+1)*NumRules,NumOutVars);
   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                                                          FEEDFORWARD PHASE                                                            %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LAYER 1 - INPUT TERM NODES
  In1 = x*ones(1,NumInTerms);
  Out1 = 1./(1 + (abs((In1-mean1)./sigma1)).^(2*b1));

  % LAYER 2 - PRODUCT NODES
  precond = combinem(Out1); 
  Out2 = prod(precond,2)';
  S_2 = sum(Out2);
   
 % LAYER 3 - NORMALIZATION NODES
  if S_2~=0
      Out3 = Out2/S_2;
  else
       Out3 = zeros(1,NumRules);
  end
    
% LAYER 4: CONSEQUENCES NODES
  Aux1 = [x; 1]*Out3;
  a = reshape(Aux1,(NumInVars+1)*NumRules,1);  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      NON-LINEAR PARAMETER LEARNING SECTION	                			               %
%                                 BACKWARD PHASE  - ERROR BACKPROPAGATION                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% LAYER 4
for m=1:NumOutVars
        ThetaL4_mat = reshape(ThetaL4(:,m),NumInVars+1,NumRules);
        f(m,:) = [x' 1]*ThetaL4_mat*e(m);
end

% LAYER 3
 e3 = sum(f,1);  % We can "normalize" the error at layer 3 by dividing with NumOutVars.

% LAYER 2
denom = S_2*S_2;

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

e2 = sum(Theta32,2);

% LAYER 1
Q = zeros(NumInVars,NumInTerms,NumRules);  
for i=1:NumInVars
     for j=1:NumInTerms
          for k=1:NumRules  
      	       if Out1(i,j)== precond(k,i) && Out1(i,j)~=0
      			  Q(i,j,k) = (Out2(k)/Out1(i,j))*e2(k);
               end
          end 
     end 
 end

Theta21 = sum(Q,3);
 
% LAYER 1 PARAMETER ADJUSTMENT BY GRADIENT DESCENT.
if isempty(find(In1==mean1))
  
    deltamean1 = Theta21.*(2*b1./(In1-mean1)).*Out1.*(1-Out1);
          deltab1 = Theta21.*(-2).*log(abs((In1-mean1)./sigma1)).*Out1.*(1-Out1);
  deltasigma1 = Theta21.*(2*b1./sigma1).*Out1.*(1-Out1);                

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

% Fixing of Consequent (Linear) Parameters by RLS.
 P = (1./lamda).*(P - P*a*a'*P./(lamda+a'*P*a));
 ThetaL4 = ThetaL4 + P*a*e';

%%%%%%%%%%%%% END OF PARAMETER LEARNING PROCESS %%%%%%%%%%%%

% State Vector Storage.
% Xt = [mean1 sigma1 b1 P ThetaL4 dmean1 dsigma1 db1 dThetaL4];

Xt = [reshape(mean1,NumInVars*NumInTerms,1);
         reshape(sigma1,NumInVars*NumInTerms,1);
         reshape(b1,NumInVars*NumInTerms,1);
         reshape(P,((NumInVars+1)*NumRules)^2,1);
         reshape(ThetaL4,(NumInVars+1)*NumRules*NumOutVars,1);
         reshape(dmean1,NumInVars*NumInTerms,1);
         reshape(dsigma1,NumInVars*NumInTerms,1);
         reshape(db1,NumInVars*NumInTerms,1);
         reshape(dThetaL4,(NumInVars+1)*NumRules*NumOutVars,1);];
end

out = Xt;

%  -------------------------------  Input->Output Function ---------------------------------------
elseif flag == 3
   
   % First read the current values of the involved CANFIS variables from the state vector. 
   off = 1;
   off_end = NumInVars*NumInTerms;
   mean1 = reshape(Xt(off:off_end),NumInVars,NumInTerms);  
   
   off = off_end+1;
   off_end = off + NumInVars*NumInTerms - 1;
   sigma1 = reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off = off_end+1;
   off_end = off+NumInVars*NumInTerms - 1;
   b1 = reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off = off_end+1;
   off_end = off + ((NumInVars+1)*NumRules)^2 - 1;
   P = reshape(Xt(off:off_end),(NumInVars+1)*NumRules,(NumInVars+1)*NumRules);
   
   off = off_end+1;
   off_end = off + (NumInVars+1)*NumRules*NumOutVars - 1;
   ThetaL4 = reshape(Xt(off:off_end),(NumInVars+1)*NumRules,NumOutVars);
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                                                FEEDFORWARD OPERATION                                                   %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LAYER 1 - INPUT TERM NODES
  x = u(1:ninp);
  In1  = x*ones(1,NumInTerms);
  Out1 = 1./(1 + (abs((In1-mean1)./sigma1)).^(2*b1));

% LAYER 2 - PRODUCT NODES
   precond = combinem(Out1); 
   Out2 = prod(precond,2)';
   S_2 = sum(Out2);
   
% LAYER 3 - NORMALIZATION NODES
if S_2~=0
     Out3 = Out2/S_2;
 else
      Out3 = zeros(1,NumRules);
 end
    
% LAYER 4: CONSEQUENT NODES
   Aux1 = [x; 1]*Out3;
   a = reshape(Aux1,(NumInVars+1)*NumRules,1);  

 % LAYER 5: SUMMING NODES
   outact = ThetaL4'*a;
  
% Block Outputs Vector Formation.
   out = [outact; Xt]; 
  
else
   out=[];
end