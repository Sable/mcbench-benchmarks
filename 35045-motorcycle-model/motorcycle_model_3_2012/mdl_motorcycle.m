%#eml
function [qdd,Fzf,Fzr,Flr,Ftr,Flf,Ftf,vlr,vtr,vlf,vtf,r0,r7,IMU,fx,hx]         = mdl_motorcycle(u,x,p)
% from nonlinear state space to generalized coordinates
qd=x(1:13);
q =x(14:26);
% coordinates
qx = q(1)  ; qxd = qd(1) ; qy = q(2)  ; qyd = qd(2) ; qz = q(3)  ; qzd = qd(3);
q0 = q(4)  ; q0d = qd(4) ; q1 = q(5)  ; q1d = qd(5) ; q2 = q(6)  ; q2d = qd(6);
q4 = q(7)  ; q4d = qd(7) ; q5 = q(8)  ; q5d = qd(8) ; q6 = q(9)  ; q6d = qd(9);
q7 = q(10) ; q7d = qd(10); qf = q(11) ; qfd = qd(11);
q8 = q(12) ; q8d = qd(12); q9 = q(13) ; q9d = qd(13);

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
             
u7=p(57); v7=p(58); w7=p(59); x7=p(60); y7=p(61); z7=p(62);
I1x=j1;I1y=i1;I1z=j1;I2x=i2;I2y=i2;I2z=i2;I3x=i3;I3y=i3;I3z=i3;
I4x=i4;I4y=i4;I4z=i4;I5x=i5;I5y=i5;I5z=i5;I6x=j6;I6y=i6;I6z=j6;

% trigonometry
s0 = sin(q0); c0 = cos(q0); s1 = sin(q1); c1 = cos(q1); s2 = sin(q2);c2 = cos(q2);
s4 = sin(q4); c4 = cos(q4); s5 = sin(q5); c5 = cos(q5); s6 = sin(q6);c6 = cos(q6);
s7 = sin(q7); c7 = cos(q7); s8 = sin(q8); c8 = cos(q8); s9 = sin(q9);c9 = cos(q9);

% basic rotations
R0 = [c0 -s0 0;s0 c0 0;0 0 1]; R0q = [-s0 -c0 0;c0 -s0 0;0 0 0]; %rear yaw
R1 = [1 0 0;0 c1 -s1;0 s1 c1]; R1q = [0 0 0;0 -s1 -c1;0 c1 -s1]; %rear roll
R2 = [c2 0 s2;0 1 0;-s2 0 c2]; R2q = [-s2 0 c2;0 0 0;-c2 0 -s2]; %rear pitch
R4 = [c4 -s4 0;s4 c4 0;0 0 1]; R4q = [-s4 -c4 0;c4 -s4 0;0 0 0]; %front yaw
R5 = [1 0 0;0 c5 -s5;0 s5 c5]; R5q = [0 0 0;0 -s5 -c5;0 c5 -s5]; %front roll
R6 = [c6 0 s6;0 1 0;-s6 0 c6]; R6q = [-s6 0 c6;0 0 0;-c6 0 -s6]; %front pitch
R7 = [c7 0 s7;0 1 0;-s7 0 c7]; R7q = [-s7 0 c7;0 0 0;-c7 0 -s7]; %swingarm angle
R8 = [c8 0 s8;0 1 0;-s8 0 c8]; R8q = [-s8 0 c8;0 0 0;-c8 0 -s8]; %rear wheel angle
R9 = [c9 0 s9;0 1 0;-s9 0 c9]; R9q = [-s9 0 c9;0 0 0;-c9 0 -s9]; %front wheel angle

% inertia matrix;
sa = m3*(x3-l3)-(m1+m2)*l3;
sb = m3*z3;
sc = m2*(x2-l2)-m1*l2;
sd = m4*x4+m5*(l4+x5)+m6*l4;
se = m4*z4+m5*z5;
sf = -m5-m6;
sg = m1*l2^2+m2*(x2-l2)^2+I2y;
sh = m6*l4+m5*(l4+x5);
si = 2*m5*z5;
sj = m4*(x4^2+z4^2)+m5*((l4+x5)^2+z5^2)+I4y+I5y+m6*l4^2;
sk = m5*(l4+x5)+m6*l4;
sl = (m1+m2)*l3^2+m3*((-l3+x3)^2+z3^2)+I3y;
sm = l3*(m1*l2+m2*(l2-x2));
sn = m3*(z3^2+x3^2)+l3*((m1+m2+m3)*l3-2*m3*x3)+I3y;
so = l3*sc;
sp = I5z-I5x+I4z-I4x;

