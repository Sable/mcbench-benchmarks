% this problem Looks at the optimality of a given control waveform for 
% restoring a pendulum to equilibrium 

m=1; %mass of plumb, kg
g=9.806; %gravity, m/sec^2
l_c=0.5; %length to center of plumb, m
% I=m*l_c^2/3; % moment of inertia
I=m*l_c^2+m*(2*l_c)^2/12; % moment of inertia, doing bar
% check with SimMechanics for current values
global LQR_K

% differentiation approximation, 
% for unequal time steps
% y[i+1]=y[i]+(t[i+1]-t[i]) y'[i]+(t[i+1]-t[i])^2 y''[i]/2 + HOT
% y[i-1]=y[i]+(t[i-1]-t[i]) y'[i]+(t[i-1]-t[i])^2 y''[i]/2 + HOT
% y'[i] = ((y[i+1]-y[i])(t[i-1]-t[i])^2-(y[i-1]-y[i])(t[i+1]-t[i])^2)/...
%   ((t[i+1]-t[i])(t[i+1]-t[i])^2-(t[i-1]-t[i])(t[i-1]-t[i])^2)
Diff = @(x,t) [(x(:,2)-x(:,1))./(t(:,2)-t(:,1)), ...
    (diff(x(:,2:end),1,2).*(repmat(diff(t(1:end-1)).^2,size(x,1),1))-...
    diff(x(:,1:end-1),1,2).*(repmat(diff(t(2:end).^2),size(x,1),1)))./...
    (repmat(diff(t(2:end)).*(diff(t(1:end-1)).^2)-...
    diff(t(1:end-1)).*(diff(t(2:end).^2)),size(x,1),1)),...
    (x(:,end)-x(:,end-1))./(t(:,end)-t(:,end-1))];
% % if you want to check 
% temp5=sort(6*rand(1,150));
% temp6=[sin(3*temp5);3*cos(3*temp5)];
% plot(temp5,temp6,'o',temp5,Diff(temp6,temp5),'b-',temp5,[3*cos(3*temp5);-9*sin(3*temp5)],'o');

Energy=@(Results) (g/l_c)*(1-cos(Results(:,1)))+1/2*Results(:,2).^2;

%%
Start=10:10:180;
% Start=20;
Cost=zeros(size(Start));
Cost_LQR=zeros(size(Start));
Cost_LQR2=zeros(size(Start));
Final=zeros(size(Start));
Final_LQR=zeros(size(Start));
Final_LQR2=zeros(size(Start));
Residual=zeros(length(Start),2);
Primal=cell(size(Start));
Control=cell(size(Start));
Dual=cell(size(Start));
Sims=cell(size(Start));
figure(1411); clf;
for jillster=1:length(Start)

if Start(jillster)<10
NumTag=['00' num2str(Start(jillster))];
elseif Start(jillster)<100
NumTag=['0' num2str(Start(jillster))];
else 
NumTag=num2str(Start(jillster));
end

LoadName=['Pendlium_2_', NumTag, 'deg'];
load(LoadName,'t','bounds','Tau','primal','dual','Theta','Omega',...
    'Time_primal','State_primal','Output_primal');
[Time_primal,State_primal,Output_primal]=sim('Arm_1DOF_1b',t,...
    simset('InitialState',bounds.lower.events(1:2)+[180;0]*pi/180),...
    [t(:),Tau(:)]); 
Primal{jillster}=primal;
Dual{jillster}=dual;
Control{jillster}=Tau;
SimResults.Time=Time_primal;
SimResults.State=State_primal;
SimResults.Output=Output_primal;
Sims{jillster}=SimResults;
% Cost
Cost(jillster)=quad(@(t) (interp1(Primal{jillster}.nodes,Primal{jillster}.controls,t,'pchip')).^2,0,1);
Final(jillster)=Energy(primal.states(:,end).')/Energy(primal.states(:,1).');

[Results,u_star,T]=Arm_1DOF_LinearStateTransition_Fun(Start(jillster),1,I,l_c);
Cost_LQR(jillster)=quad(@(t) (interp1(T,u_star,t)).^2,0,1);
dummy=find(T>=primal.nodes(end),1,'first');
Final_LQR(jillster)=Energy(Results(dummy,:))/Energy(Results(1,:));

