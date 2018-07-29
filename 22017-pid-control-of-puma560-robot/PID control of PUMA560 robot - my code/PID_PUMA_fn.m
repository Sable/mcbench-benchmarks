

% ODE function of PID control of a 3DOF PUMA 560 Robot code
% 
% Name: Abdel-Razzak MERHEB
% Date: 5 Oct. 2008
%

function dy = PID_PUMA_fn(t,x)

global xdot z perror2 pderror perror desiredteta teta olderror told deltat


% here is the desired path for the first three joints
%desiredteta = [0 2*t -2*t 0 0 0];  % drawing a circle in the space
desiredteta = [t 2*t -2*t 0 0 0];
%desiredteta = [0 0 0 0 0 0];

% PID gains
Kp = 70;
Kd = 10;
Ki = 20;

% x is the vector containing the initial values, both displacements and
% velocities in one column

for i = 1:1:6
   teta(i) = x(i);    %teta vector is the first 6 elements of x (displacement vector)
   dteta(i) = x(6+i);    %dteta vector is the second 6 elements of x (velocity vector)
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%Forming the dynamic equation of the robot%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% the robot equation is of the form: tetadotdot = inv(A).[TOW-(B+C+G)]

c2=cos(teta(2));
s2=sin(teta(2));

c3=cos(teta(3));
s3=sin(teta(3));

c23=cos(teta(2)+teta(3));
s23=sin(teta(2)+teta(3));

c223=cos(2*teta(2)+teta(3));
s223=sin(2*teta(2)+teta(3));



%Inertial Constants (kg.m^2)
I1=1.43; %+-.05
I2=1.75;
I3=1.38;
I4=.69;
I5=.372;
I6=.333;
I7=.298;
I8=-.134;
I9=.0238;
I10=-.0213;
I11=-.0142;
I12=-.011;
I13=-.00379;
I14=.00164;
I15=.00125;
I16=.00124;
I17=.000642;
I18=.000431;
I19=.0003;
I20=-.000202;
I21=-.0001;
I22=-.000058;
I23=.00004;

Im1=1.14;
Im2=4.71;
Im3=.827;
Im4=.2;
Im5=.179;
Im6=.193;

%gravitational constants (N.m)
g1=-37.2;
g2=-8.44;
g3=1.02;
g4=.249;
g5=-.0282;

%here are the robot matrices A, B, C and G
% A matrix

a11=Im1+I1+I3*c2^2+I7*s23^2+I10*s23*c23+I11*s2*c2+I21*s23^2+2*(I5*c2*s23+I12*c2*c23+I15*s23*s23+I16*c2*s23+I22*s23*c23);
a12=I4*s2+I8*c23+I9*c2+I13*s23-I18*c23;
a13=I8*c23+I13*s23-I18*c23;

a22=Im2+I2+I6+2*(I5*s3+I12*c2+I15+I16*s3);
a23=I5*s3+I6+I12*c3+I16*s3+2*I15;

a33=Im3+I6+2*I15;
a35=I15+I17;

a44=Im4+I14;

a55=Im5+I17;

a66=Im6+I23;

a21=a12; a31=a13; a32=a23;

a14=0;
a15=0;
a16=0;

a24=0;
a25=0;
a26=0;

a34=0;
a36=0;

a41=0;
a42=0;
a43=0;
a45=0;
a46=0;

a51=0;
a52=0;
a53=0;
a54=0;
a56=0;

a61=0;
a62=0;
a63=0;
a64=0;
a65=0;


%and here is the A matrix
A= [a11 a12 a13 a14 a15 a16;
    a21 a22 a23 a24 a25 a26;
    a31 a32 a33 a34 a35 a36;
    a41 a42 a43 a44 a45 a46;
    a51 a52 a53 a54 a55 a56;
    a61 a62 a63 a64 a65 a66];





