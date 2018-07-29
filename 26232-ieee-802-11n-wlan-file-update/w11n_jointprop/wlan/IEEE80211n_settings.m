function params = IEEE80211n_settings(...
	NTX, ...
	NRX, ...
    MCS, ...
	SSpreading, ...
	Beamform, ...
	STBC, ...
    PayloadSize);

global PER_bitPayload;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Based on TGn Joint Proposal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display '----------------------------------'
display 'IEEE 802.11n:   TGn Joint Proposal'
display '----------------------------------'

% Note: A sample period of 0.08e-6 corresponds to approx. 12 Msym/s, 
% which, in turn, corresponds to 54 Mb/s for 3/4-coded 64-QAM
symbolPeriod = 0.04e-6;
vtbd = 128; %%34;    

% Setup the IEEE 802.11n parameters
p.NTX_max = 4;
p.NRX_max = 4;
p.NTX = NTX;
p.NRX = NRX;
p.NSS = floor(MCS/8)+1;
p.STBC = STBC;
p.NSTS = p.NSS + STBC;
p.SSpreading = SSpreading;
p.Beamform = Beamform;
p.NLTF = p.NSTS;
if (p.NSTS==3) % use 4 TRN symbols for NSTS=3
   p.NLTF = 4;
end
p.Rate = mod(MCS,8)+1;

% IEEE 802.11n - fundamental sizes
p.NSD_L = 48;  % number of data symbols in Legacy OFDM symbol
p.NSD   = 52;  % number of data symbols in OFDM symbol
p.NST   = 56;  % number of data symbols and pilots in OFDM symbol
p.NFFT  = 64; % number of points on FFT
p.NcyclicPrefix = 16;
p.NFFT2 = p.NFFT + p.NcyclicPrefix;

% Compute number of MIMO OFDM symbols from rate, payload
MCS_BitsPerSym = p.NSS * p.NSD * ...
                 [1 2 2 4 4 6 6 6] .* ...
                 [1/2 1/2 3/4 1/2 3/4 2/3 3/4 5/6] ;
PER_bitPayload = (8*PayloadSize+vtbd);
OFDMSymPerFrame = ceil(PER_bitPayload/MCS_BitsPerSym(p.Rate));

% Multiple of two (space-time coding)
OFDMSymPerFrame = ceil(OFDMSymPerFrame/2)*2;

% TX indices
p.TXFFTShiftIndices = [p.NST/2+1:p.NFFT 1:p.NST/2];
p.TXCyclicPrefixIndices = [p.NFFT-[p.NcyclicPrefix-1:-1:0] 1:p.NFFT];

% RX indices
p.RXCyclicPrefixIndices = [p.NcyclicPrefix+1:p.NFFT2];
p.RXSelectFFTIndices = [p.NFFT-[p.NST/2-1:-1:0] 1:p.NST/2+1];

% TX Data Subcarriers
p.TXDataCarriers = {1:7, 8:20, 21:26, 27:32, 33:45, 46:52};

% OFDM symbols
p.OFDM_LSTF_SymPerFrame = 2; % fixed
p.OFDM_LLTF_SymPerFrame = 2; % fixed
p.OFDM_LSIG_SymPerFrame = 1; % fixed
p.OFDM_HTSIG_SymPerFrame = 2; % fixed
p.OFDM_HTSTF_SymPerFrame = 1; % fixed
p.OFDM_HTLTF_SymPerFrame = p.NLTF;  % 2+(p.NLTF-1);
p.OFDM_TotPreamblePerFrame = ( p.OFDM_LSTF_SymPerFrame+p.OFDM_LLTF_SymPerFrame+ ...
                               p.OFDM_LSIG_SymPerFrame+p.OFDM_HTSIG_SymPerFrame+ ...
                               p.OFDM_HTSTF_SymPerFrame+p.OFDM_HTLTF_SymPerFrame );
