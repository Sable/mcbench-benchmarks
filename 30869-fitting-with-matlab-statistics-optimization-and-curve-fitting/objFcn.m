function yPred = objFcn(p , tObs, drug)
%Copyright (c) 2011, The MathWorks, Inc.

L0  = p(1)   ; % Drug-independent parameter 1
L1  = p(2)   ; % Drug-independent parameter 2
k1  = p(3)   ; % Drug-independent parameter 3

k2_A  = p(4) ; % Drug dependent parameter (drug A)
k2_B  = p(5) ; % Drug dependent parameter (drug B)

% Simulate model for drug A 
yPred_A = evalTumorWeight(tObs(drug == 'A'), [L1, L0, k1, k2_A]) ;

% Simulate model for drug B 
yPred_B = evalTumorWeight(tObs(drug == 'B'), [L1, L0, k1, k2_B]) ;

% Combine prediction
yPred = [yPred_A; yPred_B] ; 

end