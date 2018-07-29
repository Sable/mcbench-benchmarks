function td=tau_damp(veh,vr,de)

% td=tau_damp(veh,vr,de); calculates damping forces from 
% vehicle variables ,generalized velocity vr and delta angles de

% --------------------------------------------------------------
% forces on FUSELAGE 

% Fuselage reference surface
sf=pi/4*veh.d^2;

% relative velocity of B_b wrt c in b
v_Bcb=vr(1:3)+vp(vr(4:6),veh.B_b);

% fuselage rotation matrix
i_fb=[1; 0; 0];
if   norm([0; v_Bcb(2); v_Bcb(3)])<1e-12, k_fb=[0; 0; 1];
else k_fb=[0; v_Bcb(2); v_Bcb(3)]/norm([0; v_Bcb(2); v_Bcb(3)]);end
R_fb=[i_fb, vp(k_fb,i_fb), k_fb];

% relative velocity of B_b wrt c in f
v_Bcf=R_fb'*v_Bcb;

% attack angle
af=atan2(v_Bcf(3),v_Bcf(1));

% wind frame rotation matrix
R_wf=[cos(af) 0 -sin(af); 0 1 0; sin(af) 0 cos(af)];

% cl cd xcp computation
[cl,cd,xcp]=a2clcdxc(af);

% damping forces on B wrt w 
F_Bw=-0.5*veh.rho*sf*v_Bcf'*v_Bcf*[cd; 0; cl];

% damping forces on B wrt b 
F_Bb=R_fb*R_wf*F_Bw;

% force application point
Pf_b=[-xcp*veh.l; 0; 0];

% moments on B with pole in b wrt b
M_Bbb=vp(Pf_b,F_Bb);

tf=[F_Bb;M_Bbb];

% --------------------------------------------------------------
% forces on FIN 1 

% fin1 rotation matrix
R_1b=[cos(de(1)) 0 sin(de(1)); 0 1 0; -sin(de(1)) 0 cos(de(1))];

% relative velocity of fin1 middle point wrt c in b
v_1cb=vr(1:3)+vp(vr(4:6),veh.P1_b);

% relative velocity of fin1 middle point wrt c in 1
v_1c1=R_1b'*v_1cb;

% attack angle
a1=atan2(v_1c1(3),v_1c1(1));

% fin1 wind frame rotation matrix
R_w1=[cos(a1) 0 -sin(a1); 0 1 0; sin(a1) 0 cos(a1)];

% cl and cd computation
[cl,cd]=a2clcd(a1);

% damping forces on 1 wrt w 
F_1w=-0.5*veh.rho*veh.sw*(v_1c1(1)^2+v_1c1(3)^2)*[cd; 0; cl];

% damping forces on 1 wrt b 
F_1b=R_1b*R_w1*F_1w;

% moments on 1 with pole in b wrt b
M_1bb=vp(veh.P1_b,F_1b);

t1=[F_1b;M_1bb];

% --------------------------------------------------------------
% forces on FIN 2 

% fin2 rotation matrix
R_2b=[cos(de(2)) 0 sin(de(2)); sin(de(2)) 0 -cos(de(2)); 0 1 0];

% relative velocity of fin2 middle point wrt c in b
v_2cb=vr(1:3)+vp(vr(4:6),veh.P2_b);

% relative velocity of fin2 middle point wrt c in 2
v_2c2=R_2b'*v_2cb;

% attack angle
a2=atan2(v_2c2(3),v_2c2(1));

% fin2 wind frame rotation matrix
R_w2=[cos(a2) 0 -sin(a2); 0 1 0; sin(a2) 0 cos(a2)];

% cl and cd computation
[cl,cd]=a2clcd(a2);

% damping forces on 2 wrt w 
F_2w=-0.5*veh.rho*veh.sw*(v_2c2(1)^2+v_2c2(3)^2)*[cd; 0; cl];

% damping forces on 2 wrt b 
F_2b=R_2b*R_w2*F_2w;

% moments on 2 with pole in b wrt b
M_2bb=vp(veh.P2_b,F_2b);

t2=[F_2b;M_2bb];

% --------------------------------------------------------------
% forces on FIN 3 

% fin3 rotation matrix
R_3b=[cos(de(3)) 0 sin(de(3));  0 -1 0; sin(de(3)) 0 -cos(de(3))];

% relative velocity of fin3 middle point wrt c in b
v_3cb=vr(1:3)+vp(vr(4:6),veh.P3_b);

% relative velocity of fin3 middle point wrt c in 3
v_3c3=R_3b'*v_3cb;

% attack angle
a3=atan2(v_3c3(3),v_3c3(1));

% fin3 wind frame rotation matrix
R_w3=[cos(a3) 0 -sin(a3); 0 1 0; sin(a3) 0 cos(a3)];

% cl and cd computation
[cl,cd]=a2clcd(a3);

% damping forces on 3 wrt w 
F_3w=-0.5*veh.rho*veh.sw*(v_3c3(1)^2+v_3c3(3)^2)*[cd; 0; cl];

% damping forces on 3 wrt b 
F_3b=R_3b*R_w3*F_3w;

% moments on 3 with pole in b wrt b
M_3bb=vp(veh.P3_b,F_3b);

t3=[F_3b;M_3bb];

% --------------------------------------------------------------
% forces on FIN 4 

% fin4 rotation matrix
R_4b=[cos(de(4)) 0 sin(de(4)); -sin(de(4)) 0 cos(de(4));  0 -1 0];

% relative velocity of fin4 middle point wrt c in b
v_4cb=vr(1:3)+vp(vr(4:6),veh.P4_b);

