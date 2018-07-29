riseTime = zeros(mcSamples,1);
ssVelocity = riseTime;

disp('Running MonteCarlo Simulation ...')
tic
hwb = waitbar(0,'Starting Simulation...');
for i = 1:mcSamples
    Ra = mcRa(i);
    La = mcLa(i);
    Kt = mcKt(i);
    Kemf = mcKemf(i);
    sim('MaxonDCMotor.mdl');
    waitbar(i/mcSamples,hwb,['Run ',num2str(i), ' of ',num2str(mcSamples)])
    s = stepinfo(vel,tout);
    riseTime(i) = s.RiseTime;
    ssVelocity(i) = s.Peak;
    clear s
end
close(hwb)
toc
clear NbBlocks blk m powerguiblock pos_vel V Jd tout Ra La Kt Kemf b J hwb