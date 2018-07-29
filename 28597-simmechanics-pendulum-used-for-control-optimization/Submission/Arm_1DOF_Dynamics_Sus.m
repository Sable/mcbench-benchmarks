function a=Arm_1DOF_Dynamics(x)

a=zeros(size(x.states));
for jerry =1:length(x.nodes)
    theta_0=x.states(1,jerry); 
    omega_0=x.states(2,jerry); 
[t,State,Output]=sim('Arm_1DOF_1b',x.nodes(jerry)+[0;0.01;0.02],...
    simset('InitialState',[theta_0+180*pi/180, omega_0]),...
    [x.nodes(jerry)+[0;0.02],x.controls(jerry)+[0;0]]); 
a(:,jerry) = Output(1,:).';
end