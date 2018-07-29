function [out,Xt,str,ts] = rfnn_miso_scatter(t,Xt,u,flag,itaVector,alphaVector, NumInVars,NumInTerms,x0,T)

% This program is an implementation of the on line RFNN (MISO) system.
% The structure of the network is determined by the user.
% The input space is partitioned using the scatter-type method.
% All parameters of the network are estimated by Gradient Descent (GD)
% through error backpropagation. 

    ninp = NumInVars;
    nout = 1;
   ninps = ninp+nout+1;  % number of inputs to sfunction [ x y LE ]
   NumRules = NumInTerms;  % Scatter-Type Input Space Partitioning.
       ns = 4*NumInVars*NumInTerms + NumRules;
     nds = 3*NumInVars*NumInTerms + NumRules;
     % Learning Rates
     ita1 = itaVector(1); ita2 = itaVector(2);
     ita3 = itaVector(3); ita4 = itaVector(4);
     % Momentum Constants.
     alpha1 = alphaVector(1); alpha2 = alphaVector(2); 
     alpha3 = alphaVector(3); alpha4 = alphaVector(4);
%  ----------------------- % initial informations --------------
if abs(flag)==0

    out = [0,ns+nds,1+ns+nds,ninps,0,1,1];    % states, outputs, inputs, ?, df, #ts
    str = [];                                 % API block consistency
     ts = T;                                  % sample time
    Xt = x0;
%  ----------------------- % state derivatives -----------------
elseif abs(flag) == 2
   
          x = u(1:ninp);
          e = u(ninp+1:ninp+nout);
   learning = u(ninp+nout+1);

if learning == 1 
  
   % Unroll the states:  
   off=1;
   off_end=NumInVars*NumInTerms;
   mean2=reshape(Xt(off:off_end),NumInVars,NumInTerms);  
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   sigma2=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off+NumInVars*NumInTerms-1;
   Theta2=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + NumRules-1;
   W = reshape(Xt(off:off_end),NumRules,1);
      
   off=off_end+1;
   off_end=off+NumInVars*NumInTerms-1;
   Out2 = reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   % Unroll the differential states:
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   dmean2=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   dsigma2=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   dTheta2=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + NumRules-1;
   dW = reshape(Xt(off:off_end),NumRules,1); 
        
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                                                    FEEDFORWARD OPERATION                                                      %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LAYER 2 - INPUT TERM NODES
  Out2_pr = Out2;

 In2 = x*ones(1,NumInTerms) + Out2_pr.*Theta2;
 Out2 = exp(-((In2-mean2)./sigma2).^2);
 
% LAYER 3 - RULE (PRODUCT) NODES
 precond = Out2'; 
 Out3 = prod(precond,2);
 
%%%%%%%%%%%% END OF NETWORK FUNCTIONALITY SECTION %%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			 					                 PARAMETER LEARNING SECTION	                       			                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BACKWARD PASS. Error Backpropagation
% LAYERS 4-3
delta3 = e*W;

% LAYER 2
delta2 = zeros(NumInVars,NumInTerms);  
for i=1:NumInVars
     for j=1:NumInTerms
           if Out2(i,j)== precond(j,i) && Out2(i,j)~=0
      		  delta2(i,j) = (Out3(j)/Out2(i,j))*delta3(j);
            end
        end 
 end
  
% LAYER 1 PARAMETER ADJUSTMENT BY GRADIENT DESCENT.  
deltamean2  =  2*delta2.*Out2.*(In2-mean2)./((sigma2).^2);
deltasigma2 =  2*delta2.*Out2.*((In2-mean2).^2)./(sigma2.^3);
 deltaTheta2 = -2*delta2.*Out2.*(In2-mean2).*Out2_pr./sigma2.^2; 

dmean2 = ita2*deltamean2 + alpha2*dmean2;
 mean2  = mean2 + dmean2;

dsigma2 = ita3*deltasigma2 + alpha3*dsigma2;
  sigma2 = sigma2 + dsigma2;

dTheta2 = ita4*deltaTheta2 + alpha4*dTheta2;
 Theta2  = Theta2 + dTheta2;

% LAYER 4 PARAMETER ADJUSTMENT
  deltaW = e*Out3;
  dW = ita1*deltaW + alpha1*dW;
   W = W + dW;

%%%%%%%%%%%   END OF PARAMETER LEARNING PROCESS %%%%%%%%%
% State Vector Storage.
% Xt = [mean2 sigma2 Theta2 W Out2 dmean2 dsigma2 dTheta2 dW];

Xt = [ reshape(mean2,NumInVars*NumInTerms,1);
          reshape(sigma2,NumInVars*NumInTerms,1);
          reshape(Theta2,NumInVars*NumInTerms,1);
          W;
          reshape(Out2,NumInVars*NumInTerms,1);
          reshape(dmean2,NumInVars*NumInTerms,1);
          reshape(dsigma2,NumInVars*NumInTerms,1);
          reshape(dTheta2,NumInVars*NumInTerms,1);
          dW;];
end

out=Xt;

%  ----------------------- % outputs -------------------------
elseif flag == 3
   
  % Unpack the network's parameters first...
   off=1;
   off_end=NumInVars*NumInTerms;
   mean2=reshape(Xt(off:off_end),NumInVars,NumInTerms);  
   
   off=off_end+1;
   off_end=off + NumInVars*NumInTerms-1;
   sigma2=reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off+NumInVars*NumInTerms-1;
   Theta2 =reshape(Xt(off:off_end),NumInVars,NumInTerms);
   
   off=off_end+1;
   off_end=off + NumRules - 1;
   W = Xt(off:off_end);
   
   off=off_end+1;
   off_end=off+NumInVars*NumInTerms-1;
   Out2 = reshape(Xt(off:off_end),NumInVars,NumInTerms);
         
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                                                       FEEDFORWARD OPERATION                                                       %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LAYER 1 - INPUT TERM NODES
  Out2_pr = Out2;

  x = u(1:ninp);
 In2 = x*ones(1,NumInTerms) + Out2_pr.*Theta2;
 Out2 = exp(-((In2-mean2)./sigma2).^2);
 
% LAYER 3 - RULE (PRODUCT) NODES
precond = Out2.';
 Out3 = prod(precond,2);
 
 % LAYER 4 
  outact = W.'*Out3;

  % Block Outputs Vector Formation.
   out=[outact;Xt];            
     
else
   out=[];
end