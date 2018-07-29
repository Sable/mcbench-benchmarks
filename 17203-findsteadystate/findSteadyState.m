function [steadystate_mean, steadystate_index] = findSteadyState(dataX, Tsteadystate, Sstep, SampleTime, std_crit, deltaX, lowerBoundery, upperBoundery)

% 
% FINDSTEADYSTATE, finds periods of steady state within a data-set.
% 
% this function goes through a data-set (1) with defined steps (3) from the
% end of the data-set to the beginning. the standard deviation (std) within
% a defined time period (2) is compared with a defined maximum std (5), if
% the calculated std is smaller than the average it is stored together with
% the start time of the steady state period. in order to make this function
% more effective also the minimum difference between the average calculated
% from the steady state period has to be included (6). optionally the lower
% and upper bounderies (7 & 8) can be given to exclude noise.
% 
% this function gives the following output:
%   *the average of the steady state periods (steadystate_mean)
%   *the start index of the steady state period (steadystate_index)
%
% this function handles the following input:
%   1*dataX: vector with data for analysis
%   2*Tsteadystate (s): length of steady state period
%   3*Sstep (s): length of steps for analysis dataX
%   4*SampleTime (s): the sample time
%   5*std_crit: the minimal allowed standard deviation within a steady
%     state period
%   6*deltaX: the minimal allowed difference between the average of two
%     concecutive steady state periods
%   7*lowerBoundery (optional): smaller or equal values in dataX defined by
%     lowerBoundery will be ignored
%   8*upperBoundery (optional): larger or equal values in dataX defined by
%     upperBoundery will be ignored
%
% Created by Cornelis P. Bogerd at Empa
% bogerd@nielsbogerd.com
% First version (1.0): 2007.03.16
% Current version (1.2): 2007.10.28

%% version information
% version 1.0: first running version
% version 1.1: in this version an lower and upper bounderies are taken into
% consideration. This was needed since data sometimes shows spikes, 
% distorbing the function of this function
% version 1.2: 'flipud' is used instead of a inversion loop

%% checking input and creating matrices
% checking input
if nargin < 6
   error('Minimal six input arguments are required.')
elseif nargin == 6
    lowerBoundery = min(dataX) - 1;
    upperBoundery = max(dataX) + 1;
elseif nargin == 7
    upperBoundery = max(dataX) + 1;
elseif nargin > 8
    error('Maximal eight input arguments are required.')
end
% make sure that dataX is a collumn vector
dataX = dataX(:);

% creating matrices
X_meanX = 99;                                                               % initial value, indicating that there is not input yet
startX = [];

%% fine steady state values
for i = length(dataX) - Sstep : -1 * (Sstep / SampleTime) : Tsteadystate / SampleTime + 1% go through the results for each sensor
    X_std = std(dataX(i - Tsteadystate / SampleTime + 1 : i, 1));           % get std from time interval
    X_mean = mean(dataX(i - Tsteadystate / SampleTime + 1 : i, 1));         % calculate mean from steady state period
    if ((X_std < std_crit) && (abs(X_meanX(length(X_meanX),1) - X_mean) > deltaX) ...
         && (X_mean > lowerBoundery) && (X_mean < upperBoundery))           % evaluate if std is larger than last generated std, is smaller or equall to the criterion
        startX = [startX; i - Tsteadystate / SampleTime + 1];                 % store start of steady state period
        X_meanX = [X_meanX; X_mean];                                        % store average of steady state period
        i = i - Tsteadystate / SampleTime;                                  % don't analyze data in this steady state period anymore
    end
end
X_meanX = X_meanX(2:length(X_meanX),1);                                     % delete first index of average of steady state period (=999)

% invert the sequence in the output matrices so that time runs from 0 and
% up as opposed to down to 0
steadystate_mean = flipud(X_meanX);
steadystate_index = flipud(startX);