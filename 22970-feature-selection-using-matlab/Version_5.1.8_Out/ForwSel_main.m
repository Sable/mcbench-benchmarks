%==================================================================
%--- Forward Feature selection by Correst Classification Rate    --
%-------------------Main Function ---------------------------------
%==================================================================

% function [ResultMat] = ForwS_main 

% Matlab function of the two forward selection algorithms:
% a) Sequential Forward Selection              (SFS)
% b) Sequential Floating Forward Selection     (SFFS)
% Methods are improved by a t-test and a Information Loss  
% evaluation. The criterion in feature selection is the correct 
% classification achieved by the Bayes classifier when each 
% probability density function is modeled as single Gaussian. 

% Main function: 
% - The feature selection method and our improvement on sequential
%   selection algorithms
% Secondary function: BayesClassMVGaussPDFs
% - Bayes Classifier with Gaussian modeled PDFs 
%   using Crossvalidation or Resubstitution methods.

%   Copyright 2003-2009 Dimitrios Ververidis, AIIA Lab.
%   $Revision: 5.1.8 $  $Date: 07/03/2009 $

% REFERENCES:
% [1] D. Ververidis and C. Kotropoulos, "Fast and accurate feature 
%     subset selection applied into speech emotion recognition," 
%     Els. Signal Process., vol. 88, issue 12, pp. 2956-2970, 2008.
% [2] D. Ververidis and C. Kotropoulos, "Optimum feature subset 
%     selection with respect to the information loss of the 
%     Mahalanobis distance in high dimensions," under preparation, 
%     2009.

 function [ResultMat, ConfMatOpt, Tlapse, OptimumFeatureSet,...
      OptimumCCR] = ForwSel_main(DatasetToUse, FSSettings, handles) 

 format short g

% INPUT
% DatasetToUse:   STRING ('finalvecXXX' where XXX=Your dbname)

% FSSettings;
ErrorEstMethod      = FSSettings.ErrorEstMethod;
FSMethod            = FSSettings.FSMethod;
MahalInfoLossMethod = FSSettings.MahalInfoLossMethod;
GammaParam          = FSSettings.GammaParam;
PercTest            = FSSettings.PercTest;
ConfMatSwitch       = FSSettings.ConfMatSwitch;
TotalNStepsThres    = FSSettings.TotalNStepsThres;
LogViewOfIntStep    = FSSettings.LogViewOfIntStep;

% ErrorEstMethod: (STRING) Error Estimation Method 
%                 Values: 'Standard'   stands for cross-validation
%                         'ProposedA'  stands for cross-validation  
%                         'ProposedAB' stands for cross-validation 
%                                      (see paper [1])   
%                         'Resubstitution' Train and Test sets are  
%                                        the whole data set

% FSMethod   : (STRING) Feature Selection method  ('SFFS','SFS')
%                                              (DEFAULT = 'SFS')

% MahalInfoLossMethod: (Binary) To use Limits of CCR wrt 
%                      Dimensionality found with Mahalanobis Info 
%                      Loss (see [2])   (DEFAULT = 1)

% PercTest: (Integer) 1/PercTest of data is used for testing. 
%           Remain is used for training the classifier 
%           (DEFAULT= 10, RANGE [5,...,50]). 

%TotalNStepsThres: (Integer) Thresh. for number of 
%                  inclusion-exclusions steps (DEFAULT = 250)

% NRepThres: (Integer) Number of Cross-validation repetitions when
%       'Standard' ErrorEstMethod is used (INTEGER>10, DEFAULT=50). 

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

% LogViewOfIntStep: (Binary) To view internal Feature selection 
%                  comparisons (DEFAULT=1)

% OUTPUT  
% ResultMat: Contains the features selected, the correct 
%      classification rate (CCR) achieved, and its Limits. Format:
% # Features | CCR | Feature Index | DownLimit | UpperLimit

%=============== Load The Patterns ===============================

% NPatterns: The number of Patterns
% KFeatures: The number of features
% CClasses : The number of features

% Patterns, features and Targets in a single matrix of 
% NPatterns X (KFeatures + 1) dimensionality. 
% The additional feature column is the Targets. 
% Patterns: FLOAT numbers in [0,1]
% Targets: INTEGER in {1,2,...,C}, where C the number of classes. 
 