[Results,u_star,T,Q,LQR_K,t_set]=Arm_1DOF_LinearQuadRegulator_Fun(Start(jillster),1,I,l_c);
% Note that LQR_K is used as a variable in Arm_1DOF_LQR_Sus.mdl
[T2,Results2,dummy]=sim('Arm_1DOF_LQR_Sus',t,...
    simset('InitialState',bounds.lower.events(1:2)+[0;0]*pi/180)); 
u_star2=-Results2(:,1:2)*LQR_K(:); 
u_star2(u_star2<-7)=-7;
u_star2(u_star2>7)=7;
Cost_LQR2(jillster)=quad(@(t) (interp1(T2,u_star2,t)).^2,0,1);
Final_LQR2(jillster)=Energy(Results2(end,:))/Energy(Results2(1,:));
Residual(jillster,:)=Results2(end,:).';
%Plots 
figure(1411); subplot(length(Start),1,jillster);
plot(t, 180/pi*Theta, 'bx', t, 180/pi*Omega/10, 'rx', t, 10*Tau, 'g+',...
    Time_primal,180/pi*State_primal(:,1)-180,'bo',Time_primal,180/pi*State_primal(:,2)/10,'ro',...
    T,Results(:,1)*180/pi,'b-',T,Results(:,2)*180/pi/10,'r-',T,10*u_star,'g-',...
    T2,Results2(:,1)*180/pi-0,'bs',T2,Results2(:,2)*180/pi/10,'rs');
axis tight
ylabel('states');
end
xlabel('time');
subplot(length(Start),1,1)
title('Pendulium results')
% legend('\theta, deg', '\omega/10, deg/sec', '10 \tau', '\theta sim','\omega sim/10');

%% Look at cost 
figure(3611);clf;
subplot(2,1,1)
hold on;
plot(Start,Cost(:).^.5,'-x','Color',[0,0,.5]);
plot(Start,Cost_LQR(:).^.5,'-+','Color',[.5,1,1]);
plot(Start,Cost_LQR2(:).^.5,'-o','Color',[1,.3,.3]);
plot(Start,Cost(:).^.5,'-x','Color',[0,0,.5]);
hold off;
title('Control Cost, Suspended Pendulum')
ylabel({'N m $\sqrt{sec}$'},'interpreter','latex')
% legend('DIDO','LQ','LQR','Location','NW')
% xlabel('\theta_o, deg')
axis([0,190,0,6.4])
grid on 
subplot(2,1,2)
hold on;
plot(Start,100*Final(:),'-x','Color',[0,0,.5]);
plot(Start,100*Final_LQR(:),'-+','Color',[.5,1,1]);
plot(Start,100*Final_LQR2(:),'-o','Color',[1,.3,.3]);
hold off;
title('Final State')
legend('DIDO','LQ','LQR','Location','E')
xlabel('\theta_o, deg')
ylabel({'Settling measure, %'})
axis([0,190,0,5])
% ylabel({'Settling measure';'log_{10}(Final/Initial)'})
% axis([0,190,-3,1])
grid on 
% for jill=1:length(Start)
%     text(Start(jill),Cost_LQR(jill)+0.05,['(' num2str(Residual(jill,:)) ')']);
% end
% subplot(1,2,2)
%%
Start_inv=10:10:180;
Cost_inv=zeros(size(Start_inv));
Cost_LQR_inv=zeros(size(Start_inv));
Cost_LQR2_inv=zeros(size(Start_inv));
Residual_inv=zeros(length(Start_inv),2);
Final_inv=zeros(size(Start));
Final_LQR_inv=zeros(size(Start));
Final_LQR2_inv=zeros(size(Start));
Primal_inv=cell(size(Start_inv));
Control_inv=cell(size(Start_inv));
Dual_inv=cell(size(Start_inv));
Sims_inv=cell(size(Start_inv));
figure(1511); clf;
for jill=1:length(Start_inv)
if Start_inv(jill)<10
NumTag=['00' num2str(Start_inv(jill))];
elseif Start_inv(jill)<100
NumTag=['0' num2str(Start_inv(jill))];
else 
NumTag=num2str(Start_inv(jill));
end
LoadName=['Pendlium_2_', NumTag, 'deg_inv'];
load(LoadName,'t','bounds','Tau','primal','dual','Theta','Omega',...
    'Time_primal','State_primal','Output_primal');
[Time_primal,State_primal,Output_primal]=sim('Arm_1DOF_1b',t,...
    simset('InitialState',bounds.lower.events(1:2)+[0;0]*pi/180),...
    [t(:),Tau(:)]); 
