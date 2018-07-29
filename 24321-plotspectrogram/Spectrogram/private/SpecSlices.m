function [PdB, f] = SpecSlices (t, x, Fs, Win, Nfft)
% Generate a 2-D array of dB spectrum values
%
% Outputs:
% PdB  - 2-D array of decibel values Nh x NSlice, where Nh = Nfft/2+1
%        for Nfft even and NSlice is the number of elements in t.
% f    - row vector of frequency values, f(i) corresponds to BdB(i,:).
%
% Inputs:
% t    - vector of time values for the CENTRE of each window. Time
%        zero corresponds to the first sample of the data vector and
%        time (L-1)/Fs corresponds to the last sample of the data vector
%        where L is the number of elements in x. To get N spectrogram
%        slices from t0 to t1, set t = linspace (t0, t1, N).
% x    - data vector. The data is considered to be extended with zeros
%        at each end in case the time windows extend into those regions.
% Fs   - sampling frequency
% Win  - data window. The data window size can exceed the DFT length.
% Nfft - Number of DFT values. For efficiency choose Nfft to be a power
%        of 2.

% $Id: SpecSlices.m,v 1.8 2009/03/31 18:04:50 pkabal Exp $

NSlice = length(t);
LWin = length(Win);

% Make win a column vector if it is not one already
if (size(Win,1) < size(Win,2))
    Win = Win';
end

% Small bandwidths correspond to long windows. If the window is longer
% than the DFT size, there are two options.
% - Take a longer DFT and subsample the output spectrum
% - Wrap the windowed sequence and take the DFT
% The latter is more efficient computationally.

if (mod(Nfft, 2) == 0)
    Nh = Nfft / 2 + 1;
else
    Nh = (Nfft+1) / 2;
end

% Windows are centered at t
is = round(t * Fs - (LWin-1) / 2) + 1;

% Calculate the DFT values and convert to dB
S = warning;
warning('off', 'MATLAB:log:logOfZero');     % For Matlab 7
PdB = NaN * ones(Nh, NSlice);               % Pre-allocate space
for (i = 1:NSlice)
    xw = Win .* GetData(x, is(i), LWin);    % Windowed data

    % Wrap
    if (LWin > Nfft)
      xb = buffer(xw, Nfft);
      xw = sum(xb, 2);
    end
    xf = fft(xw, Nfft);
 
    PdB(:,i) = (20 * log10 (abs(xf(1:Nh))));     % dB
end
warning (S);

% Frequency values
f = ((0:Nh-1) / Nfft) * Fs;

return

%=======================
% Get data values from x, filling in zeros at the ends
function xs = GetData (x, is, N)

Nx = length(x);
iss = max(is, 1);
ie = min(is+N-1, Nx);

xs = zeros(N,1);
Nv = ie - iss + 1;
if (Nv > 0)
    offs = iss - is;
    xs(offs+1:offs+Nv) = x(iss:ie);
end

return

