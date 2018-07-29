clear;
syms ph1 phd1 phdd1 ph2 phd2 phdd2 th1 th2 thd1 thd2 thdd1 thdd2
syms l1 l2 m1 m2 g
syms x1 x2 x3 x4 x5 x6 x7 x8

%Generalized coordinates 
r1=l1*sin(th1);
x1=r1*cos(ph1);
y1=r1*sin(ph1);
z1=-l1*cos(th1);
r2=l2*sin(th2);
x2=x1+r2*cos(ph2);
y2=y1+r2*sin(ph2);
z2=z1-l2*cos(th2);

%Generalized velocities 
xd1=diff(x1,ph1)*phd1+diff(x1,th1)*thd1+diff(x1,ph2)*phd2+diff(x1,th2)*thd2;
yd1=diff(y1,ph1)*phd1+diff(y1,th1)*thd1+diff(y1,ph2)*phd2+diff(y1,th2)*thd2;
zd1=diff(z1,ph1)*phd1+diff(z1,th1)*thd1+diff(z1,ph2)*phd2+diff(z1,th2)*thd2;
xd2=diff(x2,ph1)*phd1+diff(x2,th1)*thd1+diff(x2,ph2)*phd2+diff(x2,th2)*thd2;
yd2=diff(y2,ph1)*phd1+diff(y2,th1)*thd1+diff(y2,ph2)*phd2+diff(y2,th2)*thd2;
zd2=diff(z2,ph1)*phd1+diff(z2,th1)*thd1+diff(z2,ph2)*phd2+diff(z2,th2)*thd2;

%Kinetic and potetial energy
T=0.5*m1*(xd1^2+yd1^2+zd1^2)+0.5*m2*(xd2^2+yd2^2+zd2^2);
V=m1*g*z1+m2*g*z2;

%Equations of motion
pTpphd1=diff(T,phd1);
ddtpTpphd1=diff(pTpphd1,ph1)*phd1+diff(pTpphd1,phd1)*phdd1+diff(pTpphd1,ph2)*phd2+diff(pTpphd1,phd2)*phdd2+...
           diff(pTpphd1,th1)*thd1+diff(pTpphd1,thd1)*thdd1+diff(pTpphd1,th2)*thd2+diff(pTpphd1,thd2)*thdd2;
pTpph1=diff(T,ph1);
pVpph1=diff(V,ph1);
eqph1=simple(ddtpTpphd1-pTpph1+pVpph1);

pTpthd1=diff(T,thd1);
ddtpTpthd1=diff(pTpthd1,ph1)*phd1+diff(pTpthd1,phd1)*phdd1+diff(pTpthd1,ph2)*phd2+diff(pTpthd1,phd2)*phdd2+...
           diff(pTpthd1,th1)*thd1+diff(pTpthd1,thd1)*thdd1+diff(pTpthd1,th2)*thd2+diff(pTpthd1,thd2)*thdd2;
pTpth1=diff(T,th1);
pVpth1=diff(V,th1);
eqth1=simple(ddtpTpthd1-pTpth1+pVpth1);

pTpphd2=diff(T,phd2);
ddtpTpphd2=diff(pTpphd2,ph1)*phd1+diff(pTpphd2,phd1)*phdd1+diff(pTpphd2,ph2)*phd2+diff(pTpphd2,phd2)*phdd2+...
           diff(pTpphd2,th1)*thd1+diff(pTpphd2,thd1)*thdd1+diff(pTpphd2,th2)*thd2+diff(pTpphd2,thd2)*thdd2;
pTpph2=diff(T,ph2);
pVpph2=diff(V,ph2);
eqph2=simple(ddtpTpphd2-pTpph2+pVpph2);

pTpthd2=diff(T,thd2);
ddtpTpthd2=diff(pTpthd2,ph1)*phd1+diff(pTpthd2,phd1)*phdd1+diff(pTpthd2,ph2)*phd2+diff(pTpthd2,phd2)*phdd2+...
           diff(pTpthd2,th1)*thd1+diff(pTpthd2,thd1)*thdd1+diff(pTpthd2,th2)*thd2+diff(pTpthd2,thd2)*thdd2;
pTpth2=diff(T,th2);
pVpth2=diff(V,th2);
eqth2=simple(ddtpTpthd2-pTpth2+pVpth2);

%Solving with respect generalized accelerations
Sol=solve(eqph1,eqth1,eqph2,eqth2,'phdd1,thdd1,phdd2,thdd2');
Sol.phdd1=simple(Sol.phdd1);
Sol.thdd1=simple(Sol.thdd1);
Sol.phdd2=simple(Sol.phdd2);
Sol.thdd2=simple(Sol.thdd2);

%Substituting variables for ODEs manipulations
fph1=subs(Sol.phdd1,{ph1,phd1,th1,thd1,ph2,phd2,th2,thd2},{x1,x2,x3,x4,x5,x6,x7,x8});
fth1=subs(Sol.thdd1,{ph1,phd1,th1,thd1,ph2,phd2,th2,thd2},{x1,x2,x3,x4,x5,x6,x7,x8});
fph2=subs(Sol.phdd2,{ph1,phd1,th1,thd1,ph2,phd2,th2,thd2},{x1,x2,x3,x4,x5,x6,x7,x8});
fth2=subs(Sol.thdd2,{ph1,phd1,th1,thd1,ph2,phd2,th2,thd2},{x1,x2,x3,x4,x5,x6,x7,x8});

%Total energy, Lagrange function and generalized momenta
E=T+V;
L=T-V;
pLpphd1=diff(L,phd1);
pLpthd1=diff(L,thd1);
pLpphd2=diff(L,phd2);
pLpthd2=diff(L,thd2);

