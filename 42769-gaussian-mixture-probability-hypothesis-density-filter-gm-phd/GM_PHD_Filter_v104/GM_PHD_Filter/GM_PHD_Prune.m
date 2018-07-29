%GM_PHD_Prune
%Last modified 12th September 2013
%Matlab code by Bryan Clarke b.clarke@acfr.usyd.edu.au 

%This file performs merging and pruning after the PHD update.
%The PHD update creates a combinatorial explosion in the number of targets.
%We prune the low-weight ones and merge the close-together ones. The weight
%threshold T and distance threshold L that control this process are set in
%GM_PHD_Initialisation.
s = sprintf('Step 5: Prune and merge targets.');
disp(s);

%% Prune out the low-weight targets
I = find(w_k >= T);%Find targets with high enough weights
if(VERBOSE == 1)
    s = sprintf('The only tracks with high enough weights are:');
    disp(s);
    disp(I);
end

%% Merge the close-together targets
l = 0;%Counts number of features
w_bar_k = [];
m_bar_k = [];
P_bar_k = [];
while isempty(I) == false %We delete from I as we merge
    l = l + 1;
    %Find j, which is i corresponding to highest w_k for all i in I
    highWeights = w_k(:,I);
    [maxW, j] = max(highWeights);
    j = j(1); %In case of two targets with equal weight
    %j is an index of highWeights (i.e. a position in I)
    %We want the index in w_k
    j = I(j);
    
    %Find all points with Mahalanobis distance less than U from point
    %m_k(j)
    L = [];%A vector of indexes of w_k
    for iterateI = 1:length(I)
        thisI = I(iterateI);

        delta_m = m_k(:,thisI) - m_k(:,j);
        P_range = calculateDataRange4(thisI); 
        mahal_dist = delta_m' * (P_k(:,P_range) \ delta_m);%Invert covariance via left division
        if(mahal_dist <= mergeThresholdU)
            L = [L, thisI];
        end
    end
    if(VERBOSE == 1)
        s = sprintf('\tMerging target %d with these targets:', j);
        disp(s);
        disp(L);
    end
    %The new weight is the sum of the old weights
    w_bar_k_l = sum(w_k(L));
    
    %The new mean is the weighted average of the merged means
    m_bar_k_l = 0;
    for i = 1:length(L)
        thisI = L(i);
        m_bar_k_l = m_bar_k_l + 1 / w_bar_k_l *  (w_k(thisI) * m_k(:,thisI));
    end
   
    %Calculating covariance P_bar_k is a bit trickier
    P_val = zeros(4,4);
    for i = 1:length(L)
        thisI = L(i);
        delta_m = m_bar_k_l - m_k(:,thisI);  
        P_range = calculateDataRange4(thisI);
        P_val = P_val + w_k(thisI) * (P_k(:,P_range) + delta_m * delta_m');
        tmpP = P_k(:,P_range);
    end
    P_bar_k_l = P_val / w_bar_k_l;
    
    old_P_range = calculateDataRange4(j);
    oldP = P_k(:,old_P_range);

    %Now delete the elements in L from I
    for i = 1:length(L)
        iToRemove = find(I == L(i));
        I(iToRemove) = [];
    end
    
    %Append the new values to the lists
    w_bar_k = [w_bar_k, w_bar_k_l];
    m_bar_k = [m_bar_k, m_bar_k_l];
    P_bar_k = [P_bar_k, P_bar_k_l];
end

numTargets_J_pruned = size(w_bar_k,2);%The number of targets after pruning

%Here you could do some check to see if numTargets_J_pruned > maxGaussiansJ
%and if needed delete some of the weaker gaussians. I haven't bothered but
%it might be useful for your implementation.

numTargets_Jk_minus_1 = numTargets_J_pruned;%Number of targets in total, passed into the next filter iteration
%Store the weights, means and covariances for use next iteration.
wk_minus_1 = w_bar_k; %Weights from this iteration
mk_minus_1 = m_bar_k; %Means from this iteration
Pk_minus_1 = P_bar_k; %Covariances from this iteration