M          = (m1+m2+m3+m4+m5+m6)*eye(13);
M(1:3,4:11)= [R0q*(R1*(R2*[sa;0;sb]+R7*[sc;0;0])) R0*(R1q*(R2*[sa;0;sb]+R7*[sc;0;0])) R0*(R1*(R2q*[sa;0;sb])) R4q*(R5*(R6*[sd;0;se+sf*qf])) R4*(R5q*(R6*[sd;0;se+sf*qf])) R4*(R5*(R6q*[sd;0;se+sf*qf])) R0*(R1*(R7q*[sc;0;0])) R4*(R5*(R6*[0;0;sf]))];
M(4,4)     = [1 1 0]*R1.^2*((m1*(R2*[-l3;0;0]+R7*[-l2;0;0]).^2+m2*(R2*[-l3;0;0]+R7*[-l2+x2;0;0]).^2+m3*(R2*[-l3+x3;0;z3]).^2))+I3y+I2y+I1y+c1^2*(I1x-I1y+I2x-I2y+I3x-I3y+c7^2*(I2z-I2x)+c2^2*(I3z-I3x));
M(4,5)     = -c1*(m1*(-c2*l3-c7*l2)*(s2*l3+s7*l2)+m2*(-c2*l3-c7*l2+c7*x2)*(s2*l3+s7*l2-s7*x2)+m3*(-c2*l3+c2*x3+s2*z3)*(s2*l3-s2*x3+c2*z3))+c1*s7*c7*(I2z-I2x)+c1*s2*c2*(I3z-I3x);
M(4,6)     = s1*(sn-cos(q2-q7)*so);
M(4,10)    = s1*(sg+cos(q2-q7)*sm);
M(4,12)    = I1y*s1;
M(5,5)     = m1*(s2*l3+s7*l2)^2+m2*(s2*l3-s7*(-l2+x2))^2+m3*(-s2*(-l3+x3)+c2*z3)^2+c7^2*(I2x-I2z)+c2^2*(I3x-I3z)+I3z+I2z+I1x;
M(6,6)     = sl;
M(6,10)    = cos(q2-q7)*sm;
M(7,7)     = [1 1 0]*(R5.^2*(m4*(R6*[x4;0;z4]).^2+m5*(R6*[l4+x5;0;-qf+z5]).^2+m6*(R6*[l4;0;-qf]).^2))+I6y+I5y+I4y+c5^2*(I6x-I6y+I5x-I5y+I4x-I4y+c6^2*sp);
M(7,8)     = -c5*(c6*s6*(m4*(z4^2-x4^2)+m5*((z5-qf)^2-(l4+x5)^2)+m6*(qf^2-l4^2))+cos(2*q6)*(m4*x4*z4+m5*(l4+x5)*(z5-qf)-m6*l4*qf))+c5*s6*c6*sp;
M(7,9)     = s5*(sj-sf*qf^2-si*qf);
M(7,11)    = s5*sk;
M(7,13)    = I6y*s5;
M(8,8)     = m4*(c6*z4-s6*x4)^2+m5*(-s6*(l4+x5)+c6*(z5-qf))^2+m6*(-s6*l4-c6*qf)^2-c6^2*sp+I4z+I5z+I6x;
M(9,9)     = sj-sf*qf^2-si*qf;
M(9,11)    = sh;
M(10,10)   = sg;
M(11,11)   = -sf;
M(12,12)   = I1y;
M(13,13)   = I6y;
M          = M.'+triu(M,1);

% Christoffel matrix
s=[m6*(-s6*l4-c6*qf)*c6;-s6*(l4+x5)+c6*(-qf+z5);c5*(c6*s6*(m5*(2*qf-2*z5)+2*m6*qf)+cos(2*q6)*(-m5*(l4+x5)-m6*l4));c6*(l4+x5)+s6*(-qf+z5);s1*sin(q2-q7)*sm;s1*sin(q2-q7)*so;s2*l3-s7*(-l2+x2);m1*(s2*l3+s7*l2)*c7*l2;c1*(sg+cos(q2-q7)*sm);-c2*l3-c7*l2+c7*x2;s2*l3+s7*l2-s7*x2;c1*(m1*s7*l2*(s2*l3+s7*l2)+m1*...
   (-c2*l3-c7*l2)*c7*l2+m2*(s7*l2-s7*x2)*(s2*l3+s7*l2-s7*x2)+m2*(-c2*l3-c7*l2+c7*x2)*(c7*l2-c7*x2));-c2*l3+c7*(-l2+x2);m6*(-s6*l4-c6*qf)*(-c6*l4+s6*qf);m5*(-s6*(l4+x5)+c6*(-qf+z5))*(-c6*(l4+x5)-s6*(-qf+z5));m4*(-s6*x4+c6*z4)*(-c6*x4-s6*z4);c5*(sj-sf*qf^2-si*qf);m4*x4*z4+m5*(l4+x5)*(-qf+z5)-m6*l4*qf;...
   m4*(z4^2-x4^2)+m5*((-qf+z5)^2-(l4+x5)^2)+m6*(qf^2-l4^2);c5*(-s6^2*(m4*(z4^2-x4^2)+m5*((-qf+z5)^2-(l4+x5)^2)+m6*(qf^2-l4^2))+c6^2*(m4*(z4^2-x4^2)+m5*((-qf+z5)^2-(l4+x5)^2)+m6*(qf^2-l4^2))-2*sin(2*q6)*(m4*x4*z4+m5*(l4+x5)*(-qf+z5)-m6*l4*qf));-c6*sd-s6*(se+sf*qf);-s6*sd+c6*(se+sf*qf);c5*(I6x-I6y+I5x...
   -I5y+I4x-I4y+c6^2*sp)*s5;s5*(m4*(-s6*x4+c6*z4)^2+m5*(-s6*(l4+x5)+c6*(-qf+z5))^2+m6*(-s6*l4-c6*qf)^2)*c5;-s2*(-l3+x3)+c2*z3;m3*(-s2*(-l3+x3)+c2*z3)*(-c2*(-l3+x3)-s2*z3);m1*(s2*l3+s7*l2)*c2*l3;c1*(sn-cos(q2-q7)*so);-c2*l3+c2*x3+s2*z3;s2*l3-s2*x3+c2*z3;c1*(m1*s2*l3*(s2*l3+s7*l2)+m1*(-c2*l3-c7*l2)*c2*...
   l3+m2*s2*l3*(s2*l3+s7*l2-s7*x2)+m2*(-c2*l3-c7*l2+c7*x2)*c2*l3+m3*(s2*l3-s2*x3+c2*z3)^2+m3*(-c2*l3+c2*x3+s2*z3)*(c2*l3-c2*x3-s2*z3));c1*(I1x-I1y+I2x-I2y+I3x-I3y+c7^2*(I2z-I2x)+c2^2*(I3z-I3x))*s1;s1*(m1*(s2*l3+s7*l2)^2+m2*(s2*l3-s7*(-l2+x2))^2+m3*(-s2*(-l3+x3)+c2*z3)^2)*c1;-s2*sa+c2*sb-s7*sc];
