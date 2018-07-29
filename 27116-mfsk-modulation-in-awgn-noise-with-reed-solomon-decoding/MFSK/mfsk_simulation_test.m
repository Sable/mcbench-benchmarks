% Simulates an MFSK system using the PDFs of the signals which are inputs to
% the envelope detector


%Proakis p.307
%Uses RS encoding and decoding

clear
clc


%***********************
%*** MFSK Parameters ***
%***********************
m = 4
M = 2^m         % Amount of Symbols in the MFSK system

E_s = 1        % Signal Power in dB




%**************************
%*** RS code Parameters ***
%**************************

%m = 8
n = 2^m - 1
k = 3                   %Information symbols [ 1 - n-1] where n = 2^m - 1
h = n-k
t = h/2



%*** Generate the Galois Field ***

field = gftuple([-1:2^m-2]', m, 2);


%*** Generator Polynomial ***

%Lin + Costello, p.171

%Get the generator polynomial
c = [1 0]; 
p(1) = c(1);

for i = 1:h-1
    p(1) = gfmul(p(1),1,field);
    p(2) = 0;
    c = gfconv(c,p,field);
end
g = c;

%**************************



%*****************************
%*** Simulation parameters ***
%*****************************

% number of iterations
num_runs = 25


% the length of the data to be transmitted over the channel
num_data = 100       %Number of codewords to be transmitted (Increase to 10000 to obtain smoother curves)

length_data_n = n * num_data;

%***************************




SNR_dB = 2
inc = 0.5;



T_SER = [];
ED_UC_SER = [];
ED_C_SER = [];

SNR_arr = [];






for nr = 1:num_runs
    
    nr
    
    SNR_dB = SNR_dB + inc;
    
    
    
    
    
    
    %Clear the counters
    ACC_Stats_ED = 0;
    ACC_Stats_ED_DEC = 0;
      
    
    
    % for each transmitted codeword, do the following 
    
    for num_codewords = 1:num_data
        
        %Create k random symbols to be encoded 
        INFO = randint(1,k,[-1 M-2]);
        
        %Encode the INFO to form a RS Codeword
        RS_CODE = RS_ENC(INFO,n,k,g,field);
        
        %convert data to M_FSK data
        send_MFSK = ConvertRS2MFSK(RS_CODE);
                     
        %***********************************
     
        
        
        
        %***************************
        %*** Do the demodulation ***
        %***************************
        
        Metric_table = MFSK_DEMOD(send_MFSK, M,E_s, SNR_dB); %Create a table of metrics for MFSK with specific SNR
        
        
        RECEIVED_ED = [];
        
        for j = 1:n
            
            Metrics = transpose(Metric_table(1:M,j));
     
        
            %--- Do for Envelope Detection ---
            RECEIVED_ED = [RECEIVED_ED DECODE_MFSK(Metrics,M)];
            
        end
        
        %*** End demodulation *** 
             
        
        
        %**********************
        %*** Do RS decoding ***
        %**********************
    
    
        %*** Envelope detection ***
        
        RECEIVED_ED_SYMB = ConvertMFSK2RS(RECEIVED_ED);
        Stats_ED =  Compare(RECEIVED_ED_SYMB, RS_CODE,n,field);       %Without coding
        
        
        Stats_ED_DEC = Decode_and_compare(RECEIVED_ED,RS_CODE,n,k,t,h,g,field);
    
          
        %**********************
        
        
        %************************
        %*** Accumulute Stats ***
        %************************
        ACC_Stats_ED = ACC_Stats_ED + Stats_ED;
        ACC_Stats_ED_DEC = ACC_Stats_ED_DEC + Stats_ED_DEC;
        
        %************************
        
    end
    
    %***********************
    %*** Calculate Stats ***
    %***********************
    
    %*** Theoretical result for envelope detection ***
    prob_symb_err = prob_symb_error_MFSK(M,SNR_dB);
    
    %*** Envelope Detector Statistics ***
    sym_prob_ED = ACC_Stats_ED / length_data_n;      %Envelope demodulation without decoding
    dec_sym_prob_ED = ACC_Stats_ED_DEC/length_data_n;    %Envelope demodulation with decoding
            
    %*******************
    
    
    T_SER = [T_SER prob_symb_err];
    ED_UC_SER = [ED_UC_SER sym_prob_ED];
    ED_C_SER = [ED_C_SER dec_sym_prob_ED];

        
    SNR_arr = [SNR_arr SNR_dB];
    
end


%Plot the data
plot_compare = figure;
semilogy(SNR_arr,T_SER,'k*-' , SNR_arr, ED_UC_SER,'kd-' , ...
    SNR_arr, ED_C_SER,'kx-');


xlabel('SNR','FontWeight','Bold','FontSize',12);
ylabel('Probability of a symbol error','FontWeight','Bold','FontSize',12);
tt = [int2str(2^m) '-FSK (' int2str(n) ',' int2str(k) ') RS']
title(tt);
set(plot_compare,'Position',[10,10,1000,600]);

legend('Theoretical','Envelope detection - uncoded', 'Envelope detection - coded')