% function [ output_args ] = proclivityStateTracking( huntOption )
%usage: PROCLIVITYSTATETRACKING, usage_BrakingCriteriaUsingFeatures aka usage_ParamBasedHunt
clear all; clc;

% note that some functions, for eg. a sine wave does not have a plateau
proclivityFeatureToHuntModes = {'PLATEAU', 'MAXIMA', 'MINIMA'};
proclivityFeatureToHunt_Choice = 2;
proclivityFeatureToHunt = char(proclivityFeatureToHuntModes(proclivityFeatureToHunt_Choice));
huntModeON = proclivityFeatureToHunt;

chosenProclivity = upper(proclivityFeatureToHunt);

% BrakingCriteria
numOfMinimaOrMaximaStoppingCriteria = 5;
crossOverNumberOfMinimaOrMaxima = 0;

% for plateau start
currentInput = [0 Inf -Inf];
previousInput = [0 -Inf Inf];

% start
% proclivity = determineProclivity( currentInput, previousInput );
% t = 0:.1:10;
thresholdInitialForApprox = 0;
paramOffset = 0.1;

runID = 0;
resultTrackArchive = [];
markLocations = [];

result_featureDetected = [];

thresholdInitialForApproxStart = thresholdInitialForApprox;

previousProclivity = ''; % no trend proclivity to start with [Caveat to troubleshoot]

%% get the 1st feature trend
for i = 1:2         % 2 data points to mark the 1st proclivity  
    
    runID = runID + 1;
    
    previousInput = currentInput;
    [currentInput] = benchmarkSampleFunction (thresholdInitialForApprox);
    thresholdInitialForApprox = thresholdInitialForApprox + paramOffset; % incrememt for the next input
    
    resultTrackArchive = [resultTrackArchive currentInput]; % collect the trend/ signal data
    
    currentProclivity = determineProclivity( currentInput, previousInput );
    previousProclivity =  currentProclivity; % to be the next proclivity    
end

startSiteTrackON = 0;
%% [INCOMPLETE LOGIC] : TODO : PLATEAU TRACK
plateauSitesCount = 0;
startSitesPlateau = [];
endSitesPlateau = [];
%%

while ( (crossOverNumberOfMinimaOrMaxima ~= numOfMinimaOrMaximaStoppingCriteria) )        
    
    runID = runID + 1;
    
    previousInput = currentInput;
    [currentInput] = benchmarkSampleFunction (thresholdInitialForApprox);
    thresholdInitialForApprox = thresholdInitialForApprox + paramOffset; % incrememt for the next input
    
    resultTrackArchive = [resultTrackArchive currentInput]; % collect the trend/ signal data
    
    currentProclivity = determineProclivity( currentInput, previousInput );
    proclivityFeature = {char(trendFeatureDetector( previousProclivity, currentProclivity ))};
    
    if (strcmp(proclivityFeature, chosenProclivity)) %         
        if (~strcmp(proclivityFeature, 'PLATEAU'))
            crossOverNumberOfMinimaOrMaxima = crossOverNumberOfMinimaOrMaxima + 1;        
            markLocations(crossOverNumberOfMinimaOrMaxima) = thresholdInitialForApprox - 2*paramOffset; % before the 2 increments ago
            result_featureDetected = [result_featureDetected previousInput];
                                   
        else % 'PLATEAU' detected            
            if (startSiteTrackON == 0)
                plateauSitesCount = plateauSitesCount + 1;
                %% Plateau mode ON
                startSiteTrackON = 1;
                % track start and end locations of plateau
                % start of plateau found
                startSitesPlateau(plateauSitesCount) = thresholdInitialForApprox - 2*paramOffset; % before the 2 increments ago
                
                result_featureDetected = [result_featureDetected previousInput];
            end
        end
            %%
    else
            % if previously the Platueau tracking was ON
            if (startSiteTrackON == 1)
                crossOverNumberOfMinimaOrMaxima = crossOverNumberOfMinimaOrMaxima + 1;   % feature found count for Plateau
                startSiteTrackON = 0;
                endSitesPlateau(plateauSitesCount) = thresholdInitialForApprox - 2*paramOffset; % before the 2 increments ago
                
                result_featureDetected = [result_featureDetected previousInput];
            end  
    end
    
%     if (length(startSitesPlateau) ~= length(endSitesPlateau))
%         endSitesPlateau(plateauSitesCount) = length(proclivityFeatureALL) + 2;
%     end            
    
    previousProclivity = currentProclivity;    
end

thresholdInitialForApproxEnd = thresholdInitialForApproxStart + ((runID-1)*paramOffset);

figure,
plot(thresholdInitialForApproxStart:paramOffset:thresholdInitialForApproxEnd, resultTrackArchive);

%%
hold on;
% huntModeON = proclivityFeatureToHunt
if (  (strcmp (huntModeON, 'MAXIMA')) | ...
      (strcmp (huntModeON, 'MINIMA')))
  
    markLocationsIndex = markLocations/paramOffset;

    if (markLocationsIndex(1) == 0)
        markLocationsIndex(1) = 1;  % no zero for index 1
    end

    valuesAtLocationsOfMaxOrMin = result_featureDetected; % resultTrackArchive(locationsOfMaxOrMin)
    
    % looping deters multiple annotations of points at 1 site
    for i = 1 : length(markLocationsIndex)
        plot(markLocations(i), valuesAtLocationsOfMaxOrMin(i), 'r*');   % mark local maxima/ minima
    
        annot = sprintf('Max/Min: \n x=%f, \n y=%f\n', markLocations(i), valuesAtLocationsOfMaxOrMin(i));
        text(markLocations(i), valuesAtLocationsOfMaxOrMin(i), annot);
    end
    
elseif (strcmp (proclivityFeatureToHunt, 'PLATEAU')) 
    locationsOfPlateaus = sort([startSitesPlateau endSitesPlateau], 'ascend' );
    locationsOfPlateausIndex = locationsOfPlateaus/paramOffset;
    
    valuesAtPlateaus = result_featureDetected;
    
    % looping deters multiple annotations of points at 1 site
    for i = 1 : length(locationsOfPlateaus)    
        plot(locationsOfPlateaus(i), valuesAtPlateaus(i), 'rx');   % mark local plateaus
        
        annot = sprintf('Plateau: \n x=%f, \n y=%f\n', locationsOfPlateaus(i), valuesAtPlateaus(i));
        text(locationsOfPlateaus(i), valuesAtPlateaus(i), annot);        
    end
end

hold off;

% end

%{
MINIMA
------
[1]
\   /
 \ /
  V                  descend, ascend
[2]
     /
    /
___/                 plateau, ascend

[3]
\         /
 \       /
  \_____/
        \
         \           descend, plateau, (ascend/ descend)

MAXIMA
------
[1]
  ^
 / \
/   \               ascend, descend

[2]  
___ 
   \
    \
     \              plateau, descend

[3]
         /
        /
  _____/
 /     \
/       \           ascend, plateau, (ascend/ descend)

%}


