function [x,y,state,Energy,TotalEnergy1MCS,ColorMatrix]=FirstThingsFirst(nlp,MonteCarloSteps,Q)


display('PLease wait. Simulation is in progress.');pause(0.5)
[x,y] = MakeSquare2DLatticeQPOTTS(nlp);
[state,Energy,TotalEnergy1MCS,ColorMatrix] = InitializeMatricesQPOTTS(x,MonteCarloSteps,Q);
state = AssignRandomInitialStateMatrixQPOTTS(x,Q);