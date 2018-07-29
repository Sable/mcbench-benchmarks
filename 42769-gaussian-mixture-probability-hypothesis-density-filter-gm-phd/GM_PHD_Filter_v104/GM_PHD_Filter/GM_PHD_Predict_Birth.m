%GM_PHD_Predict_Birth
%Last modified 2nd September 2013
%Matlab code by Bryan Clarke b.clarke@acfr.usyd.edu.au 

%This file performs prediction for newly birthed and spawned targets
%This is necessary since their positions were initialised in a previous timestep and they may
%have moved between then and now
%We iterate through j = 1..J_b,k where J_b,k is number of birthed landmarks
%at time k (but the landmarks correspond to the measurement from time k-1)
%For this implementation, birthed and spawned targets are identical except
%they have weights that are calculated from different functions, and
%different starting covariances. A target is spawned or birthed depending
%on which weighting function will give it a higher starting weight.

%The means of these will be the position in Cartesian space where they are detected
%The covariances & weights are calculated according to Vo&Ma
s = sprintf('Step 1: Prediction for birthed and spawned targets.');
disp(s);

m_birth_before_prediction = [m_birth, m_spawn]; %Need to store these BEFORE prediction for use in the update step.

%Perform prediction for birthed targets using birthed velocities.
for j = 1:numBirthedTargets
    i = i + 1;
    %w_birth was already instantiated in GM_PHD_Create_Birth
    m_birth(:,j) = F * m_birth(:,j);
    P_range = calculateDataRange4(j); 
    P_birth(:,P_range) = Q + F * P_birth(:,P_range) * F';
end
%Perform prediction for birthed targets using birthed velocities.
for j = 1:numSpawnedTargets
    i = i + 1;
    %w_birth was already instantiated in GM_PHD_Create_Birth
    m_spawn(:,j) = F * m_spawn(:,j);
    P_range = calculateDataRange4(j); 
    P_spawn(:,P_range) = Q + F * P_spawn(:,P_range) * F';
end

if(VERBOSE == 1)
  for j = 1:numBirthedTargets
        thisM = m_birth(:,j);
        s = sprintf('Birthed target %d: %3.4f %3.4f %3.4f %3.4f Weight %3.9f', j, thisM(1), thisM(2), thisM(3), thisM(4), w_birth(j));
        disp(s);      
  end
  for j = 1:numSpawnedTargets
        thisM = m_spawn(:,j);
        s = sprintf('Spawned target %d: %3.4f %3.4f %3.4f %3.4f Weight %3.9f', j, thisM(1), thisM(2), thisM(3), thisM(4), w_birth(j));
        disp(s);      
   end
end