Primal_inv{jill}=primal;
Dual_inv{jill}=dual;
Control_inv{jill}=Tau;
SimResults.Time=Time_primal;
SimResults.State=State_primal;
SimResults.Output=Output_primal;
Sims_inv{jill}=SimResults;
% Cost
Cost_inv(jill)=quad(@(t) (interp1(Primal_inv{jill}.nodes,Primal_inv{jill}.controls,t,'pchip')).^2,0,1);

[Results,u_star,T]=Arm_1DOF_LinearStateTransition_Fun(Start_inv(jill),-1,I,l_c);
Cost_LQR_inv(jill)=quad(@(t) (interp1(T,u_star,t)).^2,0,1);
dummy=find(T>=primal.nodes(end),1,'first');
Final_LQR_inv(jill)=Energy(Results(dummy,:))/Energy(Results(1,:));


[Results,u_star,T,Q,LQR_K,t_set]=Arm_1DOF_LinearQuadRegulator_Fun(Start_inv(jill),-1,I,l_c);
[T2,Results2,dummy]=sim('Arm_1DOF_LQR_Inv',t,...
    simset('InitialState',bounds.lower.events(1:2)+[0;0]*pi/180)); 
u_star2=-Results2(:,1:2)*LQR_K(:); 
u_star2(u_star2<-7)=-7;
u_star2(u_star2>7)=7;
Cost_LQR2_inv(jill)=quad(@(t) (interp1(T2,u_star2,t)).^2,0,1);
Residual_inv(jill,:)=Results2(end,:).';
Final_LQR2_inv(jill)=Energy(Results2(end,:))/Energy(Results2(1,:));
% plots
figure(1511); 
if length(Start_inv)>6
subplot(ceil(length(Start_inv)/2),2,jill);
else
subplot(length(Start_inv),1,jill);
end
plot(t, 180/pi*Theta, 'bx', t, 180/pi*Omega/10, 'rx', t, 10*Tau, 'g+',...
    Time_primal,180/pi*State_primal(:,1)-0,'bo',Time_primal,180/pi*State_primal(:,2)/10,'ro',...
    T,Results(:,1)*180/pi,'b-',T,Results(:,2)*180/pi/10,'r-',T,10*u_star,'g-',...
    T2,Results2(:,1)*180/pi,'bs',T2,Results2(:,2)*180/pi/10,'rs');
axis tight
ylabel('states');
end
xlabel('time');
if length(Start_inv)>6
subplot(ceil(length(Start_inv)/2),2,1);
else
subplot(length(Start_inv),1,1);
end
title('Inverted Pendulium results')
legend({'\theta, deg', '\omega/10, deg/sec', '10 \tau', '\theta sim','\omega sim/10',...
    '\theta LQR ODE', '\omega LQR ODE','\tau LQR', '\theta LQR sim', '\omega LQR sim'}...
    ,'Location','EastOutside');

%% Look at cost 
figure(3612);clf;
subplot(2,1,1)
hold on;
plot(Start_inv,Cost_inv(:).^.5,'-x','Color',[0,0,.5]);
plot(Start_inv,Cost_LQR_inv(:).^.5,'-+','Color',[.5,1,1]);
plot(Start_inv,Cost_LQR2_inv(:).^.5,'-o','Color',[1,.3,.3]);
plot(Start_inv,Cost_inv(:).^.5,'-x','Color',[0,0,.5]);
hold off;
title('Control Cost, Inverted Pendulum')
% legend('DIDO','LQ','LQR','Location','NW')
% xlabel('\theta_o, deg')
ylabel({'N m $\sqrt{sec}$'},'interpreter','latex')
axis([0,190,0,8])
grid on
subplot(2,1,2)
hold on;
plot(Start_inv,100*Final_inv(:),'-x','Color',[0,0,.5]);
plot(Start_inv,100*Final_LQR_inv(:),'-+','Color',[.5,1,1]);
plot(Start_inv,100*Final_LQR2_inv(:),'-o','Color',[1,.3,.3]);
hold off;

title('Final State')
legend('DIDO','LQ','LQR','Location','E')
xlabel('\theta_o, deg')
% ylabel({'Settling measure';'log_{10}(Final/Initial)'})
% axis([0,190,-3,1])
ylabel({'Settling measure, %'})
axis([0,190,0,5])
grid on


%%
% for the minimum control energy problem 

