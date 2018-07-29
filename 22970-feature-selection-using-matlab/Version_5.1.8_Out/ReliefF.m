function [ResultMat,FeaturesWeightsOrdered,FeaturesIndexOrdered,...
  OptimumFeatureSet] = ReliefF(DatasetToUse,FSSettings,handles)

% FSSettings
NCorePatterns = FSSettings.NCorePatterns; 
NHits         = FSSettings.NHits; 
PercTest      = FSSettings.PercTest;
GammaParam    = FSSettings.GammaParam;
ConfMatSwitch  = FSSettings.ConfMatSwitch;
ErrorEstMethod = FSSettings.ErrorEstMethod;
NRepThres = 50;

% NCorePatterns: (Integer) Number of randomly selected Patterns 
%              (or equivalent Steps) for ReliefF (Default = 250)

% NHits: (Integer) Number of Hits/Misses (Default = 10)

% PercTest: (Integer) 1/PercTest of data is used for testing. 
%           Remain is used for training the classifier 
%           (DEFAULT= 10, RANGE [5,...,50]). 

% GammaParam: (Double in [0,1]) The accuracy of the feature 
%             selection when the ttest 
%             method is used (DEFAULT = 0.015)
                        % Confidence interval to control number of 
                        % repetitions. Options:0<GammaParam <1. 
                        % The lowest, the better. GammaParam 
                        % will be used to override unecessary 
                        % repetition with a stat. test.

% ConfMatSwitch: (Binary) Calcul. & View Confusion matrix switch
%                (DEFAULT = 1)

%=============== Load The Patterns ===============================

% NPatterns: The number of Patterns
% KFeatures: The number of features
% CClasses : The number of features

% Patterns, features and Targets in a single matrix of 
% NPatterns X (KFeatures + 1) dimensionality. 
% The additional feature column is the Targets. 
% Patterns: FLOAT numbers in [0,1]
% Targets: INTEGER in {1,2,...,C}, where C the number of classes. 

global NPatterns KFeatures Patterns Targets CClasses Prior 
global StopByUser SetOfClasses

%================= Data Load ======================================
[Patterns, Targets] = DataLoadAndPreprocess(DatasetToUse);
 
[NPatterns, KFeatures] = size(Patterns);
CClasses = max(Targets);

for IndexClass =1:CClasses
    Prior(IndexClass) = sum(Targets == IndexClass)/ NPatterns;
end

%============ Settings of ReliefF =================================

SetOfClasses  = 1:CClasses;
NDc = NPatterns*(1-1/PercTest)/CClasses;

%============ Initialization ======================================
FeatureWeightsTab = zeros(KFeatures,1);
CurrentFeatureSet = [];
ResultMat         = [];
OptimumFeatureSet = [];
OptimumLowLimMahal = 0;
CCR                  = zeros(NCorePatterns,1);  
InfoLoss             = zeros(NCorePatterns,1);
LowLimitMahalInfLoss = zeros(NCorePatterns,1);
%============ Log Print ===========================================
StrLine = ['------------------------------------------'];  
                                 
fprintf(['\t\t ReliefF Steps \n' StrLine '\n' ... 
         'Step | CCR | Lower CCR | Number of Features\n' ...
         StrLine '\n']);

