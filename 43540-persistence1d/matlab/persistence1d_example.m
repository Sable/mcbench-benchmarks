%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This is an example for using the Persistence1D class in Matlab
%   This example demonstates the following:
%   1. Compiling run_persistence1d
%   2. Input and output parameters and formats for run_persistence1d
%   3. C++/Matlab interface function calling convention
%   4. Different methods for filering paired extrema:
%       - Logical indexing
%       - Supplied script filter_features_by_persistence
%   5. Plotting results
%       - Manually
%       - With supplied script plot_data_with_features
%
%   Known Issues:
%   Pairs structure needs to be transposed manually. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear workspace
clear minIndices maxIndices pairs globalMinIndex globalMinValue data markers persistence_features threshold 

% Compile the mex file.
% If mex is not set up, choose a C++ compatible compiler.
% This was tested on Microsoft Visual Studio 2008 and above.
% This does not compile with Matlab's built-in C compiler.
mex run_persistence1d.cpp 

% Generate some data
x = 1:100; 
x = sin(x* 0.1 * pi);
data = x + 0.5*randn(size(x));

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
plot(data);
title('all extrema');
hold on;

% Add a scatter plot of all found features
extremaIndices = [minIndices ; maxIndices ; globalMinIndex];
markers = data(extremaIndices);
scatter(extremaIndices, markers,'fill');
hold off;

% Set a threshold for filtering resulting paired extrema
threshold = 1;

% Use logical indexing to find paired features whose persistence
% is bigger than threshold.
persistent_features_logical_index = persistence > threshold;  

% Now create a vector with all indices of extrema features
extremaIndices = [min(persistent_features_logical_index);
                  max(persistent_features_logical_index)];

% Or use filter_features_by_persistence to filter the pairs
persistent_features = filter_features_by_persistence(minIndices, maxIndices, persistence, threshold); 
clear extremaIndices;

extremaIndices = [persistent_features(:,1) ; 
                  persistent_features(:,2) ;];

% Plot only features with persistence > threshold.
subplot(2,1,2);
plot(data);
title(strcat('extrema with persistence > ', num2str(threshold)));
hold on;

% Add a scatter plot with markers on filtered features
markers = data(extremaIndices);
scatter(extremaIndices, markers, 'blue', 'fill');

% The global minimum is not paired, can add it with a different color.
scatter(globalMinIndex, globalMinValue, 'red', 'fill');

title(strcat('extrema with persistence > ', num2str(threshold)));
hold off;

% Or do the same with plot_data_with_features
figure;
plot_data_with_features(data, [extremaIndices; globalMinIndex]);
title('plot from function');