% J = \int_{t_o}^{t_f} u^\top u dt

% H = u^\top u + \lambda^\top x_dot 

% x_dot = [x(2); -mgl_c/I sin(x(1))]

% The Euler-Lagrange equations are 

% H_\lambda = x_dot

% P_dot = -H_x

% \Delta H(\delta u) >= 0

% H_u = 2u + \lambda_2/I

Res_Costates=cell(length(Start),1);
Res_State=cell(length(Start),1);
Res_Control=cell(length(Start),1);
for jill=1:length(Start)
% Costate residuals
Res_Costates{jill} = Primal{jill}.statedots-Arm_1DOF_Dynamics_Sus(Primal{jill});
% Scale by relative magnitude
for kim=1:size(Res_Costates{jill},1)
    Res_Costates{jill}(kim,:)=Res_Costates{jill}(kim,:)/max(abs(Primal{jill}.statedots(kim,:)));
end
% costate dynamics, state equation
Res_State{jill} = ...
    Diff(Dual{jill}.dynamics,Primal{jill}.nodes)+...
    [-1*Dual{jill}.dynamics(2,:).*((m*g*l_c/I)*cos(Primal{jill}.states(1,:))); ...
    Dual{jill}.dynamics(1,:)];
for kim=1:size(Res_State{jill},1)
    Res_State{jill}(kim,:)=Res_State{jill}(kim,:)/max(abs(Diff(Dual{jill}.dynamics,Primal{jill}.nodes)));
end
% stationary/ constrained control equation
Res_Control{jill} = 2*Primal{jill}.controls+Dual{jill}.dynamics(2,:)/I;
for kim=1:size(Res_Control{jill},1)
    Res_Control{jill}(kim,:)=Res_Control{jill}(kim,:)/max(abs(2*Primal{jill}.controls));
end
end
Res_Costates_inv=cell(length(Start_inv),1);
Res_State_inv=cell(length(Start_inv),1);
Res_Control_inv=cell(length(Start_inv),1);
for jill=1:length(Start_inv)
% Costate residuals
Res_Costates_inv{jill} = Primal_inv{jill}.statedots-Arm_1DOF_Dynamics_Inv(Primal_inv{jill});
% Scale by relative magnitude
for kim=1:size(Res_Costates_inv{jill},1)
    Res_Costates_inv{jill}(kim,:)=Res_Costates_inv{jill}(kim,:)/max(abs(Primal_inv{jill}.statedots(kim,:)));
end
% costate dynamics, state equation
Res_State_inv{jill} = Diff(Dual_inv{jill}.dynamics,Primal_inv{jill}.nodes)+...
    [1*Dual_inv{jill}.dynamics(2,:).*((m*g*l_c/I)*cos(Primal_inv{jill}.states(1,:))); ...
    Dual_inv{jill}.dynamics(1,:)];
for kim=1:size(Res_State_inv{jill},1)
    Res_State_inv{jill}(kim,:)=Res_State_inv{jill}(kim,:)/max(abs(Diff(Dual_inv{jill}.dynamics,Primal_inv{jill}.nodes)));
end
% stationary/ constrained control equation
Res_Control_inv{jill} = 2*Primal_inv{jill}.controls+Dual_inv{jill}.dynamics(2,:)/I;
for kim=1:size(Res_Control_inv{jill},1)
    Res_Control_inv{jill}(kim,:)=Res_Control_inv{jill}(kim,:)/max(abs(2*Primal_inv{jill}.controls));
end
end
%%
figure(196); clf; 
for jill=1:length(Start)
if length(Start)>6
subplot(ceil(length(Start)/2),2,jill);
else
subplot(length(Start),1,jill);
end
plot(Primal{jill}.nodes,Res_Costates{jill},'+-',...
    Primal{jill}.nodes,Res_State{jill},'o-',...
    Primal{jill}.nodes,Res_Control{jill},'s-');
axis tight
xlabel([num2str(Start(jill)) ' deg start']);
end
if length(Start)>6
subplot(ceil(length(Start)/2),2,1);
else
subplot(length(Start),1,1);
end
legend('\lambda_1','\lambda_2','\theta','\omega','u','location','EastOutside')
title('Residuals of Euler Lagrange Equations')

