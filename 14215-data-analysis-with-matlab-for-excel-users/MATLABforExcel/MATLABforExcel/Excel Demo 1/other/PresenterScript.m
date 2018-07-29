%% Energy Demo
% This is a script for Energy Forecast Demo
% Copyright 2006-2009 The MathWorks, Inc.

%% Import Data
% Copy and paste data from spreadsheet. Do this interactively. Later, I can
% explain about the programmatic methods (seen below).
%
% * |energyData| - from SOP sheet
% * |DayType|, |HDD|, |Temp|

    energyData= xlsread('January.xls', 'Liability', 'B2:Y32');
    DayType   = xlsread('January.xls', 'Weather'  , 'B2:B32');
    HDD       = xlsread('January.xls', 'Weather'  , 'C2:C32'); %Heating Degree Days
    Temp      = xlsread('January.xls', 'Weather'  , 'D2:D32');

%% Quick Visualization
% Point-n-click visualizations
%
% * Select |energyData| and click on plot icon - first plot, but not useful
% * |plot(energyData')| to plot on a hourly basis
% * Open Plot Catalog to do other visualizations - |ribbon|, |waterfall|
%
% Customize using |plottools|
%
% * Create initial plot using |mesh|
% * Open |plottools|
% * Add a second axes
% * Use |contourf| for second axes
% * Add colorbar
% * Add annotations (labels, titles)
% * Close |plottools| and generate m-file
% * Run auto-generated m-file
%
% The contour plot gives us more insights to the data. I can see the two
% peaks during the day. I can also deduce cyclical behavior during the
% month.

    myCreateFigure(energyData);

%% Basic Statistics
% Start with simple statistics (some command line, some interactive)
%
% * Let's determine the mean hourly profile:

    meanDay = mean(energyData);

%%
% * Plot all data and mean (thick line)

    figure;
    plot(energyData', 'green');
    hold;
    plot(meanDay, 'linewidth', 4);

%%
% * Examine the distribution of the variance:

    res = energyData - repmat(meanDay, 31, 1);

%%
% * Distribution Fitting Tool:
%
%    dfittool(res(:))
%
% * Fit a normal distribution.
% * Generate m-file. Run m-file.

    myDistFit(res);
    
%% Intermediate Statistics
% Now that we know the distribution is normal, we can carry on with more
% statistics assuming a normally distributed data set.
%
% Let's see if we can determine the 95% confidence interval of the mean
% profile.
%
% * Go to the doc and search for "confidence intervals normal distribution"
% * The first entry is a page on "confidence intervals"
% * Go down half a page where they have an example for |normfit|
% * Highlight the 2 lines and "Evaluate"

    data = normrnd(10,2,100,2);
    [mu,sigma,muci,sigmaci] = normfit(data)

%%
% * Explain what it does. Now apply to |data|.

    [mu,sigma,muci,sigmaci] = normfit(energyData);
    [mu2,sigma2,muci2,sigmaci2] = normfit(energyData');
    plot(mu);
    hold on;
    plot(muci', 'r');

%%
% * I have a function that does this for both hour and day dimensions and
% visualizes them. If appropriate, open |plotCI.m| and explain.

    plotCI(energyData,mu,sigma,muci,mu2,sigma2,muci2);

%% Automating Tasks
% We have done a lot of interactive exploration of our data, and now I
% would like to start capturing my workflow so that the same processes can
% be applied to new data sets.
%
% * Go to command history and capture appropriate commands and create
% M-file.
% * Run m-file.
% * Create cells by partitioning with cell headings. Here's an example:

    type myscript_template
    
%% Cell Execution and Publish
% Step through more detailed analysis using cell mode. Open
% |EnergyForecastAnalysis.m|. Publish the document.

%% Reusable functions
%
% * First make |EnergyForecastAnalysis.m| a function with data file name as
% an input argument.
% * Add a simple user interface:
%
%       if nargin == 0
%         dataFileName = uigetfile('*.xls', 'Select data file');
%       end
%
    
%% GUI
%
% * Open |GUIDE| and create a single button GUI and call
% |EnergyForecastAnalysis.m|
%
% * Open final GUI |energyForecastGUI.m| and run

energyForecastGUI([], {'January.xls', 9, 1, 1, '10, 15'});
