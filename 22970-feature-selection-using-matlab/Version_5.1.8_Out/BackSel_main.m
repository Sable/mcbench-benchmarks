%==================================================================
%--- Backward Feature selection by Correst Classification Rate ----
%---------------   Main Function  ---------------------------------
%==================================================================

% function [ResultMat] = BackSel_main 

% Matlab function of the two backward selection algorithms:
% a) Sequential Backward Selection              (SBS)
% b) Sequential Floating Backward Selection     (SFBS)
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
%   $Revision: 5.1.4 $  $Date: 27/01/2009 $

% REFERENCES:
% [1] D. Ververidis and C. Kotropoulos, "Fast and accurate feature 
%     subset selection applied into speech emotion recognition," 
%     Els. Signal Process., vol. 88, issue 12, pp. 2956-2970, 2008.
% [2] D. Ververidis and C. Kotropoulos, "Optimum feature subset 
%     selection with respect to the information loss of the 
%     Mahalanobis distance in high dimensions," under preparation, 
%     2009.

 function [ResultMat, ConfMatFinal, Tlapse, OptimumFeatureSet,...
    OptimumError] = BackSel_main(DatasetToUse, FSSettings, handles) 
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


% ErrorEstMethod: Error Estimation Method (STRING)  
%                 Values: 'Standard'   stands for cross-validation
%                         'ProposedA'  stands for cross-validation  
%                         'ProposedAB' stands for cross-validation 
%                                      (see paper [1])   
%                         'Resubstitution' Train and Test sets are  
%                                        the whole data set

% MahalInfoLossMethod: (Binary) To use Limits of CCR wrt 
%                      Dimensionality found with Mahalanobis Info 
%                      Loss (see [2])   (DEFAULT = 1)


% FSMethod  : (STRING) Feature Selection method  ('SFFS','SFS')
%                                              (DEFAULT = 'SFS')

% PercTest: (Integer) 1/PercTest of data is used for testing. 
%           Remain is used for training the classifier 
%           (DEFAULT= 10, RANGE [5,...,50]). 

%TotalNStepsThres: (Integer) Thresh. for number of 
%                  inclusion-exclusions steps (DEFAULT = 250)

% NRepThres: (Integer) Number of Cross-validation repetitions when 
%     'Standard' ErrorEstMethod is used (INTEGER>10, DEFAULT=50). 


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

StrInclusionStep = ['\n\t Conditional Inclusion Step\n' StrLine ...
'\nFeature | Corr. Classif.\t | Crossval. Repet.| Best Current\n'];

StrExclusionStep =['\n\t\t Exclusion Step \t\t\t\n' StrLine ...
    '\n Feature | Corr. Classification |  Crossval. Repet.'...
                                              '|  Best Current\n'];

StrFeatSelected=['\n\t\t\t\t Features Discarded \n' StrLine '\n'...
'#Feat| Correct | Features | LowCL  | UpCL  | LowCL\n' ...
'Remov| Classif.| Discarded| Hyper  | Hyper | Mahal\n'];                
               
FormatToPrintInterStep =['%3d \t|\t\t %1.3f \t\t\t|\t' ...
                                        '%3d \t\t|       %1.3f\n'];

FormatToPrintExterStep = [' %3d | \t%4.3f |'...
                           '\t %3d\t | %4.3f  | %4.3f |  %4.3f\n'];
%==================================================================
      
%=============== Feature Selection Initialize =====================
%NTestSet   = NPatterns/PercTest; % # of samples in test set 
CritvalOpt = zeros(1,KFeatures); % Maximum criterion value for sets 
                                 % of all sizes.

SelectedFeatPool = 1:KFeatures; % Pool of selected feature indices.
PoolRemainFeat   = [];          % Pool of remaining feat indices.
ResultMat        = [];      % Result matrix with selection history.
NSteps           = 0;       % No Inclusion or exclusion step yet. 
NSelectedFeat    = KFeatures; % # of selected features.
ContinueFlag     = 1;         % Stop criterion not met yet.
StopByUser       = 0;        % Not stoped by user
FlagAll          = 0;       
%================== Handle too many features ======================
if NDc < KFeatures + 1
    RandSelectFeatIndices = randperm(KFeatures);
    SelectedFeatPool = RandSelectFeatIndices(1:(NDc-1));
    SelectedFeatPool = sort(SelectedFeatPool);
    PoolRemainFeat = setxor(1:KFeatures, SelectedFeatPool);
    NSelectedFeat = NDc-1;
    disp('Select Randomly some features')
end

