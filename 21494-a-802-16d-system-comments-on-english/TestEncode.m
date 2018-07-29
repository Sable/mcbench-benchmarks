function TestEncode(n_mod_type,G,SUI,samples,BW,figur)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                        %
%%    Name: TestEncode.m                                                  %
%%                                                                        %
%%       This function runs the routine that simulates the system         %
%%       with different parameters. In this case, we are checking if      %
%%       there are changes in the simulation if we realise it with and    %
%%       withou encoding the transmitted bits.                            %
%%                                                                        %
%%       It returns a graph showing the difference in simulation of       %
%%       both with and without encoding the bits.                         %
%%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
figure(figur);

v_EbN0_dB=[1:18];
encode = 0;           % It is indicated that the function is not going to encode, then it will show the difference of encoding.
                     
channel = channelSUI(SUI,G,BW);

for i=0:1
    v_ber = [];    
    for SNR = v_EbN0_dB
        n_ber = systems(SNR,n_mod_type,G,SUI,encode,samples,BW,channel);
        v_ber = [v_ber n_ber];
    end
    draw('Encode',encode,v_EbN0_dB,v_ber,1);   
    encode = 1;
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
    title(['BER of the received symbols. ( G=',num2str(G),',BW=',num2str(BW),'MHz,AWGN channel and modulation of ',modulation,' )']);
else
    title(['BER of the received symbols. ( G=',num2str(G),',BW=',num2str(BW),'MHz,SUI=',num2str(SUI),' and modulation of ',modulation,' )']);
end

% Theoretical calculation of the BER, based on the used modulationción. (At the moment only AWGN)
  figure(figur);
  BERtheoretical(v_EbN0_dB,n_mod_type,SUI);
  label = legend('Without encoding','With encoding','Theoretical','Location','SouthWest');