figure(197); clf; 
for jill=1:length(Start_inv)
if length(Start_inv)>6
subplot(ceil(length(Start_inv)/2),2,jill);
else
subplot(length(Start_inv),1,jill);
end
plot(Primal_inv{jill}.nodes,Res_Costates_inv{jill},'+-',...
    Primal_inv{jill}.nodes,Res_State_inv{jill},'o-',...
    Primal_inv{jill}.nodes,Res_Control_inv{jill},'s-')
axis tight
xlabel([num2str(Start_inv(jill)) ' deg start']);
end
if length(Start_inv)>6
subplot(ceil(length(Start_inv)/2),2,1);
else
subplot(length(Start_inv),1,1);
end
legend('\lambda_1','\lambda_2','\theta','\omega','u','location','EastOutside')
title('Residuals of Euler Lagrange Equations, inverted pendulium')

%% Straight plot of residuals to see magnitude

figure(592)
clf;
subplot(2,2,2)
hold on;
for jill=1:length(Start_inv)
plot(Primal_inv{jill}.nodes,Res_Costates_inv{jill},'r+',...
    Primal_inv{jill}.nodes,Res_State_inv{jill},'go',...
    Primal_inv{jill}.nodes,Res_Control_inv{jill},'ks')
end
% axis tight
axis([-0.001,1.001,-0.25,1.5])
% xlabel([num2str(Start_inv(jill)) ' deg start']);
% legend('\lambda_1','\lambda_2','\theta','\omega','u','location','EastOutside')
% title('Residuals of Euler Lagrange Equations, inverted pendulium')
title({'Residuals,'; 'inverted pendulum'})
xlabel('time (sec)');

subplot(2,2,4)
hold on;
for jill=1:length(Start_inv)
plot(Primal_inv{jill}.nodes,Res_Costates_inv{jill},'r+',...
    Primal_inv{jill}.nodes,Res_State_inv{jill},'go',...
    Primal_inv{jill}.nodes,Res_Control_inv{jill},'ks')
end
axis([-0.001,1.001,-0.15,0.05])
% xlabel([num2str(Start_inv(jill)) ' deg start']);
% legend('\lambda_1','\lambda_2','\theta','\omega','u','location','EastOutside')
% title('Residuals of Euler Lagrange Equations, inverted pendulium')
title('Inverted, zoomed in')
xlabel('time (sec)');

subplot(2,2,1)
hold on;
for jill=1:length(Start)
plot(Primal{jill}.nodes,Res_Costates{jill},'r+',...
    Primal{jill}.nodes,Res_State{jill},'go',...
    Primal{jill}.nodes,Res_Control{jill},'ks')
end
% axis tight
axis([-0.001,1.001,-0.25,1.5])
% xlabel([num2str(Start_inv(jill)) ' deg start']);
% legend('\lambda_1','\lambda_2','\theta','\omega','u','location','EastOutside')
% title('Residuals of Euler Lagrange Equations, inverted pendulium')
title({'Residuals,'; 'suspended pendulum'})
xlabel('time (sec)');

subplot(2,2,3)
hold on;
for jill=1:length(Start)
plot(Primal{jill}.nodes,Res_Costates{jill},'r+',...
    Primal{jill}.nodes,Res_State{jill},'go',...
    Primal{jill}.nodes,Res_Control{jill},'ks')
end
axis([-0.001,1.001,-0.15,0.05])
% xlabel([num2str(Start_inv(jill)) ' deg start']);
% legend('\lambda_1','\lambda_2','\theta','\omega','u','location','EastOutside')
% title('Residuals of Euler Lagrange Equations, inverted pendulium')
title('Suspended, zoomed in')
xlabel('time (sec)');

%% Show control saturation on control and residuals
[temp_ang, temp_nodes]=meshgrid(Start,Primal{1}.nodes);

temp_control_inv=zeros(size(temp_ang));
for alice=1:length(Start_inv)
    temp_control_inv(:,alice)=Control_inv{alice};
end

temp_res_control_inv=zeros(size(temp_ang));
for alice=1:length(Start_inv)
    temp_res_control_inv(:,alice)=Res_Control_inv{alice};
end


