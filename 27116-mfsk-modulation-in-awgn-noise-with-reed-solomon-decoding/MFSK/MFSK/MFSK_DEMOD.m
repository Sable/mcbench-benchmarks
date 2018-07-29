function  Metric_table  = MFSK_DEMOD(Data_in,M,E_s,SNR_dB)
%*** MFSK DEMOD ***
%function  Metric_table  = MFSK_DEMOD(Data_in,M,E_s,SNR_dB)
% Create a (M x n) matrix containing the metrics of the M-FSK demodulator,
% simulating an AWGN channel
% Data_in is random values [0 .. M-1], representing the data that must be
% transmitted
% M is the number of frequencies used (M-FSK)
% E_s is the transmitted signal energy
% SNR_dB is the signal-to-noise ratio, measured in dBs
    
    n = length(Data_in);
    
    %Calculate the mu and sigma_2 values from the SNR
    
    SNR = Convert_SNR(SNR_dB);
    N_o = E_s / SNR;        % Noise Power on channel in dB (Proakis - MFSK)
       
    mu = 0;
    sigma_2 = (1/2)*N_o;
    sigma = sqrt(sigma_2);
        
    
    %******************************
    %*** Create Decision matrix ***
    %******************************
     
    Metric_table = [];
    T_Metrics =[];
    
    %Create 2 x M metric outputs for timeslot i (M equals number of frequencies in M-FSK)
    for num = 1:n
        Signal = [];
        for i = 0:M-1
            if (i == Data_in(num))
                %It is the symbol that was transmitted
                
                %Determine a value for phi
                phi = 2 * pi * rand;
                
                % Compute the COS Component:
                Signal(i+1,1) = sqrt(E_s) * cos(phi) + normrnd(mu,sigma);
                
                % Compute the SIN Component 
                Signal(i+1,2) = sqrt(E_s) * sin(phi) + normrnd(mu,sigma);
                
            else
                Signal(i+1,1) = normrnd(mu,sigma);
                Signal(i+1,2) = normrnd(mu,sigma);
            end
        end
        
        
        % Compute the Envelope metrics for each symbol
        Metrics = [];  % Vector containing the computed envelope metrics
        
        
        for i = 1:M
            Metrics(i) = Decision_metric(Signal(i,1),Signal(i,2));
        end
         
         
        Metric_table = [Metric_table transpose(Metrics)];
    end