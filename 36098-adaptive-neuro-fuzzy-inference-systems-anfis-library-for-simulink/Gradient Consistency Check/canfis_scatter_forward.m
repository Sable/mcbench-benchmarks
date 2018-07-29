% CANFIS Scatter Feed-Forward operation.
function y = canfis_scatter_forward(x,mean,sigma,b,ThetaL4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        								 							     				                                       %
%   			                 	NETWORK FUNCTIONALITY SECTION					   %
%      																					                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[NumInVars NumInTerms] = size(mean);

NumRules = NumInTerms;  

% LAYER 1 - INPUT TERM NODES
 In2 = x*ones(1,NumInTerms);
Out1 = 1./(1 + (abs((In2-mean)./sigma)).^(2*b));

% LAYER 2 - PRODUCT NODES
 Out2 = prod(Out1.',2);
 S_2 = sum(Out2);
 
% LAYER 3 - NORMALIZATION NODES
 Out3 = Out2/S_2;
    
% LAYERS 4 - 5: CONSEQUENT NODES - SUMMING NODE
Aux1 = [x; 1]*Out3';

a = reshape(Aux1,(NumInVars+1)*NumRules,1);  % New Input Training Data shaped as a column vector.

y = ThetaL4'*a; 