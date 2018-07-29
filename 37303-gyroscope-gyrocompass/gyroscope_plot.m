clear;

%Input data
L=0.055;
R1=0.05;
R2=0.045;
R3=0.04;
g=9.81;
m=0.2;
m1=0.1;
m2=0.1;
m3=0.2;
tf=2.2;
ts=0.01;
time=(0:ts:tf);
N=length(time);

%Initial conditions
ph0=0;
phd0=0;
th0=0.5;
thd0=0;
ps0=0;
psd0=200;
initial= [ph0 phd0 th0 thd0 ps0 psd0];

%Configuring ODEs solution
options=odeset('AbsTol',1.e-16,'RelTol',1.e-12);  
tic;
[t x]=ode45('gyroscope',time,initial,options,L,R1,R2,R3,g,m,m1,m2,m3);
elapsed_time_sec=toc

%Euler angles and angular velocities in time
    f1=figure;
subplot(3,2,1)
    plot(t(:,1),x(:,1))
    ylabel('\phi','FontSize',11)
    title('Euler angles and angular velocities ','FontSize',11)
subplot(3,2,2)
    plot(t(:,1),x(:,2))
    ylabel('d\phi/dt','FontSize',11)
    %title(['[\phi_0 d\phi_0/dt  \theta_0 d\theta_0/dt \psi_0 d\psi_0/dt]= ['...
    % ,num2str(ph0,2),' ',num2str(phd0,2),' ',num2str(th0,2),' '...
    % ,num2str(thd0,2),' ',num2str(ps0,2),' ',num2str(psd0,2),']'],'FontSize',11)
subplot(3,2,3)
    plot(t(:,1),x(:,3))
    ylabel('\theta','FontSize',11)
subplot(3,2,4)
    plot(t(:,1),x(:,4))
    ylabel('d\theta/dt','FontSize',11)
subplot(3,2,5)
    plot(t(:,1),x(:,5)) 
    xlabel('t','FontSize',11)
    ylabel('\psi','FontSize',11)
subplot(3,2,6)
    plot(t(:,1),x(:,6))
    xlabel('t','FontSize',11)
    ylabel('d\psi/dt','FontSize',11)

%Phase subspaces of nutation and angular velocities    
    f2=figure;
subplot(3,1,1)
    plot(x(:,3),x(:,2))
    xlabel('\theta','FontSize',11)
    ylabel('d\phi/dt','FontSize',11)
    title('Phase subspaces','FontSize',11)
    %title(['Phase subspaces','[\phi_0 d\phi_0/dt  \theta_0 d\theta_0/dt \psi_0 d\psi_0/dt]= ['...
    % ,num2str(ph0,2),' ',num2str(phd0,2),' ',num2str(th0,2),' '...
    % ,num2str(thd0,2),' ',num2str(ps0,2),' ',num2str(psd0,2),']'],'FontSize',11)
subplot(3,1,2)
    plot(x(:,3),x(:,4))
    xlabel('\theta','FontSize',11)
    ylabel('d\theta/dt','FontSize',11)
subplot(3,1,3)
    plot(x(:,3),x(:,6))
    xlabel('\theta','FontSize',11)
    ylabel('d\psi/dt','FontSize',11)

%State space of angular velocities
   f3=figure;
plot3(x(:,4),x(:,2),x(:,6))
ylabel('d\theta/dt','FontSize',11)
xlabel('d\phi/dt','FontSize',11)
zlabel('d\psi/dt','FontSize',11)
grid on
title(['State space ','[\phi_0 d\phi_0/dt  \theta_0 d\theta_0/dt \psi_0 d\psi_0/dt]= ['...
     ,num2str(ph0,2),' ',num2str(phd0,2),' ',num2str(th0,2),' '...
     ,num2str(thd0,2),' ',num2str(ps0,2),' ',num2str(psd0,2),']'],'FontSize',11)
 
 %Kinetic nad potetial energy
   f4=figure;
T(:,:)=zeros(N,1);
V(:,:)=zeros(N,1);
     for i=1:N