C=[0 0 0 (-c0*(c2*sa+s2*sb+c7*sc)-s0*s1*s(34))*q0d+c0*c1*s(34)*q1d+(-s0*(-s2*sa+c2*sb)+c0*s1*(-c2*sa-s2*sb))*q2d+(s0*s7*sc-c0*s1*c7*sc)*q7d c0*c1*s(34)*q0d-s0*s1*s(34)*q1d+s0*c1*(-c2*sa-s2*sb)*q2d-s0*c1*c7*sc*q7d (-s0*(-s2*sa+c2*sb)+c0*s1*(-c2*sa-s2*sb))*q0d+s0*c1*(-c2*sa-s2*sb)*q1d+(c0*(-c2*sa-s2*...
   sb)+s0*s1*(s2*sa-c2*sb))*q2d (-c4*(c6*sd+s6*(se+sf*qf))-s4*s5*s(22))*q4d+c4*c5*s(22)*q5d+(-s4*s(22)+c4*s5*s(21))*q6d+(-s4*s6*sf+c4*s5*c6*sf)*qfd c4*c5*s(22)*q4d-s4*s5*s(22)*q5d+s4*c5*s(21)*q6d+s4*c5*c6*sf*qfd (-s4*s(22)+c4*s5*s(21))*q4d+s4*c5*s(21)*q5d+(c4*s(21)+s4*s5*(s6*sd-c6*(se+sf*qf)))*q6d+...
   (c4*c6*sf-s4*s5*s6*sf)*qfd (s0*s7*sc-c0*s1*c7*sc)*q0d-s0*c1*c7*sc*q1d+(-c0*c7*sc+s0*s1*s7*sc)*q7d (-s4*s6*sf+c4*s5*c6*sf)*q4d+s4*c5*c6*sf*q5d+(c4*c6*sf-s4*s5*s6*sf)*q6d 0 0 ;0 0 0 (-s0*(c2*sa+s2*sb+c7*sc)+c0*s1*s(34))*q0d+s0*c1*s(34)*q1d+(c0*(-s2*sa+c2*sb)+s0*s1*(-c2*sa-s2*sb))*q2d+(-c0*s7*sc-s0*...
   s1*c7*sc)*q7d s0*c1*s(34)*q0d+c0*s1*s(34)*q1d-c0*c1*(-c2*sa-s2*sb)*q2d+c0*c1*c7*sc*q7d (c0*(-s2*sa+c2*sb)+s0*s1*(-c2*sa-s2*sb))*q0d-c0*c1*(-c2*sa-s2*sb)*q1d+(s0*(-c2*sa-s2*sb)-c0*s1*(s2*sa-c2*sb))*q2d (-s4*(c6*sd+s6*(se+sf*qf))+c4*s5*s(22))*q4d+s4*c5*s(22)*q5d+(c4*s(22)+s4*s5*s(21))*q6d+(c4*s6*sf+...
   s4*s5*c6*sf)*qfd s4*c5*s(22)*q4d+c4*s5*s(22)*q5d-c4*c5*s(21)*q6d-c4*c5*c6*sf*qfd (c4*s(22)+s4*s5*s(21))*q4d-c4*c5*s(21)*q5d+(s4*s(21)-c4*s5*(s6*sd-c6*(se+sf*qf)))*q6d+(s4*c6*sf+c4*s5*s6*sf)*qfd (-c0*s7*sc-s0*s1*c7*sc)*q0d+c0*c1*c7*sc*q1d+(-s0*c7*sc-c0*s1*s7*sc)*q7d (c4*s6*sf+s4*s5*c6*sf)*q4d-c4*...
   c5*c6*sf*q5d+(s4*c6*sf+c4*s5*s6*sf)*q6d 0 0 ;0 0 0 0 -c1*s(34)*q1d-s1*(-c2*sa-s2*sb)*q2d+s1*c7*sc*q7d -s1*(-c2*sa-s2*sb)*q1d+c1*(s2*sa-c2*sb)*q2d 0 -c5*s(22)*q5d-s5*s(21)*q6d-s5*c6*sf*qfd -s5*s(21)*q5d+c5*(s6*sd-c6*(se+sf*qf))*q6d-c5*s6*sf*qfd s1*c7*sc*q1d+c1*s7*sc*q7d -s5*c6*sf*q5d-c5*s6*sf*q6d ...
   0 0 ;0 0 0 (s(33)-s(32))*q1d+(m1*(-c2*l3-c7*l2)*s2*l3+m2*s(13)*s2*l3+m3*(c2*(-l3+x3)+s2*z3)*s(25)+1/2*s1^2*(2*s(27)+2*m2*s(7)*c2*l3+2*s(26))-c1^2*c2*(I3z-I3x)*s2)*q2d+(m1*(-c2*l3-c7*l2)*s7*l2-m2*s(13)*s7*(-l2+x2)+1/2*s1^2*(2*s(8)-2*m2*s(7)*c7*(-l2+x2))-c1^2*c7*(I2z-I2x)*s7)*q7d (s(33)-s(32))*q0d+...
   (s1*(m1*(-c2*l3-c7*l2)*(s2*l3+s7*l2)+m2*s(10)*s(11)+m3*s(29)*s(30))-s1*s7*c7*(I2z-I2x)-s1*s2*c2*(I3z-I3x))*q1d+(1/2*s(28)-1/2*s(31)+1/2*c1*c2^2*(I3z-I3x)-1/2*c1*s2^2*(I3z-I3x))*q2d+(1/2*s(9)-1/2*s(12)+1/2*c1*c7^2*(I2z-I2x)-1/2*c1*s7^2*(I2z-I2x))*q7d+1/2*I1y*c1*q8d (m1*(-c2*l3-c7*l2)*s2*l3+m2*s(13)...
   *s2*l3+m3*(c2*(-l3+x3)+s2*z3)*s(25)+1/2*s1^2*(2*s(27)+2*m2*s(7)*c2*l3+2*s(26))-c1^2*c2*(I3z-I3x)*s2)*q0d+(1/2*s(28)-1/2*s(31)+1/2*c1*c2^2*(I3z-I3x)-1/2*c1*s2^2*(I3z-I3x))*q1d+s1*sin(q2-q7)*so*q2d+(-1/2*s(5)-1/2*s(6))*q7d 0 0 0 (m1*(-c2*l3-c7*l2)*s7*l2-m2*s(13)*s7*(-l2+x2)+1/2*s1^2*(2*s(8)-2*m2*...
   s(7)*c7*(-l2+x2))-c1^2*c7*(I2z-I2x)*s7)*q0d+(1/2*s(9)-1/2*s(12)+1/2*c1*c7^2*(I2z-I2x)-1/2*c1*s7^2*(I2z-I2x))*q1d+(-1/2*s(5)-1/2*s(6))*q2d+s1*sin(q2-q7)*sm*q7d 0 1/2*I1y*c1*q1d 0 ;0 0 0 (-s(33)+s(32))*q0d+(-1/2*s(31)+1/2*c1*c2^2*(I3z-I3x)-1/2*c1*s2^2*(I3z-I3x)-1/2*s(28))*q2d+(-1/2*s(12)+1/2*c1*...
   c7^2*(I2z-I2x)-1/2*c1*s7^2*(I2z-I2x)-1/2*s(9))*q7d-1/2*I1y*c1*q8d (s(27)+m2*s(7)*c2*l3+s(26)-c2*(I3x-I3z)*s2)*q2d+(s(8)-m2*s(7)*c7*(-l2+x2)-c7*(I2x-I2z)*s7)*q7d (-1/2*s(31)+1/2*c1*c2^2*(I3z-I3x)-1/2*c1*s2^2*(I3z-I3x)-1/2*s(28))*q0d+(s(27)+m2*s(7)*c2*l3+s(26)-c2*(I3x-I3z)*s2)*q1d 0 0 0 (-1/2*s(12)...
   +1/2*c1*c7^2*(I2z-I2x)-1/2*c1*s7^2*(I2z-I2x)-1/2*s(9))*q0d+(s(8)-m2*s(7)*c7*(-l2+x2)-c7*(I2x-I2z)*s7)*q1d 0 -1/2*I1y*c1*q0d 0 ;0 0 0 (-m1*(-c2*l3-c7*l2)*s2*l3-m2*s(13)*s2*l3-m3*(c2*(-l3+x3)+s2*z3)*s(25)-1/2*s1^2*(2*s(27)+2*m2*s(7)*c2*l3+2*s(26))+c1^2*c2*(I3z-I3x)*s2)*q0d+(1/2*s(28)+1/2*s(31)-1/2*...
   c1*c2^2*(I3z-I3x)+1/2*c1*s2^2*(I3z-I3x))*q1d+(-1/2*s(6)+1/2*s(5))*q7d (1/2*s(28)+1/2*s(31)-1/2*c1*c2^2*(I3z-I3x)+1/2*c1*s2^2*(I3z-I3x))*q0d+(-s(27)-m2*s(7)*c2*l3-s(26)+c2*(I3x-I3z)*s2)*q1d 0 0 0 0 (-1/2*s(6)+1/2*s(5))*q0d+sin(q2-q7)*sm*q7d 0 0 0 ;0 0 0 0 0 0 (s(24)-s(23))*q5d+(m4*(c6*x4+s6*z4)*...
   (-s6*x4+c6*z4)+m5*s(4)*s(2)+m6*(c6*l4-s6*qf)*(-s6*l4-c6*qf)+1/2*s5^2*(2*s(16)+2*s(15)+2*s(14))-c5^2*c6*sp*s6)*q6d+(-m5*s(4)*s6-m6*(c6*l4-s6*qf)*s6+1/2*s5^2*(-2*m5*s(2)*c6-2*s(1)))*qfd (s(24)-s(23))*q4d+(s5*(c6*s6*s(19)+cos(2*q6)*s(18))-s5*s6*c6*sp)*q5d+(1/2*s(17)-1/2*s(20)+1/2*c5*c6^2*sp-1/2*c5*...
   s6^2*sp)*q6d+(1/2*c5*sk-1/2*s(3))*qfd+1/2*I6y*c5*q9d (m4*(c6*x4+s6*z4)*(-s6*x4+c6*z4)+m5*s(4)*s(2)+m6*(c6*l4-s6*qf)*(-s6*l4-c6*qf)+1/2*s5^2*(2*s(16)+2*s(15)+2*s(14))-c5^2*c6*sp*s6)*q4d+(1/2*s(17)-1/2*s(20)+1/2*c5*c6^2*sp-1/2*c5*s6^2*sp)*q5d+1/2*s5*(-2*sf*qf-si)*qfd 0 (-m5*s(4)*s6-m6*(c6*l4-s6*qf)...
   *s6+1/2*s5^2*(-2*m5*s(2)*c6-2*s(1)))*q4d+(1/2*c5*sk-1/2*s(3))*q5d+1/2*s5*(-2*sf*qf-si)*q6d 0 1/2*I6y*c5*q5d ;0 0 0 0 0 0 (-s(24)+s(23))*q4d+(-1/2*s(20)+1/2*c5*c6^2*sp-1/2*c5*s6^2*sp-1/2*s(17))*q6d+(-1/2*s(3)-1/2*c5*sk)*qfd-1/2*I6y*c5*q9d (s(16)+s(15)+s(14)+c6*sp*s6)*q6d+(-m5*s(2)*c6-s(1))*qfd ...
   (-1/2*s(20)+1/2*c5*c6^2*sp-1/2*c5*s6^2*sp-1/2*s(17))*q4d+(s(16)+s(15)+s(14)+c6*sp*s6)*q5d 0 (-1/2*s(3)-1/2*c5*sk)*q4d+(-m5*s(2)*c6-s(1))*q5d 0 -1/2*I6y*c5*q4d ;0 0 0 0 0 0 (-m4*(c6*x4+s6*z4)*(-s6*x4+c6*z4)-m5*s(4)*s(2)-m6*(c6*l4-s6*qf)*(-s6*l4-c6*qf)-1/2*s5^2*(2*s(16)+2*s(15)+2*s(14))+c5^2*c6*sp*...
   s6)*q4d+(1/2*s(17)+1/2*s(20)-1/2*c5*c6^2*sp+1/2*c5*s6^2*sp)*q5d+1/2*s5*(-2*sf*qf-si)*qfd (1/2*s(17)+1/2*s(20)-1/2*c5*c6^2*sp+1/2*c5*s6^2*sp)*q4d+(-s(16)-s(15)-s(14)-c6*sp*s6)*q5d (-sf*qf-1/2*si)*qfd 0 1/2*s5*(-2*sf*qf-si)*q4d+(-sf*qf-1/2*si)*q6d 0 0 ;0 0 0 (-m1*(-c2*l3-c7*l2)*s7*l2+m2*s(13)*s7*...
   (-l2+x2)-1/2*s1^2*(2*s(8)-2*m2*s(7)*c7*(-l2+x2))+c1^2*c7*(I2z-I2x)*s7)*q0d+(1/2*s(9)+1/2*s(12)-1/2*c1*c7^2*(I2z-I2x)+1/2*c1*s7^2*(I2z-I2x))*q1d+(-1/2*s(5)+1/2*s(6))*q2d (1/2*s(9)+1/2*s(12)-1/2*c1*c7^2*(I2z-I2x)+1/2*c1*s7^2*(I2z-I2x))*q0d+(-s(8)+m2*s(7)*c7*(-l2+x2)+c7*(I2x-I2z)*s7)*q1d (-1/2*s(5)+...
   1/2*s(6))*q0d-sin(q2-q7)*sm*q2d 0 0 0 0 0 0 0 ;0 0 0 0 0 0 (m5*s(4)*s6+m6*(c6*l4-s6*qf)*s6-1/2*s5^2*(-2*m5*s(2)*c6-2*s(1)))*q4d+(1/2*c5*sk+1/2*s(3))*q5d-1/2*s5*(-2*sf*qf-si)*q6d (1/2*c5*sk+1/2*s(3))*q4d+(m5*s(2)*c6+s(1))*q5d -1/2*s5*(-2*sf*qf-si)*q4d+(sf*qf+1/2*si)*q6d 0 0 0 0 ;0 0 0 1/2*I1y*c1*...
   q1d 1/2*I1y*c1*q0d 0 0 0 0 0 0 0 0 ;0 0 0 0 0 0 1/2*I6y*c5*q5d 1/2*I6y*c5*q4d 0 0 0 0 0 ];