p.OFDMTrainPerFrame = p.OFDM_HTLTF_SymPerFrame; % only use HT-LTF (for now)
p.OFDMSymPerFrame = OFDMSymPerFrame;
p.OFDMTotSymPerFrame = p.OFDMSymPerFrame + p.OFDM_TotPreamblePerFrame;

% Indices for preamble, data mode symbols
p.OFDM_PreambleIndices = 1 : p.OFDM_TotPreamblePerFrame;
p.OFDM_DatamodeIndices = p.OFDM_TotPreamblePerFrame+1 : p.OFDMTotSymPerFrame;

% For space-time block coding (STBC), to re-sort symbol indices
STBCSymPerFrame = OFDMSymPerFrame;
p.TXSTBCInputIndices1 = 1:2:STBCSymPerFrame;
p.TXSTBCInputIndices2 = 2:2:STBCSymPerFrame;
p.TXSTBCShiftIndices(1:2:STBCSymPerFrame) = 1 : (STBCSymPerFrame/2);
p.TXSTBCShiftIndices(2:2:STBCSymPerFrame) = (STBCSymPerFrame/2 + 1) : STBCSymPerFrame;

% Constellation symbols
p.numTxSymbols = p.NSD * OFDMSymPerFrame;
p.numTrainingSymbols = p.NSD * p.OFDMTrainPerFrame;

% L-SIG, HT-SIG data
p.OFDM_LSIG_data  = [0 0 0 1 1 0 0 0 0 0 1 1 0 1 1 1 1 0 0 1 0 0 1 1];  % 24 bits (dummy data for now)
p.OFDM_HTSIG_data = [0 0 0 1 1 0 0 0 0 0 1 1 0 1 1 1 1 0 0 1 0 0 1 1 ...
                     1 1 1 1 0 1 0 0 0 1 1 0 1 0 1 1 1 0 1 1 0 1 1 1]; % 48 bits (dummy data for now)

% Training sequence (L-STF) (Note: Two zeros added to each side to match HT-LTF)
p.short_training_seq = ...
    (1/sqrt(2))*[0 0 0 0 1+j 0 0 0 -1-j 0 0 0 1+j 0 0 0 -1-j 0 0 0 -1-j 0 0 0 1+j 0 0 0 ...
     0 0 0 0 -1-j 0 0 0 -1-j 0 0 0 1+j 0 0 0 1+j 0 0 0 1+j 0 0 0 1+j 0 0 0 0].';   
% Training sequence (L-LTF) (Note: Two zeros added to each side to match HT-LTF)
p.long_training_seq = ...
    [0 0 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 0 ...
     1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1 0 0].';   
% Scale L-STF, L-LTF sequences
p.short_training_seq = p.short_training_seq * sqrt(p.NSD)/sqrt(12);
p.long_training_seq  = p.long_training_seq  * sqrt(p.NSD)/sqrt(p.NSD_L);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Training sequences HT-STF, HT-LTF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: Mixed mode (MM) only...
    
% Training sequence (HT-STF)
%   - symbol same as L-STF except for cyclic shifts (CS) across
%     antennas (added elsewhere)
p.HT20_short_training_seq_ss1 = p.short_training_seq;
p.HT20_short_training_seq_ss2 = p.short_training_seq;
p.HT20_short_training_seq_ss3 = p.short_training_seq;
p.HT20_short_training_seq_ss4 = p.short_training_seq;

% Training sequence (HT-LTF)
%   - symbols similar to L-LTF except for cyclic shifts (CS) across
%     antennas (added elsewhere), as well as coding over space and
%     time (matrix P_LTF)
P_LTF = [ 1 -1  1  1; ...
          1  1 -1  1; ...
          1  1  1 -1; ...
         -1  1  1  1; ];
HT20_LTF_seq = ...
    [1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 0 ...
     1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1].';   
HT20_LTF_seq_zeros  = zeros(size(HT20_LTF_seq));

