
%% DECLARATIONS AND INITIALIZATIONS

% Calculates windowed (over- and non-overlapping) RMS of a signal using the specified windowlength
% y = rms(signal, windowlength, overlap, zeropad)
% signal is a 1-D vector
% windowlength is an integer length of the RMS window in samples
% overlap is the number of samples to overlap adjacent windows (enter 0 to use non-overlapping windows)
% zeropad is a flag for zero padding the end of your data...(0 for NO, 1 for YES)
% ex. y=rms(mysignal, 30, 10, 1).  Calculate RMS with window of length 30 samples, overlapped by 10 samples each, and zeropad the last window if necessary
% ex. y=rms(mysignal, 30, 0, 0).  Calculate RMS with window of length 30 samples, no overlapping samples, and do not zeropad the last window
%
% Author: A. Bolu Ajiboye

function y = rms(signal, windowlength, overlap, zeropad)

delta = windowlength - overlap;

%% CALCULATE RMS

indices = 1:delta:length(signal);
% Zeropad signal
if length(signal) - indices(end) + 1 < windowlength
    if zeropad
        signal(end+1:indices(end)+windowlength-1) = 0;
    else
        indices = indices(1:find(indices+windowlength-1 <= length(signal), 1, 'last'));
    end
end

y = zeros(1, length(indices));
% Square the samples
signal = signal.^2;

index = 0;
for i = indices
	index = index+1;
	% Average and take the square root of each window
	y(index) = sqrt(mean(signal(i:i+windowlength-1)));
end