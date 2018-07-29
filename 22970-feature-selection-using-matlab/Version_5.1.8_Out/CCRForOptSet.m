%--------------------------------------------------------------------------
%----------------------  Validation of the result -------------------------
%--------------------------------------------------------------------------

% With this function you can re-estimated the CCR for the optimal Feature
% Subset found by a Feature Selection method



 function [ResultMat, UpLimitCOD,  LowLimitCOD] = ...
                    CCRForOptSet(ResultMat, DatasetToUse, ErrorEstMethod) 
 format short g
 axis([0 length(ResultMat(:,1)) 0 1])
 axis manual 
%----------- Feed from Feature Selection method----------------------------
%Cross-val
%PoolSelectFeat = [18;19;45;14;28;40;6;90;11;68;84;22;69;2;44;70;25;7;65;1;5;4;8;57;9;21;13;10;29;3;53;20;27;15;47;23;16;33;26;30;35;89;24;82;31;59;62;79;32;50;34;36;51;55;60;37;72;43;12;38;17;58;39;41;86;67;42;46;48;49;52;54;56;64;88;61;66;63;75;71;85;73;74;76;80;77;78;81;87;83;];
%Resub
PoolSelectFeat =ResultMat(:,3);
%--------------------------------------------------------------------------
 
 if strcmp(DatasetToUse, 'finalvecDESsubset')
     [Patterns, Targets] = Preprocessing('finalvecDES');
     Patterns = Patterns(1:360,:);
     Targets  = Targets(1:360);
 elseif strcmp(DatasetToUse, 'finalvecSUSASsubset')
     [Patterns, Targets] = Preprocessing('finalvecSUSAS');
     rand('twister',260); % To have always the same set
     IndexSubset = randperm(length(Targets));
     IndexSubset = IndexSubset(1:end);
     Patterns = Patterns(IndexSubset,:);
     Targets  = Targets(IndexSubset);
     size(Patterns)
 else
     [Patterns, Targets] = Preprocessing(DatasetToUse);
 end
 
[NPatterns, KFeatures] = size(Patterns);
CClasses = max(Targets);
%  ------------------------- sffs settings -------------
PercTest             = 10;             % Percentage of data to use for testing. Options 5,...,50. 
GammaParam = 0;                        % confidence interval to control number of repetitions. 
                                       % Options:0<GammaParam <1. The lowest, the better.  

if strcmp(ErrorEstMethod,'ProposedAB')
    NRepThres = [];                   % Only for programming. Do not change. 
elseif strcmp(ErrorEstMethod,'ProposedA') || strcmp(ErrorEstMethod,'Standard')
   NRepThres = 1;                  % Number of repetitions for the standard SFFS. Options: >10,
                                               % The greater, the better.  
   GammaParam = [];                          % Only for programming. Do not change.
elseif strcmp(ErrorEstMethod,'Resubstitution')             
    NRepThres  =1;
end
  

ResultMat           = [];          		        	     % Result matrix with selection history.

for FeatIndx = 1:length(PoolSelectFeat)
    ResultMat(end+1,1)  = FeatIndx;
    ResultMat(end,2) = PoolSelectFeat(FeatIndx);

    [Critval(FeatIndx)] = EnsembCriterEval(...
                               Patterns(:,PoolSelectFeat(1:FeatIndx)), ...
                                        Targets, PercTest, ErrorEstMethod);

    ResultMat(end,4) = 1;
    ResultMat(end,3) = Critval(FeatIndx);


    NDc = NPatterns/CClasses;

    [InfoLossResub]   = CalcInfoLoss(FeatIndx, floor(NDc), 1);
    [InfoLossCross]   = CalcInfoLoss(FeatIndx, floor(NDc), 0);
    AverInfoLoss      = (InfoLossCross + InfoLossResub)/2;

    CCR                   = ResultMat(end,3);
    UpLimitCOD(FeatIndx)  = CCR  + AverInfoLoss*(1-CCR);
    LowLimitCOD(FeatIndx) = CCR  - AverInfoLoss*(CCR-1/CClasses);

    hold on
    plot(ResultMat(1:end,3))
    plot(   UpLimitCOD, 'g.-')
    plot(   LowLimitCOD, 'r.-')

    drawnow
