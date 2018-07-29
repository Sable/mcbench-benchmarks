% This program is adapted from the DIDO brachistochrone example 

Starts=10:10:180;
for jill=1:length(Starts)
for Inv=[1,-1]
    disp([Starts(jill),Inv])
%===================
% Problem variables:
%-------------------
% states = theta, theta_dot
% controls = u, torque applied
%===================
%---------------------------------------
% bounds the state and control variables
%---------------------------------------
ThetaL = -360*pi/180; ThetaU = 360*pi/180;
OmegaL = -500*pi/180; OmegaU = 500*pi/180; %3x's angle seems good
bounds.lower.states = [ThetaL; OmegaL];
bounds.upper.states = [ThetaU; OmegaU];
bounds.lower.controls = -7;
bounds.upper.controls =  7;
%------------------
% bound the horizon
%------------------
t0 = 0;
tfMax = 1; 
bounds.lower.time = [t0; t0];
bounds.upper.time = [t0; tfMax]; 
% Fixed time at t0 and a possibly free time at tf
%-------------------------------------------
% Set up the bounds on the endpoint function
%-------------------------------------------
% See events file for definition of events function
bounds.lower.events = [Starts(jill)*pi/180; 0; 0; 0];
bounds.upper.events = bounds.lower.events; 
% equality event function bounds
%============================================
% Define the problem using DIDO expresssions:
%============================================
Arm_1Dof.cost = 'Arm_1DOF_MinEnergy_Cost';
if Inv==1
Arm_1Dof.dynamics = 'Arm_1DOF_Dynamics_Sus';
else
Arm_1Dof.dynamics = 'Arm_1DOF_Dynamics_Inv';
end
Arm_1Dof.events = 'Arm_1DOF_FixedFinal';
%Path file not required for this problem formulation;
% Path files are used to establish constraints during the motion
Arm_1Dof.bounds = bounds;
%====================================================
algorithm.nodes = 36; % represents some measure of desired solution accuracy

% Compose initial guess to aid in computuation
[Results,u_star,t]=Arm_1DOF_LinearQuadRegulator_Fun(Starts(jill),Inv,0.0855038,0.495);
algorithm.guess.states = Results.';
algorithm.guess.controls =u_star(:).';
algorithm.guess.time = t(:).';

% Call dido
tic
% Make sure and initialize DIDO prior to calling dido
[cost, primal, dual] = dido(Arm_1Dof, algorithm);
RunTime=toc;
if Inv==1
Name=['Results_20100204\SimMechanicsImport_Sus' num2str(Starts(jill),'%03g')];
else
Name=['Results_20100204\SimMechanicsImport_Inv' num2str(Starts(jill),'%03g')];
end
save(Name, 'cost', 'primal', 'dual', 'Starts', 'jill', 'Inv', 'RunTime');
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Theta = primal.states(1,:);
Omega = primal.states(2,:);
Tau = primal.controls(1,:);
t = primal.nodes;
%% =============================================
figure(301); plot(t, Theta, '-o', t, Omega, '-x',t,Tau,'-s');
title('Pendulium results')
xlabel('time');
ylabel('states');
legend('\theta', 'omega','\tau');
%----------------------------------------------
figure(302); plot(t, dual.Hamiltonian);
title('Brachistochrone Hamiltonian Evolution');
legend('H');
xlabel('time');
ylabel('Hamiltonian Value');
%----------------------------------------------
figure(303); plot(t, dual.dynamics);
title('Brachistochrone Costates: Brac 1')
xlabel('time');
ylabel('costates');
legend('\lambda_\theta', '\lambda_\omega');
%==============================================

[Time_primal,State_primal,Output_primal]=sim('Arm_1DOF_1b',t,...
    simset('InitialState',bounds.lower.events(1:2)+[180*(Inv+1)/2;0]*pi/180),...
    [t(:),Tau(:)]); 
figure(311); plot(t, Theta, 'b-x', t, Omega, 'r-x', t, Tau, 'r-+',...
    Time_primal,State_primal(:,1)-180*(Inv+1)/2*pi/180,'b-o',Time_primal,State_primal(:,2),'r-o');
title('Pendulium results')
xlabel('time');
ylabel('states');
legend('\theta', '\omega', '\tau', '\theta sim','\omega sim');

save('Results_20100204\temp.mat','jill','Starts');
clear all
load('Results_20100204\temp.mat','jill','Starts');

end
end