T(i,1)=(m*L^2*x(i,2)^2*cos(x(i,3))^2)/2 + (m1*R1^2*x(i,2)^2)/4 + (3*m2*R2^2*x(i,2)^2)/4 + (m2*R2^2*x(i,4)^2)/2 + (m3*R3^2*x(i,2)^2*cos(x(i,3))^2)/8 + (m3*R3^2*x(i,2)^2)/8 + (m3*R3^2*x(i,2)*x(i,6)*cos(x(i,3)))/2 + (m3*R3^2*x(i,6)^2)/4 + (m3*R3^2*x(i,4)^2)/8;
V(i,1)=m*g*L*cos(x(i,3));
     end
E=T+V;

subplot(3,1,1)
    plot(t,E)
    ylabel('E','FontSize',11)
    title(['Energy:Total, Potential, Kinetic '...
     ,'[\phi_0 d\phi_0/dt  \theta_0 d\theta_0/dt \psi_0 d\psi_0/dt]= ['...
     ,num2str(ph0,2),' ',num2str(phd0,2),' ',num2str(th0,2),' '...
     ,num2str(thd0,2),' ',num2str(ps0,2),' ',num2str(psd0,2),']'],'FontSize',11)
subplot(3,1,2)
    plot(t,V) 
    ylabel('V','FontSize',11)
subplot(3,1,3)
    plot(t,T)
    xlabel('t','FontSize',11)
    ylabel('T','FontSize',11)

%Angular momenta
    f5=figure;
H(:,:)=zeros(N,3);
     for i=1:N      
H(i,1)=m*x(i,2)*L^2*cos(x(i,3))^2 + (m1*x(i,2)*R1^2)/2 + (3*m2*x(i,2)*R2^2)/2 + (m3*x(i,2)*R3^2*cos(x(i,3))^2)/4 + (m3*x(i,6)*R3^2*cos(x(i,3)))/2 + (m3*x(i,2)*R3^2)/4;
H(i,2)=m2*x(i,4)*R2^2 + (m3*x(i,4)*R3^2)/4;
H(i,3)=(R3^2*m3*x(i,6))/2 + (R3^2*m3*x(i,2)*cos(x(i,3)))/2;
     end
     
subplot(3,1,1)
    plot(t,H(:,1))
    ylabel('p\phi','FontSize',11)
    title(['Angular momentum: \phi, \theta, \psi '...
     ,'[\phi_0 d\phi_0/dt  \theta_0 d\theta_0/dt \psi_0 d\psi_0/dt]= ['...
     ,num2str(ph0,2),' ',num2str(phd0,2),' ',num2str(th0,2),' '...
     ,num2str(thd0,2),' ',num2str(ps0,2),' ',num2str(psd0,2),']'],'FontSize',11)
subplot(3,1,2)
     plot(t,H(:,2)) 
     ylabel('p\theta','FontSize',11)
subplot(3,1,3)
     plot(t,H(:,3))
     xlabel('t','FontSize',11)
     ylabel('p\psi','FontSize',11) 

%Visualization of gyroscope motion
     f6=figure;
Ha(:,:)=zeros(N,3);
Hr(:,:)=zeros(N,3);
for i=1:N
Ha(i,1)=0*H(i,1)+H(1,2)*cos(x(i,1))+H(i,3)*sin(x(1,3))*sin(x(i,1));
Ha(i,2)=0*H(i,1)+H(1,2)*sin(x(i,1))-H(i,3)*sin(x(1,3))*cos(x(i,1));
Ha(i,3)=1*H(i,1)+0*H(1,2)+H(i,3)*cos(x(1,3));
Hr(i,1)=0*H(1,1)+H(1,2)*cos(x(i,1))+H(i,3)*sin(x(i,3))*sin(x(i,1));
Hr(i,2)=0*H(1,1)+H(1,2)*sin(x(i,1))-H(i,3)*sin(x(i,3))*cos(x(i,1));
Hr(i,3)=1*H(1,1)+0*H(1,2)+H(1,3)*cos(x(i,3));
end

