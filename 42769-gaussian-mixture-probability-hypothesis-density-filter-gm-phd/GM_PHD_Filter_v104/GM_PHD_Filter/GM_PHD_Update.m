%GM_PHD_Update
%Last modified 27th August 2013
%Matlab code by Bryan Clarke b.clarke@acfr.usyd.edu.au 

%This file performs a PHD filter update on the targets
%This is basically a brute-force Kalman update of every target with every
%measurement and creating a new target from the update results.

s = sprintf('Step 4: Performing update.');
disp(s);

%Set up matrices for post-update filter state
w_k = zeros(1, numTargets_Jk_k_minus_1 * size(Z, 2) + numTargets_Jk_k_minus_1);
m_k = zeros(4, numTargets_Jk_k_minus_1 * size(Z, 2) + numTargets_Jk_k_minus_1);
P_k =  zeros(size(Pk_k_minus_1,1), size(Pk_k_minus_1,1) * (numTargets_Jk_k_minus_1 * size(Z, 2) + numTargets_Jk_k_minus_1));

thisAugmentedZ = [];%This is used for plotting if we want to show extra data

%First we assume that we failed to detect all targets.
%We scale all weights by probability of missed detection
%We already did the prediction step for these so their position &
%covariance will have been updated. What remains is to rescale their
%weight.
for j = 1:numTargets_Jk_k_minus_1
    w_k(j) = (1 - prob_detection) * wk_k_minus_1(j); 
    m_k(:,j) = mk_k_minus_1(:,j);    
    P_range = calculateDataRange4(j);
    newP = Pk_k_minus_1(:,P_range);
    P_k(:,P_range) = newP;
end

%Now we update all combinations of matching every observation with every target in the
%map. 
%First we expand the observation to include velocity (by simple v = delta_x/delta_t for 
%delta_x = measured_position - position_before_prediction. 
%That is, how fast would the target have needed
%to move to get from where it was to where it was seen now?
L = 0; 
for zi = 1:size(Z,2)
    L = L + 1;%L is used to calculate an offset from previous updates. It maxes out at L = number_of_measurements. A more elegant solution would be to set L = zi but I retain this method for compatibility with Vo&Ma
    if(VERBOSE == 1)
        s = sprintf('Matching targets against measurement %d', zi);
        disp(s);
    end
    
    for j = 1:numTargets_Jk_k_minus_1

        m_j = mk_k_minus_1(:,j);
        %Augment the measurement of position with calculated velocity
        thisZ = Z(:,zi);%This consists of only the observed position. But we need to extract the equivalent velocity observation
        prevX = mk_k_minus_1_before_prediction(1:2,j);%Get the old (pre-prediction) position of the target
        V = (thisZ - prevX) / dt;%velocity = dx / dt. Since Z and x are 2d, V = [Vx Vy]
        thisZ = [thisZ; V];%So we pretend to observe velocity as well as position
        thisAugmentedZ = [thisAugmentedZ, thisZ];%Store for plotting.
      
        %If this is the first time a target has been observed, it will have
        %no velocity stored.
        %Therefore it will be missing a prediction update, which will
        %impact both its position and its covariance.
        thisIndex = L * numTargets_Jk_k_minus_1 + j;
        
        old_P_range = calculateDataRange4(j);%Returns 4 columns
        new_P_range = 4 * L * numTargets_Jk_k_minus_1 + old_P_range;
        S_range = calculateDataRange4(j);
        
        %Recalculate weight.
        w_new = prob_detection * wk_k_minus_1(j) * mvnpdf(thisZ(weightDataRange), eta(weightDataRange,j), S(weightDataRange,S_range(weightDataRange)));%Hoping normpdf is the function I need
        w_k(thisIndex) = w_new;
        
        %Update mean
        delta = thisZ - eta(:,j);
        K_range = calculateDataRange4(j);
        m_new = m_j +  K(:,K_range) * delta;
        m_k(:,thisIndex) = m_new;
        
        %Update covariance
        P_new = P_k_k(:,old_P_range);
        P_k(:,new_P_range) = P_new;
        
        if(VERBOSE == 1)
            s1 = sprintf('Observation: %3.4f %3.4f %3.4f %3.4f', thisZ(1), thisZ(2), thisZ(3), thisZ(4));
            disp(s1);
            thisEta = eta(:,j);
            s2 = sprintf('Expected Obs: %3.4f %3.4f %3.4f %3.4f', thisEta(1), thisEta(2), thisEta(3), thisEta(4));
            disp(s2);

            s1 = sprintf('Before Update: %3.4f %3.4f %3.4f %3.4f %3.4f %3.4f', m_k(1), m_k(2), m_k(3), m_k(4));
            s2 = sprintf('After Update: %3.4f %3.4f %3.4f %3.4f', m_new(1), m_new(2), m_new(3), m_new(4));
            s3 = sprintf('True State: %3.4f %3.4f %3.4f %3.4f', simTarget1State(1), simTarget1State(2), simTarget1Vel(1), simTarget1Vel(2));
            disp(s1);
            disp(s2);
            disp(s3);
        end

    end

    %Sum up weights for use in reweighting
    weight_tally = 0;
    for i = 1:numTargets_Jk_k_minus_1
        thisIndex = L * numTargets_Jk_k_minus_1 + i;
        weight_tally = weight_tally + w_k(thisIndex);
    end
    
    %Recalculate weights
    if(VERBOSE == 1)
        s = sprintf('Calculating new weights for observation %d', zi);
        disp(s);
    end
    for j = 1:numTargets_Jk_k_minus_1
        old_weight = w_k(L * numTargets_Jk_k_minus_1 + j);
        measZ = [Z(1,zi), Z(2,zi)];
        new_weight = old_weight / (clutter_intensity(measZ) + weight_tally);%Normalise
        w_k(L * numTargets_Jk_k_minus_1 + j) = new_weight;
        
        S_range = calculateDataRange4(j);%Data range for S, which is 2x2 matrix
        if(VERBOSE == 1)
            s = sprintf('\tNew target %d: Matching old target %d at %3.4f %3.4f to measurement %d at %3.4f %3.4f. Prob detection %3.4f. Old Weight %3.8f New Weight %3.8f Normalised New Weight: %3.8f', L * numTargets_Jk_k_minus_1 + j, j, mk_k_minus_1(1, j), mk_k_minus_1(2, j), zi, measZ(1), measZ(2), mvnpdf(Z(1:2,zi), eta(1:2,j), S(1:2,S_range(1:2))), wk_k_minus_1(j), old_weight, new_weight);
            disp(s);
        end
    end

end
numTargets_Jk = L * numTargets_Jk_k_minus_1 + numTargets_Jk_k_minus_1;

if(VERBOSE == 1)
    for j = 1:numTargets_Jk
        thisPos = m_k(:,j);
        thisW = w_k(j);
        s = sprintf('Target %d: %3.4f %3.4f %3.4f %3.4f, Weight %3.9f', j, thisPos(1), thisPos(2), thisPos(3), thisPos(4), thisW);
        disp(s);
    end
end