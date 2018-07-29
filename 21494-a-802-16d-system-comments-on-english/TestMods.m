function TestMods (G,SUI,samples,BW,figur)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                        %
%%   Name: TestMods.m                                                     %
%%                                                                        %
%%       This function runs the routine that simulates the system         %
%%       with different parameters. In this case we are calling the       %
%%       function to realize mapping in differenct methods. This way,     %
%%       it will give us constellation mappings using BPSK, QPSK,         %
%%       16QAM and 64QAM.                                                 %
%%                                                                        %
%%       It will return a graph of the differences of the simulation      %
%%       on having used different mappings of the bits to transmit.       %
%%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% The types of modulations for which the program can simulate
v_mod_type = [1 2 4 6];               
v_EbN0_dB = [1:20];
encode = 1;

channel = channelSUI(SUI,G,BW);

% The simulations for different modulations are realized
for n_mod_type = v_mod_type         
    v_ber=[];
    
    for SNR = v_EbN0_dB
        n_ber = systems(SNR,n_mod_type,G,SUI,encode,samples,BW,channel);
        v_ber = [v_ber n_ber];
    end  
    
    switch n_mod_type
        case 1
            modulation = 'BPSK';
        case 2
            modulation = 'QPSK';
        case 4
            modulation = '16QAM';
        case 6
            modulation = '64QAM';
    end
   
    figure(figur);
    semilogy(v_EbN0_dB,v_ber,'r-o');
    
    if SUI == 0
        title(['BER of the received symbols. ( G=',num2str(G),',BW=',num2str(BW),'MHz, AWGN channel and modulation of ',modulation,' )']);
    else
        title(['BER of the received symbols. ( G=',num2str(G),',BW=',num2str(BW),'MHz,SUI=',num2str(SUI),' and modulation of ',modulation,' )']);
    end
    
    hold on;drawnow;
    
    % Theoretical calculation of the BER, according to the used modulation.
    figure(figur);
    BERtheoretical(v_EbN0_dB,n_mod_type,SUI);
    label = legend('Simulated','Theoretical','Location','SouthWest');
    figur = figur+1;

end

