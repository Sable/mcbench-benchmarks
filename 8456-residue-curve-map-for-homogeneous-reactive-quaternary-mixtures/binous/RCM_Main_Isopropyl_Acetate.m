% Residue Curve Map for Reactive Systems / Isopropyl Acetate Chemistry
% Author's Data: Housam BINOUS
% Department of Chemical Engineering
% National Institute of Applied Sciences and Technology
% Tunis, TUNISIA
% Email: binoushousam@yahoo.com 

c=rand(50,3);

for i=0:19,

xO1=0.0478508;
x02=0.564896;
x03=0.182812;
x04=0.204442;

T0=353.892;
y01=0.00303558;

X01=0.05*i;
X02=0.05*i;

tf=20;

x0 = [xO1  x02  x03  x04 y01 T0 X01 X02];

opts = odeset('Mass','M','MassSingular','yes');

[t,x] = ode15s('RCM_IsopropylAcetate',[0 tf],x0,opts);


x1=x(:,7);
x2=x(:,8);

figure(1);
x1=x(:,7);
x2=x(:,8);

AXIS([0 1 0 1])
hold on

if mod(i,4)==0 plot(x1,x2,'color',[c(i+1,1) c(i+1,2) 1],'LineWidth',2); end

end

for i=0:19,

xO1=0.0478508;
x02=0.564896;
x03=0.182812;
x04=0.204442;

T0=353.892;
y01=0.00303558;

X01=0.05*i;
X02=0.05*i;

tf=20;

x0 = [xO1  x02  x03  x04 y01 T0 X01 X02];

opts = odeset('Mass','M','MassSingular','yes');

[t,x] = ode15s('RCM_IsopropylAcetate2',[0 tf],x0,opts);


x1=x(:,7);
x2=x(:,8);

figure(1);
x1=x(:,7);
x2=x(:,8);

AXIS([0 1 0 1])
hold on

if mod(i,4)==0 plot(x1,x2,'color',[c(i+1,1) c(i+1,2) 1],'LineWidth',2); end

end

for i=0:19,

xO1=0.0478508;
x02=0.564896;
x03=0.182812;
x04=0.204442;

T0=353.892;
y01=0.00303558;

X01=0.1;
X02=0.05*i;

tf=20;

x0 = [xO1  x02  x03  x04 y01 T0 X01 X02];

opts = odeset('Mass','M','MassSingular','yes');

[t,x] = ode15s('RCM_IsopropylAcetate',[0 tf],x0,opts);


x1=x(:,7);
x2=x(:,8);

figure(1);
x1=x(:,7);
x2=x(:,8);

AXIS([0 1 0 1])
hold on

if mod(i,4)==0 plot(x1,x2,'color',[c(i+1,1) 1 c(i+1,3)],'LineWidth',2); end

end

for i=0:19,

xO1=0.0478508;
x02=0.564896;
x03=0.182812;
x04=0.204442;

T0=353.892;
y01=0.00303558;

X01=0.1;
X02=0.05*i;

tf=20;

x0 = [xO1  x02  x03  x04 y01 T0 X01 X02];

opts = odeset('Mass','M','MassSingular','yes');

[t,x] = ode15s('RCM_IsopropylAcetate2',[0 tf],x0,opts);


x1=x(:,7);
x2=x(:,8);

figure(1);
x1=x(:,7);
x2=x(:,8);

AXIS([0 1 0 1])
hold on

if mod(i,4)==0 plot(x1,x2,'color',[c(i+1,1) 1 c(i+1,3)],'LineWidth',2); end

end

for i=0:19,

xO1=0.0478508;
x02=0.564896;
x03=0.182812;
x04=0.204442;

T0=353.892;
y01=0.00303558;

X01=0.05*i;
X02=0.9;

tf=20;

x0 = [xO1  x02  x03  x04 y01 T0 X01 X02];

opts = odeset('Mass','M','MassSingular','yes');

[t,x] = ode15s('RCM_IsopropylAcetate',[0 tf],x0,opts);


x1=x(:,7);
x2=x(:,8);

figure(1);
x1=x(:,7);
x2=x(:,8);

AXIS([0 1 0 1])
hold on

if mod(i,4)==0 plot(x1,x2,'color',[1 c(i+1,2) c(i+1,3)],'LineWidth',2); end

end

for i=0:19,

xO1=0.0478508;
x02=0.564896;
x03=0.182812;
x04=0.204442;

T0=353.892;
y01=0.00303558;

X01=0.05*i;
X02=0.9;

tf=20;

x0 = [xO1  x02  x03  x04 y01 T0 X01 X02];

opts = odeset('Mass','M','MassSingular','yes');

[t,x] = ode15s('RCM_IsopropylAcetate2',[0 tf],x0,opts);


x1=x(:,7);
x2=x(:,8);

figure(1);
x1=x(:,7);
x2=x(:,8);

AXIS([0 1 0 1])
hold on

if mod(i,4)==0 plot(x1,x2,'color',[1 c(i+1,2) c(i+1,3)],'LineWidth',2); end

end