% Create HT-LTF sequence
if (p.NSTS==1)
    % generate NLTF sequences
    p.HT20_long_training_seq_ss1 = kron(P_LTF(1,1), HT20_LTF_seq);
    % set other spatial streams to ones (set to zero elsewhere)
    p.HT20_long_training_seq_ss2 = HT20_LTF_seq_zeros + 1;
    p.HT20_long_training_seq_ss3 = HT20_LTF_seq_zeros + 1;
    p.HT20_long_training_seq_ss4 = HT20_LTF_seq_zeros + 1;
elseif (p.NSTS==2)
    % generate NLTF sequences
    p.HT20_long_training_seq_ss1 = kron(P_LTF(1,1:2), HT20_LTF_seq);
    p.HT20_long_training_seq_ss2 = kron(P_LTF(2,1:2), HT20_LTF_seq);
    % set other spatial streams to ones (set to zero elsewhere)
    p.HT20_long_training_seq_ss3 = [ HT20_LTF_seq_zeros  HT20_LTF_seq_zeros ] + 1;
    p.HT20_long_training_seq_ss4 = [ HT20_LTF_seq_zeros  HT20_LTF_seq_zeros ] + 1;
elseif (p.NSTS==3)
    % generate NLTF sequences (4 OFDM symbols)
    p.HT20_long_training_seq_ss1 = kron(P_LTF(1,1:4), HT20_LTF_seq);
    p.HT20_long_training_seq_ss2 = kron(P_LTF(2,1:4), HT20_LTF_seq);
    p.HT20_long_training_seq_ss3 = kron(P_LTF(3,1:4), HT20_LTF_seq);
    % set other spatial streams to ones (set to zero elsewhere)
    p.HT20_long_training_seq_ss4 = [ HT20_LTF_seq_zeros  HT20_LTF_seq_zeros ...
                                     HT20_LTF_seq_zeros  HT20_LTF_seq_zeros ] + 1;
elseif (p.NSTS==4)
    % generate NLTF sequences
    p.HT20_long_training_seq_ss1 = kron(P_LTF(1,1:4), HT20_LTF_seq);
    p.HT20_long_training_seq_ss2 = kron(P_LTF(2,1:4), HT20_LTF_seq);
    p.HT20_long_training_seq_ss3 = kron(P_LTF(3,1:4), HT20_LTF_seq);
    p.HT20_long_training_seq_ss4 = kron(P_LTF(4,1:4), HT20_LTF_seq);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cyclic Shifts before IFFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: Mixed mode (MM) only...

% Used only for spatial expansion
if (p.SSpreading==1)
    % Cyclic Shift (CS) for HT (used after HT-STF)
    k = (-28:28).';  % subcarriers (-28 to 28)
    dF = 0.3125e6;   % subcarrier spacing = 0.3125 MHz (20 MHz / 64)
    % CS for HT mode...
    p.cs1_HT20_ss1 = exp(j*0*2*pi*dF*   0e-9*k); %    0 ns delay
    p.cs1_HT20_ss2 = exp(j*1*2*pi*dF*-400e-9*k); % -400 ns delay
    p.cs1_HT20_ss3 = exp(j*2*2*pi*dF*-200e-9*k); % -200 ns delay
    p.cs1_HT20_ss4 = exp(j*3*2*pi*dF*-600e-9*k); % -600 ns delay
    % Add cyclic shift to HT-LTF, Data mode
    no_cs1 = repmat(ones(size(k)), 1, p.OFDM_TotPreamblePerFrame-p.OFDMTrainPerFrame);
    p.cs1_HT20_ss1 = [no_cs1 repmat(p.cs1_HT20_ss1, 1, p.OFDMTrainPerFrame+OFDMSymPerFrame)];
    p.cs1_HT20_ss2 = [no_cs1 repmat(p.cs1_HT20_ss2, 1, p.OFDMTrainPerFrame+OFDMSymPerFrame)];
    p.cs1_HT20_ss3 = [no_cs1 repmat(p.cs1_HT20_ss3, 1, p.OFDMTrainPerFrame+OFDMSymPerFrame)];
    p.cs1_HT20_ss4 = [no_cs1 repmat(p.cs1_HT20_ss4, 1, p.OFDMTrainPerFrame+OFDMSymPerFrame)];
