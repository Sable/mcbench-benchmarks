function TestCP(n_mod_type,SUI,samples,BW,figur);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                        %
%%   Name: PruebaCP.m                                                     %
%%                                                                        %
%%       This function runs the routine that simulates the system         %
%%       with different parameters. In this case, we do a change of       %
%%       the size of the cyclical prefix to see how it influences         %
%%       the probability of error of the transmitted bits.                %
%%                                                                        %
%%       It returns graphs of the simulations with the different sizes    %
%%       of the prefix.                                                   %
%%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(figur);

% The different sizes of the Cyclic Prefix that can be used
v_G = [1/4 1/8 1/16 1/32];          
v_EbN0_dB=[1:15];
encode = 1;

% Different simulations are made for the different values of G
for G = v_G   
    v_ber=[];
    channel = channelSUI(SUI,G,BW);
    for SNR = v_EbN0_dB
        n_ber = systems(SNR,n_mod_type,G,SUI,encode,samples,BW,channel);
        v_ber = [v_ber n_ber];
    end
    draw('CP',G,v_EbN0_dB,v_ber,1);
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

if SUI == 0
    title(['BER of the received symbols. ( channel AWGN, BW=',num2str(BW),'MHz and modulation of ',modulation,' )']);
else
    title(['BER of the received symbols. ( SUI=',num2str(SUI),',BW=',num2str(BW),'MHz and modulation of ',modulation,' )']);
end

% Theoretical calculation of the BER, based on the used modulationción. (At the moment only AWGN)
figure(figur);
BERtheoretical(v_EbN0_dB,n_mod_type,SUI);
label = legend('CP=1/4','CP=1/8','CP=1/16','CP=1/32','Theoretical','Location','SouthWest');



