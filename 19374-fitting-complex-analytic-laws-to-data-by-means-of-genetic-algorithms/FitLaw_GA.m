function [coeff,RMSout]=FitLaw_GA(X,y,fh,Int,LB,UB)
%
% function [coeff,RMSout]=FitLaw_GA(X,y,fh,Int,LB,UB)
%
% The script fits a given general analytical law using Genetic Algorithms.
% Such law can depend on several input variables and various parameters,
% but it must have only one output, to be matched to the input variable y.
% The optimum coefficients are derived using an optimization based on the
% Genetic Algorithm.
%
% INPUT
%   X = matrix containing the values of the indipendent variables of the
%       function. Each column refers to a variable
%   y = target values to be matched by the function (row vector)
%   fh = handle of the function to be fitted to y and whose parameters have
%        to be optimized
%   Int = initial interval of the parameters to be optmized. Column i of
%         the matrix refer to parameter i
%   LB,UB = vectors defining the lower and upper bounds never to be
%           exceeded by the parameters. Position i of the vectors refer to
%           parameter i.
%
% OUTPUT
%   coeff = parameters providing the best fitting
%   RMSout = lowest RMS of the fitting error
%
% EXAMPLE OF USAGE
%   Suppose one wants to fit to y the function p=x.*(1-exp(-a.*w+b.*z)),
%   where (x,w,z) are the indipendent variables and (a,b) are the
%   parameters to be determined. It is first necessary to define the handle
%   to the function p before calling the optimization function. This is
%   done as follows:
%
%      fh=@(X,par) X(:,1)'.*(1-exp(-par(1).*X(:,2)'+par(2).*X(:,3)'))
%
%   Afterwards, the callback of the function would be:
%
%   [coeff,RMSout]=FitLaw_GA([x' w' z'],y,fh,[-5 -5; 5 5],[-10 10],[10 10])
%
%   Note that since fh has been defined considering that each variable is
%   assigned to each column of the matrix X, then X in the callback has to
%   be in such form (as in the example). y is a row vector containing the
%   target values of the function to be fitted. [-5 -5; 5 5] defines the
%   initial intervals in which the parameters are sampled when the
%   algorithm starts. Specifically, column i of the matrix Int contains the
%   lower and upper limits for parameter i. However, as the algorithm
%   proceeds, the parameters may exceed such intervals. That is why lower
%   and upper bounds can be introduced to limit the acceptable values of
%   the parameters (in this example, both paramaters are such that
%   -10 < a,b < 10).
%   
%   To improve the fitting power, increase the variables PopSize and Iter
%   defined below in the cell GENETIC ALGORITHM OPTIONS. Specifically,
%   a high value of PopSize provides a higher probability to avoid local
%   minima in the optimization procedure, while a high value of Iter
%   permits a proper convergence of the algorithm.
%   Obviously, high values of those variables imply longer calculation
%   times.
%
% By: L.Luini

%% GENETIC ALGORITHM OPTIONS
PopSize=200;   % population size (default==200)
Iter=100;   % number of iterations of the algorithm (default==100)
MigrInt=Iter/10;   % migration interval
Fig=1;   % if Fig==1, plot optimization results

%% RUN THE GENETIC ALGORITHM
numPar=size(Int,2);
options=gaoptimset('PlotFcns',{@gaplotbestf,@gaplotbestindiv}, ...
    'PopInitRange',Int, ...
    'PopulationSize',PopSize,'MigrationInterval',MigrInt, ...
    'StallGenLimit',Inf,'StallTimeLimit',Inf,'Generations',Iter);
coeff=ga(@FitFcn,numPar,[],[],[],[],LB,UB,[],options);
est=fh(X,coeff);
error=100.*(est-y)./y;
RMSout=sqrt(mean(error).^2+std(error).^2);

% plot results if the function depends only on 1 variable
if Fig==1&&numPar==1
    figure
    plot(X,y,'b','LineWidth',1.5)
    hold on;grid on;
    plot(X,est,'r','LineWidth',1.5)
    legend('Input data','Fitting curve')
    grid
end

    function fitness=FitFcn(param)

        % Fitness function definition: RMS of the error        
        est=fh(X,param);
        error=100.*(est-y)./y;   % definition of the error
        fitness=sqrt(mean(error).^2+std(error).^2);
    end

end


