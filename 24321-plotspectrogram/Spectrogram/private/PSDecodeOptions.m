function [NSlice, Win, Nfft, FLim, PLimdB, Amax, preF] = ...
                                            PSDecodeOptions(Options, Fs)
% Decode options for PlotSpectrogram
                                 
PLimdBdefault = 80;
BWNBdefault = 50/8000 * Fs;      % Narrowband
BWWBdefault = 300/8000 * Fs;     % Wideband
NfftMin = 1024;
NfftMax = 2048;
FLimdefault = [0, Fs/2];

NSlicedefault = 500;
Amaxdefault = 1;
preFdefault = 0;

% Rearrange the Options into a 2xN/2 array
NOpt = length(Options) / 2;
Options = reshape(Options, 2, NOpt);

% Resolve the window
[Win, Options] = Decode_Opt(Options, 'Win', []);
LWin = length(Win);
if (LWin == 0)
  [LWin, Options] = Decode_Opt(Options, 'LWin', 0);
  if (LWin > 0)
    Win = ModHamming(LWin);
  end
end
if (LWin == 0)
  [BW, Options] = Decode_Opt(Options, 'BW', []);
  if (~ isempty(BW))
    if (strcmpi(BW, 'NB'))
      BW = BWNBdefault;
    elseif (strcmpi(BW, 'WB'))
      BW = BWWBdefault;
    end
    LWin = round(1.18523 * Fs / BW);
    Win = ModHamming(LWin);
  end
end
if (LWin == 0)
  LWin = round(1.18523 * Fs / BWNBdefault);
  Win = ModHamming(LWin);
end

% DFT size
% The DFT bin spacing is Fs/Nfft. The goal is to choose an DFT size which
% will accurately show fine ripples in the frequency response. For a
% digital display, using a Kell factor of 0.9, the DFT size should be at
% least 1/0.9 times the window length. Additionally, the DFT size is
% limited to lie between NfftMin and NfftMax, inclusive.
KellF = 0.9;
[Nfft, Options] = Decode_Opt(Options, 'Nfft', []);
if (isempty(Nfft))
  Nfft = NfftMin;
  while (Nfft < LWin/KellF && Nfft < NfftMax / 2)
    Nfft = 2 * Nfft;
  end
end

% Number of slices
[NSlice, Options] = Decode_Opt(Options, 'NSlice', NSlicedefault);

% Frequency range to be plotted
[FLim, Options] = Decode_Opt(Options, 'FLim', FLimdefault);

% Dynamic range of the intensities
[PLimdB, Options] = Decode_Opt(Options, 'PLimdB', PLimdBdefault);

% Maximum data values
[Amax, Options] = Decode_Opt(Options, 'Amax', Amaxdefault);

% Pre-emphasis factor
[preF, Options] = Decode_Opt(Options, 'preF', preFdefault);

% Error check
if (~ isempty(Options))
  error('PlotSpectrogram: Unused options');
end

return

% ----- -----
function [v Options] = Decode_Opt(Options, OptName, default)
% Return an option value and delete the option

v = default;
if (~ isempty(Options))
  i = find(strcmpi(OptName, Options(1, :)), 1);
  if (~ isempty(i))
    v = Options{2, i};
    Options(:, i) = [];
  end
end

return

% ===============================
function h = ModHamming (N)

% Modified Hamming window
% This window is a continous Hamming window, sampled uniformly starting
% half a step from the start edge and ending half a step from the end edge.
% In Matlab, we generate a double length Hamming window and then take
% alternate samples.
h2 = hamming(2*N+1);
h = h2(2:2:end);

return

