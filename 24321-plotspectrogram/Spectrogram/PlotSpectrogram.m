function h = PlotSpectrogram (x, varargin)
% Plot a gray-level spectrogram. The spectrogram is plotted as an image
% with the intensities encoding the levels. The spectrogram has time on the
% abscissa and frequency on the ordinate axis. The spectrogram consists of
% vertical slices displaying the spectral response as intensities in dB.
% The slices are calculated as the DFT of windowed samples. The time window
% for each slice is centred at the corresponding abscissa point. The length
% of the time window determines the time-frequency resolution trade-off.
% The default window length (190 samples) gives relatively good frequency
% resolution.
%
% The intensity values in the plot is calibrated in terms of the decibel
% value relative to a full scale (dBov, see ITU-T G.100.1). A full scale
% sine wave with frequency at one of the DFT values appears  at -6 dBov.
% The default mapping makes the maximum value appear as the darkest value
% and -80 dB below that correspond to the lightest value.
%
%   h = PlotSpectrogram (x, [ts, tf], Fs, Options)
% Simplified forms
%   h = PlotSpectrogram (x, Fs)
%   h = PlotSPectrogram (x)
% Options can appear as the last arguments in any of these forms. Options
% take the form of pairs of arguments, the first being a keyword, the
% second being a value.
%
% h    - handle to the image
% x    - data vector. The data is considered to be extended with zeros at
%        each end in case the windows extend into those regions.
% [ts, tf] - Specifies the start and stop times. The first spectrogram
%        slice is centred at ts and the last spectrogram slice is centred
%        at tf. The default is to create slices spanning the entire data
%        vector, i.e., ts=0, tf=(N-1)/Fs, where N is the number of samples
%        in the data vector.
% Fs   - sampling frequency, default 1.
%
% Options
%  Data window
%    The data window used for each spectrum slice can be specified with
%    the keywords 'Win', 'Lwin' or 'BW'.
%  'Win': the data window vector is explicitly specified.
%  'LWin': the length of the data window (in samples) is specified.
%    A Hamming window of that length is used.
%  'BW': the 3 dB bandwidth (in Hz) of the Hamming window to be used
%    is specified. The length of the Hamming window is chosen using the
%    formula, LWin = 1.18523 * Fs / BW. The default bandwidth is Fs/160.
%    The bandwidth can also be specified with the character strings
%    'NB' (narrowband spectrogram - good frequency resolution, but poor
%    time resolution, same as Fs/160), or 'WB' (wideband spectrogram - poor
%    frequency resolution, but good time resolution, same as 6/160 Fs).
% 'NSlice'
%   The number of spectrogram slices, default 500.
% 'Nfft'
%   The number of rows in the spectrogram is determined by the DFT size,
%   Nfft. The Nfft/2+1 rows correspond to frequencies from 0 to Fs/2. The
%   frequency resolution of the DFT is Fs/Nfft. If not specified, Nfft is
%   chosen to be 1024 or 2048, with the larger value chosen if the window
%   length is greater than 0.9*1024 (0.9 is the Kell factor).
% 'PLimdB'
%   Minimum and maximum levels for the spectrogram on dB. The spectrogram
%   levels are clipped outside of these values. The value for 'PLimdB' can
%   be a two element vector giving the minimum and maximum values. The
%   'PLimdB' value can also be a single value giving the dynamic range in
%   dB. In that case, the maximum is determined automatically and the
%   minimum is set according to the specified dynamic range. The default is
%   to determine the maximum automatically and apply a dynamic range of 80
%   dB.
% 'Amax'
%   The data is expected to take on values between -Amax to +Amax. The
%   default is 1 is suitable for data acquired from sound files. This value
%   affects the scaling of the intensities.
% 'FLim'
%   This parameter is of the form [Fs, Ff] specifying the frequency range
%   of the spectrogram to be plotted. The spectrogram is always calculated
%   over the whole frequency range. This parameter can be used to select
%   a subrange of frequencies for plotting. The default is [0, Fs/2].
% 'preF'
%   The frequency response values can be pre-emphasized to better show
%   lower amplitude high-frequency components. The pre-emphasis response is
%   that of a first order difference filter with parameter preF. The
%   default value of preF is 0. A suitable value for pre-emphasis might be
%   0.97.
%
% Notes:
% - To get a colour spectrogram with a colorbar legend:
%       PlotSpectrogram(...);
%       colormap(SpecColorMap);
%       colorbar;
% - To get an intensity scale in dB SPL (sound pressure level):
%   - Assume that a full scale sine results in PmaxdBSPL (often chosen to
%     be 92 dB SPL).
%   - Then to convert dBov to dB SPL,
%       PmaxdBSPL = 92;  % Max level in dB SPL
%       Amax = 1;        % Assume normalized scaling from a sound file
%       PoffsdB = PmaxdBSPL + 20*log10(2);
%       g = 10^(PoffsdB/20);
%       AmaxN = Amax/g;
%       PlotSpectrogram(..., 'Amax', AmaxN);
%   - This conversion brings the peak sine wave response in the display
%     to be PmaxdBSPL.

