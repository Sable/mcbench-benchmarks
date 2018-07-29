% Residue Curve Map for Reactive Systems / Methyl Acetate Chemistry
% Author's Data: Housam BINOUS
% Department of Chemical Engineering
% National Institute of Applied Sciences and Technology
% Tunis, TUNISIA
% Email: binoushousam@yahoo.com 

c=rand(50,3);

for i=0:9,

xO1=0.00867394;
x02=0.608674;
x03=0.191326;
x04=0.191326;

T0=330;
y01=0.00025;

X01=0.1*i;
X02=0.1*(9-i);

tf=20;

x0 = [xO1  x02  x03  x04 y01 T0 X01 X02];

opts = odeset('Mass','M','MassSingular','yes');

[t,x] = ode15s('RCM_MethylAcetate',[0 tf],x0,opts);


x1=x(:,7);
x2=x(:,8);

figure(1);
x1=x(:,7);
x2=x(:,8);

AXIS([0 1 0 1])
hold on

plot(x1,x2,'color',[c(i+1,1) c(i+1,2) c(i+1,3)],'LineWidth',2);

end

for i=0:9,

xO1=0.00867394;
x02=0.608674;
x03=0.191326;
x04=0.191326;

T0=330;
y01=0.00025;

X01=0.1*i;
X02=0.1*(9-i);

tf=20;

x0 = [xO1  x02  x03  x04 y01 T0 X01 X02];

opts = odeset('Mass','M','MassSingular','yes');

[t,x] = ode15s('RCM_MethylAcetate2',[0 tf],x0,opts);


x1=x(:,7);
x2=x(:,8);

figure(1);
x1=x(:,7);
x2=x(:,8);

AXIS([0 1 0 1])
hold on

plot(x1,x2,'color',[c(i+1,1) c(i+1,2) c(i+1,3)],'LineWidth',2); 

end
