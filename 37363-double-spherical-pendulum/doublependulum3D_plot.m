clear;

%Input data
l1=1;
l2=1;
m1=1;
m2=1;
g=9.81;
tf=15;
ts=0.01;
time=(0:ts:tf);
N=length(time);

%Initial conditions
ph10=0;
phd10=3;
th10=0.25;
thd10=0;
ph20=0;
phd20=6;
th20=0.25;
thd20=0;
initial= [ph10 phd10 th10 thd10 ph20 phd20 th20 thd20];

%Configuring ODEs solution
tic;
options=odeset('AbsTol',1.e-16,'RelTol',1.e-12);  
[t x]=ode113('doublependulum3D',time,initial,options,l1,l2,m1,m2,g);
elapsed_time_sec=toc

%Generalized coordinates and velocities in time
f1=figure;
subplot(4,2,1)
     plot(t(:,1),x(:,1))
     ylabel('\phi_1','FontSize',11)
     title('Angles and derivatives ','FontSize',11)
subplot(4,2,2)
     plot(t(:,1),x(:,2))
     ylabel('d\phi_1/dt','FontSize',11)
     %title(['[\phi_1_0 d\phi_1_0/dt \theta_1_0 d\theta_1_0/dt \phi_2_0 d\phi_2_0/dt \theta_2_0 d\theta_2_0/dt]= ['...
     %,num2str(ph10,2),' ',num2str(phd10,2),' ',num2str(th10,2),' ',num2str(thd10,2),' ',num2str(ph20,2),' ',num2str(phd20,2),' ',num2str(th20,2),' ',num2str(thd20,2),']'],'FontSize',11)
subplot(4,2,3)
     plot(t(:,1),x(:,3))
     ylabel('\theta_1','FontSize',11)
subplot(4,2,4)
     plot(t(:,1),x(:,4))
     ylabel('d\theta_1/dt','FontSize',11)
subplot(4,2,5)
     plot(t(:,1),x(:,5))
     ylabel('\phi_2','FontSize',11)
subplot(4,2,6)
     plot(t(:,1),x(:,6))
     ylabel('d\phi_2/dt','FontSize',11)
subplot(4,2,7)
     plot(t(:,1),x(:,7))
     xlabel('t','FontSize',11)
     ylabel('\theta_2','FontSize',11)
subplot(4,2,8)
     plot(t(:,1),x(:,8))
     xlabel('t','FontSize',11)
     ylabel('d\theta_2/dt','FontSize',11)

%Phase subspaces of generalized coordinates with respective velocities
f2=figure;
subplot(2,2,1)
     plot(x(:,1),x(:,2))
     xlabel('\phi_1','FontSize',11)
     ylabel('d\phi_1/dt','FontSize',11)
     title('Phase subspaces','FontSize',11)
subplot(2,2,2)
     plot(x(:,3),x(:,4))
     xlabel('\theta_1','FontSize',11)
     ylabel('d\theta_1/dt','FontSize',11)
     %title(['[\phi_1_0 d\phi_1_0/dt \theta_1_0 d\theta_1_0/dt \phi_2_0 d\phi_2_0/dt \theta_2_0 d\theta_2_0/dt]= ['...
     %,num2str(ph10,2),' ',num2str(phd10,2),' ',num2str(th10,2),' ',num2str(thd10,2),' ',num2str(ph20,2),' ',num2str(phd20,2),' ',num2str(th20,2),' ',num2str(thd20,2),']'],'FontSize',11)
subplot(2,2,3)
     plot(x(:,5),x(:,6))
     xlabel('\phi_2','FontSize',11)
     ylabel('d\phi_2/dt','FontSize',11)
subplot(2,2,4)
     plot(x(:,7),x(:,8))
     xlabel('\theta_2','FontSize',11)
     ylabel('d\theta_2/dt','FontSize',11)

%State subspaces of combinations of generalized velocities
f3=figure;
subplot(2,2,1)
     plot3(x(:,2),x(:,4),x(:,6))
     xlabel('d\phi_1/dt','FontSize',11)
     ylabel('d\theta_1/dt','FontSize',11)
     zlabel('d\phi_2/dt','FontSize',11)
     title('State subspaces','FontSize',11)
     grid on