% preparation on force calculation
g=9.81;
q70=-.2;
qf0=0.3;

r0d =[qxd+(-s0*(-c2*l3-c7*l2)-c0*(-c1*s1*a1-s1*(s2*l3+s7*l2-b1-c1*a1)))*q0d+s0*c1*(s2*l3+s7*l2-b1-c1*a1)*q1d+(c0*s2*l3+s0*s1*c2*l3)*q2d+(c0*s7*l2+s0*s1*c7*l2)*q7d+c0*(-b1-c1*a1)*q8d
      qyd+(c0*(-c2*l3-c7*l2)-s0*(-c1*s1*a1-s1*(s2*l3+s7*l2-b1-c1*a1)))*q0d-c0*c1*(s2*l3+s7*l2-b1-c1*a1)*q1d+(s0*s2*l3-c0*s1*c2*l3)*q2d+(s0*s7*l2-c0*s1*c7*l2)*q7d+s0*(-b1-c1*a1)*q8d
      qzd-s1*(s2*l3+s7*l2-b1-c1*a1)*q1d+c1*c2*l3*q2d+c1*c7*l2*q7d];
r7d =[qxd+(-s4*(c6*l4-s6*qf)-c4*(-c5*s5*a6-s5*(-s6*l4-c6*qf-b6-c5*a6)))*q4d+s4*c5*(-s6*l4-c6*qf-b6-c5*a6)*q5d+(c4*(-s6*l4-c6*qf)+s4*s5*(-c6*l4+s6*qf))*q6d+(-c4*s6-sin(q4)*s5*c6)*qfd+c4*(-b6-c5*a6)*q9d
      qyd+(c4*(c6*l4-s6*qf)-s4*(-c5*s5*a6-s5*(-s6*l4-c6*qf-b6-c5*a6)))*q4d-c4*c5*(-s6*l4-c6*qf-b6-c5*a6)*q5d+(s4*(-s6*l4-c6*qf)-c4*s5*(-c6*l4+s6*qf))*q6d+(-s4*s6+c4*s5*c6)*qfd+s4*(-b6-c5*a6)*q9d
      qzd-s5*(-s6*l4-c6*qf-b6-c5*a6)*q5d+c5*(-c6*l4+s6*qf)*q6d-c5*c6*qfd];