else % disable CSD
    % no CSD used
    k = (-28:28).';  % subcarriers (-28 to 28)
    p.cs1_HT20_ss1 = repmat(ones(size(k)), 1, p.OFDM_TotPreamblePerFrame+OFDMSymPerFrame);
    p.cs1_HT20_ss2 = repmat(ones(size(k)), 1, p.OFDM_TotPreamblePerFrame+OFDMSymPerFrame);
    p.cs1_HT20_ss3 = repmat(ones(size(k)), 1, p.OFDM_TotPreamblePerFrame+OFDMSymPerFrame);
    p.cs1_HT20_ss4 = repmat(ones(size(k)), 1, p.OFDM_TotPreamblePerFrame+OFDMSymPerFrame);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Antenna Mapping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% Direct Map/Spatial Spreading
if (p.SSpreading==0)  
    %%%% Direct Map
    
    % Legacy Antenna Mapping
    p.L_Pmap = [ 1 0 0 0; ...
                 0 0 0 0; ...
                 0 0 0 0; ...
                 0 0 0 0 ];      % legacy antenna map
         
    % HT Antenna Mapping
    p.HT_Pmap = eye(p.NTX_max);
else
    %%%% Spatial Spreading
    
    % Legacy Antenna Mapping
    p.L_Pmap = zeros(p.NTX_max, p.NTX_max);
    p.L_Pmap(1:p.NTX,1:p.NTX) = eye(p.NTX);
         
    % HT Antenna Mapping
    if (p.NTX==2)
        % 2x2 Walsh (4x4 with zeros)
        p.HT_Pmap = 1/sqrt(2)*[ 1  1  0  0; ...
                                1 -1  0  0; ...
                                0  0  0  0; ...
                                0  0  0  0 ];
    elseif (p.NTX==3)
        % 3x3 Fourier (4x4 with zeros)
        p.HT_Pmap = 1/sqrt(3)*[ 1           1              1           0; ...
                                1     exp(j*2*pi/3) exp(-j*2*pi/3)     0; ...
                                1    exp(-j*2*pi/3)  exp(j*2*pi/3)     0; ...
                                0           0              0           0 ];
    elseif (p.NTX==4)
        % 4x4 Walsh
        p.HT_Pmap = 1/sqrt(4)*[ 1  1  1  1; ...
                                1 -1  1 -1; ...
                                1 -1 -1  1; ...
                                1  1 -1 -1 ];
    end
end
    
% Mask mapping (input vector is spatial streams)
Pmask = zeros(p.NTX_max, p.NTX_max);
Pmask(1:p.NTX,1:p.NSTS) = ones(p.NTX, p.NSTS);
% Apply mask to 'Pmap'
p.HT_Pmap = p.HT_Pmap .* Pmask;

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cyclic Shifts after IFFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: Mixed mode (MM) only...

% Cyclic Shift Indices...
p.cs2_Indices1 = 1 : p.OFDM_TotPreamblePerFrame-(p.OFDM_HTSTF_SymPerFrame+p.OFDM_HTLTF_SymPerFrame);
p.cs2_Indices2 = p.OFDM_TotPreamblePerFrame-(p.OFDM_HTSTF_SymPerFrame+p.OFDM_HTLTF_SymPerFrame)+1 : ...
                 p.OFDM_TotPreamblePerFrame-(p.OFDM_HTLTF_SymPerFrame);
p.cs2_Indices3 = p.OFDM_TotPreamblePerFrame-(p.OFDM_HTLTF_SymPerFrame)+1 : p.OFDMTotSymPerFrame;

% Init. Cyclic Shifts (CS)
p.cs2_Legacy_ss1 = [1:p.NFFT]; % init. cyclic shifts
p.cs2_Legacy_ss2 = [1:p.NFFT];
p.cs2_Legacy_ss3 = [1:p.NFFT];
p.cs2_Legacy_ss4 = [1:p.NFFT];

