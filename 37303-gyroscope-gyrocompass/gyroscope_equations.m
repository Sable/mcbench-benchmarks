clear;
syms ph phd phdd th thd thdd ps psd psdd
syms L R1 R2 R3 g m m1 m2 m3 
syms x1 x2 x3 x4 x5 x6

%Generalized coorditates are Euler angles 3-1-3 (ph)-preccesion,(th)-nutation, (ps)-spin
%Generalized (angular) velocities of (1)-outer gimbal, (2)-inner gimbal, (3)-rotor
omg1=[0; 0; phd];
omg2=[thd;phd*sin(th); phd*cos(th)];
omg3=[thd*cos(ps)+sin(th)*phd*sin(ps) ; -thd*sin(ps)+sin(th)*phd*cos(ps); psd+cos(th)*phd];
omg1t=[0, 0, phd];
omg2t=[thd, phd*sin(th), phd*cos(th)];
omg3t=[thd*cos(ps)+sin(th)*phd*sin(ps) , -thd*sin(ps)+sin(th)*phd*cos(ps), psd+cos(th)*phd];

%Inertia tensors
I1=[ m1*R1^2, 0, 0
0, 0.5*m1*R1^2, 0
0, 0, 0.5*m1*R1^2];
I2=[m2*R2^2, 0, 0
0, 1.5*m2*R2^2, 0
0,0, 1.5*m2*R2^2+m*L^2];
I3 =[ 0.25*m3*R3^2, 0, 0
0,0.25*m3*R3^2, 0
0, 0, 0.5*m3*R3^2];

%Kinetic and potetial energy
T=simplify(0.5*(omg1t*I1*omg1+omg2t*I2*omg2+omg3t*I3*omg3));
V=m*g*L*cos(th);

%Equations of motion
pTpphd=diff(T,phd);
ddtpTpphd=diff(pTpphd,ph)*phd+diff(pTpphd,phd)*phdd+diff(pTpphd,ps)*psd+diff(pTpphd,psd)*psdd+diff(pTpphd,th)*thd+diff(pTpphd,thd)*thdd;
pTpph=diff(T,ph);
pVpph=diff(V,ph);

pTppsd=diff(T,psd);
ddtpTppsd=diff(pTppsd,ph)*phd+diff(pTppsd,phd)*phdd+diff(pTppsd,ps)*psd+diff(pTppsd,psd)*psdd+diff(pTppsd,th)*thd+diff(pTppsd,thd)*thdd;
pTpps=diff(T,ps);
pVpps=diff(V,ps);

pTpthd=diff(T,thd);
ddtpTpthd=diff(pTpthd,ph)*phd+diff(pTpthd,phd)*phdd+diff(pTpthd,ps)*psd+diff(pTpthd,psd)*psdd+diff(pTpthd,th)*thd+diff(pTpthd,thd)*thdd;
pTpth=diff(T,th);
pVpth=diff(V,th);

eqph=simple(ddtpTpphd-pTpph+pVpph);
eqth=simple(ddtpTpthd-pTpth+pVpth);
eqps=simple(ddtpTppsd-pTpps+pVpps);

%Solving with respect generalized accelerations
Sol=solve(eqph,eqth,eqps,'phdd,thdd,psdd');
Sol.phdd=simple( Sol.phdd);
Sol.psdd=simple( Sol.psdd);
Sol.thdd=simple( Sol.thdd);

%Substituting variables for ODEs manipulations
fph=(subs(Sol.phdd,{ph,phd,th,thd,ps,psd},{x1,x2,x3,x4,x5,x6}));
fth=(subs(Sol.thdd,{ph,phd,th,thd,ps,psd},{x1,x2,x3,x4,x5,x6}));
fps=(subs(Sol.psdd,{ph,phd,th,thd,ps,psd},{x1,x2,x3,x4,x5,x6}));

%Total energy, Lagrange function and generalized momenta
E=T+V;
L=T-V;
pLpphd=diff(L,phd);
pLpthd=diff(L,thd);
pLppsd=diff(L,psd);






