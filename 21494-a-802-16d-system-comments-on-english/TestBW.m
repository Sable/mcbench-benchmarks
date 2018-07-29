function TestBW (G,SUI,n_mod_type,samples,figur)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                        %
%%    Name: TestBW.m                                                      %
%%                                                                        %
%%       This function runs the routine that simulates the system         %
%%       with different parameters. In this case, a variation is          %
%%       made to the available bandwidth in the system the effects        %
%%       are studied.                                                     %
%%                                                                        %
%%      It then returns graphs of the different simulations when the      %   
%%      bits are transmitted through different channels.                  %
%%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(figur);

% Some of the bandwidths available.
v_BW = [28 20 15 10 2.50 1.25];
v_EbN0_dB=[1:20];
encode = 1;

% The simulations for the different bandwidths are realized.
for BW = v_BW         
    channel = channelSUI(SUI,G,BW);
    v_ber=[];
    for SNR = v_EbN0_dB
        n_ber = systems(SNR,n_mod_type,G,SUI,encode,samples,BW,channel);
        v_ber = [v_ber n_ber];
    end  
    draw('BW',BW,v_EbN0_dB,v_ber,1);
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
    title(['BER of the received symbols. ( G=',num2str(G),',channel AWGN',' and modulation of ',modulation,' )']);
else
    title(['BER of the received symbols. ( G=',num2str(G),',SUI=',num2str(SUI),' and modulation of ',modulation,' )']);
end

% CTheoretical calculation of the BER, based on the used modulationción.(At the moment only AWGN)
figure(figur);
BERtheoretical(v_EbN0_dB,n_mod_type,SUI);
label = legend('BW.-28 MHz','BW.-20 MHz','BW.-15 MHz','BW.-10 MHz','BW.-2.5 MHz','BW.-1.25 MHz','Theoretical','Location','SouthWest');