subplot(2,2,2)
     plot3(x(:,4),x(:,6),x(:,8))
     xlabel('d\theta_1/dt','FontSize',11)
     ylabel('d\phi_2/dt','FontSize',11)
     zlabel('d\theta_2/dt','FontSize',11)
     %title(['[\phi_1_0 d\phi_1_0/dt \theta_1_0 d\theta_1_0/dt \phi_2_0 d\phi_2_0/dt \theta_2_0 d\theta_2_0/dt]= ['...
     %,num2str(ph10,2),' ',num2str(phd10,2),' ',num2str(th10,2),' ',num2str(thd10,2),' ',num2str(ph20,2),' ',num2str(phd20,2),' ',num2str(th20,2),' ',num2str(thd20,2),']'],'FontSize',11)
     grid on
subplot(2,2,3)
     plot3(x(:,6),x(:,8),x(:,2))
     xlabel('d\phi_2/dt','FontSize',11)
     ylabel('d\theta_2/dt','FontSize',11)
     zlabel('d\phi_1/dt','FontSize',11)
     grid on
subplot(2,2,4)
     plot3(x(:,8),x(:,2),x(:,4))
     xlabel('d\theta_2/dt','FontSize',11)
     ylabel('d\phi_1/dt','FontSize',11)
     zlabel('d\theta_1/dt','FontSize',11)
     grid on

