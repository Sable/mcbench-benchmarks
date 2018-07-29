function params = IEEE80211a_settings(...
    symbolPeriod, ...
    OFDMSymPerFrame, ...
    OFDMTrainPerFrame, ...
    vtbd);

% Note: A sample period of 0.08e-6 corresponds to approx. 12 Msym/s, 
% which, in turn, corresponds to 54 Mb/s for 3/4-coded 64-QAM

% IEEE 802.11a - fundamental sizes
p.NSD = 48;  % number of data symbols in OFDM symbol (variable name as in 802.11a standard)
p.NST = 52;  % number of data symbols and pilots in OFDM symbol (variable name as in 802.11a standard)
p.NFFT = 64; % number of points on FFT
p.NcyclicPrefix = 16;

p.NFFT2 = p.NFFT + p.NcyclicPrefix;

% TX indices
p.TXFFTShiftIndices = [p.NST/2+1:p.NFFT 1:p.NST/2];
p.TXCyclicPrefixIndices = [p.NFFT-[p.NcyclicPrefix-1:-1:0] 1:p.NFFT];

% RX indices
p.RXCyclicPrefixIndices = [p.NcyclicPrefix+1:p.NFFT2];
p.RXSelectFFTIndices = [p.NFFT-[p.NST/2-1:-1:0] 1:p.NST/2+1];

% OFDM symbols
p.OFDMSymPerFrame = OFDMSymPerFrame;
p.OFDMTrainPerFrame = OFDMTrainPerFrame;
p.OFDMTotSymPerFrame = OFDMSymPerFrame + OFDMTrainPerFrame;

% Constellation symbols
p.numTxSymbols = p.NSD * OFDMSymPerFrame;
p.numTrainingSymbols = p.NSD * OFDMTrainPerFrame;

% Training sequence
p.long_training_seq = ...
    [1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 0 ...
     1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1].';   

% Modulator/demodulator banks
p.numModulators = 8;
p.txBitsPerSymbol = [1 1 2 2 4 4 6 6];
p.txBitsPerBlock = p.numTxSymbols * p.txBitsPerSymbol;
p.modOrder = 2.^p.txBitsPerSymbol;
p.codeRate = [1/2 3/4 1/2 3/4 1/2 3/4 2/3 3/4];
p.bitsPerBlock = p.txBitsPerBlock .* p.codeRate;
p.bitsPerSymbol = p.txBitsPerSymbol .* p.codeRate;
p.maxBitsPerBlock = max(p.bitsPerBlock);

% Frame size for variable rate source
p.nSource = min( gcd( min(p.bitsPerBlock), p.bitsPerBlock ) ); 

% Source blocks per TX frame
p.nS = p.bitsPerBlock/p.nSource;

% Timing-related parameters
p.symbolPeriod = symbolPeriod;
p.blockPeriod = p.numTxSymbols * symbolPeriod;
p.bitPeriod = symbolPeriod ./ p.bitsPerSymbol;
p.minBitPeriod =  min(p.bitPeriod);
p.chanSamplePeriod = p.blockPeriod/(p.OFDMTotSymPerFrame * p.NFFT2);

% Viterbi trace back depth and link delay
vtbd_set = vtbd(ones(1, p.numModulators));
p.vtbd_set = vtbd_set;
p.link_delay = vtbd_set;

params = p;
