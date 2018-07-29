% Author: Housam Binous

% Dynamic and control of a tank using the genetic algorithm toolbox

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

function [X,FVAL,REASON,OUTPUT,POPULATION,SCORES] =  binousga2
%%   This is an auto generated M file to do optimization with the Genetic Algorithm and
%    Direct Search Toolbox. Use GAOPTIMSET for default GA options structure.

global t1 h sys X

%%Fitness function
fitnessFunction = @obj2;
%%Number of Variables
nvars = 3 ;
%Start with default options
options = gaoptimset;
%%Modify some parameters
options = gaoptimset(options,'PopInitRange' ,[0  0  0 ;5  2  5]);
options = gaoptimset(options,'SelectionFcn' ,@selectionuniform);
options = gaoptimset(options,'MutationFcn' ,{ @mutationuniform 0.21 });
options = gaoptimset(options,'Display' ,'off');
%%Run GA
[X,FVAL,REASON,OUTPUT,POPULATION,SCORES] = ga(fitnessFunction,nvars,options);