% B matrix
b112=2*(-I3*s2*c2+I5*c223+I7*s23*c23-I12*s223+I15*2*s23*c23+I16*c223+I21*s23*c23+I22*(1-2*s23^2))+I10*(1-2*s23^2)+I11*(1-2*s2^2);
b113=2*(I5*c23*c2+I7*s23*c23-I12*s23*c2+I15*2*s23*c23+I16*c2*c23+I21*s23*c23+I22*(1-2*s23^2))+I10*(1-2*s23^2);
b115=2*(-s23*c23+I15*s23*c23+I16*c2*c23+I22*c23^2);
b123=2*(-I8*s23+I13*c23+I18*s23);
b214=I14*s23+I19*s23+I20*s23;
b223=2*(-I12*s3+I5*c3+I16*c3);
b225=2*(I16*c3+I22);
b235=b225;
b314=(I20*+I14+I19)*s23;
b412=-b214;
b413=-b314;
b415=-I20*s23-I17*s23;
b514=-b415;


%and here is the B matrix
B= [b112 b113 0 b115 0 b123 0 0 0 0 0 0 0 0 0;
    0 0 b214 0 0 b223 0 b225 0 0 b235 0 0 0 0;
    0 0 b314 0 0 0 0 0 0 0 0 0 0 0 0;
    b412 b413 0 b415 0 0 0 0 0 0 0 0 0 0 0;
    0 0 b514 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;];



% matrix C
c12=I4*c2-I8*s23-I9*s2+I13*c23+I18*s23;
c13=.5*b123;
c21=-.5*b112;
c23=.5*b223;
c31=-.5*b113;
c32=-c23;
c51=-.5*b115;
c52=-.5*b225;


%and here is the C matrix
C= [0 c12 c13 0 0 0;
    c21 0 c23 0 0 0;
    c31 c32 0 0 0 0;
    0 0 0 0 0 0;
    c51 c52 0 0 0 0;
    0 0 0 0 0 0];




% G matrix
G2=g1*c2+g2*s23+g3*s2+g4*c23+g5*s23;
G3=g2*s23+g4*c23+g5*s23;
G5=g5*s23;


%here is vector G
G=[0;g2;g3;0;g5;0];


%angular velocity vectors
qdt=[dteta(1)*dteta(2);dteta(1)*dteta(3);0;0;0;dteta(2)*dteta(3);0;0;0;0;0;0;0;0;0];
qsq=[dteta(1)^2;dteta(2)^2;dteta(3)^2;0;0;0];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% here is the PID control law

%olderror = [0 0 0 0 0 0];

if t == 0
olderror = [0 0 0 0 0 0];  %initialization of the error
end

perror = (desiredteta - teta);  % proportional error
pierror = olderror + perror;    % integral error
pderror = (olderror - perror)*0.00251;    % differential error


Law = Kp*perror;% + Kd*pderror;% + Ki*pierror;

% values to keep the last three joints zero
Law(4) = b412*dteta(1)*dteta(2) + b413*dteta(1)*dteta(3);
Law(5) = c51*dteta(1)^2 + c52*dteta(2)^2 + g5;
Law(6) = 0;

T = Law';

olderror = perror;

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% here is the dynamic equation of the robot
%x(1)dot = x(2)
%x(2)dot = inv(A)*[T-(B*qdt+C*qsq+G)];

tetadot=dteta;
ddteta=inv(A)*[T-(B*qdt+C*qsq+G)];


% here solve the differential equation of the robot
% form the vector dy, a combination of dteta and ddteta

dy(1) = x(7);       % dteta1
dy(7) = ddteta(1);  % ddteta1

dy(2) = x(8);       % dteta2
dy(8) = ddteta(2);  % ddteta2

dy(3) = x(9);       % dteta3
dy(9) = ddteta(3);  % ddteta3

dy(4) = x(10);       % dteta4
dy(10) = ddteta(4);  % ddteta4


dy(5) = x(11);       % dteta5
dy(11) = ddteta(5);  % ddteta5

dy(6) = x(12);       % dteta6
dy(12) = ddteta(6);  % ddteta6


dy = dy';   % return a column-vector

