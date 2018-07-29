function [state,Energy,TotalEnergy1MCS,ColorMatrix] = InitializeMatricesQPOTTS(x,MonteCarloSteps,Q);

state=zeros(size(x,1),size(x,1));
Energy=zeros(size(x,1),size(x,1),MonteCarloSteps);
TotalEnergy1MCS=zeros(1,MonteCarloSteps);
ColorMatrix=rand(Q,3);