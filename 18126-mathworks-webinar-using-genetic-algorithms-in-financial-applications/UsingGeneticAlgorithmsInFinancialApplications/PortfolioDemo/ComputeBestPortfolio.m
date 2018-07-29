function [portStd, portRet, portWts, portIndx] = ComputeBestPortfolio(expRet,expCov,portSize,targetRet)
% Oren Rosen
% The MathWorks
% 8/29/2007
%
% Use Genetic Algorithm to pick a subset of stocks out of a given
% universe.


% Generate initial population for GA
univSize = length(expRet);
iPop = generateinitpop(univSize,portSize);

% Start with default options
options = gaoptimset;

% Set population options
options = gaoptimset(options,'PopulationSize' ,univSize-portSize+1 );
options = gaoptimset(options,'InitialPopulation' , iPop);

% Set evolution options
options = gaoptimset(options,'CrossoverFraction' ,0.9 );
options = gaoptimset(options,'CrossoverFcn' ,@crossoverNcK);
options = gaoptimset(options,'MutationFcn' ,@mutationNcK);

% Set diaplay options
options = gaoptimset(options,'Display' ,'off');
%options = gaoptimset(options,'PlotFcns' ,{  @gaplotbestf @gaplotbestindiv });

% Run GA
[portBits,fval,gaExit] = ga(@rankport,univSize,[],[],[],[],[],[],[],options);

% Output of GA is logical vector of the best equities to
% include in the portfolio. Use this data to run quadprog
% one more time to insure that we get the correct weights.
portBits = logical(portBits);
subCov = expCov(portBits,portBits);
subRet = expRet(portBits);
%[portStd, portRet, portWts] = portopt(subRet, subCov,[], targetRet);
[subWts,subVar,mvExit] = minvar(subCov,subRet,targetRet);
portRet = subWts'*subRet;
portStd = sqrt(subVar);

% Extract tickers for best portfolio
indices = 1:univSize;
portIndx = indices(portBits);
portWts = zeros(univSize,1);
portWts(portIndx) = subWts;

    % *****************************************************************%
    % Fitness function for GA
    function risk = rankport(x)
        x = logical(x);
        subCov = expCov(x,x);
        subRet = expRet(x);
        
        [weights,fval,mvExit] = minvar(subCov,subRet,targetRet);
        
        % If the optimization routine in minvar failed,
        % set risk to high level.
        if( mvExit == 1 )
            risk = sqrt(fval);
        else
            risk = 1;
        end
    end
    % *****************************************************************%
end
