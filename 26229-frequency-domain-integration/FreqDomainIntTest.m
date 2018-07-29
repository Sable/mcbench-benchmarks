%Frequency Domain Integration Test
%

%Generate chirp (Down-up linear frequency sweep')
dt=512/25000;
fDop0=1000;
nrecs=10000;
tt=[-nrecs/2:nrecs/2-1]*dt;
a= 2*pi*fDop0/tt(1);
phase=a*tt.^2/2;                     %Pure symmetric quadratic phase
fDop =a*tt/(2*pi);                   %Associated linear rate of change

phase_meas=FrequencyDomainIntegrator(fDop,tt);

figure
subplot(2,1,1)
plot(tt,phase-phase(nrecs/2),'r')
ylabel('True Phase--rad')
grid on
subplot(2,1,2)
plot(tt,(phase_meas-phase_meas(nrecs/2))-(phase-phase(nrecs/2)),'r')
ylabel('Phase Error--rad')
xlabel('time--sec')
grid on

