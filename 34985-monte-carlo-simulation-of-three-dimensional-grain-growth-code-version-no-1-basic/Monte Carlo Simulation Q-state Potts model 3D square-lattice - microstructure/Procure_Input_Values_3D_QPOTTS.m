function [NoLatticePoints,Q,MonteCarloSteps,PrintToJPEG]=Procure_Input_Values_3D_QPOTTS()

NoLatticePoints=input('Lattice size. [Defaults to 25] = >> ');
if isempty(NoLatticePoints)
    NoLatticePoints = 25;
end

Q=input('No. of State (Q) [Defaults to 64] = >> ');
if isempty(Q)
    Q = 64;
end

MonteCarloSteps=input('No. of Monte-Carlo Steps [Defaults to 100] = >> ');
if isempty(MonteCarloSteps)
    MonteCarloSteps = 100;
end

PrintToJPEG=input('PrintToJPEG ??  [ 0 | 1 ] (Default: 0) = >> ');
if isempty(PrintToJPEG)
    PrintToJPEG = 0;
end

% Trials=input('Number of simulations [defaults to 1] = >> ');
% if isempty(Trials)
%     Trials = 1;
% end