r0  = [0;0;qz+c1*(s2*l3+s7*l2-b1)-a1];
r7  = [0;0;qz-c5*(s6*l4+c6*qf+b6)-a6];
vtr =-s0*r0d(1)+c0*r0d(2);
vlr = c0*r0d(1)+s0*r0d(2)+.01;
vtf =-s4*r7d(1)+c4*r7d(2);
vlf = c4*r7d(1)+s4*r7d(2)+.01;
v1  = [c0*s2+s0*s1*c2;s0*s2-c0*s1*c2;c1*c2];
v2  = [c4*s6+s4*s5*c6;s4*s6-c4*s5*c6;c5*c6];

Rm3 = R0*(R1*R2); % frame
Rm4 = R4*R5*R6; % steering head

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


T3  = -u(2)*(v1+v2)/norm(v1+v2);

% forces/torques
Frs = k2*(q2-q7-q70)+b2*(q2d-q7d);
Ffs = k5*(qf-p5)+d5*qfd*(qfd<0)+e5*qfd*(qfd>0)-k3*(qf<b5)+k3*(qf>t5);

Frb = u(1)*(u(1)>0);
Ffb = u(1)*(u(1)<0);

Fzr = max((-k1*r0(3)-d1*r0d(3))*(r0(3)<0),0) ;
Ftr = t1*Fzr*atan(-vtr/vlr);
Flr = Fzr*min(max(f1*((b1+a1*cos(q1))*q8d/vlr-1),-1),1);

