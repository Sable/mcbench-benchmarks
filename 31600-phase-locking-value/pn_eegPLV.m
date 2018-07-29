function [plv] = pn_eegPLV(eegData, srate, filtSpec, dataSelectArr)
% Computes the Phase Locking Value (PLV) for an EEG dataset.
%
% Input parameters:
%   eegData is a 3D matrix numChannels x numTimePoints x numTrials
%   srate is the sampling rate of the EEG data
%   filtSpec is the filter specification to filter the EEG signal in the
%     desired frequency band of interest. It is a structure with two
%     fields, order and range. 
%       Range specifies the limits of the frequency
%     band, for example, put filtSpec.range = [35 45] for gamma band.
%       Specify the order of the FIR filter in filtSpec.order. A useful
%     rule of thumb can be to include about 4 to 5 cycles of the desired
%     signal. For example, filtSpec.order = 50 for eeg data sampled at
%     500 Hz corresponds to 100 ms and contains ~4 cycles of gamma band
%     (40 Hz).
%   dataSelectArr (OPTIONAL) is a logical 2D matrix of size - numTrials x
%     numConditions. For example, if you have a 250 trials in your EEG
%     dataset and the first 125 correspond to the 'attend' condition and
%     the last 125 correspond to the 'ignore' condition, then use
%     dataSelectArr = [[true(125, 1); false(125, 1)],...
%       [false(125, 1); true(125, 1)]];
%
% Output parameters:
%   plv is a 4D matrix - 
%     numTimePoints x numChannels x numChannels x numConditions
%   If 'dataSelectArr' is not specified, then it is assumed that there is
%   only one condition and all trials belong to that condition.
%
%--------------------------------------------------------------------------
% Example: Consider a 28 channel EEG data sampled @ 500 Hz with 231 trials,
% where each trial lasts for 2 seconds. You are required to plot the phase
% locking value in the gamma band between channels Fz (17) and Oz (20) for
% two conditions (say, attend and ignore). Below is an example of how to
% use this function.
%
%   eegData = rand(28, 1000, 231); 
%   srate = 500; %Hz
%   filtSpec.order = 50;
%   filtSpec.range = [35 45]; %Hz
%   dataSelectArr = rand(231, 1) >= 0.5; % attend trials
%   dataSelectArr(:, 2) = ~dataSelectArr(:, 1); % ignore trials
%   [plv] = pn_eegPLV(eegData, srate, filtSpec, dataSelectArr);
%   figure; plot((0:size(eegData, 2)-1)/srate, squeeze(plv(:, 17, 20, :)));
%   xlabel('Time (s)'); ylabel('Plase Locking Value');
%
% NOTE:
% As you have probably noticed in the plot from the above example, the PLV 
% between two random signals is spuriously large in the first 100 ms. While 
% using FIR filtering and/or hilbert transform, it is good practice to 
% discard both ends of the signal (same number of samples as the order of 
% the FIR filter, or more).
% 
% Also note that in order to extract the PLV between channels 17 and 20, 
% use plv(:, 17, 20, :) and NOT plv(:, 20, 17, :). The smaller channel 
% number is to be used first.
%--------------------------------------------------------------------------
% 
% Reference:
%   Lachaux, J P, E Rodriguez, J Martinerie, and F J Varela. 
%   “Measuring phase synchrony in brain signals.” 
%   Human brain mapping 8, no. 4 (January 1999): 194-208. 
%   http://www.ncbi.nlm.nih.gov/pubmed/10619414.
% 
%--------------------------------------------------------------------------
% Written by: 
% Praneeth Namburi
% Cognitive Neuroscience Lab, DUKE-NUS
% 01 Dec 2009
% 
% Present address: Neuroscience Graduate Program, MIT
% email:           praneeth@mit.edu

numChannels = size(eegData, 1);
numTrials = size(eegData, 3);
if ~exist('dataSelectArr', 'var')
    dataSelectArr = true(numTrials, 1);
else
    if ~islogical(dataSelectArr)
        error('Data selection array must be a logical');
    end
end
numConditions = size(dataSelectArr, 2);

% disp('Filtering data...');
filtPts = fir1(filtSpec.order, 2/srate*filtSpec.range);
filteredData = filter(filtPts, 1, eegData, [], 2);

% disp(['Calculating PLV for ' mat2str(sum(dataSelectArr, 1)) ' trials...']);
for channelCount = 1:numChannels
    filteredData(channelCount, :, :) = angle(hilbert(squeeze(filteredData(channelCount, :, :))));
end
plv = zeros(size(filteredData, 2), numChannels, numChannels, numConditions);
for channelCount = 1:numChannels-1
    channelData = squeeze(filteredData(channelCount, :, :));
    for compareChannelCount = channelCount+1:numChannels
        compareChannelData = squeeze(filteredData(compareChannelCount, :, :));
        for conditionCount = 1:numConditions
            plv(:, channelCount, compareChannelCount, conditionCount) = abs(sum(exp(1i*(channelData(:, dataSelectArr(:, conditionCount)) - compareChannelData(:, dataSelectArr(:, conditionCount)))), 2))/sum(dataSelectArr(:, conditionCount));
        end
    end
end
plv = squeeze(plv);
return;