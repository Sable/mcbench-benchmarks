%------------------------------------------------------------------
%---------  Bayes Classifier with Gaussian pdf---------------------
%------------------------------------------------------------------

function [AverCorr, ConfMat, lowCL, upCL]=BayesClassMVGaussPDFs(...
Patterns, Targets, PercTest, ErrorEstMethod, NRepThres, ...
                             GammaParam, CritvalMax, ConfMatSwitch)

% INPUT
% CritvalMax: Current Best Criterion value
% OUTPUT
% AverCorr: Average CCR through repetitions

global HISTORYtable
[NPatterns, KFeatures] = size(Patterns);
CClasses               = max(Targets);

if (1-1/PercTest)*NPatterns/CClasses < KFeatures + 1
    AverCorr=1/CClasses;
    ConfMat = zeros(CClasses,CClasses);
    lowCL = 1/CClasses;
    upCL = 1/CClasses;
    HISTORYtable(end,3) = 0;
  return    
end


NBins      = floor(100/PercTest);  %# of bins for Cross-validation
GaussConst = (2*pi)^(-KFeatures/2); % Pre-estimation
CCRTable   = zeros(1, 2000);     % Pre-allocation (max # rep 2000)
Prior      = zeros(1,CClasses);
ConfMatAll = zeros(CClasses, CClasses);

if strcmp(ErrorEstMethod,'Resubstitution'),
    NRep = 1;
elseif strcmp(ErrorEstMethod, 'Standard') || ... % Cross-validation
       strcmp(ErrorEstMethod, 'ProposedA') 
    NRep = NRepThres;                      % Perform 10 repetition
    % and estimated if more are needed for the
    % specific GammaParam
elseif strcmp(ErrorEstMethod, 'ProposedAB')  % Cross-validation
    NRep = 10;        % Perform 10 repetitions
end

HISTORYtable(end,3) = NRep;
rep=0;
while rep  <  NRep,
 
    rep=rep+1;
    if strcmp(ErrorEstMethod,'ProposedAB') || ...% Cross-validation
       strcmp(ErrorEstMethod,'ProposedA') || ... % Divide Patterns 
       strcmp(ErrorEstMethod,'Standard'),      % as well as Targets
        IndexAll   = randperm(NPatterns); %into Train and Test sets 
        IndexTrain = IndexAll(...
                            (floor(NPatterns*PercTest/100)+1):end);
        TrainSetPatterns = Patterns(IndexTrain,:);
        TrainSetTargets  = Targets(IndexTrain);
        IndexTest      = IndexAll(1:floor(NPatterns*PercTest/100));
        TestSetPatterns  = Patterns(IndexTest,:);
        TestSetTargets   = Targets(IndexTest);
    elseif strcmp(ErrorEstMethod,'Resubstitution') % Resubstitution
        TrainSetPatterns = Patterns;      % Test and Train Sets are
        TrainSetTargets  = Targets;       % the whole set.
        TestSetPatterns  = Patterns;
        TestSetTargets   = Targets;
    end
   
    NTestPatterns  = size(TestSetPatterns,1);
    NTrainPatterns = size(TrainSetPatterns,1);
    % ------------- Pre-allocate ----------------------------------
    TargetsProbs   = zeros(NTestPatterns, CClasses);  
                            % the P(Omega|u) = P(u|\Omega)P(\Omega)

    CovDet = zeros(CClasses);                            
    MuV    = zeros(CClasses, KFeatures);
    CovMat = zeros(KFeatures, KFeatures, CClasses);
    CovInv = zeros(KFeatures, KFeatures, CClasses);

    for IndexClass = 1:CClasses
        TrainSetIndexPerClass= find(TrainSetTargets == IndexClass);
        TrainSetPatternPerClass = TrainSetPatterns( ...
                                         TrainSetIndexPerClass,: );
        
        
                                     
        if length(TrainSetIndexPerClass) > KFeatures + 1
        MuV(IndexClass,:)         = mean(TrainSetPatternPerClass);
        CovMat(:,:,IndexClass)    = cov(TrainSetPatternPerClass);
        CovDet(IndexClass)        = det(CovMat(:,:,IndexClass));
        else
           CovDet(IndexClass)        = 0;
        end
        
        if CovDet(IndexClass)    ~= 0
            CovInv(:,:,IndexClass)= inv(CovMat(:,:,IndexClass));
            %[CovInv(:,:,IndexClass), CovDet(IndexClass)] =...
            %                       InvDet(CovMat(:,:,IndexClass));

            %NTestPatternsPerClass=sum(TestSetTargets==IndexClass);
            %Prior(IndexClass)  = 1/CClasses; % all equiprobable
            %Prior(IndexClass) = ...  
            %  NTestPatternsPerClass/length(TestSetTargets);
            Prior(IndexClass)= length(TrainSetIndexPerClass) ...
                                                  / NTrainPatterns;
            ClassConst = GaussConst* Prior(IndexClass)* ...
                                         CovDet(IndexClass)^(-0.5);
            % Fastest way to estim. Probs is with Matrix operations                         
            DistMeanVectorTest = TestSetPatterns - ...
                repmat( MuV(IndexClass,:), NTestPatterns, 1);
            A = DistMeanVectorTest * CovInv(:,:,IndexClass);
            G = sum(A.*DistMeanVectorTest,2);
            TargetsProbs(1:NTestPatterns, IndexClass)= ...
                                          ClassConst * exp(-0.5*G);
        else % The case of singular covariance matrix is 
             % treated with random classification.
            TargetsProbs(1:NTestPatterns, IndexClass) = eps* ...
                                             rand(NTestPatterns,1);
        end
    end
    
    
    [TargetMaxProb, TargetPrediction] = max(TargetsProbs, [], 2);
    CorrClassified= length(find(...
                         TargetPrediction - TestSetTargets == 0));
    CCRTable(rep)                  = CorrClassified/ NTestPatterns;

    %-----------Handle Confusion Matrix ---------------------------
    ConfMatRep = zeros(CClasses,CClasses); % ConfMatix of a single 
                                           % Repetition 
    if ConfMatSwitch ==1 % Switch to estimate or not
        [ConfMatRep] = ConfMatEstimation(CClasses, ...
                                 TestSetTargets, TargetPrediction);
        ConfMatAll = ConfMatAll + ConfMatRep/NTestPatterns; % For 
                                                  % all Repetitions
    end
    % ----- Estimate ConfLimits due to Ensemble variation ---------
    if rep == 10 && ( strcmp(ErrorEstMethod, 'ProposedAB') || ...
                      strcmp(ErrorEstMethod, 'ProposedA'))
        MCCR = mean(CCRTable(1:rep));   % Proposed hypergeometric
        VCCR = (NBins-1)/(NPatterns-1)*MCCR*(1-MCCR); % model 
        CLDist =  1.96 * sqrt(VCCR/ rep);
    elseif (rep == NRepThres) & ...
                          (strcmp(ErrorEstMethod, 'Standard'))
        VCCR = var(CCRTable(1:rep));     %Standard, variance method
        CLDist =  1.96 * sqrt(VCCR/ rep);
    end
    %---------------- Improvement A. ------------------------------
    % Reject potentially bad features from a small number of 
    % cross-validation repetitions
    if (strcmp(ErrorEstMethod,'ProposedA') || ...
         strcmp(ErrorEstMethod,'ProposedAB')) ...
           && CritvalMax >0 && rep==10 % Reject from 10 repetitions
        MCCR10 = mean(CCRTable(1:rep));
        VCCR10 = (NBins-1)/ (NPatterns-1) * MCCR10*(1-MCCR10);
        Stat = (MCCR10 - CritvalMax)/(VCCR10/ sqrt(10));
        if Stat < -1.96
            HISTORYtable(end,3) = rep;
            AverCorr = MCCR10;
            ConfMatClass = ConfMatAll/rep;
            ConfMat = ConfMatClass*CClasses;
            lowCL = nan;
            upCL =  nan;
            return
        end
    end
    
    % ------------------ Improvement B.---------------------------
    % Estimate Crossval Repetitions from MCV10 and MCVb, rep>10. 
    if strcmp(ErrorEstMethod,'ProposedAB') && rep>=10, % Update 
                                            % number of Repetitions
        MCCR10up = mean(CCRTable(1:rep));
        NRep = floor( 4*1.96^2/ GammaParam^2*...
            (NBins-1)/(NPatterns-1)*MCCR10up*(1-MCCR10up) );
        HISTORYtable(end,3) = NRep;
    end
    % ------------------ Re-substitution --------------------------
    % CCR limits due to ensemblying can not be found
    if strcmp(ErrorEstMethod,'Resubstitution')
        VCCR = 0;
    end
end                 % repetetion

AverCorr     = sum(CCRTable(1:NRep))/NRep;
ConfMatClass = ConfMatAll/NRep;
ConfMat      = ConfMatClass*CClasses;
CLDist       =  1.96 * sqrt(  VCCR /  NRep);
lowCL        = AverCorr - CLDist;
upCL         = AverCorr + CLDist;
% The lines do not sum to 1 because the stimulus per Class is not 
% NTestPatterns / C. If you want the lines to sum to 1 uncomment 
% the following lines
% ConfMat = ConfMat ./ repmat(sum(ConfMat')', 1, CClasses)
% ConfMat = floor(ConfMat*10000)/100;
return

%------------------------------------------------------------------
%------------     Confusion Matrix Estimation     -----------------
%------------------------------------------------------------------
function [ConfMatRep]  = ConfMatEstimation(CClasses, ...
                               TestSetTargets, TargetPrediction)
 
 ConfMatRep = zeros(CClasses,CClasses);
 for IndexClassesStimulus = 1:CClasses
     IndexTargetsCClasses = find(TestSetTargets == ...
                                             IndexClassesStimulus);
     if (isempty(IndexTargetsCClasses))
         ConfMatRep(IndexClassesStimulus,:) = zeros(1, CClasses);
     else
         for IndexClassesResponse = 1:CClasses
             ConfMatRep(IndexClassesStimulus, ...
                 IndexClassesResponse) = length(find(...
                 TargetPrediction(IndexTargetsCClasses)==...
                                            IndexClassesResponse));
         end
     end
 end
return