Fzf = max((-k1*r7(3)-d1*r7d(3))*(r7(3)<0),0) ;
Ftf = t6*Fzf*atan(-vtf/vlf);
Flf = Fzf*min(max(f6*((b6+a6*cos(q5))*q9d/vlf-1),-1),1);

T1  =  k3*(pi/2-dot(v1,v2))*cross(v1,v2);

%% experiment
sr    =  r0d(1:2);
Fr    =  -Fzr*(sr./((sr.'*sr)^4+1)^(1/8)+sr./((sr.'*sr)^2+1));
Flr =  c0*Fr(1)+s0*Fr(2);
Ftr = -s0*Fr(1)+c0*Fr(2);

ss    =  r7d(1:2);
Ff    =  -Fzf*(ss./((ss.'*ss)^4+1)^(1/8)+ss./((ss.'*ss)^2+1));
Flf =  c4*Ff(1)+s4*Ff(2);
Ftf = -s4*Ff(1)+c4*Ff(2);
%% end of experiment

% work done by forces/torques
Qfs = [0 0 0 0 0 0 0 0 0 0 -Ffs 0 0].';
Qrs = [0 0 0 0 0 -Frs 0 0 0 Frs 0 0 0].'; 
Qfb = [0 0 0 0 0 0 0 0 -Ffb 0 0 0 Ffb].';
Qrb = [0 0 0 0 0 0 0 0 0 -Frb 0 Frb 0].'; 
QT1 = [0 0 0 T1(3) c0*T1(1)+s0*T1(2) -s0*c1*T1(1)+c0*c1*T1(2)+s1*T1(3) -T1(3) -c4*T1(1)-s4*T1(2) s4*c5*T1(1)-c4*c5*T1(2)-s5*T1(3) 0 0 0 0].';
QT3 = [0 0 0 T3(3) c0*T3(1)+s0*T3(2) -s0*c1*T3(1)+c0*c1*T3(2)+s1*T3(3) -T3(3) -c4*T3(1)-s4*T3(2) s4*c5*T3(1)-c4*c5*T3(2)-s5*T3(3) 0 0 0 0].';
Qrz = [0 0 1 0 -s1*(s2*l3+s7*l2-b1) c1*c2*l3 0 0 0 c1*c7*l2 0 0 0                    ].'*Fzr;
Qfz = [0 0 1 0 0 0 0 s5*(s6*l4+c6*qf+b6) c5*(s6*qf-c6*l4) 0 -c5*c6 0 0               ].'*Fzf;
Qlf = [c4 s4 0 0 0 0 -s5*(s6*l4+c6*qf+b6) 0 -s6*l4-c6*qf 0 -s6 0 -c5*a6-b6           ].'*Flf; 
Qlr = [c0 s0 0 -s1*(-s2*l3-s7*l2+b1) 0 s2*l3 0 0 0 s7*l2 0 -c1*a1-b1 0               ].'*Flr;                     
Qtf = [-s4 c4 0 0 0 0 c6*l4-s6*qf c5*(s6*l4+c6*qf+b6)+a6 s5*(c6*l4-s6*qf) 0 s5*c6 0 0].'*Ftf;
Qtr = [-s0 c0 0 -c2*l3-c7*l2 c1*(b1-s2*l3-s7*l2)+a1 -s1*c2*l3 0 0 0 -s1*c7*l2 0 0 0  ].'*Ftr;
Vq  = -g*[0 0 m1+m2+m3+m4+m5+m6 0 -m1*s1*(s2*l3+s7*l2)-m2*s1*(s2*l3-s7*(-l2+x2))-m3*s1*(-s2*(-l3+x3)+c2*z3) (m1+m2)*c1*c2*l3+m3*c1*(-c2*(-l3+x3)-s2*z3) 0 (-m4*s5*(-s6*x4+c6*z4)-m5*s5*(-s6*(l4+x5)+c6*(-qf+z5))-m6*s5*(-s6*l4-c6*qf)) m4*c5*(-c6*x4-s6*z4)+m5*c5*(-c6*(l4+x5)-s6*(-qf+z5))+m6*c5*(-c6*l4+s6*qf) m1*c1*c7*l2-m2*c1*c7*(-l2+x2) c5*c6*sf 0 0];
% Q   = Vq.'+Qfs+Qrs+Qrz+Qfz+QT1+QT3+Qlf+Qlr+Qtf; 
Q   = Vq.'+Qfs+Qrs+Qrz+Qfz+QT1+QT3+Qtf+Qlf+Qlr+Qtr+Qfb+Qrb;
% Q   = Vq.'+Qfs+Qrs+Qrz+Qfz+QT1+QT3+Qflon+Qrlon+Qflat+Qrlat; 

