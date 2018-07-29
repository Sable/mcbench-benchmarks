%#eml
function [F1,F2,T1,T2,Frs,Ffs,Frb,Ffb,q,qd,q3,q3d,Fzf,Fzr,vx]    = mdl_force_calculator(u,X1,X2,X3,X4,X5,X6,p)%fcn(x1,v1,x2,v2,R1,R2,S)
% r  = positions
% rd = velocities
% q  = generalized coordinates
% qd = generalized velocities
% R  = orientation matrices
% dr/dq * dq/dt = speed
% p  = parameter

% parameters
a1 = p(1)  ; l2 = p(11)  ; l3 = p(23) ; m5 = p(35)  ; a6 = p(47) ;
b1 = p(2)  ; m2 = p(12)  ; m3 = p(24) ; x5 = p(36)  ; b6 = p(48) ;
m1 = p(3)  ; x2 = p(13)  ; x3 = p(25) ; z5 = p(37)  ; m6 = p(49) ;
i1 = p(4)  ; i2 = p(14)  ; z3 = p(26) ; i5 = p(38)  ; i6 = p(50) ;
j1 = p(5)  ; t2 = p(15)  ; i3 = p(27) ; t5 = p(39)  ; j6 = p(51) ;
f1 = p(6)  ; b2 = p(16)  ; k3 = p(28) ; b5 = p(40)  ; f6 = p(52) ;
e1 = p(7)  ; p2 = p(17)  ; d3 = p(29) ; p5 = p(41)  ; e6 = p(53) ;
k1 = p(8)  ; d2 = p(18)  ; l4 = p(30) ; d5 = p(42)  ; k6 = p(54) ;
d1 = p(9)  ; e2 = p(19)  ; m4 = p(31) ; e5 = p(43)  ; d6 = p(55) ;
t1 = p(10) ; k2 = p(20)  ; x4 = p(32) ; k5 = p(44)  ; t6 = p(56) ;
             n2 = p(21)  ; z4 = p(33) ; n5 = p(45)  ; 
             f2 = p(22)  ; i4 = p(34) ; f5 = p(46)  ; 

%-------------------------------------------
% preprocessing and signal conversion
Rm3=reshape(X1(10:18),3,3); % frame orientation
Rm4=reshape(X2( 7:15),3,3); % handlebar orientation

% preparation for q3: rotate one frame to get the z-axes colinear
% first, find the axis about to rotate and the angle
v1 = Rm3(:,3);
v2 = Rm4(:,3);
w  = cross(v1,v2)/norm(cross(v1,v2))   ;     % axis
qq  = acos(complex(dot(v1,v2))) ;   % angle
% second, use Rodrigues rotation formula to get the new x and y vectors
x_old = Rm3(:,1);
x_new = x_old*dot(v1,v2)+cross(w,x_old)*sin(qq)+w*dot(w,x_old)*(1-dot(v1,v2));

% x_new = x_old*dot(v1,v2)+cross(w,x_old)*sqrt(1-dot(v1,v2)^2)+w*dot(w,x_old)*(1-dot(v1,v2));


c1 = sqrt(1-Rm3(3,2)^2); % cos(q1)
c5 = sqrt(1-Rm4(3,2)^2); % cos(q5)

% r0  = x7(1:3);
% r7  = x8(1:3);
%
% r0d = x7(4:6);
% r7d = x8(4:6);