% Cyclic Shifts (CS) for Legacy
if (p.NTX==2)
    p.cs2_Legacy_ss2 = [p.NFFT-[3:-1:0] 1:(p.NFFT-4)]; % -200ns cyclic shift
elseif (p.NTX==3)
    p.cs2_Legacy_ss2 = [p.NFFT-[1:-1:0] 1:(p.NFFT-2)]; % -100ns cyclic shift
    p.cs2_Legacy_ss3 = [p.NFFT-[3:-1:0] 1:(p.NFFT-4)]; % -200ns cyclic shift
elseif (p.NTX==4)
    p.cs2_Legacy_ss2 = [p.NFFT-[0:-1:0] 1:(p.NFFT-1)]; %  -50ns cyclic shift
    p.cs2_Legacy_ss3 = [p.NFFT-[1:-1:0] 1:(p.NFFT-2)]; % -100ns cyclic shift
    p.cs2_Legacy_ss4 = [p.NFFT-[2:-1:0] 1:(p.NFFT-3)]; % -150ns cyclic shift
end

% Cyclic Shifts (CS) for HT-STF (always used)
p.cs2_HT20_STF_ss1 = [1:p.NFFT];                       %    0ns cyclic shift
p.cs2_HT20_STF_ss2 = [p.NFFT-[ 7:-1:0] 1:(p.NFFT- 8)]; % -400ns cyclic shift
p.cs2_HT20_STF_ss3 = [p.NFFT-[ 3:-1:0] 1:(p.NFFT- 4)]; % -200ns cyclic shift
p.cs2_HT20_STF_ss4 = [p.NFFT-[11:-1:0] 1:(p.NFFT-12)]; % -600ns cyclic shift

% Cyclic Shifts (CS) after HT-STF (not used with spatial expansion)
if (p.SSpreading==1)
    p.cs2_HT20_ss1 = [1:p.NFFT];                       %    no cyclic shifts
    p.cs2_HT20_ss2 = [1:p.NFFT];
    p.cs2_HT20_ss3 = [1:p.NFFT];
    p.cs2_HT20_ss4 = [1:p.NFFT];
else  % CS for HT-LTF, Data mode
    p.cs2_HT20_ss1 = [1:p.NFFT];                       %    0ns cyclic shift
    p.cs2_HT20_ss2 = [p.NFFT-[ 7:-1:0] 1:(p.NFFT- 8)]; % -400ns cyclic shift
    p.cs2_HT20_ss3 = [p.NFFT-[ 3:-1:0] 1:(p.NFFT- 4)]; % -200ns cyclic shift
    p.cs2_HT20_ss4 = [p.NFFT-[11:-1:0] 1:(p.NFFT-12)]; % -600ns cyclic shift
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data Mode Pilot tones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Init. data mode pilot tones...
p.dmPilot_ss1 = [0 0 0 0];
p.dmPilot_ss2 = [0 0 0 0];
p.dmPilot_ss3 = [0 0 0 0];
p.dmPilot_ss4 = [0 0 0 0];

% Generate pilot tones sequences
if (p.NSTS==1)
    p.dmPilot_ss1 = [ 1  1  1 -1];
elseif (p.NSTS==2)
    p.dmPilot_ss1 = [ 1  1 -1 -1];
    p.dmPilot_ss2 = [ 1 -1 -1  1];
elseif (p.NSTS==3)
    p.dmPilot_ss1 = [ 1  1 -1 -1];
    p.dmPilot_ss2 = [ 1 -1  1 -1];
    p.dmPilot_ss3 = [-1  1  1 -1];
elseif (p.NSTS==4)
    p.dmPilot_ss1 = [ 1  1  1 -1];
    p.dmPilot_ss2 = [ 1  1 -1  1];
    p.dmPilot_ss3 = [ 1 -1  1  1];
    p.dmPilot_ss4 = [-1  1  1  1];
