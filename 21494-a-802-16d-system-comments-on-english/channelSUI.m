function channel = channelSUI(N_SUI,G,BW)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                        %
%%     Name: channelSUI.m                                                 %
%%                                                                        %
%%     Description: It generates the Channel Impulse Response of the      %
%%     channel variant by using Jakes Model.                              %
%%                                                                        %
%%     The Channel used depends on the parameters that are indicated      %
%%     to it. We can simulate SUI channeles 1 to 6, with different        %
%%     bandwidths.                                                        %
%%                                                                        %
%%     Parameters:                                                        %
%%      N_SUI = Channel to simulate.    G = Size of the cyclic prefix     %
%%      v = Speed of the system.        BW = Bandwidth of the channel     %
%%                                                                        %
%%                                                                        %
%%     Authors: Bertrand Muquet, Sebastien Simoens, Shengli Zhou          %
%%      October 2000                                                      %
%%     Modification : Carlos Batlles - April 2007                         %
%%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Speed of the receiver 0.001 m/s
v = 0.001;                      

% We are going to consider that we are sending a unique symbol
FrameLength = 1;                 

% The following parameters are with which we calculated the duration of the symbol in WiMAX
Nfft = 256;
BW = BW*1e6;

% Factor of correction
if mod(BW,1.75)==0
    n = 8/7;
elseif mod(BW,1.5)==0
    n = 86/75;
elseif mod(BW,1.25)==0
    n = 144/125;
elseif mod(BW,2.75)==0
    n = 316/275;
elseif mod(BW,2)==0
    n = 57/50;
else 
    n = 8/7;
end

if N_SUI~=0
    Fs = floor(n*BW/8000)*8000;         % Sampling frequency
    deltaF = Fs / Nfft;                 % Subcarrier spacing.
    Tb = 1/deltaF;                      % Useful symbol time (data only)
    Ts = Tb * (1+G);                    % OFDM symbol time (data + cyclic prefix)
    T = 1/(Fs*1e-6);                    % Duration in microseconds of each carrier


    [variances,Lc,Dop]=CIRpowers(N_SUI,T);

    hfr=[];
    for ih=1:Lc+1
      hfr=[hfr;genh(FrameLength,v,Dop,Ts)];     
    end
    hfr=diag(variances.^0.5)*hfr;
    %% hfr has a size of (Lc+1)x(FrameLength)
    %% hfr(:,i) It contains the CIR(Channel Impulse Response) corresponding to the transmission of symbol i

    % Finally, the values of the channel are normalized.
    channel = hfr ./ norm(hfr);
    
elseif N_SUI == 0
    channel = 1;         % If an AWGN channel is chosen, the channel will be the unit.
end
