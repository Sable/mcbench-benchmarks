%GM_PHD_Estimate
%Last modified 27th August 2013
%Matlab code by Bryan Clarke b.clarke@acfr.usyd.edu.au 

%This file estimates the positions of targets tracked by the PHD filter.
%We need to extract the likely target positions from the PHD (i.e. we need to find the peaks of the PHD).
%This is actually fairly tricky. The naive approach is to pull out targets with the
%highest weights, but this is FAR from the best approach. A large covariance will pull down
%the peak size, and when targets are close together or have high covariances, there can be
%superposition effects which shift the peak.
%This just implements the method in Vo&Ma, which is pulling out every target with a weight over  
%weightThresholdToBeExtracted (defined in GM_PHD_Initialisation).
s = sprintf('Step 6: Estimate target states');
disp(s);

X_k_P = [];
X_k_w = [];

i = find(w_bar_k > weightThresholdToBeExtracted);%The algorithm in the paper seems a bit redundant - checking the threshold AND rounding. So we use the one from Mullane
X_k = m_bar_k(:,i);
X_k_w = w_bar_k(:,i);
for j = 1:length(i)
    thisI = i(j);
    P_range = calculateDataRange4(thisI);
   
    thisP = P_bar_k(:,P_range);
    X_k_P = [X_k_P, thisP];
end

if(VERBOSE == 1)
    s = sprintf('\t%d targets beleived to be valid:', size(X_k, 2));
    disp(s);
    for i = 1:size(X_k, 2)
        P_range = calculateDataRange4(i);
       s = sprintf('\t\tTarget %d at %3.4f %3.4f, P %3.4f %3.4f, W %3.5f', i, X_k(1, i), X_k(2,i), X_k_P(1, P_range(1)), X_k_P(2, P_range(2)), w_bar_k(i));
       disp(s);
    end
end

%Store history for plotting.
X_k_history = [X_k_history, X_k];