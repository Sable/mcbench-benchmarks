function [nlp,MonteCarloSteps,Q,Trials,PrintToJPEG]=Procure_Input_Values()

nlp=input('Lattice size. [Defaults to 30] = >> ');
if isempty(nlp)
    nlp = 30;
end
nlp=nlp-1;

Q=input('No. of State (Q) [Defaults to 32] = >> ');
if isempty(Q)
    Q = 32;
end

MonteCarloSteps=input('No. of Monte-Carlo Steps [Defaults to 100] = >> ');
if isempty(MonteCarloSteps)
    MonteCarloSteps = 100;
end

Trials=input('Number of simulations [defaults to 1] = >> ');
if isempty(Trials)
    Trials = 1;
end

PrintToJPEG=input('PrintToJPEG ??  [ 0 | 1 ] (Default: 0) = >> ');
if isempty(PrintToJPEG)
    PrintToJPEG = 0;
end

% PlotType = input('Patch plot = 1, Grain Boundary site plot = 2, Grain Boundary plot = 3, All = 4. [Defaults to 2]. Needed plot type = >> ');
% if isempty(PlotType)
%     PlotType= 2;
% end
% 
% if PlotType == 1 | 2 | 3
%     NoOfFigures = input('NoOfFiguresInPatch Defaults to 25] ( range = [1,99] ) = >> ');
%     if isempty(NoOfFigures)
%         NoOfFigures = 25;
%     end
% end