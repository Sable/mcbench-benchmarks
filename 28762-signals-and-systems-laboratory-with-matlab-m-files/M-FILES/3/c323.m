% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% linearity

%linear system
t=-3:.1:3;
x1=heaviside(t)-heaviside(t-1);
x2=heaviside(t)-heaviside(t-2);
a1=2;
a2=3;
z=a1*x1+a2*x2;
y=2*z;
plot(t,y);
ylim([-1 11]);

figure;
z1=2*x1;
z2=2*x2;
y=a1*z1+a2*z2;
plot(t,y);
ylim([-1 11]);



%non linear system
figure
t=-3:.1:3;
x1=heaviside(t)-  heaviside(t-1);
x2=heaviside(t)-heaviside(t-2);
a1=2;
a2=3;
z=a1*x1+a2*x2;
y=z.^2;
plot(t,y);
ylim([-1 26]);

figure
z1=x1.^2;
z2=x2.^2;
y=a1*z1+a2*z2;
plot(t,y);
ylim([-1 6]);


%non linear system
n=0:5;
x1=0.8.^n;
x2=cos(n);
a1=2;
a2=3;
z=a1*x1+a2*x2;

y1=2.^z
z1=2.^x1;
z2=2.^x2;	
y2=a1*z1+a2*z2

%linear system
n=0:5;
x1=0.8.^n;
x2=cos(n);
a1=2;
a2=3;
z=a1*x1+a2*x2;

y1=n.*z
z1=n.*x1;
z2=n.*x2;	
y2=a1*z1+a2*z2


