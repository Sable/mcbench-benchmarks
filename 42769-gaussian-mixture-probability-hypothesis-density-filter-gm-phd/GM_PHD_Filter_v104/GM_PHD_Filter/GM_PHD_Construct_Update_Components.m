%GM_PHD_Construct_Update_Components
%Last modified 12th September 2013
%Matlab code by Bryan Clarke b.clarke@acfr.usyd.edu.au 

%This file creates the components needed for performing a Kalman filter update on the
%targets using the measurement.
s = sprintf('Step 3: Constructing update components for all targets, new and existing.');
disp(s);

%We need to clear the data structures each iteration
eta = [];
S = [];
K = [];
P_k_k = [];

for j = 1:numTargets_Jk_k_minus_1
    m_j = mk_k_minus_1(:,j);
    eta_j = H2 * m_j;%Observation model. Assume we see position AND velocity of the target.

    P_range = calculateDataRange4(j); %4x4 array

    PHt = Pk_k_minus_1(:,P_range) * H2'; %Taken from Tim Bailey's EKF code. 4x4 array

    %Calculate K via Tim Bailey's method.
    S_j = R2 + H2 * PHt;
    %At this point, Tim Bailey's code makes S_j symmetric. In this case, it leads to the matrix being non-positive definite a lot of the time and chol() crashes.
    %So we won't do that. 
    SChol= chol(S_j);

    SCholInv= SChol \ eye(size(SChol)); % triangular matrix, invert via left division
    W1 = PHt * SCholInv;

    K_j = W1 * SCholInv';

    P_j = Pk_k_minus_1(:,P_range) - W1*W1';%4x4 array
    %End Tim Bailey's code.
    
    eta = [eta, eta_j];
    S = [S, S_j];
    K = [K, K_j];
    P_k_k = [P_k_k, P_j]; 
end