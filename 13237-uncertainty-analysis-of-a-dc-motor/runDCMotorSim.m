%% Helper scriprt for running the DC Motor Simulation
close all % figures
disp('Running Simulation ...')
tic
plotMotorSim([Voltage, Inertia],0,'Starting Simulation...');

% perform simulation
for i = 1:noRuns
    V = Voltage(i);     % input voltage         (V)
    Jd = Inertia(i);    % load inertia          (g-cm^2)
    sim('MaxonDCMotor.mdl',[0 20]);
    time{i} = tout;
    velocity{i} = vel;
    plotMotorSim([Voltage, Inertia],i,['Run ',num2str(i), ' of ',num2str(noRuns)])
end
clear NbBlocks blk m powerguiblock vel tout t s simData
plotMotorSim([Voltage, Inertia],i,'Finished Simulation')
toc
