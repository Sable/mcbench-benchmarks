%==========================================================================
%
%  By Gennady Zilberman, Ben-Gurion University of the Negev
%  genazilberman@yahoo.com
%
%   This software performs Forward Channel simulation of IS-95 standrd
%   system. 
%
%   The simulation environment: Static AWGN channel.
%   Link Rate = 9600 KBps
%
%==========================================================================


global Zi Zq Zs show R Gi Gq

clear j;
show = 0;
SD = 0;         % ---- Soft/Hard Decision Receiver

%==========================================================================
% ---------------------------------------- MAIN SIMULATION DEFINITIONS --------------------------------
%==========================================================================
BitRate = 9600;
ChipRate = 1228800; 
N = 184;  		         % 9.6 KBps rate -> 184 netto data bits in each 20 msec packet
MFType = 1;		     % Matched filter type - Raised Cosine
R = 5;			            % Analog Signal Simulation rate

% ------------------------ Viterbi Polynom -------------------
G_Vit = [1 1 1 1 0 1 0 1 1; 1 0 1 1 1 0 0 0 1];
K = size(G_Vit, 2); 		% number of cheap per data bit
L = size(G_Vit, 1); 		% number of cheap per data bit
  
% ------------------------ Walsh Matrix -------------------
WLen = 64;
Walsh = reshape([1;0]*ones(1, WLen/2), WLen , 1);
%Walsh = zeros(WLen ,1);

%------- Spreading PN polynomials ---------
%Gi = [ 1 0 1 0 0 0 1 1 1 0 1 0 0 0 0 1]';
%Gq = [ 1 0 0 1 1 1 0 0 0 1 1 1 1 0 0 1]';

Gi_ind = [15, 13, 9, 8, 7, 5, 0]';
Gq_ind = [15, 12, 11, 10, 6, 5, 4, 3, 0]';

Gi = zeros(16, 1);
Gi(16-Gi_ind) = ones(size(Gi_ind));
Zi = [zeros(length(Gi)-1, 1); 1];     % Initial State for I-Channel PN generator

Gq = zeros(16, 1);
Gq(16-Gq_ind) = ones(size(Gq_ind));
Zq = [zeros(length(Gq)-1, 1); 1]; 	  % Initial State for Q-Channel PN generator

%------- Scrambler Generation Polynom ---------
Gs_ind = [42, 35, 33, 31, 27, 26, 25, 22, 21, 19, 18, 17, 16, 10, 7, 6, 5, 3, 2, 1, 0]';
Gs = zeros(43, 1);
Gs(43-Gs_ind) = ones(size(Gs_ind));
Zs = [zeros(length(Gs)-1, 1); 1];  		% Initial State for Long Sequence Generator


%------- AWGN definitions -------------
EbEc = 10*log10(ChipRate/BitRate); 		% Bit/Chip rate loss
EbEcVit = 10*log10(L);
EbNo = [-2 : 0.5 : 6.5]; 		% measured EbNo range (dB) 

%==========================================================================
% ----------------------------------------------- MAIN SIMULATION LOOP ---------------------------------
%==========================================================================
ErrorsB = []; ErrorsC = []; NN = [];
if (SD == 1)
   fprintf('\n SOFT Decision Viterbi Decoder\n\n');
else
   fprintf('\n HARD Decision Viterbi Decoder\n\n');
end

for i=1:length(EbNo)
   fprintf('\nProcessing %1.1f (dB)', EbNo(i));
   iter = 0;	ErrB = 0; ErrC = 0;
   while (ErrB <300) & (iter <150)
      drawnow;
      
      %----------------------------------- Data Transmit ---------------------------------
      TxData = (randn(N, 1)>0);          %- Gamble the Tx data
      
      [TxChips, Scrambler] = PacketBuilder(TxData, G_Vit, Gs);		% 19.2 Kcps rate
      [x PN MF] = Modulator(TxChips, MFType, Walsh);  % 1.2288 Mcps rate
      
      %-------------------------------- AWGN Channel ------------------------------------
      noise = 1/sqrt(2)*sqrt(R/2)*( randn(size(x)) + j*randn(size(x)))*10^(-(EbNo(i) - EbEc)/20);
      r = x+noise;
      
      %------------------------------------ Receiver ---------------------------------
      RxSD = Demodulator(r, PN, MF, Walsh); 		% Soft Decision   19.2 Kcps
      RxHD = (RxSD>0); 		% Define Hard Decisions received chips
      if (SD)
        % RxSD = sign(RxSD); 		% SOFT Decision = HARD Decision
        % RxSD = sign(RxSD).*(log2(abs(RxSD)+1)); 		% SOFT decision = 3 bits representation
        [RxData Metric]= ReceiverSD(RxSD, G_Vit, Scrambler); 		% Get Received Data 9.6 KBps (Soft Decision)
      else
        [RxData Metric]= ReceiverHD(RxHD, G_Vit, Scrambler); 		% Get Received Data 9.6 KBps (Hard Decision)
      end
      
      
      if(show)
         subplot(311); plot(RxSD, '-o'); title('Soft Decisions');
         subplot(312); plot(xor(TxChips, RxHD), '-o'); title('Chip Errors');
         subplot(313); plot(xor(TxData, RxData), '-o'); 
         title(['Data Bit Errors. Metric = ', num2str(Metric)]);
         pause;
      end        
       
      if(mod(iter, 50)==0)
         fprintf('.');
         save TempResults ErrB ErrC N iter
      end
      
      ErrB = ErrB + sum(xor(RxData, TxData));  % Data bits Error
      ErrC = ErrC + sum(xor(RxHD, TxChips));  	  % Chip Error (before Viterbi)
      iter = iter+ 1;
   end
   %---------------------------------------- Save the data of current  iteration ---------------------
   ErrorsB = [ErrorsB; ErrB];
   ErrorsC = [ErrorsC; ErrC];
   NN = [NN; N*iter];
   save SimData *
end

%---------------------------------------- Calculate Error's probability ----------------------------
PerrB = ErrorsB./NN;
%PerrB1 = ErrorsB1./NN1;
PerrC = ErrorsC./NN;
Pbpsk= 1/2*erfc(sqrt(10.^(EbNo/10)));
PcVit= 1/2*erfc(sqrt(10.^((EbNo-EbEcVit)/10)));
Pc =   1/2*erfc(sqrt(10.^((EbNo-EbEc)/10)));

%---------------------------------------- Show simulation Results -------- ---------------------
figure; 
semilogy(EbNo(1:length(PerrB)), PerrB, 'r-o'); hold on;
%semilogy(EbNo(1:length(PerrB1)), PerrB1, 'k-o'); hold on;
semilogy(EbNo(1:length(PerrC)), PerrC, 'm-o'); grid on;
semilogy(EbNo, Pbpsk, 'b-.x'); xlabel('EbNo (dB)');
%semilogy(EbNo, PcVit, 'k-.x'); ylabel('BER');
semilogy(EbNo, Pc, 'g-.x'); 

title('Error probability as function of EbNo');

legend('Pb of System (HD)', 'Pb of System (SD)', 'Pc before Viterbi of System', ...
   'Pb of BPSK with no Viterbi (theory)', 'Pc on Receiver (theory)');



legend('Pb of System', 'Pc before Viterbi of System', ...
   'Pb of BPSK with no Viterbi (theory)', 'Pc before Viterbi (theory)', 'Pc on Receiver (theory)');
