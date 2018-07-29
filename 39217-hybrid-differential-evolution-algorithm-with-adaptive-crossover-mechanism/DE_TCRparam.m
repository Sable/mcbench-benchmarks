%% DE_TCRparam
% Generates the required parameters to run the DE_TCR optimization 
% algorithm.
%%
%% Beta version 
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
% Gilberto Reynoso-Meza
% gilreyme@upv.es
% http://cpoh.upv.es/en/gilberto-reynoso-meza.html
% http://www.mathworks.es/matlabcentral/fileexchange/authors/289050
%%
%% For new releases and bug fixing of this Tool Set please visit:
% 1) http://cpoh.upv.es/en/research/software.html
% 2) Matlab Central File Exchange
%%
%% Overall Description
% This code implements a version of the single-objective 
% optimization algorithm described at:
%
% G. Reynoso; J. Sanchis; X. Blasco; Juan M. Herrero. Hybrid DE Algorithm 
% With Adaptive Crossover Operator For Solving Real-World Numerical 
% Optimization Problems. In IEEE Congress on Evolutionary Computation. 
% CEC 2011. (ISBN 978-1-4244-7833-0). New Orleans (USA). June 2011.
% 
% It uses the defaut values as shown in the paper.
%
%%
%%
%
clear all
close all
clc
%
%%
%% Variables regarding the adaptive mechanism

DE_TCRDat.TF=[0.3 0.4 0.5];                  % Triangular distribution for
                                             % scaling factor.
                                             
DE_TCRDat.TCR=[0.2 0.5 1.0];                 % Triangular distribution for
                                             % crossover rate.
                                             
DE_TCRDat.Recomb=0.75;                       % Lineal recombination factor.

DE_TCRDat.CRsuccess=15;                      % Number of success to re-
                                             % calculate the triangular
                                             % distribution for crossover
                                             % rate
%
%%
%% Variables regarding the optimization problem

DE_TCRDat.NVAR   = 30;                       % Number of decision variables

DE_TCRDat.sop = str2func('CostFunction');    % Cost function

DE_TCRDat.CostProblem='Rastrigin';           % Cost function instance

DE_TCRDat.FieldD =[-5.12*ones(DE_TCRDat.NVAR,1)...
                    5.12*ones(DE_TCRDat.NVAR,1)]; % (Re)Initialization bounds
                
DE_TCRDat.Initial=[-5.12*ones(DE_TCRDat.NVAR,1)...
                    5.12*ones(DE_TCRDat.NVAR,1)]; % Optimization bounds  
%
%%
%% Variables regarding the local search routine

DE_TCRDat.RateLS=1-1/(100*DE_TCRDat.NVAR);   % Probability to run a Local
                                             % Search procedure in a given
                                             % Child
                                             
DE_TCRDat.sopLS = str2func('LocalSearch');   % Local Search Routine to use.
%
%%
%% Variables regarding Population Management 

DE_TCRDat.Xpop        =  5*DE_TCRDat.NVAR;   % Population Size

DE_TCRDat.XpopRefresh =  2*DE_TCRDat.NVAR;   % Refreshment Size

DE_TCRDat.GammaVar=3;                        % Interquartil difference 
                                             % threshold for population
                                             % refreshment.
                                             
DE_TCRDat.minVarPop   =  0.05*...            % Minimum IQR allowed.
 (DE_TCRDat.Initial(:,2)-...
  DE_TCRDat.Initial(:,1))';                    
%                                               
%%
%% Termination criteria
%
DE_TCRDat.MAXGEN =2e2*DE_TCRDat.NVAR;                      % Generations

DE_TCRDat.MAXFUNEVALS = 1e4*DE_TCRDat.NVAR;  % Function evaluations           
%
%%
%% Initialization (don't modify)
%
DE_TCRDat.CounterGEN=0;

DE_TCRDat.CounterFES=0;
%
%%
%% Put here the variables required by your code (if any).
%
%
%
%%
%% Records
%
DE_TCRDat.SaveResults='no';               % Write 'yes' if you want to 
                                           % save your results after the
                                           % optimization process;
                                           % otherwise, write 'no';
DE_TCRDat.Plotter='yes';                   % 'yes' if you want to see some
                                           % a graph at each generation.

DE_TCRDat.SeeProgress='yes';                % 'yes' if you want to see some
                                           % information at each generation.                                           
%
%%
%% Release and bug report:
%
% November 2012: Initial release