qdd = M\(Q-C*qd);


IMU = [0;0;0;0;0;0];

qxdd=qdd(1);
qydd=qdd(2);
qzdd=qdd(3);
q0dd=qdd(4);
q1dd=qdd(5);
q2dd=qdd(6);

su = sin(u7); cu = cos(u7); sv = sin(v7); cv = cos(v7); sw = sin(w7);cw = cos(w7);

% basic rotations
R0 = [c0 -s0 0;s0 c0 0;0 0 1]; R0q = [-s0 -c0 0;c0 -s0 0;0 0 0]; R0qq = [-c0 s0 0;-s0 -c0 0;0 0 0];
R1 = [1 0 0;0 c1 -s1;0 s1 c1]; R1q = [0 0 0;0 -s1 -c1;0 c1 -s1]; R1qq = [0 0 0;0 -c1 s1;0 -s1 -c1];
R2 = [c2 0 s2;0 1 0;-s2 0 c2]; R2q = [-s2 0 c2;0 0 0;-c2 0 -s2]; R2qq = [-c2 0 -s2;0 0 0;s2 0 -c2];

Ru = [cu -su 0;su cu 0;0 0 1];
Rv = [1 0 0;0 cv -sv;0 sv cv];
Rw = [cw 0 sw;0 1 0;-sw 0 cw];

% position vector
rm7 = [qx;qy;qz]+R0*(R1*(R2*[x7;y7;z7]));

% % velocity vector
% rm7d=jacobian(rm7,q)*qd
% rm7d1= [qxd;qyd;qzd]+q0d*R0q*(R1*(R2*[x7;y7;z7]))+R0*(q1d*R1q*(R2*[x7;y7;z7])+R1*(q2d*R2q*[x7;y7;z7]))
% rm7d2= [qxd;qyd;qzd]+R0q*(R1*(R2*q0d*[x7;y7;z7]))+R0*(R1q*(R2*q1d*[x7;y7;z7])+R1*(R2q*q2d*[x7;y7;z7]))
% temp=simple(rm7d1-rm7d2)
% acceleration vector
% rm7dd=(jacobian(rm7d,[q;qd])*[qd;qdd])
% rm7dd1=(jacobian(rm7d1,[q;qd])*[qd;qdd])% this vector is in global coordinates, but the sensor measures in local coordinates.
% rm7dd2=[qxdd;qydd;qzdd] ...
%     +R0qq*(R1*(R2*q0d^2*[x7;y7;z7]))   +R0q*(R1q*(R2*q0d*q1d*[x7;y7;z7])) +R0q*(R1*(R2q*q0d*q2d*[x7;y7;z7])) +R0q*(R1*(R2*q0dd*[x7;y7;z7])) ...
%     +R0q*(R1q*(R2*q0d*q1d*[x7;y7;z7])) +R0*(R1qq*(R2*q1d^2*[x7;y7;z7]))   +R0*(R1q*(R2q*q1d*q2d*[x7;y7;z7])) +R0*(R1q*(R2*q1dd*[x7;y7;z7])) ...
%     +R0q*(R1*(R2q*q0d*q2d*[x7;y7;z7])) +R0*(R1q*(R2q*q1d*q2d*[x7;y7;z7])) +R0*(R1*(R2qq*q2d^2*[x7;y7;z7]))   +R0*(R1*(R2q*q2dd*[x7;y7;z7]))
% temp=simple(rm7dd-rm7dd2)

