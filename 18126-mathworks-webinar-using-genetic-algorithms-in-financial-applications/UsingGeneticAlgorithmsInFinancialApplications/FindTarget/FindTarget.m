function [X,FVAL,exitflag,output] = FindTarget(target)
% Oren Rosen
% The MathWorks
% 8/29/2007
%
% USAGE: Enter in a target bit string of zeros and ones as a row vector
% in the input variable "target". Note that the success of the algorithm
% depends on the "crossover fraction" set in the ga options below.
% See the documentation for a description of this setting.
%
% The objective is to test out custom crossover and mutation functions for
% a GA routine. Each variable is a vector of zeros and ones. The crossover
% and mutation operators are written to preserve the number of ones
% exactly. They only produce children that automatically satisfy this
% constraint. The fitness function in this example measures the distance
% of the current input from a specified target vector, both defined below.
%
% See the mat file "PerformanceResults.mat" for results of testing this
% routine for a range of target sizes.

numVars = length(target);
numOnes = sum(target);

% Generate initial population
ipop = generateinitpop(numVars,numOnes);

% Start with default options
options = gaoptimset;

% Set population options
options = gaoptimset(options,'PopulationSize' ,numVars-numOnes+1 );
options = gaoptimset(options,'InitialPopulation' , ipop);

% Set reproduction options
options = gaoptimset(options,'CrossoverFraction' ,0.7 );
options = gaoptimset(options,'CrossoverFcn' ,@crossoverNcK);
options = gaoptimset(options,'MutationFcn' ,@mutationNcK);

% Set stopping options
options = gaoptimset(options,'FitnessLimit',0);

% Set dislay options
options = gaoptimset(options,'Display' ,'off');
options = gaoptimset(options,'PlotFcns' ,{  @gaplotbestf @gaplotbestindiv });


% Run GA
[X,FVAL,exitflag,output] = ga(@fitDist,numVars,[],[],[],[],[],[],[],options);

disp(' ');
if( X == target)
    disp('Target Found');
else
    disp('Target Not Found');
end
disp(['Total Function Evals: ',num2str(output.funccount)]);

    %% *** FITNESS FUNCTION ***
    % Fitness function is just the euclidean distance of x from target
    function err = fitDist(x)
        err = norm(x-target);
    end
end