figure(593);
clf;
subplot(2,1,1);
surf(temp_nodes.',temp_ang.', temp_control_inv.');
% axis('tight')
axis([0,1,10,180,-7,7])
ylabel('Starting Angle (deg)');
xlabel('Time (sec)');
zlabel('Control (Nm)');
title('Control vs starting angle');

subplot(2,1,2);
surf(temp_nodes.', temp_ang.', temp_res_control_inv.');
% axis('tight')
axis([0,1,10,180,-0.15,1.5])
ylabel('Starting Angle (deg)');
xlabel('Time (sec)');
zlabel('Residual (Nm)');
title('Control Optimality residual');


%% Show path comparison, suspended

Choice=4;
[Results,u_star,T]=Arm_1DOF_LinearStateTransition_Fun(Start(Choice),1,I,l_c);
Results0=interp1(T,Results,Primal{Choice}.nodes);
u_star0=interp1(T,u_star,Primal{Choice}.nodes);
T0=Primal{Choice}.nodes;
[Results,u_star,T,Q,LQR_K,t_set]=Arm_1DOF_LinearQuadRegulator_Fun(Start(Choice),1,I,l_c);
[T2,Results2,dummy]=sim('Arm_1DOF_LQR_Sus',t,...
    simset('InitialState',[Start(Choice);0]*pi/180)); 
u_star2=-Results2(:,1:2)*LQR_K(:); 
u_star2(u_star2<-7)=-7;
u_star2(u_star2>7)=7;

%%
figure(595); clf;
subplot(3,1,1);
plot(Primal{Choice}.nodes, 180/pi*Primal{Choice}.states(1,:), 'bx',...
    T0,Results0(:,1)*180/pi,'r-',T2,Results2(:,1)*180/pi,'c-');
legend({'DIDO'; 'LQ'; 'LQR'}...
    ,'Location','NorthEastOutside');
ylabel('$\theta$, deg','interpreter', 'latex','fontsize',12)
axis([0,1,-10,50])
daspect([1/3,50,1])
% title({'                          Comparison of results for \theta_o=40^\circ',...
%        '                          for suspended pendulum'})
title({'                     Suspended pendulum for \theta_o=40^\circ'})
% axis('tight')

subplot(3,1,2);
plot(Primal{Choice}.nodes, 180/pi*Primal{Choice}.states(2,:), 'bx',...
    T0,Results0(:,2)*180/pi,'r-',T2,Results2(:,2)*180/pi,'c-');
axis([0,1,-135,20])
daspect([1/3,155,1])
ylabel('$\dot{\theta}$, deg/sec','interpreter', 'latex','fontsize',12)
subplot(3,1,3);
plot(Primal{Choice}.nodes, Primal{Choice}.controls, 'bx',...
    T0,u_star0,'r-',T2,u_star2,'c-');
ylabel('u, N m','interpreter', 'latex','fontsize',12)
axis([0,1,-7,7])
daspect([1/3,14,1])
% title({['           Comparison of DIDO results to LQR for suspended pendulium'];...
%     '\theta_o=40^o'})
% title({'Comparison of DIDO results to LQR','for suspended pendulium'})
xlabel('time (sec)');

%%
Choice=14;
[Results0,u_star0,T0]=Arm_1DOF_LinearStateTransition_Fun(Start(Choice),1,I,l_c);
[Results,u_star,T,Q,LQR_K,t_set]=Arm_1DOF_LinearQuadRegulator_Fun(Start(Choice),1,I,l_c);
[T2,Results2,dummy]=sim('Arm_1DOF_LQR_Sus',t,...
    simset('InitialState',[Start(Choice);0]*pi/180)); 
u_star2=-Results2(:,1:2)*LQR_K(:); 
u_star2(u_star2<-7)=-7;
u_star2(u_star2>7)=7;
%%
figure(594);clf;

subplot(3,1,1);
plot(Primal{Choice}.nodes, 180/pi*Primal{Choice}.states(1,:), 'bx',...
    T0,Results0(:,1)*180/pi,'r-',T2,Results2(:,1)*180/pi,'c-');
legend({'DIDO'; 'LQ'; 'LQR'}...
    ,'Location','NorthEastOutside');
ylabel('$\theta$, deg','interpreter', 'latex','fontsize',12)
axis([0,1,-50,160])
daspect([1/3,170,1])
title({'                     Suspended pendulum for \theta_o=140^\circ'})

subplot(3,1,2);
plot(Primal{Choice}.nodes, 180/pi*Primal{Choice}.states(2,:), 'bx',...
    T0,Results0(:,2)*180/pi,'r-',T2,Results2(:,2)*180/pi,'c-');
axis([0,1,-300,50])
daspect([1/3,350,1])
ylabel('$\dot{\theta}$, deg/sec','interpreter', 'latex','fontsize',12)
subplot(3,1,3);
plot(Primal{Choice}.nodes, Primal{Choice}.controls, 'bx',...
    T0,u_star0,'r-',T2,u_star2,'c-');
ylabel('u, N m','interpreter', 'latex','fontsize',12)
axis([0,1,-6,8])
daspect([1/3,14,1])
xlabel('time (sec)');


%% Show path comparison, inverted 

Choice=2;

[Results0,u_star0,T0]=Arm_1DOF_LinearStateTransition_Fun(Start_inv(Choice),-1,I,l_c);
[Results,u_star,T,Q,LQR_K,t_set]=Arm_1DOF_LinearQuadRegulator_Fun(Start_inv(Choice),-1,I,l_c);
[T2,Results2]=sim('Arm_1DOF_LQR_Inv',t,...
    simset('InitialState',[Start_inv(Choice);0]*pi/180)); 
u_star2=-Results2(:,1:2)*LQR_K(:); 
u_star2(u_star2<-7)=-7;
u_star2(u_star2>7)=7;
%
figure(596);clf;
subplot(3,1,1);
plot(Primal_inv{Choice}.nodes, 180/pi*Primal_inv{Choice}.states(1,:), 'bx',...
    T0,Results0(:,1)*180/pi,'r-',T2,Results2(:,1)*180/pi,'c-');
legend({'DIDO'; 'LQ'; 'LQR'}...
    ,'Location','NorthEastOutside');
ylabel('$\theta$, deg','interpreter', 'latex','fontsize',12)
axis([0,1,-10,25])
daspect([1/3,35,1])
title({'                     Inverted pendulum for \theta_o=20^\circ'})

subplot(3,1,2);
plot(Primal_inv{Choice}.nodes, 180/pi*Primal_inv{Choice}.states(2,:), 'bx',...
    T0,Results0(:,2)*180/pi,'r-',T2,Results2(:,2)*180/pi,'c-');
axis([0,1,-40,5])
daspect([1/3,45,1])
ylabel('$\dot{\theta}$, deg/sec','interpreter', 'latex','fontsize',12)
subplot(3,1,3);
plot(Primal_inv{Choice}.nodes, Primal_inv{Choice}.controls, 'bx',...
    T0,u_star0,'r-',T2,u_star2,'c-');
ylabel('u, N m','interpreter', 'latex','fontsize',12)
axis([0,1,-5,1])
daspect([1/3,6,1])
xlabel('time (sec)');
%%
Choice=14;

[Results0,u_star0,T0]=Arm_1DOF_LinearStateTransition_Fun(Start_inv(Choice),-1,I,l_c);
[Results,u_star,T,Q,LQR_K,t_set]=Arm_1DOF_LinearQuadRegulator_Fun(Start_inv(Choice),-1,I,l_c);
[T2,Results2]=sim('Arm_1DOF_LQR_Inv',t,...
    simset('InitialState',[Start_inv(Choice);0]*pi/180)); 
u_star2=-Results2(:,1:2)*LQR_K(:); 
u_star2(u_star2<-7)=-7;
u_star2(u_star2>7)=7;
%
figure(597);clf;
subplot(3,1,1);
plot(Primal_inv{Choice}.nodes, 180/pi*Primal_inv{Choice}.states(1,:), 'bx',...
    T0,Results0(:,1)*180/pi,'r-',T2,Results2(:,1)*180/pi,'c-');
legend({'DIDO'; 'LQ'; 'LQR'}...
    ,'Location','NorthEastOutside');
ylabel('$\theta$, deg','interpreter', 'latex','fontsize',12)
axis([0,1,-10,150])
daspect([1/3,160,1])
title({'                     Inverted pendulum for \theta_o=140^\circ'})

subplot(3,1,2);
plot(Primal_inv{Choice}.nodes, 180/pi*Primal_inv{Choice}.states(2,:), 'bx',...
    T0,Results0(:,2)*180/pi,'r-',T2,Results2(:,2)*180/pi,'c-');
axis([0,1,-270,50])
daspect([1/3,320,1])
ylabel('$\dot{\theta}$, deg/sec','interpreter', 'latex','fontsize',12)
subplot(3,1,3);
plot(Primal_inv{Choice}.nodes, Primal_inv{Choice}.controls, 'bx',...
    T0,u_star0,'r-',T2,u_star2,'c-');
ylabel('u, N m','interpreter', 'latex','fontsize',12)
axis([0,1,-8,8])
daspect([1/3,16,1])
xlabel('time (sec)');


