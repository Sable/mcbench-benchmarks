%------------------------------------------------------------------
%---------------Load Data and Preprocessing -----------------------
%------------------------------------------------------------------

%   Copyright 2003-2009 Dimitrios Ververidis, AIIA Lab.
%   $Revision: 0.0$ $Date: 09/01/2009$

% Do by your will:
% 1. Remove redudant features: Features with many Nans or unique 
%    values
% 2. Normalize feature values to 0-1

function [Patterns, Targets] = DataLoadAndPreprocess(DatasetToUse)

if strfind(DatasetToUse,'.mat')
  DatasetToUse = DatasetToUse(1:(length(DatasetToUse)-4));
end

%--------------------- Load data ----------------------------------
cd('PatTargMatrices')
load([DatasetToUse]);
cd('..');
%------------------- End Load data  -------------------------------

%-----------------Prepare Targets and Patterns --------------------
[NPatterns, KInitialFeatures] = eval(['size(' DatasetToUse ')']);   
patterns = eval([DatasetToUse '(1:NPatterns,1:KInitialFeatures)']);

if strcmp(DatasetToUse,'finalvecDES') || ...
       strcmp(DatasetToUse,'finalvecSUSAS') || ...
               strcmp(DatasetToUse,'finalvecKidsVR')
   emotions     = eval([DatasetToUse '(1:NPatterns, 114)']);
   if strcmp(DatasetToUse, 'finalvecSUSAS')
       EmotionsOfInterest = ...
       (emotions == 1 | emotions == 2 | ...
        emotions == 6 | emotions == 8); % | ...
%        emotions == 8 | emotions == 9 | ...
 %       emotions == 10 | emotions == 11);
%   1     2     3     4     5     6     7     8     9     10   11
% 'ARY' 'CAR' 'C50' 'C70' 'FST' 'LRD' 'LUD' 'NAL' 'QON' 'SOW' 'SFT'
                        
       patterns  = patterns(EmotionsOfInterest, :);
       emotions = emotions( EmotionsOfInterest);
       emotions(emotions ==6) = emotions(emotions == 6) -3;
       emotions(emotions ==8) = emotions(emotions == 8) -4;
%        emotions(emotions ==8) = emotions(emotions ==8) -3;
%        emotions(emotions ==9) = emotions(emotions ==9) - 3;
%        emotions(emotions ==10) = emotions(emotions ==10) - 3;
%        emotions(emotions ==11) = emotions(emotions ==11) - 3;
   end

   [NPatterns,  KInitialFeatures]  = size(patterns);
   KFeatures           =     90;   % 90 Remained after Processing

   %------------------- Missing data handle --------
   for FeatureIndex = 1:KInitialFeatures
       FeatureMean(FeatureIndex)=nanmean(patterns(:,FeatureIndex));
       for PatternIndex = 1:NPatterns  ,
           if isnan(patterns(PatternIndex,FeatureIndex)),
               patterns(PatternIndex, FeatureIndex) = ...
                                         FeatureMean(FeatureIndex);
           end
       end
   end

   %--------------Exponential Normalization------------------------
   tabexp   = [13 14 30:32 37 39:40 46 53 64:66 68 ...
       71 86:104  106:113];   % Exponentially distributed features

   for FeaturesIndex=1:length(tabexp),
       lamda=1/mean(patterns(:,tabexp(FeaturesIndex)));
       for PatternsIndex=1:NPatterns
           patterns(PatternsIndex,tabexp(FeaturesIndex)) = (1 - ...
              exp(-lamda* patterns(PatternsIndex,...
              tabexp( FeaturesIndex ))))/(1 - exp(-lamda));
       end
   end

   %-----------------Linear Normalization--------------------------
   for FeaturesIndex=1:KInitialFeatures,
       a = min(patterns(:,FeaturesIndex));
       b = max(patterns(:,FeaturesIndex));
       patterns(:, FeaturesIndex)=(patterns(:, FeaturesIndex) -...
                                                          a)/(b-a);
   end

    %---------------- Remove features ----------------
    tabNans = [23:29 48 57:63];               % Feature with Nans
    tabbias = [8 33:34 41 60 67 75 82 105];   % Features with Bias
    tabnw   = sort([tabNans tabbias]);        % Useless features
   
    tabfin = 1:KInitialFeatures;
    for FeatureIndex = 1:length(tabnw)
        tabfin(tabnw(FeatureIndex)) = 0;
    end

    tabfin = tabfin(find(tabfin~=0));
    patterns = patterns(:,tabfin);
    
    Patterns = patterns(1:NPatterns,1:KFeatures);
    Targets = emotions;
elseif strcmp(DatasetToUse,'finalvecCOLONCANCER')
    for FeaturesIndex= 1:KInitialFeatures-1,
        a = min(patterns(:,FeaturesIndex));
        b = max(patterns(:,FeaturesIndex));
        patterns(:, FeaturesIndex)=(patterns(:, FeaturesIndex) -...
            a)/(b-a);
    end
    Patterns = patterns(:,1:(KInitialFeatures-1));
    Targets  = eval([DatasetToUse '(1:NPatterns, end)']);

    NewTargets = zeros(NPatterns,1);
    NewTargets(find(Targets>0)) = 1;
    NewTargets(find(Targets<0)) = 2;
    Targets = NewTargets;
    disp('1 responds to Benign, 2 responds to Malignant');
else   % Your Data is loaded here
       % Linear transformation, Normalization to [0,1]
    for FeaturesIndex= 1:KInitialFeatures-1,
        a = min(patterns(:,FeaturesIndex));
        b = max(patterns(:,FeaturesIndex));
        patterns(:, FeaturesIndex)=(patterns(:, FeaturesIndex) -...
            a)/(b-a);
    end
    Patterns = patterns(:,1:(KInitialFeatures-1));
    Targets  = eval([DatasetToUse '(1:NPatterns, end)']);
    disp(['No Preprocessing Code, however PatternTargets format'...
        'is appropriate']);
end

disp('Size of Patterns');
size(Patterns)
disp('Size of Targets');
size(Targets)
save  'Patterns.mat' Patterns
save  'Targets.mat' Targets
return