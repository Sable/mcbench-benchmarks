% illutrates the utility required for long processes where each round of output
% takes a long time. User may wish to halt in condition of the detection of
% the next maxima. minima, plateau start or plateau end
% further conditions may start N maxima, N minima, N plateau start/ end from now

% usage_trendGeneratorWithProclivityStatesGiven
clear all; clc;

statesMapProfile = [ ...
    {'plateau'}, {3}, ...
    {'ascent'}, {25}, ...
    {'plateau'}, {10}, ...
    {'descent'}, {30}, ...
    {'plateau'}, {3}];

statesMapProfile = [ ...
    {'plateau'}, {3}, ...
    {'ascent'}, {2}, ...
    {'plateau'}, {2}, ...
    {'descent'}, {3}, ...
    {'plateau'}, {3}];

%numberOfHorizontalWiseRepetition = 30;
% repeat numberOfHorizontalWiseRepetition times
%statesMapProfile = repmat(statesMapProfile, 1, numberOfHorizontalWiseRepetition);

startValue = 150;
stepSize = 5;

trend = trendGeneratorWithProclivityStatesGiven (statesMapProfile, startValue, stepSize);
plot(trend);

% ==== trend test ====
% t = 0:.1:10;
% trend = square(100*t) .* exp(-t.*sin(0.1*t));
% plot(trend);

% usage_proclivityDetector
for i = 2:length(trend)
    previousInput = trend(i-1);
    currentInput = trend(i);
    proclivityCollections(i-1) = {determineProclivity( currentInput, previousInput )};
end

% proclivityCollections   % [observe]

% usage_trendFeatureDetector
for i = 2:length(proclivityCollections)
    previousProclivity = proclivityCollections(i-1);
    currentProclivity = proclivityCollections(i);
    proclivityFeature(i-1) = {char(trendFeatureDetector( previousProclivity, currentProclivity ))};    
end

% usage_trendFeatureLocator
% * This would not be required if the feature is tracked on-the-fly, ie.
% the location and feature is tracked as it moves along
proclivityFeatureALL = proclivityFeature;
proclivityFeatureToHuntModes = {'PLATEAU', 'MAXIMA', 'MINIMA'};
proclivityFeatureToHunt_Choice = 1;
proclivityFeatureToHunt = char(proclivityFeatureToHuntModes(proclivityFeatureToHunt_Choice));

[locationsOfMaxOrMin, startSitesPlateau, endSitesPlateau ] = determineLocationsOfMaximaMinimaPlateauFromProclivityFeature( proclivityFeatureALL, proclivityFeatureToHunt )

hold on;

if (  (strcmp (proclivityFeatureToHunt, 'MAXIMA')) | ...
      (strcmp (proclivityFeatureToHunt, 'MINIMA')))
    valuesAtLocationsOfMaxOrMin = trend(locationsOfMaxOrMin);
    
    % looping deters multiple annotations of points at 1 site
    for i = 1 : length(locationsOfMaxOrMin)
        plot(locationsOfMaxOrMin(i), valuesAtLocationsOfMaxOrMin(i), 'r*');   % mark local maxima/ minima
        %plot(xLocationOfMax, yLocationOfMax, 'rx');   % mark local maxima
        %plot(xLocationOfMin, yLocationOfMin, 'bo');   % mark local minima
    
        annot = sprintf('Max/Min: \n x=%f, \n y=%f\n', locationsOfMaxOrMin(i), valuesAtLocationsOfMaxOrMin(i));
        text(locationsOfMaxOrMin(i), valuesAtLocationsOfMaxOrMin(i), annot);
    end
    
elseif (strcmp (proclivityFeatureToHunt, 'PLATEAU')) 
    locationsOfPlateaus = sort([startSitesPlateau endSitesPlateau], 'ascend' );
    valuesAtPlateaus = trend(locationsOfPlateaus);
    
    % looping deters multiple annotations of points at 1 site
    for i = 1 : length(locationsOfPlateaus)    
        plot(locationsOfPlateaus(i), valuesAtPlateaus(i), 'rx');   % mark local plateaus
        
        annot = sprintf('Plateau: \n x=%f, \n y=%f\n', locationsOfPlateaus(i), valuesAtPlateaus(i));
        text(locationsOfPlateaus(i), valuesAtPlateaus(i), annot);        
    end
end
    
hold off;