InitialSelectedFeatPool = SelectedFeatPool;
%=================== Plot Feature Lines ===========================
if ~isempty(handles)
    if NPatterns > KFeatures
        xLim = NPatterns;  yLim = KFeatures;
    else 
        yLim = NPatterns;  xLim = KFeatures;
    end
    
    axes(handles.YelLinesAxes);
    axis([0 xLim 0 yLim]); axis manual
    hold on
    for IndexFeatures = 1:length(SelectedFeatPool)
      if (NPatterns > KFeatures)
          HYelLines(SelectedFeatPool(IndexFeatures)) = ...
              plot([0 NPatterns+2],...
               (SelectedFeatPool(IndexFeatures)-.5)*ones(1,2),'y');
      else
          HYelLines(SelectedFeatPool(IndexFeatures)) = ...
            plot((SelectedFeatPool(IndexFeatures)-.5)*...
                                    ones(1,2),[0 NPatterns+2],'y');
       end
    end
    set(gca,'Visible','off');
    drawnow
    set(findobj(gcf,'Tag','ListSelFeats'), 'String', ...
                                        num2str(SelectedFeatPool));
end


%==================End of Initialization ==========================
while ContinueFlag == 1 && StopByUser == 0 %== Begin Steps ========
    if NSteps >= TotalNStepsThres
        ContinueFlag = 0;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %---------- Exclusion -----------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if LogViewOfIntStep == 1
        fprintf(1,[StrExclusionStep StrLine '\n']);
    end
    % First Internal of First External: Use all Features
    if NSelectedFeat == KFeatures
        HISTORYtable(end+1,1) = 0;
        [Critval, ConfMatOptBack, lowCLOptBack, upCLOptBack] = ...
                        BayesClassMVGaussPDFs(...
            Patterns, Targets, PercTest, ErrorEstMethod,...
            NRepThres, GammaParam, 0, ConfMatSwitch);
        HISTORYtable(end  ,2) = Critval;
        HISTORYtable(end  ,4) = Critval;   
        if LogViewOfIntStep == 1
        fprintf(1, FormatToPrintInterStep, ...
            HISTORYtable(end,1), ...
            HISTORYtable(end,2),  HISTORYtable(end,3),Critval);
        end
        CritvalMaxCurrBack = Critval;
        FlagAll = 1;
    end
    
    Critval            = zeros(1,length(PoolRemainFeat));
    CritvalMaxCurrBack = 0;
    for FeatSerialIndx = 1:NSelectedFeat
        CandidateFeatSet = SelectedFeatPool;
        %Remove one feature from the selected ones.
        CandidateFeatSet(FeatSerialIndx) = [];
        HISTORYtable(end+1,1)= -SelectedFeatPool(FeatSerialIndx);
        
        [Critval(FeatSerialIndx), ConfMat, lowCL, upCL] = ...
            BayesClassMVGaussPDFs( Patterns(:,...
            CandidateFeatSet), Targets, PercTest,...
            ErrorEstMethod, NRepThres, GammaParam, ...
            CritvalMaxCurrBack, ConfMatSwitch);

        HISTORYtable(end  ,2) = Critval(FeatSerialIndx);
        % If removing this feature gives the best result so far
        % (or the same result using less features), and we have
        % not yet removed all NFeatToSelect features, store it.

        if strcmp(ErrorEstMethod,'ProposedAB')
            CritvalThres = CritvalMaxCurrBack + GammaParam;
        else
            CritvalThres = CritvalMaxCurrBack;
        end

        if Critval(FeatSerialIndx)     >= CritvalThres
            CritvalMaxCurrBack       = Critval(FeatSerialIndx);
            ConfMatOptBack              = ConfMat;
            lowCLOptBack                = lowCL;
            upCLOptBack                 = upCL;
            FeatSerialIndxCritvalMaxCurr= FeatSerialIndx;
            HISTORYtable(end  ,4)    = Critval(FeatSerialIndx);
            FlagAll = 0;
        end

        
        if LogViewOfIntStep ==1 
        fprintf(1, FormatToPrintInterStep,...
            HISTORYtable(end,1), ...
            HISTORYtable(end,2),  HISTORYtable(end,3),...
            CritvalMaxCurrBack);
        end
    end % end check all selected features (End Internal Step)

    ConfMatFinal             = ConfMatOptBack;
    lowCLFinal               = lowCLOptBack;
    upCLFinal                = upCLOptBack;
    NSteps                   = NSteps+1;
    HISTORYtable(end, 4)     = CritvalMaxCurrBack;
    CritvalMaxCurrForw       = CritvalMaxCurrBack;
    
    if FlagAll
     ResultMat(end+1,1:5) =[KFeatures-NSelected ...
                    CritvalMaxCurrBack 0 lowCLOptBack upCLOptBack];
    else
     CritvalOpt(NSelectedFeat)= CritvalMaxCurrBack ;
     NSelectedFeat            = NSelectedFeat - 1;
     PoolRemainFeat           = [PoolRemainFeat ...
                   SelectedFeatPool(FeatSerialIndxCritvalMaxCurr)];
     PoolRemainFeat           = sort(PoolRemainFeat);
     ResultMat(end+1,1:5)    =[KFeatures-NSelectedFeat ...
          CritvalMaxCurrBack  ...
                -SelectedFeatPool(FeatSerialIndxCritvalMaxCurr) ...
                                        lowCLOptBack upCLOptBack ];
                                   
     SelectedFeatPool(FeatSerialIndxCritvalMaxCurr ) = [];
    end

    if NSelectedFeat == 1
        ContinueFlag = 0;
    end
    %------ Curse-of-dim limits For Exclusion ---------------------
    if strcmp(MahalInfoLossMethod, 'on')
       LowLimitMahalInfLoss(NSteps) =  ...
            MahalaInfoLoss(NSelectedFeat, ResultMat(end,2),...
                     NPatterns/CClasses, CClasses, ErrorEstMethod);

        ResultMat(end, 6) = LowLimitMahalInfLoss(NSteps);
    else
        LowLimitMahalInfLoss(NSteps) = 0;
        ResultMat(end, 6) = LowLimitMahalInfLoss(NSteps);
    end

    %-------------------------------------------------------------- 

    %------------- Plot Module for Exclusion ----------------------
    if ~isempty(handles)
        axes(handles.FeatSelCurve);
        plot( ResultMat(:,2)      , 'b.-');
        hold on
        plot( LowLimitMahalInfLoss, 'r.-');
        
        axes(handles.YelLinesAxes);           % Delete lines of  
        delete(HYelLines(-ResultMat(end,3))); % discarded features
        set(findobj(gcf,'Tag','ListSelFeats'), 'String', ...
                                                 SelectedFeatPool);
    else
        plot( ResultMat(:,2)          , 'b.-');
        hold on
        plot( LowLimitMahalInfLoss, 'r.-');
        drawnow
        title([DatasetToUse ' ' ErrorEstMethod ' Backward']);
    end
    drawnow
    %----------------End Plot -------------------------------------

    
    
    %--------------- Report for Exclusion -------------------------
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
    %-------------  End Report ------------------------------------          
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %-------Conditional Inclusion ---
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Now keep adding features until the criterion gets worse.
    CritvalMaxCurrForw = CritvalMaxCurrBack;
    FlagForwSteps = 1;

    if NSelectedFeat == KFeatures
        ContinueFlag = 0;
    end

    while (NSelectedFeat<KFeatures - 2) && FlagForwSteps == 1 &&...
                       ContinueFlag == 1 && strcmp(FSMethod,'SFBS')

        if LogViewOfIntStep == 1                   
          fprintf(1, [StrInclusionStep StrLine '\n']);
        end

        for FeatSerialIndx = 1:length(PoolRemainFeat)
            % Add one feature to the already selected ones.
            CandFeatureToAdd = PoolRemainFeat(FeatSerialIndx);
            CandidateFeatSet = [SelectedFeatPool CandFeatureToAdd];
            HISTORYtable(end+1,1) = CandFeatureToAdd;

            [Critval(FeatSerialIndx), ConfMat, lowCL, upCL] = ...
             BayesClassMVGaussPDFs(Patterns(:,CandidateFeatSet),...
                   Targets, PercTest, ErrorEstMethod, NRepThres,...
                    GammaParam, CritvalMaxCurrBack, ConfMatSwitch);
                     
            HISTORYtable(end, 2)  =  Critval(FeatSerialIndx);
            
           % If this feature is the best so far and we have not yet
           % selected NFeatToSelect features, store it.

            if strcmp(ErrorEstMethod,'ProposedAB')
                CritvalThres = CritvalMaxCurrForw + GammaParam;
            else
                CritvalThres = CritvalMaxCurrForw;
            end

            if Critval(FeatSerialIndx)  >= CritvalThres
                CritvalMaxCurrForw       = Critval(FeatSerialIndx);
                FeatSerialIndxCritvalMaxCurr = FeatSerialIndx;
                ConfMatOptForw           = ConfMat;
                lowCLoptForw             = lowCL;
                upCLoptForw              = upCL;
                HISTORYtable(end, 4)     = Critval(FeatSerialIndx);
            end

            
           if LogViewOfIntStep == 1
              fprintf(1, FormatToPrintInterStep, ...
                   HISTORYtable(end,1), HISTORYtable(end,2), ...
                          HISTORYtable(end,3), CritvalMaxCurrForw);
           end
        end    % End internal step of inclusion

        % If this subset is better than any found before, store
        % and report it. Otherwise, stop removing features.

        if strcmp(ErrorEstMethod,'ProposedAB')
            CritvalThres = CritvalMaxCurrBack + GammaParam;
        else
            CritvalThres = CritvalMaxCurrBack;
        end

        if CritvalMaxCurrForw > CritvalThres
            FeatureToInclude         = ...
                      PoolRemainFeat(FeatSerialIndxCritvalMaxCurr);
            NSelectedFeat            = NSelectedFeat + 1;
            CritvalOpt(NSelectedFeat)= CritvalMaxCurrForw ;
            ConfMatOpt               = ConfMatOptForw;
            lowCLopt                 = lowCLoptForw;
            upCLopt                  = upCLoptForw;
            PoolRemainFeat(FeatSerialIndxCritvalMaxCurr) = [];
            PoolRemainFeat           = sort(PoolRemainFeat);
            ResultMat(end+1,1:5)     = [KFeatures-NSelectedFeat ...
             CritvalMaxCurrForw FeatureToInclude lowCLopt upCLopt];
            NSteps = size(ResultMat,1);
            SelectedFeatPool = [SelectedFeatPool FeatureToInclude];
            HISTORYtable(end, 4)       = CritvalMaxCurrForw;
            CritvalMaxCurrBack         = CritvalMaxCurrForw;
            %----- Curse-of-dim limits For Exclusion --------------
            if strcmp(MahalInfoLossMethod, 'on')
                LowLimitMahalInfLoss(NSteps) =  ...
                 MahalaInfoLoss(NSelectedFeat, ResultMat(end,2),...
                                    NDc, CClasses, ErrorEstMethod);
               
                ResultMat(NSteps, 6)= LowLimitMahalInfLoss(NSteps);
            end
            %------------------------------------------------------
            
            %--------------- Plot module for inclusion ------------
            if ~isempty(handles)
                axes(handles.YelLinesAxes);
                axis([0 NPatterns 0 KFeatures]); axis manual
                hold on
                if (NPatterns > KFeatures)
                    HYelLines(FeatureToInclude)= ...
                        plot([0 NPatterns+2],...
                             (FeatureToInclude-0.5)*ones(1,2),'y');
                else
                    HYelLines(IndexFeature)= ...
                         plot((FeatureToInclude-0.5)...
                                   *ones(1,2),[0 NPatterns+2],'y');
                end
                set(gca,'Visible','off');
                drawnow
                
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
            FlagForwSteps = 0;   % continue with backward steps
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
    [OptimumError, OptimumStepIndx] = max( ResultMat(:,6));
