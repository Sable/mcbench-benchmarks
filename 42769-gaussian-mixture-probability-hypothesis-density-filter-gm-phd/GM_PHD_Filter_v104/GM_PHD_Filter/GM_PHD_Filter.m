%GM_PHD_Filter
%Version 1.04, last modified 12th September 2013
%Matlab code by Bryan Clarke b.clarke@acfr.usyd.edu.au 
%With:
%- some Kalman filter update code by Tim Bailey, taken from his website http://www-personal.acfr.usyd.edu.au/tbailey/software/
%- error_ellipse by AJ Johnson, taken from Matlab Central http://www.mathworks.com.au/matlabcentral/fileexchange/4705-errorellipse
%The GM-PHD algorithm is from Ba-Ngu Vo & Wing-Kin Ma in:
%B.-N. Vo, W.-K. Ma, "The Gaussian Mixture Probability Hypothesis Density
%Filter", IEEE Transactions on Signal Processing, Vol 54, No. 11, November 2006, pp4091-4104

%See the README.txt, the comments and the Vo & Ma paper for more
%information about what this code actually does.

clear all;
close all;
clc;

%Step 0: Initialisation
GM_PHD_Initialisation;
GM_PHD_Simulate_Initialise;

%In Vo&Ma, the targets are known at filter initialisation.
%If we want to know about them, set KNOWN_TARGET to 1 in GM_PHD_Initialisation.
%Otherwise they should be initialised after being detected a few times.
%HOWEVER this is not guaranteed - sometimes due to noise or missed
%detections, one or both of the targets will not be tracked. I'm pretty
%sure this is just part of the filter and the birth_intensity function.
if KNOWN_TARGET == 1
    t1start = [simTarget1Start(1:2); simTarget1Vel];
    t2start = [simTarget2Start(1:2); simTarget2Vel];
    m_birth = [t1start, t2start];
    w_birth = [birth_intensity(t1start), birth_intensity(t2start)];
    P_birth = [covariance_birth, covariance_birth];
    numBirthedTargets = 2;
end

%Main loop
while (k < endTime)%k = timestep
    k = k + 1;
    s = sprintf('======ITERATION %d======', k);
    disp(s);
    
    %Step Sim: Generate sensor Measurements
    %If you want to use this code with your own data or for a different problem,
    %replace this function with your own.
    GM_PHD_Simulate_Measurements;  
    
    %Step 1: Prediction for birthed/spawned targets 
    GM_PHD_Predict_Birth;  
    %Step 2: Prediction for existing targets
    GM_PHD_Predict_Existing;
    %Step 3: Construction of PHD update components
    GM_PHD_Construct_Update_Components;
    %Step 4: Update targets with measurements
    GM_PHD_Update;
    %Step 5: Prune targets
    GM_PHD_Prune;
    %Step 6: Estimate position of targets
    GM_PHD_Estimate

    %Step 7: Create birthed-targets-list to add next iteration in Step 1.
    %Not a formal part of Vo&Ma but an essential step!
    GM_PHD_Create_Birth; 
    %Step Plot: Generate graphs
    GM_PHD_Simulate_Plot;
    
    if(VERBOSE == true)
        pause;%Pause to allow reading of the text
    end

end