%============ Begin ReliefF========================================
for IndexCorePattern = 1:NCorePatterns
    CorePatternIndex = round(NPatterns*rand); % Select rand a pat
    
    if CorePatternIndex == 0
        CorePatternIndex = 1;
    end
    IndexCoreClass   = Targets(CorePatternIndex);
    CorePattern      = Patterns(CorePatternIndex,:);
    SetNoCoreClass   = SetOfClasses;
    SetNoCoreClass(IndexCoreClass) = [];
    IndexMisses=FindNearMisses(CorePattern, IndexCoreClass, NHits);
    IndexHits = FindNearHits(CorePattern, IndexCoreClass, NHits);
    for IndexFeature = 1:KFeatures
        FeatureWeightsTab(IndexFeature) = ...
                  FeatureWeightsTab(IndexFeature) ...
                       -1/NCorePatterns/NHits*...
                          sum(abs(CorePattern(IndexFeature)-...
                                Patterns(IndexHits,IndexFeature)));
                            
        for IndexNoCoreClass = SetNoCoreClass
           FeatureWeightsTab(IndexFeature) = ...
             FeatureWeightsTab(IndexFeature) + ...
              Prior(IndexNoCoreClass)/(1-Prior(IndexCoreClass))/...
                   NCorePatterns/NHits*...
                   sum(abs(CorePattern(IndexFeature) - ...
                     Patterns(IndexMisses(:,IndexNoCoreClass),...
                                                   IndexFeature)));
        end
    end
    [FeaturesWeightsOrdered, FeaturesIndexOrdered] = ...
                              sort( FeatureWeightsTab, 'descend');

    IndexImportFeats  = find(FeaturesWeightsOrdered > 0);
    if length(IndexImportFeats) > NDc - 1                          
    IndexImportFeats  = find(FeaturesWeightsOrdered > ...
                                  0.7*max(FeaturesWeightsOrdered));
    end
    
    CurrentFeatureSet = FeaturesIndexOrdered(IndexImportFeats);
    if length(CurrentFeatureSet) > NDc - 1
        CurrentFeatureSet = CurrentFeatureSet(1:NDc-1);
    end
    Dim               = length(CurrentFeatureSet);
    
    [CCR(IndexCorePattern), ConfMat, lowCL, upCL] = ...
            BayesClassMVGaussPDFs(Patterns(:,CurrentFeatureSet),...
                   Targets, PercTest, ErrorEstMethod, NRepThres,...
                                     GammaParam, 0, ConfMatSwitch);

    InfoLoss(IndexCorePattern) = CalcInfoLoss(Dim, floor(NDc),...
                                                   ErrorEstMethod);
       
    LowLimitMahalInfLoss(IndexCorePattern) = ...
           CCR(IndexCorePattern) - InfoLoss(IndexCorePattern)...
                              *(CCR(IndexCorePattern)-1/CClasses); 
    
    ResultMat(end+1,1:4) = [IndexCorePattern ...
   CCR(IndexCorePattern) LowLimitMahalInfLoss(IndexCorePattern) ...
     length(IndexImportFeats)];

 
     fprintf('%d   | %1.3f | %1.3f  |   %d\n', ResultMat(end,1:4));
     
     
     
    % If best store it                               
    if LowLimitMahalInfLoss(IndexCorePattern)>OptimumLowLimMahal 
        OptimumFeatureSet = CurrentFeatureSet;
        OptimumStepIndx   = IndexCorePattern;
        OptimumLowLimMahal=LowLimitMahalInfLoss(IndexCorePattern);
    end
                                 
    %----------------------- Plot Module --------------------------
    if ~isempty(handles)
        StrList = ...
          num2str([FeaturesIndexOrdered FeaturesWeightsOrdered]);
        set(findobj(gcf,'Tag','ListSelFeats'), 'String', StrList);
        
        axes(handles.YelLinesAxes);
        axis([0 NPatterns 0 KFeatures]); axis manual
        hold on
        CountLines = 0;
        HYelLines = zeros(1,length(CurrentFeatureSet));
        for IndexFeature = CurrentFeatureSet'
            CountLines = CountLines + 1;
            if (NPatterns > KFeatures)
                HYelLines(CountLines) = plot([0 NPatterns+2],...
                                       IndexFeature*ones(1,2),'y');
            else
                HYelLines(CountLines)  =...
                 plot(IndexFeature*ones(1,2),[0 NPatterns+2], 'y');
            end
        end
        drawnow        
  
        axes(handles.FeatSelCurve);
        plot(1:IndexCorePattern, CCR(1:IndexCorePattern), 'b');
        hold on
        plot(1:IndexCorePattern, ...
                 LowLimitMahalInfLoss(1:IndexCorePattern), 'r');
        xlabel('# of core patterns');
        drawnow
        delete(HYelLines);
    else
        plot( ResultMat(1:IndexCorePattern,2),'b.-');
        hold on
        plot( ResultMat(1:IndexCorePattern,3), 'r.-');
        drawnow
        title([DatasetToUse ' ' ErrorEstMethod ' ReliefF']);
    end
    %------------------- End plot modulo --------------------------    
    if StopByUser
        StopByUser = 0;
        return
    end
     %-------------------------------------------------------------
end  % End NCorePatterns Repetition  


if ~isempty(handles)
    axes(handles.YelLinesAxes);
    for IndexFeature = OptimumFeatureSet'
        CountLines = CountLines + 1;
        hold on
        if (NPatterns > KFeatures)
            HYelLines(CountLines) = plot([0 NPatterns+2],...
                                       IndexFeature*ones(1,2),'y');
        else
            HYelLines(CountLines)  =...
                plot(IndexFeature*ones(1,2),[0 NPatterns+2], 'y');
        end
    end
    set(findobj(gcf,'Tag','ListSelFeats'), 'String', ...
                                                OptimumFeatureSet);
axes(handles.FeatSelCurve);
end

hold on
plot(OptimumStepIndx*ones(1,2), [0 OptimumLowLimMahal], 'r');
StopByUser = 0;
return
%================ Calculate Negative Term =========================
function IndexHits = FindNearHits(CorePattern,IndexCoreClass,NHits)

global Patterns Targets 
IndexCoreClassPatterns = find(Targets == IndexCoreClass);
NIndexCoreClassPatterns = length(IndexCoreClassPatterns);

[A,B] = sort(sum(abs(repmat(CorePattern,...
          NIndexCoreClassPatterns,1) ... 
                      - Patterns(IndexCoreClassPatterns,:)),2));
IndexHits = B(2:NHits+1);
%================== Calculate Positive Term =======================
function IndexMisses =FindNearMisses(CorePattern,IndexCoreClass,...
                                                             NHits)

global Patterns Targets SetOfClasses CClasses
IndexMisses    = zeros(NHits,CClasses);
SetNoCoreClass = SetOfClasses;
SetNoCoreClass(IndexCoreClass) = [];
for IndexNoCoreClass = SetNoCoreClass
    IndexNoCoreClassPatterns = find(Targets == IndexNoCoreClass);
    NIndexNoCoreClassPatterns = length(IndexNoCoreClassPatterns);
    [A,B] = sort(sum(abs(...
        repmat(CorePattern,NIndexNoCoreClassPatterns,1)-...
                    Patterns(IndexNoCoreClassPatterns,:)),2));
    IndexMisses(:,IndexNoCoreClass) = B(1:NHits);
end
%==================================================================