va1x=min(Ha);va1y=min(Ha);va1z=min(Ha);       
va2x=max(Ha);va2y=max(Ha);va2z=max(Ha);
vb1x=min(Hr);vb1y=min(Hr);vb1z=min(Hr);
vb2x=max(Hr);vb2y=max(Hr);vb2z=max(Hr);
v1x=min(va1x,vb1x);v1y=min(va1y,vb1y);v1z=min(va1z,vb1z);
v2x=max(va2x,vb2x);v2y=max(va2y,vb2y);v2z=max(va2z,vb2z);
v=max([abs(v1x),v2x,abs(v1y),v2y,abs(v1z),v2z]);
for i=1:N
clf   
axis([-v,v,-v,v,-v,v])
xlabel('x','FontSize',11)
ylabel('y','FontSize',11)
zlabel('z','FontSize',11)
hold on
h(1)=line([0,0],[0,0],[-v,v],'color','k');
h(2)=line([0,0],[-v,v],[0,0],'color','k');
h(3)=line([-v,v],[0,0],[0,0],'color','k'); 
h(4)=line([0,Ha(i,1)],[0,Ha(i,2)],[0,Ha(i,3)],'color', 'b','LineStyle','-');
h(5)=line([0,-Ha(i,1)],[0,-Ha(i,2)],[0,-Ha(i,3)],'color', 'b','LineStyle','-');
h(6)=line([Ha(i,1),Ha(i,1)],[Ha(i,2),Ha(i,2)],[0,Ha(i,3)],'color','b','LineStyle','-.','Marker','.');
h(7)=line([-Ha(i,1),-Ha(i,1)],[-Ha(i,2),-Ha(i,2)],[0,-Ha(i,3)],'color','b','LineStyle','-.','Marker','.');
h(8)=line([0,Ha(i,1)],[0,Ha(i,2)],[0,0],'color','b','LineStyle','--','Marker','.'); 
h(9)=line([0,-Ha(i,1)],[0,-Ha(i,2)],[0,0],'color','b','LineStyle','--','Marker','.');
h(10)=line([0,0],[0,0],[Ha(i,3),Ha(i,3)],'color','b','Marker','.'); 
h(11)=line([0,0],[0,0],[-Ha(i,3),-Ha(i,3)],'color','b','Marker','.'); 
h(11)=line([0,Hr(i,1)],[0,Hr(i,2)],[0,Hr(i,3)],'color', 'r','LineStyle','-');
h(12)=line([0,-Hr(i,1)],[0,-Hr(i,2)],[0,-Hr(i,3)],'color', 'r','LineStyle','-');
h(13)=line([Hr(i,1),Hr(i,1)],[Hr(i,2),Hr(i,2)],[0,Hr(i,3)],'color','r','LineStyle','-.','Marker','.');
h(14)=line([-Hr(i,1),-Hr(i,1)],[-Hr(i,2),-Hr(i,2)],[0,-Hr(i,3)],'color','r','LineStyle','-.','Marker','.');
h(15)=line([0,Hr(i,1)],[0,Hr(i,2)],[0,0],'color','r','LineStyle','--','Marker','.'); 
h(16)=line([0,-Hr(i,1)],[0,-Hr(i,2)],[0,0],'color','r','LineStyle','--','Marker','.'); 
h(17)=line([0,0],[0,0],[Hr(i,3),Hr(i,3)],'color','r','Marker','.'); 
h(18)=line([0,0],[0,0],[-Hr(i,3),-Hr(i,3)],'color','r','Marker','.');
h(19)=plot3(Hr(i,1),Hr(i,2),Hr(i,3),'ro');
grid on
pause(tf/N)
end  
    h(20)=plot3(Ha(:,1),Ha(:,2),Ha(:,3),'b:'); 
    h(21)=plot3(-Ha(:,1),-Ha(:,2),-Ha(:,3),'b:'); 
    %h(22)=plot3(Ha(:,1),Ha(:,2),zeros(N,1),'b:'); 
    h(23)=plot3(Hr(:,1),Hr(:,2),Hr(:,3),'r:'); 
    h(24)=plot3(-Hr(:,1),-Hr(:,2),-Hr(:,3),'r:');
    %h(25)=plot3(Hr(:,1),Hr(:,2),zeros(N,1),'r:');
    
    title(['Symmetry axis path '...
     ,'[\phi_0 d\phi_0/dt  \theta_0 d\theta_0/dt \psi_0 d\psi_0/dt]= ['...
     ,num2str(ph0,2),' ',num2str(phd0,2),' ',num2str(th0,2),' '...
     ,num2str(thd0,2),' ',num2str(ps0,2),' ',num2str(psd0,2),']'],'FontSize',11)