qx  = X1(1);
qy  = X1(2);
qz  = X1(3);
q0  = atan2(-Rm3(1,2),Rm3(2,2));
q1  = asin(Rm3(3,2));
q2  = atan2(-Rm3(3,1),Rm3(3,3));
% q3  = q0-q4;%acos(dot(x_new,Rm4(:,1)));
q4  = atan2(-Rm4(1,2),Rm4(2,2));
q5  = asin(Rm4(3,2));
q6  = atan2(-Rm4(3,1),Rm4(3,3));
q7  = X3(1)+q2;
qf  = -X4(1);
q8  = X5(1)+q7;
q9  = X6(1)+q6;
qxd = X1(4);
qyd = X1(5);
qzd = X1(6);
q0d = (sin(q1)*(sin(q0)*X1(7)-cos(q0)*X1(8))+X1(9)*cos(q1))/c1 ;%(-sin(q1)*cos(q0)*wy+sin(q1)*sin(q0)*wx+wz*cos(q1))/cos(q1);
q1d =  sin(q0)*X1(8)+X1(7)*cos(q0)                             ;
q2d = (cos(q0)*X1(8)-sin(q0)*X1(7))/c1                         ;%(cos(q0)*wy-sin(q0)*wx)/cos(q1);
q3d = 0;
q4d = (sin(q5)*(sin(q4)*X2(4)-cos(q4)*X2(5))+X2(6)*cos(q5))/c5 ;
q5d =  sin(q4)*X2(5)+cos(q4)*X2(4)                             ;
q6d = (cos(q4)*X2(5)-sin(q4)*X2(4))/c5                         ;
q7d = X3(2)+q2d;
qfd = -X4(2);
q8d = X5(2)+q7d;
q9d = X6(2)+q6d;

    % 1. find the axis about to rotate and the angle
    v1 = Rm3*[0;0;1];
    v2 = Rm4*[0;0;1];
    w1= cross(v1,v2);
    % 2. use Rodrigues rotation formula to get the new x and y vectors
    x_old = Rm3*[1;0;0];
    y_old = Rm3*[0;1;0];
    x_new = x_old*v1.'*v2+cross(w1,x_old)+w1*w1.'*x_old/(1+v1.'*v2);
    y_new = y_old*v1.'*v2+cross(w1,y_old)+w1*w1.'*y_old/(1+v1.'*v2);
    % 3. calculate angle between the vectors
    qxc = real(x_new.'*Rm4(:,1));
    qyc = real(y_new.'*Rm4(:,2));
    qxs = real(-x_new.'*Rm4(:,2));
    qys = real(y_new.'*Rm4(:,1));
% q3=atan2(qxs,qxc);
% q3=atan2(qxs,qyc);
q3=atan2(qys,qxc);
% q3=atan2(qys,qyc);

s0 =sin(q0);    c0=cos(q0);     s1 =sin(q1);    c1=cos(q1);
s2 =sin(q2);    c2=cos(q2);     s3 =sin(q3);    c3=cos(q3);
s4 =sin(q4);    c4=cos(q4);     s5 =sin(q5);    c5=cos(q5);
s6 =sin(q6);    c6=cos(q6);     s7 =sin(q7);    c7=cos(q7);
s8 =sin(q8);    c8=cos(q8);     s9 =sin(q9);    c9=cos(q9);

% create basic rotation matrices and their derivative
R0 = [c0 -s0 0;s0 c0 0;0 0 1]; R0q = [-s0 -c0 0;c0 -s0 0;0 0 0]; % rear yaw (rate)
R1 = [1 0 0;0 c1 -s1;0 s1 c1]; R1q = [0 0 0;0 -s1 -c1;0 c1 -s1]; % rear roll (rate)
R2 = [c2 0 s2;0 1 0;-s2 0 c2]; R2q = [-s2 0 c2;0 0 0;-c2 0 -s2]; % rear pitch (rate)
R3 = [c3 -s3 0;s3 c3 0;0 0 1];                                   % steer (dependent coordinate)
R4 = [c4 -s4 0;s4 c4 0;0 0 1]; R4q = [-s4 -c4 0;c4 -s4 0;0 0 0]; % front yaw (rate)
R5 = [1 0 0;0 c5 -s5;0 s5 c5]; R5q = [0 0 0;0 -s5 -c5;0 c5 -s5]; % front roll (rate)
R6 = [c6 0 s6;0 1 0;-s6 0 c6]; R6q = [-s6 0 c6;0 0 0;-c6 0 -s6]; % front pitch (rate)
R7 = [c7 0 s7;0 1 0;-s7 0 c7]; R7q = [-s7 0 c7;0 0 0;-c7 0 -s7]; % swingarm angle/angular velocity
R8 = [c8 0 s8;0 1 0;-s8 0 c8]; R8q = [-s8 0 c8;0 0 0;-c8 0 -s8]; % rear wheel angle/angular velocity
R9 = [c9 0 s9;0 1 0;-s9 0 c9]; R9q = [-s9 0 c9;0 0 0;-c9 0 -s9]; % front wheel angle/angular velocity

%         Rb = [cb 0 sb;0 1 0;-sb 0 cb]; R9q = [-sb 0 cb;0 0 0;-cb 0 -sb];
%         Rt = [1 0 0;0 ct -st;0 st ct]; R1q = [0 0 0;0 -st -ct;0 ct -st];

% body orientations
% Rm1 = R0*R1*R8; % rear wheel
% Rm2 = R0*R1*R7; % swingarm
% Rm3 = R0*R1*R2; % frame
% Rm4 = R4*R5*R6; % steering head
% Rm5 = R4*R5*R6; % front fork
% Rm6 = R4*R5*R9; % front wheel

% R8 = eye(3); % rear wheel angle
% R9 = eye(3); % front wheel angle

% joint positions
r4 = [qx qy qz].'                                                     ; % steering joint position
r3 = r4+R0*(R1*(R2*[-l3;0;0]))                                            ; % swingarm joint position
r2 = r4+R0*(R1*(R2*[-l3;0;0]+R7*[-l2;0;0]))                             ; % rear wheel hub position
r1 = r4+R0*(R1*(R2*[-l3;0;0]+R7*[-l2;0;0]+R8*[0;0;-b1]))              ; % rear tire torus centerline lowest point
% r0 = r4+R0*(R1*(R2*[-l3;0;0]+R7*[-l2;0;0]+R8*[0;0;-b1])+[0;0;-a1])  ; % rear wheel lowest point
  r0 = r4+R0*(R1*(R2*[-l3;0;0]+R7*[-l2;0;0]+   [0;0;-b1])+[0;0;-a1])  ; % rear wheel lowest point

r5 = r4+R4*(R5*(R6*[l4;0;-qf]))                                         ; % front wheel hub position
r6 = r4+R4*(R5*(R6*[l4;0;-qf]+R9*[0;0;-b6]))                          ; % front tyre torus centerline
% r7 = r4+R4*(R5*(R6*[l4;0;-qf]+R9*[0;0;-b6])+[0;0;-a6])              ; % front tyre outer surface
  r7 = r4+R4*(R5*(R6*[l4;0;-qf]+   [0;0;-b6])+[0;0;-a6])              ; % front tyre outer surface



r=[r0 r1 r2 r3 r4 r5 r6 r7];


%--------------------------------------------------------------------------
% calculation of the forces
q70=-.2;
qf0=0.3;

% r0d = [ qxd+(-sin(q0)*(-cos(q2)*l3-cos(q7)*l2)+cos(q0)*sin(q1)*(sin(q2)*l3+sin(q7)*l2-b1))*q0d+sin(q0)*cos(q1)*(sin(q2)*l3+sin(q7)*l2-b1)*q1d+(cos(q0)*sin(q2)*l3+sin(q0)*sin(q1)*cos(q2)*l3)*q2d+(cos(q0)*sin(q7)*l2+sin(q0)*sin(q1)*cos(q7)*l2)*q7d-cos(q0)*b1*q8d
%         qyd+(cos(q0)*(-cos(q2)*l3-cos(q7)*l2)+sin(q0)*sin(q1)*(sin(q2)*l3+sin(q7)*l2-b1))*q0d-cos(q0)*cos(q1)*(sin(q2)*l3+sin(q7)*l2-b1)*q1d+(sin(q0)*sin(q2)*l3-cos(q0)*sin(q1)*cos(q2)*l3)*q2d+(sin(q0)*sin(q7)*l2-cos(q0)*sin(q1)*cos(q7)*l2)*q7d-sin(q0)*b1*q8d
%         qzd-sin(q1)*(sin(q2)*l3+sin(q7)*l2-b1)*q1d+cos(q1)*cos(q2)*l3*q2d+cos(q1)*cos(q7)*l2*q7d];
% 
% r7d=[   qxd+(-sin(q4)*(cos(q6)*l4-sin(q6)*qf)+cos(q4)*sin(q5)*(-sin(q6)*l4-cos(q6)*qf-b6))*q4d+sin(q4)*cos(q5)*(-sin(q6)*l4-cos(q6)*qf-b6)*q5d+(cos(q4)*(-sin(q6)*l4-cos(q6)*qf)+sin(q4)*sin(q5)*(-cos(q6)*l4+sin(q6)*qf))*q6d+(-cos(q4)*sin(q6)-sin(q4)*sin(q5)*cos(q6))*qfd-cos(q4)*b6*q9d
%         qyd+(cos(q4)*(cos(q6)*l4-sin(q6)*qf)+sin(q4)*sin(q5)*(-sin(q6)*l4-cos(q6)*qf-b6))*q4d-cos(q4)*cos(q5)*(-sin(q6)*l4-cos(q6)*qf-b6)*q5d+(sin(q4)*(-sin(q6)*l4-cos(q6)*qf)-cos(q4)*sin(q5)*(-cos(q6)*l4+sin(q6)*qf))*q6d+(-sin(q4)*sin(q6)+cos(q4)*sin(q5)*cos(q6))*qfd-sin(q4)*b6*q9d
%         qzd-sin(q5)*(-sin(q6)*l4-cos(q6)*qf-b6)*q5d+cos(q5)*(-cos(q6)*l4+sin(q6)*qf)*q6d-cos(q5)*cos(q6)*qfd];

r0d =[qxd+(-sin(q0)*(-cos(q2)*l3-cos(q7)*l2)-cos(q0)*(-cos(q1)*sin(q1)*a1-sin(q1)*(sin(q2)*l3+sin(q7)*l2-b1-cos(q1)*a1)))*q0d+sin(q0)*cos(q1)*(sin(q2)*l3+sin(q7)*l2-b1-cos(q1)*a1)*q1d+(cos(q0)*sin(q2)*l3+sin(q0)*sin(q1)*cos(q2)*l3)*q2d+(cos(q0)*sin(q7)*l2+sin(q0)*sin(q1)*cos(q7)*l2)*q7d+cos(q0)*(-b1-cos(q1)*a1)*q8d
      qyd+(cos(q0)*(-cos(q2)*l3-cos(q7)*l2)-sin(q0)*(-cos(q1)*sin(q1)*a1-sin(q1)*(sin(q2)*l3+sin(q7)*l2-b1-cos(q1)*a1)))*q0d-cos(q0)*cos(q1)*(sin(q2)*l3+sin(q7)*l2-b1-cos(q1)*a1)*q1d+(sin(q0)*sin(q2)*l3-cos(q0)*sin(q1)*cos(q2)*l3)*q2d+(sin(q0)*sin(q7)*l2-cos(q0)*sin(q1)*cos(q7)*l2)*q7d+sin(q0)*(-b1-cos(q1)*a1)*q8d
      qzd-sin(q1)*(sin(q2)*l3+sin(q7)*l2-b1-cos(q1)*a1)*q1d+cos(q1)*cos(q2)*l3*q2d+cos(q1)*cos(q7)*l2*q7d];
r7d =[qxd+(-sin(q4)*(cos(q6)*l4-sin(q6)*qf)-cos(q4)*(-cos(q5)*sin(q5)*a6-sin(q5)*(-sin(q6)*l4-cos(q6)*qf-b6-cos(q5)*a6)))*q4d+sin(q4)*cos(q5)*(-sin(q6)*l4-cos(q6)*qf-b6-cos(q5)*a6)*q5d+(cos(q4)*(-sin(q6)*l4-cos(q6)*qf)+sin(q4)*sin(q5)*(-cos(q6)*l4+sin(q6)*qf))*q6d+(-cos(q4)*sin(q6)-sin(q4)*sin(q5)*cos(q6))*qfd+cos(q4)*(-b6-cos(q5)*a6)*q9d
      qyd+(cos(q4)*(cos(q6)*l4-sin(q6)*qf)-sin(q4)*(-cos(q5)*sin(q5)*a6-sin(q5)*(-sin(q6)*l4-cos(q6)*qf-b6-cos(q5)*a6)))*q4d-cos(q4)*cos(q5)*(-sin(q6)*l4-cos(q6)*qf-b6-cos(q5)*a6)*q5d+(sin(q4)*(-sin(q6)*l4-cos(q6)*qf)-cos(q4)*sin(q5)*(-cos(q6)*l4+sin(q6)*qf))*q6d+(-sin(q4)*sin(q6)+cos(q4)*sin(q5)*cos(q6))*qfd+sin(q4)*(-b6-cos(q5)*a6)*q9d
      qzd-sin(q5)*(-sin(q6)*l4-cos(q6)*qf-b6-cos(q5)*a6)*q5d+cos(q5)*(-cos(q6)*l4+sin(q6)*qf)*q6d-cos(q5)*cos(q6)*qfd];


vtr=-s0*r0d(1)+c0*r0d(2);
vlr= c0*r0d(1)+s0*r0d(2)+.01;
vtf=-s4*r7d(1)+c4*r7d(2);
vlf= c4*r7d(1)+s4*r7d(2)+.01;
vx = c0*qxd+s0*qyd;
Frs = k2*(q2-q7-q70)+b2*(q2d-q7d);
Ffs = k5*(qf-p5)+d5*qfd*(qfd<0)+e5*qfd*(qfd>0)-k3*(qf<b5)+k3*(qf>t5);

Fzr = max((-k1*r0(3)-d1*r0d(3))*(r0(3)<0),0) ;
Ftr = t1*Fzr*atan(-vtr/vlr);
Flr = Fzr*min(max(f1*((b1+a1*cos(q1))*q8d/vlr-1),-1),1);

Fzf = max((-k1*r7(3)-d1*r7d(3))*(r7(3)<0),0) ;
Ftf = t6*Fzf*atan(-vtf/vlf);
Flf = Fzf*min(max(f6*((b6+a6*cos(q5))*q9d/vlf-1),-1),1);

Fr  = [cos(q0)*Flr-sin(q0)*Ftr sin(q0)*Flr+cos(q0)*Ftr Fzr].';
Ff  = [cos(q4)*Flf-sin(q4)*Ftf sin(q4)*Flf+cos(q4)*Ftf Fzf].';

%% experiment
sr    =  r0d(1:2);
Fr    =  Fzr*[-1*(sr./((sr.'*sr)^4+1)^(1/8)+sr./((sr.'*sr)^2+1));1];

sf    =  r7d(1:2);
Ff    =  Fzf*[-1*(sf./((sf.'*sf)^4+1)^(1/8)+sf./((sf.'*sf)^2+1));1];
%% end of experiment

Mr  = cross(Fr,r2(1:3)-r0(1:3));
Mf  = cross(Ff,r5(1:3)-r7(1:3));

F1  = [Mr;Fr];
F2  = [Mf;Ff];

% F1 = [0;0;0;0 ;0;(-pk1*r0(3)-pd1*r0d(3))*(r0(3)<0)];%[0 ;0; (-100*r0(3)-10*r0d(3))]; % Normal force on ground plane
% F2 = [0;0;0;0 ;0;(-1000000*r7(3)-1000*r7d(3))*(r7(3)<0)];%[0 ;0; (-1000*r7(3)-100*r7d(3))];
% F2 = [0;0;0];
% 1 calculate angle between z-vectors
% 2 calculate vector perpendicular to z-vectors
% 3 apply a torque in that direction

% T1 =  1000*acos(complex(dot(v1,v2)))*cross(v1,v2);% acos is unstable (complex numbers arise)

T3  = -u(2)*(v1+v2)/norm(v1+v2);

T1 = k3*(pi/2-dot(v1,v2))*cross(v1,v2)+T3;
T2 = -T1;

Frb = u(1)*(u(1)>0);
Ffb = u(1)*(u(1)<0);
% Ffs = front suspension force
% Ffr = rear suspension force

q  = [qx  qy  qz  q0  q1  q2  q4  q5  q6  q7  qf  q8  q9].';
qd = [qxd qyd qzd q0d q1d q2d q4d q5d q6d q7d qfd q8d q9d].';






% BUS = [r0;r0d;vtr;vlr;Fzr;Ftr;Flr;r7d;vtf;vlf;Fzf;Ftf;Flf];
% % % vtr=-sin(q0)*vxr+cos(q0)*vyr;
% % % vlr= cos(q0)*vxr+sin(q0)*vyr;
% % % vtf=-sin(q8)*vxf+cos(q8)*vyf;
% % % vlf= cos(q8)*vxf+sin(q8)*vyf;
% % % Fz  = (((-k*z-b*zd)+sqrt((-k*z-b*zd)^2))*(z-sqrt(z^2))*z/(z^2+dzr/k))/4;
% % % Ft  = bt*Fz*atan(-vt*vl/(vl^2+dtr));
% % % Fl  = bl*Fz*((br+cr*cos(q1))*q9d-vl);
% % %
% % %
% % % F1  = [cos(q0)*Fl-sin(q0)*Ft sin(q0)*Fl+cos(q0)*Ft Fz].';
% % %
% % % M=cross(F1,O2(1:3)-O0(1:3));

% %-----------------------------------------------------------------------------------------%
% % everything below this line is for checking only and can be removed in the final version %
% %-----------------------------------------------------------------------------------------%
% Rx0 = [cos(q0) -sin(q0) 0;sin(q0) cos(q0) 0;0 0 1];   % orientation of frame 1 w.r.t inertial reference frame (yaw) p0=R10*p1)
% Rx1 = [1 0 0;0 cos(q1) -sin(q1);0 sin(q1) cos(q1)];   % roll angle (lean angle)
% Rx2 = [cos(q2) 0 sin(q2);0 1 0;-sin(q2) 0 cos(q2)];   % pitch angle
% wx=x1(7);
% wy=x1(8);
% wz=x1(9);
% check1 = Rx0*Rx1*Rx2*[x12(7);x12(8);x12(9)];
% wx1=check1(1);
% wy1=check1(2);
% wz1=check1(3);