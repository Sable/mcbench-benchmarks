% CANFIS-ART Feed-Forward operation.
function y = canfis_art_forward(x,u2,v2,gamma,ThetaL4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        								 							     				                                       %
%   			                 	NETWORK FUNCTIONALITY SECTION					   %
%      																					                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumInVars    = size(x,1);
NumInTerms = size(u2,2);
NumRules     = NumInTerms;

% LAYER 1 - MF NODES
% Each node in this layer acts as a one-dimensional membership function.  
 In1mat = x*ones(1,NumInTerms); 

 % Matrix containing a copy of Out1 for each Layer 2 Term Node.
 Out1 = 1 - g(In1mat-v2,gamma) - g(u2-In1mat,gamma);
 
% LAYER 2 - PRECONDITION MATCHING OF FUZZY LOGIC RULES
% NumRules == NumInTerms
 Out2 = prod(Out1); 
 S_2 = sum(Out2);
 
% LAYER 3 - NORMALIZATION NODES - All Node Activity Adds-up to unity.
if S_2~=0
     Out3 = Out2/S_2;
end
 
% LAYERS 4 - 5: CONSEQUENT NODES - SUMMING NODE
 Aux1 = [x; 1]*Out3;

 % New Input Training Data shaped as a column vector.
 a = reshape(Aux1,(NumInVars+1)*NumRules,1);
 y = ThetaL4'*a; 