% absolute position measured in local body coordinates
% - rm7loc = R2'*R1'*R0'*([qx;qy;qz]+R0*R1*R2*[x7;y7;z7])
% - rm7loc = R2'*R1'*R0'*[qx;qy;qz]+ R2'*R1'*R0'*R0*R1*R2*[x7;y7;z7]
% - rm7loc = R2'*R1'*R0'*[qx;qy;qz]+ [x7;y7;z7]
% rm7loc = R2.'*R1.'*R0.'*[qx;qy;qz]+ [x7;y7;z7] 
% how can this be possible? this implies (or not?) that the velocity of the sensor is
% independent of its local position [x7;y7;z7].


% absolute velocity measured in local body coordinates
% rm7dloc8 = R2.'*(R1.'*(((R0.'*[qxd;qyd;qzd])) + (R0tR0q *(R1*(R2*q0d*[x7;y7;z7]))))+(R1tR1q*(R2*q1d*[x7;y7;z7])))+(R2tR2q*q2d*[x7;y7;z7])



% syms s0 s1 s2 c0 c1 c2
% rm7ddloc6 =  R2.'*R1.'*R0.'*[qxdd;qydd;qzdd]+ ...
%   [z7*(q2dd + (q1d^2*sin(2*q2))/2 + q0dd*s1 - (q0d^2*sin(2*q2)*c1^2)/2 + 2*q0d*q1d*cos(q1)*cos(q2)^2) - x7*(q0d^2*(c2^2 + s1^2*s2^2) + q1d^2*s2^2 + q2d^2 + 2*q0d*q2d*s1 + q0d*q1d*sin(2*q2)*c1) - y7*(c1*s1*s2*q0d^2 - 2*q1d*c2*s1*q0d + q1dd*s2 + q0dd*c1*c2);
%    x7*(-c1*s1*s2*q0d^2 - 2*q2d*c1*s2*q0d + q1dd*s2 + 2*q1d*q2d*c2 + q0dd*c1*c2) - y7*(q0d^2*c1^2 + q1d^2) + z7*((sin(2*q1)*c2*q0d^2)/2 + 2*q2d*c1*c2*q0d - q1dd*c2 + 2*q1d*q2d*s2 + q0dd*c1*s2);
%    y7*((sin(2*q1)*c2*q0d^2)/2 + 2*q1d*s1*s2*q0d + q1dd*c2 - q0dd*c1*s2) - z7*(q1d^2*c2^2 - q0d^2*(c1^2*c2^2 - 1) + q2d^2 + 2*q0d*q2d*s1 - q0d*q1d*sin(2*q2)*c1) - x7*(q2dd - (q1d^2*sin(2*q2))/2 + q0dd*s1 + (q0d^2*sin(2*q2)*c1^2)/2 + 2*q0d*q1d*c1*s2^2)]


rm7ddloc6 =  R2.'*(R1.'*(R0.'*[qxdd;qydd;qzdd+9.81]))+ ...
[ z7*(q2dd+q0dd*s1+c2*s2*(q1d^2-q0d^2*c1^2)+2*c1*c2^2*q0d*q1d) ...
- y7*(s2*(c1*s1*q0d^2+q1dd)+c2*(c1*q0dd-2*q1d*s1*q0d)) ...
- x7*(q1d^2*s2^2+q0d^2*s1^2*s2^2+q0d^2*c2^2+2*q0d*q2d*s1+2*c1*c2*q0d*q1d*s2+q2d^2); ...
  z7*((c1*(s1*q0d^2+2*q2d*q0d)-q1dd)*c2+(c1*q0dd+2*q1d*q2d)*s2) ...
+ x7*(-c1*s1*s2*q0d^2-2*c1*q2d*s2*q0d+q1dd*s2+c1*c2*q0dd+2*c2*q1d*q2d) ...
- y7*(c1^2*q0d^2+q1d^2); ...
  y7*(c2*(c1*s1*q0d^2+q1dd)+s2*(2*s1*q0d*q1d-c1*q0dd)) ...
- x7*(q2dd+q0dd*s1+c2*s2*(q0d^2*c1^2-q1d^2)+2*c1*q0d*q1d*s2^2) ...
- z7*(q0d^2*(1-c2^2*c1^2)+c2^2*q1d^2+2*q0d*(q2d*s1-c1*c2*q1d*s2)+q2d^2)]...
;

rm7ddloc6 = Rw.'*(Rv.'*(Ru.'*rm7ddloc6));

wrel=R2.'*R1.'*R0.'*[0;0;q0d]+R2.'*R1.'*[q1d;0;0]+R2.'*[0;q2d;0];
wrel = Rw.'*(Rv.'*(Ru.'*wrel));

IMU=[wrel;rm7ddloc6];

% from generalized coordinates to nonlinear state space 
fx=[qdd;qd];
hx=[IMU];