%Calculation of kinetic, potetial and total energy and generalized momenta
r1=l1*sin(x(:,3));
x1=r1.*cos(x(:,1));
y1=r1.*sin(x(:,1));
z1=-l1*cos(x(:,3));
r2=l2*sin(x(:,7));
x2=x1+r2.*cos(x(:,5));
y2=y1+r2.*sin(x(:,5));
z2=z1-l2*cos(x(:,7));
V(:,:)=zeros(N,1);
T(:,:)=zeros(N,1);
H(:,:)=zeros(N,4);
for i=1:N;
 V(i,1)=- g*m2*(l1*cos(x(i,3)) + l2*cos(x(i,7))) - g*l1*m1*cos(x(i,3));
 T(i,1)=(m2*((l1*x(i,4)*sin(x(i,3)) + l2*x(i,8)*sin(x(i,7)))^2 + (l1*x(i,2)*cos(x(i,1))*sin(x(i,3)) + l2*x(i,6)*cos(x(i,5))*sin(x(i,7)) + l1*x(i,4)*cos(x(i,3))*sin(x(i,1)) + l2*x(i,8)*cos(x(i,7))*sin(x(i,5)))^2 + (l1*x(i,2)*sin(x(i,1))*sin(x(i,3)) + l2*x(i,6)*sin(x(i,5))*sin(x(i,7)) - l1*x(i,4)*cos(x(i,1))*cos(x(i,3)) - l2*x(i,8)*cos(x(i,5))*cos(x(i,7)))^2))/2 + (m1*((l1*x(i,2)*cos(x(i,1))*sin(x(i,3)) + l1*x(i,4)*cos(x(i,3))*sin(x(i,1)))^2 + (l1*x(i,2)*sin(x(i,1))*sin(x(i,3)) - l1*x(i,4)*cos(x(i,1))*cos(x(i,3)))^2 + l1^2*x(i,4)^2*sin(x(i,3))^2))/2;   
 H(i,1)=(m2*(2*l1*cos(x(i,1))*sin(x(i,3))*(l1*x(i,2)*cos(x(i,1))*sin(x(i,3)) + l2*x(i,6)*cos(x(i,5))*sin(x(i,7)) + l1*x(i,4)*cos(x(i,3))*sin(x(i,1)) + l2*x(i,8)*cos(x(i,7))*sin(x(i,5))) + 2*l1*sin(x(i,1))*sin(x(i,3))*(l1*x(i,2)*sin(x(i,1))*sin(x(i,3)) + l2*x(i,6)*sin(x(i,5))*sin(x(i,7)) - l1*x(i,4)*cos(x(i,1))*cos(x(i,3)) - l2*x(i,8)*cos(x(i,5))*cos(x(i,7)))))/2 + (m1*(2*l1*cos(x(i,1))*sin(x(i,3))*(l1*x(i,2)*cos(x(i,1))*sin(x(i,3)) + l1*x(i,4)*cos(x(i,3))*sin(x(i,1))) + 2*l1*sin(x(i,1))*sin(x(i,3))*(l1*x(i,2)*sin(x(i,1))*sin(x(i,3)) - l1*x(i,4)*cos(x(i,1))*cos(x(i,3)))))/2;
 H(i,2)=(m2*(2*l1*sin(x(i,3))*(l1*x(i,4)*sin(x(i,3)) + l2*x(i,8)*sin(x(i,7))) - 2*l1*cos(x(i,1))*cos(x(i,3))*(l1*x(i,2)*sin(x(i,1))*sin(x(i,3)) + l2*x(i,6)*sin(x(i,5))*sin(x(i,7)) - l1*x(i,4)*cos(x(i,1))*cos(x(i,3)) - l2*x(i,8)*cos(x(i,5))*cos(x(i,7))) + 2*l1*cos(x(i,3))*sin(x(i,1))*(l1*x(i,2)*cos(x(i,1))*sin(x(i,3)) + l2*x(i,6)*cos(x(i,5))*sin(x(i,7)) + l1*x(i,4)*cos(x(i,3))*sin(x(i,1)) + l2*x(i,8)*cos(x(i,7))*sin(x(i,5)))))/2 + (m1*(2*l1^2*x(i,4)*sin(x(i,3))^2 - 2*l1*cos(x(i,1))*cos(x(i,3))*(l1*x(i,2)*sin(x(i,1))*sin(x(i,3)) - l1*x(i,4)*cos(x(i,1))*cos(x(i,3))) + 2*l1*cos(x(i,3))*sin(x(i,1))*(l1*x(i,2)*cos(x(i,1))*sin(x(i,3)) + l1*x(i,4)*cos(x(i,3))*sin(x(i,1)))))/2;
 H(i,3)=(m2*(2*l2*cos(x(i,5))*sin(x(i,7))*(l1*x(i,2)*cos(x(i,1))*sin(x(i,3)) + l2*x(i,6)*cos(x(i,5))*sin(x(i,7)) + l1*x(i,4)*cos(x(i,3))*sin(x(i,1)) + l2*x(i,8)*cos(x(i,7))*sin(x(i,5))) + 2*l2*sin(x(i,5))*sin(x(i,7))*(l1*x(i,2)*sin(x(i,1))*sin(x(i,3)) + l2*x(i,6)*sin(x(i,5))*sin(x(i,7)) - l1*x(i,4)*cos(x(i,1))*cos(x(i,3)) - l2*x(i,8)*cos(x(i,5))*cos(x(i,7)))))/2;
 H(i,4)=(m2*(2*l2*sin(x(i,7))*(l1*x(i,4)*sin(x(i,3)) + l2*x(i,8)*sin(x(i,7))) - 2*l2*cos(x(i,5))*cos(x(i,7))*(l1*x(i,2)*sin(x(i,1))*sin(x(i,3)) + l2*x(i,6)*sin(x(i,5))*sin(x(i,7)) - l1*x(i,4)*cos(x(i,1))*cos(x(i,3)) - l2*x(i,8)*cos(x(i,5))*cos(x(i,7))) + 2*l2*cos(x(i,7))*sin(x(i,5))*(l1*x(i,2)*cos(x(i,1))*sin(x(i,3)) + l2*x(i,6)*cos(x(i,5))*sin(x(i,7)) + l1*x(i,4)*cos(x(i,3))*sin(x(i,1)) + l2*x(i,8)*cos(x(i,7))*sin(x(i,5)))))/2;
end
E=T+V;

%Kinetic, potetial and total energy in time
     subplot(3,1,1)
     plot(t,E)
     ylabel('E','FontSize',11)
     title('Energy: Total, Potetial, Kinetic ','FontSize',11)
     %title(['Energy: Total, Potetial, Kinetic '...
     %,'[\phi_1_0 d\phi_1_0/dt \theta_1_0 d\theta_1_0/dt \phi_2_0 d\phi_2_0/dt \theta_2_0 d\theta_2_0/dt]= ['...
     %,num2str(ph10,2),' ',num2str(phd10,2),' ',num2str(th10,2),' ',num2str(thd10,2),''...
     %,num2str(ph20,2),' ',num2str(phd20,2),' ',num2str(th20,2),' ',num2str(thd20,2),']'],'FontSize',11)
subplot(3,1,2)
     plot(t,V) 
     ylabel('V','FontSize',11)
subplot(3,1,3)
     plot(t,T)
     xlabel('t','FontSize',11)
     ylabel('T','FontSize',11)
     