else
    [OptimumError, OptimumStepIndx] = max( ResultMat(:,4));
end

OptimumFeatureSet= FindOptFeatSet(InitialSelectedFeatPool,...
                                  ResultMat(1:OptimumStepIndx, 3));    

%--------- Calculate Execution Time -------------------------------
TimeStampEnd =  clock;
Tlapse       =  etime(TimeStampEnd, TimeStampStart);
                              
                              
%---------- Plot modulo -------------------------------------------
if ~isempty(handles)
    axes(handles.YelLinesAxes);
    delete(HYelLines(SelectedFeatPool)); 
    axis([0 NPatterns 0 KFeatures]); axis manual
    hold on
    for IndexFeatures = 1:length(OptimumFeatureSet)
    if (NPatterns > KFeatures)
        HYelLines(IndexFeatures) = plot([0 NPatterns+2], ...
            (OptimumFeatureSet(IndexFeatures)-.5)*ones(1,2),'y');
    else
        HYelLines(IndexFeatures) = plot(...
                        (OptimumFeatureSet(IndexFeatures)-.5)*...
                                    ones(1,2),[0 NPatterns+2],'y');
    end
    set(gca,'Visible','off');
    drawnow
    end
    set(findobj(gcf,'Tag','ListSelFeats'), 'String', ...
                                       num2str(OptimumFeatureSet));
    axes(handles.FeatSelCurve);
end
drawnow


hold on
plot(OptimumStepIndx*ones(2,1), [0 OptimumError], 'r');
xlabel(['Time Lapse: ' num2str(Tlapse) ' secs']);
%------------------------------------------------------------------
StopByUser = 0;
return

%------------------------------------------------------------------
%--------------- Best Set after Removals --------------------------
%------------------------------------------------------------------
function OptimumFeatureSet =FindOptFeatSet(OptimumFeatureSet,... 
                                                    PathOfFeatures)
                                       
for IndexStep=1:length(PathOfFeatures),
    if PathOfFeatures(IndexStep) < 0
      OptimumFeatureSet(-PathOfFeatures(IndexStep)) = 0;
    elseif PathOfFeatures(IndexStep) > 0
      OptimumFeatureSet(PathOfFeatures(IndexStep)) = ...
                                         PathOfFeatures(IndexStep);
    end
end

OptimumFeatureSet = OptimumFeatureSet(find(OptimumFeatureSet>0));
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