% relative velocity of fin4 middle point wrt c in 4
v_4c4=R_4b'*v_4cb;

% attack angle
a4=atan2(v_4c4(3),v_4c4(1));

% fin4 wind frame rotation matrix
R_w4=[cos(a4) 0 -sin(a4); 0 1 0; sin(a4) 0 cos(a4)];

% cl and cd computation
[cl,cd]=a2clcd(a4);

% damping forces on 4 wrt w 
F_4w=-0.5*veh.rho*veh.sw*(v_4c4(1)^2+v_4c4(3)^2)*[cd; 0; cl];

% damping forces on 4 wrt b 
F_4b=R_4b*R_w4*F_4w;

% moments on 4 with pole in b wrt b
M_4bb=vp(veh.P4_b,F_4b);

t4=[F_4b;M_4bb];

% --------------------------------------------------------------
% forces on FIN 5 

% fin5 rotation matrix
R_5b=[cos(de(5)) 0 sin(de(5)); 0 1 0; -sin(de(5)) 0 cos(de(5))];

% relative velocity of fin5 middle point wrt c in b
v_5cb=vr(1:3)+vp(vr(4:6),veh.P5_b);

% relative velocity of fin5 middle point wrt c in 5
v_5c5=R_5b'*v_5cb;

% attack angle
a5=atan2(v_5c5(3),v_5c5(1));

% fin5 wind frame rotation matrix
R_w5=[cos(a5) 0 -sin(a5); 0 1 0; sin(a5) 0 cos(a5)];

% cl and cd computation
[cl,cd]=a2clcd(a5);

% damping forces on 5 wrt w 
F_5w=-0.5*veh.rho*veh.st*(v_5c5(1)^2+v_5c5(3)^2)*[cd; 0; cl];

% damping forces on 5 wrt b 
F_5b=R_5b*R_w5*F_5w;

% moments on 5 with pole in b wrt b
M_5bb=vp(veh.P5_b,F_5b);

t5=[F_5b;M_5bb];

% --------------------------------------------------------------
% forces on FIN 6 

% fin6 rotation matrix
R_6b=[cos(de(6)) 0 sin(de(6)); sin(de(6)) 0 -cos(de(6)); 0 1 0];

% relative velocity of fin6 middle point wrt c in b
v_6cb=vr(1:3)+vp(vr(4:6),veh.P6_b);

% relative velocity of fin6 middle point wrt c in 6
v_6c6=R_6b'*v_6cb;

% attack angle
a6=atan2(v_6c6(3),v_6c6(1));

% fin6 wind frame rotation matrix
R_w6=[cos(a6) 0 -sin(a6); 0 1 0; sin(a6) 0 cos(a6)];

% cl and cd computation
[cl,cd]=a2clcd(a6);

% damping forces on 6 wrt w 
F_6w=-0.5*veh.rho*veh.st*(v_6c6(1)^2+v_6c6(3)^2)*[cd; 0; cl];

% damping forces on 6 wrt b 
F_6b=R_6b*R_w6*F_6w;

% moments on 6 with pole in b wrt b
M_6bb=vp(veh.P6_b,F_6b);

t6=[F_6b;M_6bb];

% --------------------------------------------------------------
% forces on FIN 7 

% fin7 rotation matrix
R_7b=[cos(de(7)) 0 sin(de(7));  0 -1 0; sin(de(7)) 0 -cos(de(7))];

% relative velocity of fin7 middle point wrt c in b
v_7cb=vr(1:3)+vp(vr(4:6),veh.P7_b);

% relative velocity of fin7 middle point wrt c in 7
v_7c7=R_7b'*v_7cb;

% attack angle
a7=atan2(v_7c7(3),v_7c7(1));

% fin7 wind frame rotation matrix
R_w7=[cos(a7) 0 -sin(a7); 0 1 0; sin(a7) 0 cos(a7)];

% cl and cd computation
[cl,cd]=a2clcd(a7);

% damping forces on 7 wrt w 
F_7w=-0.5*veh.rho*veh.st*(v_7c7(1)^2+v_7c7(3)^2)*[cd; 0; cl];

% damping forces on 7 wrt b 
F_7b=R_7b*R_w7*F_7w;

% moments on 7 with pole in b wrt b
M_7bb=vp(veh.P7_b,F_7b);

t7=[F_7b;M_7bb];

% --------------------------------------------------------------
% forces on FIN 8 

% fin8 rotation matrix
R_8b=[cos(de(8)) 0 sin(de(8)); -sin(de(8)) 0 cos(de(8));  0 -1 0];

% relative velocity of fin8 middle point wrt c in b
v_8cb=vr(1:3)+vp(vr(4:6),veh.P8_b);

% relative velocity of fin8 middle point wrt c in 8
v_8c8=R_8b'*v_8cb;

% attack angle
a8=atan2(v_8c8(3),v_8c8(1));

% fin8 wind frame rotation matrix
R_w8=[cos(a8) 0 -sin(a8); 0 1 0; sin(a8) 0 cos(a8)];

% cl and cd computation
[cl,cd]=a2clcd(a8);

% damping forces on 8 wrt w 
F_8w=-0.5*veh.rho*veh.st*(v_8c8(1)^2+v_8c8(3)^2)*[cd; 0; cl];

% damping forces on 8 wrt b 
F_8b=R_8b*R_w8*F_8w;

% moments on 8 with pole in b wrt b
M_8bb=vp(veh.P8_b,F_8b);

t8=[F_8b;M_8bb];

% --------------------------------------------------------------
% resulting hydrodynamic force and moment with pole in b wrt b

td=tf+t1+t2+t3+t4+t5+t6+t7+t8; 
