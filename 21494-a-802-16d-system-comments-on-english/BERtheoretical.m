function BERtheoretical(v_EbN0_dB,n_mod_type,SUI);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%         Archivo: BERtheoretical.m                                     %
%%                                                                       %
%%         Description: This file draws the theoretical BER curves       %
%%          according to the approprite case (AWGN or fading)            %
%%                                                                       %
%%         Parameters: It receives the type of modulation for which      %
%%          we have to simulate.                                         %
%%                                                                       %
%%         Result: It returns the theoretical BER curve correnspoding    %
%%          to the one that is being simulated                           %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


v_EbN0=[];
v_ber_theoretical=[];
v_EbN0 = 10.^(v_EbN0_dB./10);   % The linear value of Eb/NO is needed for an AWGN channel
                                

if SUI ~= 0                                   % BER of Rayleigh Fading Channel
    switch n_mod_type
        case 1                                         
            % BER for BPSK
            v_ber_theoretical = berfading(v_EbN0_dB,'psk',2,1);     
            
        case 2    
            % BER for QPSK
            v_ber_theoretical = berfading(v_EbN0_dB,'psk',4,1);
            
        case 4                                                 
            % BER for 16-QAM
            [Ps,v_ber_theoretical]=pb_qam_ray(1:length(v_EbN0_dB),2^n_mod_type,1,'gray');     
            
        case 6                                                
            % BER for 64-QAM
            [Ps,v_ber_theoretical]=pb_qam_ray(1:length(v_EbN0_dB),2^n_mod_type,1,'gray');
            
    end
elseif SUI == 0                               % AWGN channel theoretical BER;
    switch n_mod_type
        case 1                                                 
            % BER for BPSK
             v_ber_theoretical = erfc(sqrt(2*v_EbN0));  
             
        case 2                                                
             % BER for QPSK
             v_ber_theoretical = (1/2)*erfc(sqrt((v_EbN0*n_mod_type)/2));    
             
        case 4                                                
             % BER for 16-QAM
             v_ber_theoretical = (3/8)*erfc(sqrt((v_EbN0*n_mod_type)/10));   
             
        case 6                                                 
            % BER for 64-QAM
             v_ber_theoretical = (7/24)*erfc(sqrt((v_EbN0*n_mod_type)/42));
    end
end


% In the figure at which we are working, the samples of the theoretical BER calculated in every case are drawn.

point = 'b-.';
semilogy(v_EbN0_dB,v_ber_theoretical,point);
