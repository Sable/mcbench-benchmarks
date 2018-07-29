function y = previewsong(frequencies, durations, gap, Fs)
% PREVIEWSONG plays the output of song() on the host PC.
%
%   PREVIEWSONG converts frequency domain data in the
%   form of a frequency vector and a duration vector
%   into a single time domain vector and plays it over
%   the PC speaker using the sound command.
%
%   frequencies - Vector of frequencies.
%   durations   - Vector of times.
%   gap         - Pause between notes. Default 0.01.
%   Fs          - Sample rate. Default 8192.
%
%   Example:
%      [sng.tune, sng.rhythm, sng.message, sng.stats] = song('random');
%      previewsong(sng.tune, sng.rhythm);

   if nargin < 4, Fs          = 8192;     end
   if nargin < 3, gap         = 0.01;     end
   if nargin < 2, durations   = 1;        end
   if nargin < 1, frequencies = 261.6256; end

   if length(durations) < length(frequencies)
      for i=length(durations)+1:length(frequencies)
         durations(i) = 0;
      end
   end

   if gap
      paddedFrequencies = [];
      paddedDurations = [];
      for i=1:length(frequencies)
         paddedFrequencies = [paddedFrequencies frequencies(i) 0]; %#ok<AGROW>
         paddedDurations = [paddedDurations durations(i) gap]; %#ok<AGROW>
      end
   else
      paddedFrequencies = frequencies;
      paddedDurations = durations;
   end

   deltaT = 1.0/Fs;

   startTime = 0;
   y = [];
   for i=1:length(paddedFrequencies)
%     timeIntervals = 0 : deltaT : paddedDurations(i);
      timeIntervals = startTime : deltaT : startTime+paddedDurations(i);
      startTime = timeIntervals(1)+deltaT;
      yCurrent = sin(2*pi*paddedFrequencies(i)*timeIntervals);
      y = [y yCurrent]; %#ok<AGROW>
   end

   sound(y, Fs);

return   % end of previewsong()
