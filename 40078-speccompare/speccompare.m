%SPECCOMPARE Compare spectrograms of two signals
%   SPECCOMPARE(X1, X2) compares the power spectrum density (PSD) of the
%   two signals X1 and X2 and shows the differences in a single
%   spectrogram.
%
%   The signal intensity in the resulting spectrogram is shown as
%   brightness, whereas the differences between the signals are shown with
%   colors. Decreased signal parts in the second signal are colored in red,
%   increased signal parts are colored in green. Unchanged signal parts are
%   white. This is especially useful to visualize the effect of all kind of
%   signal processing on sound files.
%
%   Full syntax: SPECCOMPARE(X1, X2, Fs, titleString, maxDiff_dB)
%
%	Input parameters:
%                 X1: Unprocessed signal
%                 X2: Processed signal
%                 Fs: Sampling frequency
%        titleString: Title of the specgram
%         maxDiff_dB: maximum difference in dB that maps to colormap
%                     boundary
%
%   Example 1: Show the effect of lowpass filtering
%     noise1 = randn(10000,1);                  % generate white noise
%     noise2 = filter([1 1],1,noise1);          % lowpass filter the noise
%     speccompare(noise1,noise2)
%
%   Example 2: Show the effect of highpass filtering
%     noise1 = randn(10000,1);                  % generate white noise
%     noise2 = filter([1 -1],1,noise1);         % highpass filter the noise
%     speccompare(noise1,noise2,22050,'highpass filter',6)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author:     Martin Kuriger
%   History:    2013-01-29      file created
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function speccompare( X1, X2, Fs, titleString, maxDiff_dB )

% Check Input Parameters
narginchk(2,5);
if nargin < 3
    Fs = []; end
if nargin < 4
    titleString = ''; end
if nargin < 5
    maxDiff_dB = []; end

% Definitions
WINDOW = 512;
NOVERLAP = WINDOW * 3/4;
DYNAMIC_RANGE = -80;
FILTER_SIZE_2D = 3;
[PosHue, ~,~] = rgb2hsv([0 1 0]);   % "positive" color in Hue format, default green
[NegHue, ~,~] = rgb2hsv([1 0 0]);   % "negative" color in Hue format, default red

% Calculate the two PSDs
[~, ~, ~, P1] = spectrogram(X1, hann(WINDOW), NOVERLAP, [], Fs);
[~, f, t, P2] = spectrogram(X2, hann(WINDOW), NOVERLAP, [], Fs);
Psd(:,:,1) = 10*log10(P1);
Psd(:,:,2) = 10*log10(P2);

% Normalization and dynamic range limitations
MaxValue = max(max(max(Psd)));
Psd = Psd - MaxValue;
Psd(Psd < DYNAMIC_RANGE) = DYNAMIC_RANGE;
PsdMax = max(Psd,[],3);                     % maximum of both PSD
PsdMaxNorm = 1 - (PsdMax./DYNAMIC_RANGE);   % normalized maximum PSD

% Calculate normalized spectral difference for representation
PsdDiff = diff(Psd,[],3);
if isequal(maxDiff_dB,[])                   % Calculate maximum difference
    Filter_2D = ones(FILTER_SIZE_2D) ./ FILTER_SIZE_2D.^2; % smoothing filter
    PsdDiffFilt = filter2(Filter_2D, PsdDiff);
    maxDiff_dB = max(max(abs(PsdDiffFilt)));% maximum represented difference
end
if maxDiff_dB == 0; maxDiff_dB = eps; end   % prevent division by zero
PsdDiffNorm = PsdDiff ./ maxDiff_dB; % difference normalized to maxDiff_dB

% Calculate HSV color values for representation
Hue = ones(size(PsdDiff));
Hue(PsdDiff >= 0) = PosHue;
Hue(PsdDiff < 0) = NegHue;
Sat = abs(PsdDiffNorm); Sat(Sat>1)=1;  % hard limit Diff to range [0 1]
Val = PsdMaxNorm;
HSV(:,:,1) = Hue; HSV(:,:,2) = Sat; HSV(:,:,3) = Val;

% Plot
imagesc(t,f, hsv2rgb(HSV));
set(gca,'YDir','normal');
if isequal(Fs,[]);
    xlabel('Time [samples]')
    ylabel('Normalized Frequency')
    title(titleString)
else
    xlabel('Time [s]')
    ylabel('Frequency [Hz]')
    title(titleString)
end

% Calculate and show the colormap
MapHSV = [];
MapHSV(:,1) = [NegHue*ones(32,1) ; PosHue*ones(32,1)];
MapHSV(:,2) = [linspace(1,0,32)';linspace(0,1,32)']; % Hard limited Colormap
MapHSV(:,3) = ones(64,1);
colormap(hsv2rgb(MapHSV));
caxis([-maxDiff_dB maxDiff_dB]);
cb = colorbar;
set(cb,'xtick',0.5,'xticklabel','Diff [dB]')

end