% Batch Rectifier for Binary Systems
% Case of Acetone - Methanol Binary Mixture and 8 Stages Rectification System (including the reboiler)
% Author's Data: Housam BINOUS
% Department of Chemical Engineering
% National Institute of Applied Sciences and Technology
% Tunis, TUNISIA
% Email: binoushousam@yahoo.com 

% Main program calls function batch_dist 
% and plot results: liquid mole fractions and temperatures in all stages 

% Initial conditions: all temperatures are equal to 70°C, all liquid mole fractions
% are equal to zero except the liquid mole fraction in the still (set equal to 0.4).
% The reboiler is initially filled with 2500 kmol.  

for i=1:8,
xim(i)=0;
end
x0(9)=0.4;
x0(10)=2500;
for i=11:19,
xiT(i)=70;
end

% Final integration time

tf=2500;

x0t = [xim(1)  xim(2)  xim(3)  xim(4)  xim(5)  xim(6) xim(7)  xim(8)  x0(9) x0(10) xiT(11)  xiT(12)  xiT(13)  xiT(14)  xiT(15)  xiT(16) xiT(17)  xiT(18) xiT(19)];

opts = odeset('Mass','M','MassSingular','yes');

[t,x] = ode15s('batch_dist',[0 tf],x0t,opts);


figure(1);
H1=TITLE('Liquid mole fractions in all stages');
AXIS([0 2500 0 1])
hold on;
x1=x(:,1);
x2=x(:,2);
x3=x(:,3);
x4=x(:,4);
x5=x(:,5);
x6=x(:,6);
x7=x(:,7);
x8=x(:,8);
x9=x(:,9);

plot(t,x1,'b')
plot(t,x2,'r')
plot(t,x3,'m')
plot(t,x4,'b')
plot(t,x5,'y')
plot(t,x6,'c')
plot(t,x7,'g')
plot(t,x8,'k')
plot(t,x9,'r')

hold off
figure(2);
H2=TITLE('Temperatures in all stages');
AXIS([0 2500 50 70])
hold on;
x11=x(:,11);
x12=x(:,12);
x13=x(:,13);
x14=x(:,14);
x15=x(:,15);
x16=x(:,16);
x17=x(:,17);
x18=x(:,18);
x19=x(:,19);

plot(t,x11,'b')
plot(t,x12,'r')
plot(t,x13,'m')
plot(t,x14,'b')
plot(t,x15,'y')
plot(t,x16,'c')
plot(t,x17,'g')
plot(t,x18,'k')
plot(t,x19,'r')

hold off