[Patterns, Targets] = DataLoadAndPreprocess(DatasetToUse);
 
[NPatterns, KFeatures] = size(Patterns);
CClasses = max(Targets);
%=============== End Loading Data ================================
 
%============  Feature Selection Settings ========================
global HISTORYtable    % For Reporting
global StopByUser      % Violent Stop of Algo by user (GUI)

%NFeatToSelect: Number of features to select (For Debugging only)
%NFeatToSelect  = 4;   % Options:  3<NFeatToSelect<TotalNStepsThres   

if strcmp(ErrorEstMethod,'ProposedAB')
    NRepThres = [];     % It is estimated automatically (see [1]). 
    NDc = floor((1-1/PercTest)*NPatterns/CClasses);
elseif strcmp(ErrorEstMethod,'ProposedA') || ...
       strcmp(ErrorEstMethod,'Standard')
   NRepThres = 50;      % Options: >10, The greater, the better.  
   GammaParam = [];     
   NDc = floor((1-1/PercTest)*NPatterns/CClasses);
elseif strcmp(ErrorEstMethod,'Resubstitution')
    NRepThres  =1;      % Train and Testing with all patterns.
    NDc = floor(NPatterns/CClasses);
end
%=============   End Feature Selection Settings ==================

TimeStampStart =  clock;

%============  Log Report Formats ================================
StrLine = ['------------------------------------------' ...
                                     '-------------------------'];                       

StrInclusionStep = ['\t\t Inclusion Step\n' StrLine '\n' ...
'Feature | Corr. Classif. | Crossval. Repet.| Best Current\n'];

StrExclusionStep =['\n\t\t  Conditional Exclusion Step \t\t\t\n'...
 StrLine '\n Feature | Corr. Classification |  Crossval. Repet.'...
                                              '|  Best Current\n'];

StrFeatSelected=['\n\t\t Features Selected \n' StrLine '\n'...
'#Feat| Correct | Features | LowCL  | UpCL  | LowCL\n' ...
'Selec| Classif.| Selected | Hyper  | Hyper | Mahal\n'];                
               
FormatToPrintInterStep =['%3d \t|\t %1.3f \t|\t' ...
                                        '%3d \t|  %1.3f\n'];

FormatToPrintExterStep = [' %3d | \t%4.3f |'...
          '\t %3d\t | %4.3f  | %4.3f |  %4.3f  \n'];
%==================================================================
      
%=============== Feature Selection Initialize =====================
   
%NTestSet   = NPatterns/PercTest; % # of samples in test set 
CritvalOpt = zeros(1,KFeatures); % Maximum criterion value for sets 
                                 % of all sizes.
                   
PoolRemainFeat   = 1:KFeatures; % Pool of remaining feat indices.
SelectedFeatPool = [];      % Pool of selected feature indices.
ResultMat        = [];      % Result matrix with selection history.
NSteps           = 0;       % No Inclusion or exclusion step yet. 
NSelectedFeat    = 0;       % # of selected features.
ContinueFlag     = 1;       % Stop criterion not met yet.

%==================End of Initialization ==========================

