function wlan80211g_settings
% Parameter settings for wlan80211g model

%  Copyright 2012 anuj saxena.
   

% Ensure function is not run twice after first loading model.
persistent postloadFlag;
if isempty(postloadFlag)
    postloadFlag = true;
else
    if postloadFlag
        postloadFlag = false;
        return
    end
end

% Fetch parameters from settings block in model.  This approach is used so
% that wlan80211g_settings can be called either from (a) the post load 
% function of the model or (b) the mask initialization of the settings 
% block.
settingsBlock = [bdroot '/Model Parameters'];
[OFDMSymPerFrame, ...
 OFDMTrainPerFrame, ...
 vtbd, ...
 thres, ...
 hyst] ...
 = getSettings(settingsBlock, ...
  'OFDMSymPerFrame', ...
  'OFDMTrainPerFrame', ...
  'vtbd', ...
  'SNR0_dB', ...
  'hyst');

if mod(OFDMSymPerFrame, 2)~=0
    error('commblks:wlan80211g_settings:InvalidSymbolsPerFrame','OFDM symbols per frame must be even.');
end

% IEEE 802.11g - fundamental sizes
p.NSD = 48;  % number of data symbols in OFDM symbol
p.NST = 52;  % number of data symbols and pilots in OFDM symbol
% Note: NSD and NST are same as symbols in 802.11g standard.
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
p.txBitsPerSymbol = [1 1 2 2 4 4 16 16];
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
p.OFDMSymbolPeriod = 4e-6;
p.OFDMPilotPeriod  = p.OFDMSymbolPeriod*p.OFDMTotSymPerFrame./p.OFDMSymPerFrame;
p.blockPeriod      = p.OFDMTotSymPerFrame.*p.OFDMSymbolPeriod;
p.bitPeriod        = p.blockPeriod./ p.bitsPerBlock;
p.minBitPeriod     = min(p.bitPeriod);

% Note: Use single precision to avoid inconsistencies on multiple platforms.
p.chanSamplePeriod = p.blockPeriod/(p.OFDMTotSymPerFrame * p.NFFT2);

% Viterbi trace back depth and link delay
vtbd_set = vtbd(ones(1, p.numModulators));
p.vtbd_set = vtbd_set;
p.link_delay = vtbd_set;

% Adaptive modulation thresholds and hysteresis
p.thres = thres;
p.hyst = hyst;

% Assign variables to base workspace
assignin('base', 'params', p);

%--------------------------------------------------------------------------
function varargout = getSettings(settingsBlock, varargin)
h = get_param(settingsBlock, 'handle');
for n = 1:length(varargin)
    varargout{n} = evalin('base', get(h, varargin{n}));
end
