%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This is an example for using the Persistence1D class in Matlab
%   We superimpose some sine functions and later find the extrema
%   of the one with the lowest frequency.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compile the mex file.
% If mex is not set up, choose a C++ compatible compiler.
% This was tested on Microsoft Visual Studio 2008 and above.
% This does not compile with Matlab's built-in C compiler.
mex run_persistence1d.cpp 

% Generate some data
x = 1:600; 
SineLowFreq = sin(x * 0.01 * pi);
SineMedFreq = 0.25 * sin(x * 0.01 * pi * 4.9);
SineHighFreq = 0.15 * sin(x * 0.01 * pi * 12.1);
data = SineLowFreq + SineMedFreq + SineHighFreq;

% Input should be in SINGLE precision
single_precision_data = single(data);

% Call persistence1d with five output parameters:
% minIndices - a nX1 vector with indices of all paired local minima
% maxIndices - a nX1 vector with indices of all paired local maxima. Guaranteed to be the same size as minIndices.
% persistence - a nX1 vector with the persistence of each minimum/maximum pair. Guaranteed to be the same size as minIndices.
% globalMinIndex - index of global minimum. The global minimum is never paired.
% globalMinValue - value of global minimum.
[minIndices maxIndices persistence globalMinIndex globalMinValue] = run_persistence1d(single_precision_data); 

% Plot all features
figure; 
subplot(2,1,1);
plot(data, '-k', 'LineWidth', 2);
title('all extrema');
hold on;

% Add a scatter plot of all found features
extremaIndices = [minIndices ; maxIndices ; globalMinIndex];
minIndices  = [minIndices; globalMinIndex];
plot(minIndices, data(minIndices), 'o', 'MarkerSize', 7, 'MarkerFaceColor', [0.3 0.3 1], 'MarkerEdgeColor', [0 0 1]);
plot(maxIndices, data(maxIndices), 'o', 'MarkerSize', 7, 'MarkerFaceColor', [1 0.2 0.2], 'MarkerEdgeColor', [1 0 0]);
hold off;


% Set a threshold for filtering resulting paired extrema
threshold = 0.5;

% Use filter_features_by_persistence to filter the pairs
persistent_features = filter_features_by_persistence(minIndices, maxIndices, persistence, threshold); 
filteredMinima = [persistent_features(:,1) ; globalMinIndex];
filteredMaxima = persistent_features(:,2);

% Plot only features with persistence > threshold.
subplot(2,1,2);
plot(data, '-k', 'LineWidth', 2);
title(strcat('extrema with persistence > ', num2str(threshold)));
hold on;

% Add a scatter plot for the filtered minima
plot(filteredMinima, data(filteredMinima), 'o', 'MarkerSize', 9, 'MarkerFaceColor', [0.3 0.3 1], 'MarkerEdgeColor', [0 0 1]);

% Add a scatter plot for the filtered maxima
plot(filteredMaxima, data(filteredMaxima), 'o', 'MarkerSize', 9, 'MarkerFaceColor', [1 0.2 0.2], 'MarkerEdgeColor', [1 0 0]);

hold off;

