% DeltaRule - Trains a single neuron via incremental delta rule
%
% by Will Dwinnell
%
% Last modified: Feb-15-2010
%
% B = DeltaRuleBatchTrain(X,Y,LearningRate,MaximumPasses,MinimumWeightChange,B0)
%
% B                    = Discovered coefficients
%
% X                    = Predictors (exemplars in rows, variables in columns)
% Y                    = Target variable (0/1 values)
% LearningRate         = Learning rate                             (try 0.05)
% MinimumWeightChange  = Minimum change in weight norm to continue (try 0.01)
% MaximumPasses        = Maximum number of training passes         (try 50)
% B0                   = Initial guess for coefficients (optional, NaN for none)
%
% Note: Requires 'Logistic" routine.
%
% Example:
% 
% % Generate some random data
% X = randn(2500,4);
% Y = double( (X(:,1) < 0.1) & (X(:,2) > 0.2) );
%
% % Train single neuron model using delta rule
% B = DeltaRule(X,Y,0.05,0.01,50);
%
% % Recall using discovered model
% Z = Logistic(B(1) + X * B(2:end));
%
% % Measure resubstitution accuracy
% mean(Y == (Z > 0.5))

% Developer's Notes:
%
% Possible enhancement: Add either of these learning rate schedules:
%
% % Rectangular hyperbola (reciprocal function)
% LearningRate = InitialLearningRate / Pass;  
%
% or...
%
% % Converges to 1/2 of InitialLearningRate
% LearningRate = InitialLearningRate / ((1 + (Pass / MaximumPasses));

function B = DeltaRule(X,Y,LearningRate,MinimumWeightChange,MaximumPasses,B0)

% Determine size of training data
[n m] = size(X);

% Initialize coefficient vector at the origin, if needed
if ( (nargin < 6) || (isnan(B0(1))) )
    B = 0.01 * randn(m+1,1);
else
    B = B0;
end;

% Initialize pass counter and trigger
Pass = 1;
OldB = B + 1e10;

% Loop over epochs or until search slows
while ( (Pass <= MaximumPasses) && (norm(B - OldB) >= MinimumWeightChange) )
    % Save weights at beginning of epoch
    OldB = B;
    
    % Randomize the order of exemplar presentation
    R = randperm(n);
    
    % Loop over exemplars
    for Exemplar = 1:n
        % Select exemplars in shuffled order
        ShuffledExemplar = R(Exemplar);
        
        % Fire model for current exemplar
        ModelOutput = Logistic(B(1) + X(ShuffledExemplar,:) * B(2:end));
        
        % Update model coefficients
        B = B + LearningRate * (Y(ShuffledExemplar) - ModelOutput) * [1 X(ShuffledExemplar,:)]';
    end
        
    % Increment pass counter
    Pass = Pass + 1;
end



% EOF


