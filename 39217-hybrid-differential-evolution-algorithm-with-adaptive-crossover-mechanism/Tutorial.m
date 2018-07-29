%% Hybrid Differential Evolution Algorithm With Adaptive Crossover Mechanism (DE_TCR) - Beta version -
%% 
% Copyright 2006 - 2012 - CPOH  
%
% Predictive Control and Heuristic Optimization Research Group
%      http://cpoh.upv.es
%
% ai2 Institute
%      http://www.ai2.upv.es
%
% Universitat Politècnica de València - Spain.
%      http://www.upv.es
%
%%
%% Author
% Gilberto Reynoso-Meza - (gilreyme@upv.es)
%
% http://cpoh.upv.es/en/gilberto-reynoso-meza.html
%
%%
%% For new releases and bug fixing of this Tool Set please visit:
%
% 1) http://cpoh.upv.es/en/research/software.html
%
% 2) Matlab Central File Exchange
%
%%
%% Tutorial Description
%
% In this tutorial, a basic problem is solved using the DE_TCR algorithm, 
% which is a version of the single objective evolutionary algorithm 
% described in:
%
% *G. Reynoso; J. Sanchis; X. Blasco; Juan M. Herrero.* _Hybrid DE Algorithm 
% With Adaptive Crossover Operator For Solving Real-World Numerical 
% Optimization Problems._ In IEEE Congress on Evolutionary Computation. 
% CEC 2011. (ISBN 978-1-4244-7833-0). New Orleans (USA). June 2011.
% 
% It uses the defaut values as shown in the paper.
% 
% Basic features of the algorithm are:
%
% # It uses a population management mechanims to improve exploration.
% # It has an adaptive mechanism for crossover rate.
% # It uses a local search routine to improve convergence.
%
%% 
%% Scripts and functions listing
% # RunTutorial.m  - Runs the tutorial.
% # Tutorial.m     - The Tutorial script.
% # DE_TCRparam.m  - Script to built the struct required for the
% optimization.
% # DE_TCR.m       - The optimization algorithm.
% # LocalSearch.m  - The Local Search subroutine.
% # CostFunction.m - Cost function definition.
%
%%
%% Basic Example
%
% Run the DE_TCRparam file to build the variable "De_TCRDat" with the
% variables required for the optimization.

DE_TCRparam;

DE_TCRDat

%%
% All of them are self-explainend in the DE_TCRparam.m script.
%
% The problem to solve is a known benchmark problem (Rastrigin). Now, run 
% the algorithm:

OUT=DE_TCR(DE_TCRDat)

disp('Minimum found at:')
disp(['J = ' min(num2str(OUT.JxPopParent))]);

%% Release and bug report:
%
% November 2012: Initial release