while ContinueFlag == 1 && StopByUser == 0 %== Begin Steps ========
    if NSteps >= TotalNStepsThres
        ContinueFlag = 0;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %---------- Inclusion -----------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Critval = zeros(1,length(PoolRemainFeat));
    if LogViewOfIntStep == 1
      fprintf(1,[StrInclusionStep StrLine '\n']);
    end
    
    CritvalMaxCurrForw= 0;
    % Begin of internal step of inclusion
    for FeatSerialIndx = 1:length(PoolRemainFeat)
        % Add one feature to the already selected ones.
        CandidateFeatSet = [SelectedFeatPool, ...
            PoolRemainFeat(FeatSerialIndx)];

        HISTORYtable(end+1,1) = PoolRemainFeat(FeatSerialIndx);

        [Critval(FeatSerialIndx), ConfMat, lowCL, upCL] = ...
            BayesClassMVGaussPDFs( Patterns(:,CandidateFeatSet),...
            Targets, PercTest, ErrorEstMethod, ...
            NRepThres, GammaParam, ...
            CritvalMaxCurrForw, ConfMatSwitch);

        HISTORYtable(end  ,2) = Critval(FeatSerialIndx);

        % If this feature is the best so far and we have not yet
        % selected NFeatToSelect features, store it.

        if strcmp(ErrorEstMethod,'ProposedAB')
            CritvalThres = CritvalMaxCurrForw + GammaParam;
        else
            CritvalThres = CritvalMaxCurrForw;
        end

        if Critval(FeatSerialIndx)     >= CritvalThres
            CritvalMaxCurrForw          = Critval(FeatSerialIndx);
            ConfMatOpt                  = ConfMat;
            lowCLopt                    = lowCL;
            upCLopt                     = upCL;
            FeatSerialIndxCritvalMaxCurr= FeatSerialIndx;
            HISTORYtable(end  ,4)       = Critval(FeatSerialIndx);
        end
        
        if LogViewOfIntStep == 1
        fprintf(1, FormatToPrintInterStep, HISTORYtable(end,1), ...
                      HISTORYtable(end,2),  HISTORYtable(end,3),...
                                               CritvalMaxCurrForw);
        end
    end  % End of Internal step of inclusion

    % Add it to the set of selected features
    FeatureToInclude= PoolRemainFeat(FeatSerialIndxCritvalMaxCurr);
    
    SelectedFeatPool = [SelectedFeatPool FeatureToInclude];
    % and remove it from the pool.
    PoolRemainFeat(FeatSerialIndxCritvalMaxCurr) = [];
    NSelectedFeat                         = NSelectedFeat + 1;
    CritvalOpt(NSelectedFeat)             = CritvalMaxCurrForw;
    ResultMat(end+1,1:5)                  = [NSelectedFeat ...
        CritvalMaxCurrForw SelectedFeatPool(end) lowCLopt upCLopt];
    NSteps = size(ResultMat,1);

    %------ Curse-of-dim limits For Inclusion ---------------------
    if strcmp(MahalInfoLossMethod, 'on')
        LowLimitMahalInfLoss(NSteps) =  ...
            MahalaInfoLoss(NSelectedFeat, ResultMat(end,2),...
                     NDc, CClasses, ErrorEstMethod);
        ResultMat(end, 6) = LowLimitMahalInfLoss(NSteps);
    else
        LowLimitMahalInfLoss(NSteps) = 0;
        ResultMat(end, 6) = LowLimitMahalInfLoss(NSteps);
    end
    %--------------------------------------------------------------
   
    %----------------------- Plot Module --------------------------
    if ~isempty(handles)
        axes(handles.YelLinesAxes);
        axis([0 NPatterns 0 KFeatures]); axis manual
        hold on
        if (NPatterns > KFeatures)
            HYelLines(FeatureToInclude)=plot([0 NPatterns+2],...
                (FeatureToInclude-0.5)*ones(1,2),'y');
        else
            HYelLines(IndexFeature)= plot((FeatureToInclude-0.5)...
                *ones(1,2),[0 NPatterns+2],'y');
        end
        set(gca,'Visible','off');
        drawnow
        set(findobj(gcf,'Tag','ListSelFeats'), 'String', ...
            sort(SelectedFeatPool));
        axes(handles.FeatSelCurve);
    end
    HCCRCurve(1) = plot( ResultMat(:,2)          , 'b.-');
    legend(HCCRCurve(1), 'CCR');  
    hold on
    if strcmp(MahalInfoLossMethod , 'on')
        HCCRCurve(2) = plot( LowLimitMahalInfLoss, 'r.-');
        legend(HCCRCurve, 'CCR', 'Lower Limit of CCR',...
                                                'Location','Best');
    end
    title([DatasetToUse ' ' ErrorEstMethod ' ' FSMethod]);
    drawnow
    %--------------------------------------------------------------
       

    %--------------- Report ---------------------------------------
    fprintf(1, ['\n\n' StrFeatSelected StrLine '\n']);
    for pre_i=1:size(ResultMat,1)
        fprintf(1,FormatToPrintExterStep, ResultMat(pre_i,1), ...
                      ResultMat(pre_i,2), ResultMat(pre_i,3), ...
                      ResultMat(pre_i,4), ResultMat(pre_i,5),...
                      ResultMat(pre_i,6));
    end
    fprintf(1,[StrLine '\n\n\n']);

    if ConfMatSwitch == 1
        ShowConfMat(ConfMatOpt);
    end
    %---------------End Report ------------------------------------

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %-------Conditional Exclusion ---
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Now keep removing features until the criterion gets worse.
    CritvalMaxCurrBack = CritvalMaxCurrForw;
    FlagBackwSteps=1;

    if NSelectedFeat == KFeatures
        ContinueFlag = 0;
    end

    while (NSelectedFeat > 2) && FlagBackwSteps == 1 && ...
                       ContinueFlag == 1 && strcmp(FSMethod,'SFFS')
        

        if LogViewOfIntStep == 1                   
          fprintf(1, [StrExclusionStep StrLine '\n']);
        end
        
        for FeatSerialIndx = 1:NSelectedFeat
            CandidateFeatSet = SelectedFeatPool;
            % Remove one feature from the selected ones.
            CandidateFeatSet(FeatSerialIndx) = [];
            HISTORYtable(end+1,1) =...
                -SelectedFeatPool(FeatSerialIndx);

            [Critval(FeatSerialIndx),  ConfMat, lowCL, upCL] = ...
             BayesClassMVGaussPDFs(Patterns(:,CandidateFeatSet),...
                   Targets, PercTest, ErrorEstMethod, NRepThres,...
                    GammaParam, CritvalMaxCurrBack, ConfMatSwitch);
                     
            HISTORYtable(end, 2)  =  Critval(FeatSerialIndx);
            % If removing this feature gives the best result so far
            % (or the same result using less features), and we have
            % not yet removed all NFeatToSelect features, store it.

            if strcmp(ErrorEstMethod,'ProposedAB')
                CritvalThres = CritvalMaxCurrBack + GammaParam;
            else
                CritvalThres = CritvalMaxCurrBack;
            end

            if Critval(FeatSerialIndx) > CritvalThres
                CritvalMaxCurrBack       = Critval(FeatSerialIndx);
                FeatSerialIndxCritvalMaxCurr = FeatSerialIndx;
                ConfMatOptBack           = ConfMat;
                lowCLoptBack             = lowCL;
                upCLoptBack              = upCL;
                HISTORYtable(end, 4)     = Critval(FeatSerialIndx);
            end

            
           if LogViewOfIntStep == 1
              fprintf(1, FormatToPrintInterStep, ...
                   HISTORYtable(end,1), HISTORYtable(end,2), ...
                          HISTORYtable(end,3), CritvalMaxCurrBack);
           end
        end    % end checking all selected features

        % If this subset is better than any found before, store
        % and report it. Otherwise, stop removing features.

        if strcmp(ErrorEstMethod,'ProposedAB')
            CritvalThres = CritvalMaxCurrForw + GammaParam;
        else
            CritvalThres = CritvalMaxCurrForw;
        end

        if CritvalMaxCurrBack > CritvalThres
            FeatureToExclude         = ...
                    SelectedFeatPool(FeatSerialIndxCritvalMaxCurr);
            NSelectedFeat            = NSelectedFeat - 1;
            CritvalOpt(NSelectedFeat)= CritvalMaxCurrBack ;
            ConfMatOpt               = ConfMatOptBack;
            lowCLopt                 = lowCLoptBack;
            upCLopt                  = upCLoptBack;
            PoolRemainFeat      =[PoolRemainFeat FeatureToExclude];
            PoolRemainFeat           = sort(PoolRemainFeat);
            ResultMat(end+1,1:5)     = [NSelectedFeat ...
                                         CritvalMaxCurrBack ...
                               -FeatureToExclude lowCLopt upCLopt];
            NSteps = size(ResultMat,1);
            SelectedFeatPool(FeatSerialIndxCritvalMaxCurr ) = [];
            HISTORYtable(end, 4)       = CritvalMaxCurrBack;
            CritvalMaxCurrForw         = CritvalMaxCurrBack;
            %----- Curse-of-dim limits For Exclusion --------------
            if strcmp(MahalInfoLossMethod, 'on')
                LowLimitMahalInfLoss(NSteps) =  ...
                 MahalaInfoLoss(NSelectedFeat, ResultMat(end,2),...
                     NDc, CClasses, ErrorEstMethod);
               
                ResultMat(NSteps, 6)= LowLimitMahalInfLoss(NSteps);
            end
            %------------------------------------------------------
            
            %--------------- Plot module for exclusion ------------
            if ~isempty(handles)
                delete(HYelLines(FeatureToExclude));
                axes(handles.FeatSelCurve);
                plot( ResultMat(:,2),  'b.-');
                hold on
                if strcmp(MahalInfoLossMethod, 'on')
                    plot( LowLimitMahalInfLoss, 'r.-');
                end
                drawnow
                set(findobj(gcf,'Tag','ListSelFeats'),'String',...
                                           sort(SelectedFeatPool));
                pause(0.1);
            end
            %------------------------------------------------------
        else
            FlagBackwSteps = 0;   % continue with forward steps
        end
        %-------------------- Report Log --------------------------
        fprintf(1, ['\n\n' StrFeatSelected StrLine '\n']);
        for pre_i=1:size(ResultMat,1)
            fprintf(1,FormatToPrintExterStep, ResultMat(pre_i,1),...
                ResultMat(pre_i,2), ResultMat(pre_i,3),...
                ResultMat(pre_i,4), ResultMat(pre_i,5),...
                ResultMat(pre_i,6));
        end
        fprintf(1,[StrLine '\n\n\n\n']);
        %----------------------------------------------------------
    end % end backwards loop

    %----------- Plot Hypergeo Upper Lower Limits -----------------
    if 0
        plot(   ResultMat(:,4) ,'b.-' )
        hold on
        plot(   ResultMat(:,5), 'r.-')
        drawnow
    end
    %--------------------------------------------------------------
