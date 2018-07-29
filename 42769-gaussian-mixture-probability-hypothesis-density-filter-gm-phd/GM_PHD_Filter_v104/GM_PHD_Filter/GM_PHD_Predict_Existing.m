%GM_PHD_Predict_Existing
%Last modified 27th August 2013
%Matlab code by Bryan Clarke b.clarke@acfr.usyd.edu.au 

%This file performs prediction for existing targets
s = sprintf('Step 2: Prediction for existing targets.');
disp(s);

mk_k_minus_1_before_prediction = mk_minus_1;

for j = 1:size(mk_minus_1,2)
    wk_minus_1(j) = prob_survival * wk_minus_1(j);
    mk_minus_1(:,j) = F * mk_minus_1(:,j); %Assume constant velocity.

    P_range = calculateDataRange4(j);
    P_i = Q + F * Pk_minus_1(:,P_range) * F';
    
    prevState = mk_k_minus_1_before_prediction(:,j);
    newState = mk_minus_1(:,j);
    
    Pk_minus_1(:,P_range) = P_i;
    
    if(VERBOSE == 1)
        s = sprintf('\t\tExisting target %d. Previously at %3.4f %3.4f, now at %3.4f %3.4f.', j, prevState(1), prevState(2), newState(1), newState(2));
        disp(s);

        s = sprintf('\t\tP was %3.4f %3.4f, NOW %3.4f %3.4f', Pk_minus_1(1,P_range(1)), Pk_minus_1(2,P_range(2)), P_i(1,1), P_i(2,2));
        disp(s);
    end
end

%% Now we combine the birthed targets with the existing ones.
%Append newly birthed targets (in m_k_minus_1) to back of old ones
wk_k_minus_1 = [wk_minus_1, w_birth, w_spawn];
mk_k_minus_1 = [mk_minus_1, m_birth, m_spawn];
Pk_k_minus_1 = [Pk_minus_1, P_birth, P_spawn];
numTargets_Jk_k_minus_1 = numTargets_Jk_minus_1 + numBirthedTargets + numSpawnedTargets; 
%Create a backup to allow for augmenting the measurement in the update
mk_k_minus_1_before_prediction = [mk_k_minus_1_before_prediction, m_birth_before_prediction];%m_birth_before_prediction also contains the spawned targets before prediction

if(VERBOSE == 1)
    s = sprintf('\tPerformed prediction for %d birthed and existing targets in total.', numTargets_Jk_k_minus_1);
    disp(s);
end