end
         
return

%--------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------
% -------------------------------  Criterion evaluation method ---------------------------------------
%--------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------

function [AverCorr] = EnsembCriterEval(Patterns, Targets, PercTest,...
               ErrorEstMethod)

NPatterns = size(Patterns,1);
Kfeatures = size(Patterns,2);
CClasses  = max(Targets);

GaussConst = (2*pi)^(-Kfeatures/2);

CCRTable = zeros(1, 2000);
Prior         = zeros(1,CClasses);
NRep = 500;
 
rep=0;
while rep  <  NRep,
        rep=rep+1; 
        if strcmp(ErrorEstMethod,'ProposedAB') || strcmp(ErrorEstMethod,'ProposedA') ...
                || strcmp(ErrorEstMethod,'Standard'),
           IndexAll  = randperm(NPatterns);
           IndexTrain = IndexAll((floor(NPatterns*PercTest/100)+1):end);
           TrainSetPatterns = Patterns(IndexTrain,:);
           TrainSetTargets = Targets(IndexTrain);
           IndexTest = IndexAll(1:floor(NPatterns*PercTest/100));
           TestSetPatterns   = Patterns(IndexTest,:);
           TestSetTargets = Targets(IndexTest);
        elseif strcmp(ErrorEstMethod,'Resubstitution')
            TrainSetPatterns = Patterns;
            TrainSetTargets = Targets;
            TestSetPatterns = Patterns;
            TestSetTargets = Targets;
        end

           NTestPatterns = size(TestSetPatterns,1);    
           NTrainPatterns = size(TrainSetPatterns,1);    
           TargetsProbs = zeros(NTestPatterns, CClasses);
           
            for IndexClass = 1:CClasses
                    TrainSetIndexPerClass = find(TrainSetTargets == IndexClass);
                    TrainSetPatternPerClass = TrainSetPatterns(TrainSetIndexPerClass,: );
                    ResCl.mean(IndexClass,:)         = mean(TrainSetPatternPerClass);
                    ResCl.cov(:,:,IndexClass)         = cov(TrainSetPatternPerClass);
                    ResCl.covDet(IndexClass)        = det(ResCl.cov(:,:,IndexClass));                                                                                       
                    if ResCl.covDet(IndexClass) ~= 0
                       ResCl.covInv(:,:,IndexClass)     = inv(ResCl.cov(:,:,IndexClass));
%                    [ResCl.covInv(:,:,IndexClass), ResCl.covDet(IndexClass)] =...
   %                                                                               InvDet(ResCl.cov(:,:,IndexClass));
%                        NTestPatternsPerClass  =  sum(TestSetTargets == IndexClass);
%                       Prior(IndexClass) = NTestPatternsPerClass /length(TestSetTargets);
                          Prior(IndexClass)  = length(TrainSetIndexPerClass) / NTrainPatterns;
%                              Prior(IndexClass)  = 1/CClasses; % all equiprobable
                          ResCl.prior(IndexClass) = Prior(IndexClass);
                          ClassConst = GaussConst * ResCl.prior(IndexClass)*ResCl.covDet(IndexClass)^(-0.5);
                          DistMeanVectorTest = TestSetPatterns - ...
                                                                   repmat( ResCl.mean(IndexClass,:), NTestPatterns,1); 
                          A = DistMeanVectorTest * ResCl.covInv(:,:,IndexClass);
                          G = sum(A.*DistMeanVectorTest,2);
                          TargetsProbs(1:NTestPatterns, IndexClass) = ClassConst * exp(-0.5*G);
                    else
                       TargetsProbs(1:NTestPatterns, IndexClass) = eps*rand(NTestPatterns,1);
                    end
            end
 
           [TargetMaxProb, TargetPrediction] = max(TargetsProbs');
           TargetPrediction = TargetPrediction';
           CorrClassified = length(find(TargetPrediction - TestSetTargets == 0));
           CCRTable(rep) = CorrClassified/ NTestPatterns;
            
 end                 % repetetion 
AverCorr = sum(CCRTable(1:NRep))/NRep;
return