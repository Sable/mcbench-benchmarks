%------------------------------------------------------------------
%---------  Bayes Classifier with Gaussian pdf---------------------
%------------------------------------------------------------------

function TargetsProbs = BayesClassValidationSet(...
    TrainSetPatterns, TrainSetTargets, TestSetPatterns)

[NPatternsToTrain, KFeatures] = size(TrainSetPatterns);
CClasses                      = max(TrainSetTargets);

GaussConst = (2*pi)^(-KFeatures/2); % Pre-estimation
Prior      = zeros(1,CClasses);

NTestPatterns  = size(TestSetPatterns,1);
% ------------- Pre-allocate --------------------------------------
TargetsProbs   = zeros(NTestPatterns, CClasses);
% the P(Omega|u) = P(u|\Omega)P(\Omega)

MuV    = zeros(CClasses, KFeatures);
CovMat = zeros(KFeatures, KFeatures, CClasses);
CovDet = zeros(CClasses);
CovInv = zeros(KFeatures, KFeatures, CClasses);
%------------------------------------------------------------------

for IndexClass = 1:CClasses
    TrainSetIndexPerClass= find(TrainSetTargets == IndexClass);
    TrainSetPatternPerClass = TrainSetPatterns( ...
                                       TrainSetIndexPerClass,: );
    MuV(IndexClass,:)         = mean(TrainSetPatternPerClass);
    CovMat(:,:,IndexClass)    = cov(TrainSetPatternPerClass);
    CovDet(IndexClass)        = det(CovMat(:,:,IndexClass));
    if CovDet(IndexClass)    ~= 0
        CovInv(:,:,IndexClass)= inv(CovMat(:,:,IndexClass));
%        Prior(IndexClass)= length(TrainSetIndexPerClass) ...
%                                                 / NTrainPatterns;
        Prior(IndexClass) = 1/CClasses;   % In Test Set no Info
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
