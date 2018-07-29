function TestChannels(n_mod_type,G,samples,BW,figur)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                        %
%%   Name: TestChannels.m                                                 %
%%                                                                        %
%%       This function runs the routine that simulates the system         %
%%       with different parameters. In this case, we are trying to        %
%%       see if there are changes in the simulation if we varied the      %
%%       channel in which we realised the simulation (SUI 1 to the 6)     %
%%                                                                        %
%%       It will give back a graph of the differences of the simulations  %
%%       in these channels.                                               %
%%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(figur);

% Different SUI channels to simulate.
v_SUI = [1 2 3 4 5 6];              

v_EbN0_dB=[1:15];
encode = 1;           % It indicates that encoding is going to be used.

% The simulations are done for each of the channels.
for SUI = v_SUI  
    channel = channelSUI(SUI,G,BW);
    v_ber=[];
    for SNR = v_EbN0_dB
        n_ber = systems(SNR,n_mod_type,G,SUI,encode,samples,BW,channel);
        v_ber = [v_ber n_ber];
    end   
    draw('Channels',SUI,v_EbN0_dB,v_ber,1);
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


title(['BER of the received symbols. ( G=',num2str(G),',BW=',num2str(BW),'MHz and modulation of ',modulation,' )']);


% CTheoretical calculation of the BER, based on the used modulationción.(At the moment only AWGN)
figure(figur);
BERtheoretical(v_EbN0_dB,n_mod_type,SUI);
label = legend('SUI-1','SUI-2','SUI-3','SUI-4','SUI-5','SUI-6','Theoretical','Location','SouthWest');