%Generalized momenta in time   
f5=figure;
subplot(4,1,1)
     plot(t,H(:,1))
     ylabel('p\phi_1 ','FontSize',11)
     title('Angular momentum: \phi_1, \theta_1, \phi_2, \theta_2 ','FontSize',11)
     %title(['Angular momentum: \phi_1, \theta_1, \phi_2, \theta_2 '...
     %,'[\phi_1_0 d\phi_1_0/dt \theta_1_0 d\theta_1_0/dt \phi_2_0 d\phi_2_0/dt \theta_2_0 d\theta_2_0/dt]= ['...
     %,num2str(ph10,2),' ',num2str(phd10,2),' ',num2str(th10,2),' ',num2str(thd10,2),' '...
     %,num2str(ph20,2),' ',num2str(phd20,2),' ',num2str(th20,2),' ',num2str(thd20,2),']'],'FontSize',11)
subplot(4,1,2)
     plot(t,H(:,2))
     ylabel('p\theta_1','FontSize',11)
subplot(4,1,3)
     plot(t,H(:,3))
     ylabel('p\phi_2','FontSize',11)
subplot(4,1,4)
     plot(t,H(:,4))
     xlabel('t','FontSize',11) 
     ylabel('p\theta_2','FontSize',11)
     
%Double spherical pendulum visualization    
f6=figure;
 for i=1:N
     clf
     axis([-l1-l2,l1+l2,-l1-l2,l1+l2,-1.25*l1-1.25*l2,0.25*l1+0.25*l2])
     hold on
     h(1)=line([-0.25*(l1+l2),0.25*(l1+l2)],[0,0],[0,0],'color','k'); 
     h(2)=line([0,0],[-0.25*(l1+l2),0.25*(l1+l2)],[0,0],'color','k');
     h(3)=line([0,0],[0,0],[-1.25*(l1+l2),0.25*(l1+l2)],'color','k');
     h(4)=line([0,x1(i)],[0,y1(i)],[0,z1(i)],'color', 'b','LineStyle','-'); 
     h(5)=line([0,x1(i)],[0,y1(i)],[0,0],'color', 'b','LineStyle','--','Marker','.');
     h(6)=line([x1(i),x1(i)],[y1(i),y1(i)],[0,z1(i)],'color', 'b','LineStyle','-.');
     h(7)=line([0,0],[0,0],[0,z1(i)],'color', 'b','Marker','.');
     h(8)=plot3(x1(i),y1(i),z1(i),'bo');                    
     h(9)=line([x1(i),x2(i)],[y1(i),y2(i)],[z1(i),z2(i)],'color', 'r','LineStyle','-');
     h(10)=line([0,x2(i)],[0,y2(i)],[0,0],'color', 'r','LineStyle','--','Marker','.');
     h(11)=line([x2(i),x2(i)],[y2(i),y2(i)],[0,z2(i)],'color', 'r','LineStyle','-.');
     h(12)=line([0,0],[0,0],[0,z2(i)],'color', 'r','Marker','.');
     h(13)=plot3(x2(i),y2(i),z2(i),'ro'); 
     h(14)=plot3(0,0,0,'k.');
     xlabel('x','FontSize',11)
     ylabel('y','FontSize',11)
     zlabel('z','FontSize',11)
     grid on
     pause(tf/N)
 end
h(15)=plot3(x1,y1,z1,'b:');                               
h(16)=plot3(x2,y2,z2,'r:');  
%h(17)=plot3(x1,y1,(-1.25*l1-1.25*l2)*ones(N,1),'b:');                               
%h(18)=plot3(x2,y2,(-1.25*l1-1.25*l2)*ones(N,1),'r:');  

xlabel('x','FontSize',11)
ylabel('y','FontSize',11)
zlabel('z','FontSize',11)
title(['Double spherical pendulum motion '...
     ,'[\phi_1_0 d\phi_1_0/dt \theta_1_0 d\theta_1_0/dt \phi_2_0 d\phi_2_0/dt \theta_2_0 d\theta_2_0/dt]= ['...
     ,num2str(ph10,2),' ',num2str(phd10,2),' ',num2str(th10,2),' ',num2str(thd10,2),' '...
     ,num2str(ph20,2),' ',num2str(phd20,2),' ',num2str(th20,2),' ',num2str(thd20,2),']'],'FontSize',11)