% $Id: PlotSpectrogram.m,v 1.10 2009/06/01 18:38:22 pkabal Exp $

% Process arguments
[TLim, Fs, Options] = DecodeArgs(varargin{:});

% Process options
[NSlice, Win, Nfft, FLim, PLimdB, Amax, preF] = ...
                                            PSDecodeOptions(Options, Fs);
% Fill in the default time limits
% Set the times of the slices
if (isempty(TLim))
  TLim = [0 (length(x)-1)/Fs];
end
t = linspace(TLim(1), TLim(2), NSlice);

% Get spectrum in dB
[PdB, f] = SpecSlices(t, x, Fs, Win, Nfft);

% Select a subset of frequencies
I = find(f >= FLim(1) & f <= FLim(2));
f = f(I);
PdB = PdB(I,:);

% Convert to dBov
PdBov = SpecCalib(PdB, Amax, Win);

% Pre-emphasis
pre = (1 + preF^2) - 2 * preF * cos(2 * pi * f / Fs);
predB = 10 * log10(pre');
for (i = 1:NSlice)
  PdBov(:,i) = PdBov(:,i) + predB;
end

% Automatic scaling
if (length(PLimdB) == 1)
  PmaxdB = max(max(PdBov));
  PLimdB = [PmaxdB-PLimdB PmaxdB];
end

% Plot the image
h = imagesc(t, f, PdBov, PLimdB);
axis('xy');

% Grayscale map (dark is more intense)
colormap(flipud(gray));

xlabel('Time (s)');
ylabel('Frequency (Hz)');

return

% ===============================
function PdBov = SpecCalib (PdB, Amax, Win)
% Calibration of a spectrum, The input spectrum in dB is gain modified so
% that a sine wave of maximum amplitude Amax gives a total energy level of
% -3 dBov. This mean that each of the two peaks (one at -fc and the other
% at +fc) will have a level of -6 dBov. A dc level of Amax will give a
% 0 dBov level at zero frequency.
% - Amax, maximum level of the sinusoid (typically 1 for scaled data from
%   sound files). With the true maximum level, the scaling gives an
%   output in dBov. However, Amax can be artificially changed to affect a
%   change in scaling. For instance halving Amax, increases the levels by
%   6 dB.

% Calibration
% - Input:
%   - dc peak amplitude Amax gives 0 dBov
%      - DFT gives sum(Win) at dc
%   - sine peak amplitude Amax give -6dBov at fc and -fc
%     - Assumes sine frequency is coincident with a DFT bin, i.e. fc is of
%       the form m * Fs/Nfft
%     - The peak amplitude of the DFT of the windowed response (assuming no
%       overlap of the components due to the sine at -fc and +fc) is
%       Apeak = abs (Amax / 2 * Wpeak)
Apeak = abs (Amax * sum(Win));
GLdB = -20 * log10(Apeak); 

PdBov = PdB + GLdB;

return

% ===============================
function [TLim, Fs, Options] = DecodeArgs(varargin)
% Decode [ts, tf], Fs, Options
% These are distinguished by being a 2 element vector, a scalar, and
% a character string (marking the start of the options)

Options = [];
Fs = 1;
TLim = [];

% Find the first argument with a character string
% Store it and the following arguments in Options
Narg = length(varargin);
for (i = 1:Narg)
  if (ischar(varargin{i}))
    Options = varargin(i:end);
    if (mod(length(Options), 2) ~= 0)
      error('PlotSpectrogram: Invalid Options format');
    end
    varargin(i:end) = [];
    break;
  end
end

% Check for a TLim argument
if (length(varargin) > 1 && length(varargin{1}) == 2)
  TLim = varargin{1};
  varargin(1) = [];
end

% Pick off Fs
if (~ isempty(varargin) && length(varargin{1}) == 1)
  Fs = varargin{1};
  varargin(1) = [];
end

if (~ isempty(varargin))
  error('PlotSpectrogram: Too many input arguments');
end
  
return