end %====================== END FINAL =============================

if ConfMatSwitch == 1
    ShowConfMat(ConfMatOpt);
end

%--------- Find Optimum Feature Set -------------------------------
if strcmp(MahalInfoLossMethod, 'on')
    [OptimumCCR, OptimumStepIndx] = max( ResultMat(:,6));
else
    [OptimumCCR, OptimumStepIndx] = max( ResultMat(:,4));
end
OptimumFeatureSet= FindOptFeatSet(ResultMat(1:OptimumStepIndx, 3));    
OptimumFeatureSet= sort(OptimumFeatureSet);

%--------- Calculate Execution Time -------------------------------
TimeStampEnd =  clock;
Tlapse       =  etime(TimeStampEnd, TimeStampStart);

%----------- Plot module ------------------------------------------
LinesToDeleteFeatInd = setxor(SelectedFeatPool, OptimumFeatureSet);

if ~isempty(handles)
    delete( HYelLines(LinesToDeleteFeatInd));
    set(findobj(gcf,'Tag','ListSelFeats'), 'String', ...
        OptimumFeatureSet);

    axes(handles.FeatSelCurve);
end
hold on
plot(OptimumStepIndx*ones(2,1), [0 OptimumCCR], 'r');
title(['Optimum FeatSet: ' num2str(OptimumFeatureSet')]);
xlabel(['Time Lapse: ' num2str(Tlapse) ' secs']);



StopByUser = 0;
return

%------------------------------------------------------------------
%--------------- Best Set after Removals --------------------------
%------------------------------------------------------------------
function OptimumFeatureSet = FindOptFeatSet(PathOfFeaturesSelected)

OptimumFeatureSet=PathOfFeaturesSelected;

for IndexStep=1:length(OptimumFeatureSet),
    if OptimumFeatureSet(IndexStep)<0,
        remov = OptimumFeatureSet(1:IndexStep) ...
                                 == -OptimumFeatureSet(IndexStep);
        OptimumFeatureSet(remov==1) =0;
        OptimumFeatureSet(IndexStep)=0;
    end
end

OptimumFeatureSet = OptimumFeatureSet( OptimumFeatureSet>0);
return

%------------------------------------------------------------------
%-------------- Mahalanobis Info Loss Limits ----------------------
%------------------------------------------------------------------
function LowLimitMahalInfLoss = MahalaInfoLoss(D, CCR, NDc, ...
                                          CClasses, ErrorEstMethod) 
%Calculate Info Loss 
InfoLoss = CalcInfoLoss(D, floor(NDc), ErrorEstMethod);
LowLimitMahalInfLoss = CCR - InfoLoss*(CCR-1/CClasses);
return