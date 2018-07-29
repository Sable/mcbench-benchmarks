run InitialThings_3D_QPOTTS
% rand('state', 0.2);
[NoLatticePoints,Q,MonteCarloSteps,PrintToJPEG] = Procure_Input_Values_3D_QPOTTS();
[x,y,z,Energy,TotalEnergy1MCS,ColorMatrix] = InitializeMatrices_3D_QPOTTS(NoLatticePoints,Q,MonteCarloSteps);
[x,y,z] = MakeSquareLattice_3D_QPOTTS(NoLatticePoints);
state = AssignRandomInitialStateMatrix_3D_QPOTTS(x,Q);
display('Simulation has started');tic
for mcs=1:MonteCarloSteps
    run DisplayCurrentMcs_3D_QPOTTS
    for n=1:(NoLatticePoints^3)
        [i,j,k] = PickRandomLatticeSite_3D_QPOTTS(x,y,z);
        caseis = EdgeBoundaryWrap_3D_QPOTTS(i,j,k,x,y,z);
        IESM = IndexElementStateMatrix_3D_QPOTTS(x,caseis,state,i,j,k);
        [E1,IESM_NewSpin,E2,DelE] = EnergyChange_3D_QPOTTS(IESM,Q);
        if DelE < 0 || DelE == 0;
            state(i,j,k)=IESM_NewSpin(2,2,2);
            Energy(i,j,k)=E2;
        else
            Energy(i,j,k)=E1;
        end
        if mod(0.05*n,NoLatticePoints^3)==0
            fprintf('... . . %d completed',n*100/NoLatticePoints^3)
        end
    end
    fprintf('Status:  [mcs / MCS, %% Comp, Q, N] = [(%d / %d), %2.4f%%, %d, %d]\n',mcs,MonteCarloSteps,mcs*100/MonteCarloSteps,Q,NoLatticePoints);
    run PlotMicrostructure_3D_QPOTTS,%pause(0.001)
end,toc,display('- - - - - - 0 - - - - - -')
run ClearVariables
% Coded by Sunil Anandatheertha
% Used in a project at PESIT where I worked as a Junior Research Fellow 
% under Dr. K T Kashyap of Department of Mechanical Engineering, PESIT.