end
p.dmPilot_ss1 = repmat(p.dmPilot_ss1, 1, ceil((OFDMSymPerFrame-1)/4)+1);
p.dmPilot_ss2 = repmat(p.dmPilot_ss2, 1, ceil((OFDMSymPerFrame-1)/4)+1);
p.dmPilot_ss3 = repmat(p.dmPilot_ss3, 1, ceil((OFDMSymPerFrame-1)/4)+1);
p.dmPilot_ss4 = repmat(p.dmPilot_ss4, 1, ceil((OFDMSymPerFrame-1)/4)+1);

% Pilots, spatial stream 1...
p.dmPilot1_seq_ss1 = p.dmPilot_ss1(1:OFDMSymPerFrame);
p.dmPilot2_seq_ss1 = p.dmPilot_ss1(2:OFDMSymPerFrame+1);
p.dmPilot3_seq_ss1 = p.dmPilot_ss1(3:OFDMSymPerFrame+2);
p.dmPilot4_seq_ss1 = p.dmPilot_ss1(4:OFDMSymPerFrame+3);
% Pilots, spatial stream 2...
p.dmPilot1_seq_ss2 = p.dmPilot_ss2(1:OFDMSymPerFrame);
p.dmPilot2_seq_ss2 = p.dmPilot_ss2(2:OFDMSymPerFrame+1);
p.dmPilot3_seq_ss2 = p.dmPilot_ss2(3:OFDMSymPerFrame+2);
p.dmPilot4_seq_ss2 = p.dmPilot_ss2(4:OFDMSymPerFrame+3);
% Pilots, spatial stream 3...
p.dmPilot1_seq_ss3 = p.dmPilot_ss3(1:OFDMSymPerFrame);
p.dmPilot2_seq_ss3 = p.dmPilot_ss3(2:OFDMSymPerFrame+1);
p.dmPilot3_seq_ss3 = p.dmPilot_ss3(3:OFDMSymPerFrame+2);
p.dmPilot4_seq_ss3 = p.dmPilot_ss3(4:OFDMSymPerFrame+3);
% Pilots, spatial stream 4...
p.dmPilot1_seq_ss4 = p.dmPilot_ss4(1:OFDMSymPerFrame);
p.dmPilot2_seq_ss4 = p.dmPilot_ss4(2:OFDMSymPerFrame+1);
p.dmPilot3_seq_ss4 = p.dmPilot_ss4(3:OFDMSymPerFrame+2);
p.dmPilot4_seq_ss4 = p.dmPilot_ss4(4:OFDMSymPerFrame+3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modulator/demodulator banks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p.numModulators = 8;
p.txBitsPerSymbol = [1 2 2 4 4 6 6 6];
p.txBitsPerBlock = p.numTxSymbols * p.txBitsPerSymbol;
p.modOrder = 2.^p.txBitsPerSymbol;
p.codeRate = [1/2 1/2 3/4 1/2 3/4 2/3 3/4 5/6];
p.bitsPerBlock = p.txBitsPerBlock .* p.codeRate;
p.bitsPerSymbol = p.txBitsPerSymbol .* p.codeRate;
p.maxBitsPerBlock = max(p.bitsPerBlock);
p.maxTxBitsPerBlock = max(p.txBitsPerBlock);

% Frame size for variable rate source
p.nSource = min( gcd( min(p.NSS*p.bitsPerBlock), p.NSS*p.bitsPerBlock ) ); 

% Source blocks per TX frame
p.nS = p.NSS*p.bitsPerBlock/p.nSource;

% Timing-related parameters
p.symbolPeriod = symbolPeriod;
p.blockPeriod = p.numTxSymbols * symbolPeriod;
p.bitPeriod = symbolPeriod ./ (p.NSS*p.bitsPerSymbol);
p.minBitPeriod =  min(p.bitPeriod);
p.chanSamplePeriod = p.blockPeriod/(p.OFDMTotSymPerFrame * p.NFFT2);

% Viterbi trace back depth and link delay
vtbd_set = vtbd(ones(1, p.numModulators));
p.vtbd_set = vtbd_set;
p.link_delay = vtbd_set;

params = p;
