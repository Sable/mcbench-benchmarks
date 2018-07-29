%%   FDI Wind Turbines
% This script containing parameters for Bench Mark Model By Peter Fogh
% Odgaard, kk-electronic a/s, Viby J Denmark -Date 7.11.2008-
% with little modification by Nassim Laouti Date 13.11.2010 
% Latest modification Date 16.02.2012

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c3=10;c4=1000;P_r=4.8e6;
% Simple time and time
Ts=1/100;Time=Ts:Ts:4400;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Wind data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D_v_wind=[Time', 9+4*sin(0.01*Time)'];

load winddata
D_v_wind=[windtime windspeed];

%% Wind Model
seed1 = 256;
seed2 = 894;
turbulence_seeds=[seed1 seed2];
R=57.5;
H=87;
k =4.7;
a=2.2;
alpha = 0.1;
D_rotor=2*R;
r = D_rotor/2;
m = 1+alpha*(alpha-1)*R^2/(8*H^2);
Length_scale = 600; %[m]
L=Length_scale;
Turbulence_intensity = 12;
turb_int=Turbulence_intensity;
T_sample=0.05;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pitch and Blade Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
omega_n=11.11;xi=0.6;rho=1.225;
R=57.5;r0 = 1.5;

% cq table
load AeroDynamics

% Fault models
% Fault 6
xi2=0.45;omega_n2=5.73;
% Fault 7
xi3=0.9;omega_n3=3.42;

%transfers to ss models
[Apb,Bpb,Cpb,Dpb]=tf2ss([omega_n^2],[1 2*xi*omega_n omega_n^2]);
[Apb1,Bpb1,Cpb1,Dpb1]=tf2ss([omega_n2^2],[1 2*xi2*omega_n2 omega_n2^2]);
[Apb2,Bpb2,Cpb2,Dpb2]=tf2ss([omega_n3^2],[1 2*xi3*omega_n3 omega_n3^2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Drive Train Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B_dt=775.49;
B_r=7.11;
B_g=45.6;
N_g=95;
K_dt=2.7e9
eta_dt=0.97;
J_g=390
J_r=55e6

Addt=[-(B_dt+B_r)/J_r B_dt/N_g/J_r -K_dt/J_r; eta_dt*B_dt/N_g/J_g -(eta_dt*B_dt/N_g^2+B_g)/J_g eta_dt*K_dt/N_g/J_g; 1 -1/N_g 0];
Bddt=[1/J_r 0; 0 -1/J_g;0 0];
Cddt=[1 0 0;0 1 0];
Dddt=[0 0;0 0];

% Fault models
% Fault 9
eta_dt2=.91

Addt2=[-(B_dt+B_r)/J_r B_dt/N_g/J_r -K_dt/J_r; eta_dt2*B_dt/N_g/J_g -(eta_dt2*B_dt/N_g^2+B_g)/J_g eta_dt2*K_dt/N_g/J_g; 1 -1/N_g 0];
Bddt2=[1/J_r 0; 0 -1/J_g;0 0];
Cddt2=[1 0 0;0 1 0];
Dddt2=[0 0;0 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generator & Converter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha_gc=1/20e-3;
eta_gc=0.98;

%Fault models
%fault 8
Constant_tau_gc=100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Controller
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K_opt=.5* rho* pi*R^2*eta_dt*R^3*0.4554/(N_g*8)^3

K_i=1;
K_p=4;
Omega_nom=162;
Omega_delta=5;
P_r=4.8e6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sensors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m_vw=1.5;
sigma_vm=0.5;
m_omega_r=0;
sigma_omega_r=0.004*2*pi;
m_omega_g=0;
sigma_omega_g=0.05;
m_tau_g=0;
sigma_tau_g=90;
m_P_g=0;
sigma_P_g=1e3;
m_Beta=0;
sigma_Beta=0.2;

%% Fault models (choose the scenario of fault parameters and magnitude)

% %1st fault scenario
% Constant_Beta_1_m1=5;Gain_Beta_2_m2=1.2;Constant_Beta_3_m1=10;Constant_Omega_r_m1=1.4;Gain_Omega_r_m2=1.1;Gain_Omega_g_m2=0.9;
% xi2=0.45;omega_n2=5.73;xi3=0.9;omega_n3=3.42;Constant_tau_gc=100;eta_dt2=.92;Constant_Omega_g_m1=140;

% %2nd fault scenario
% Constant_Beta_1_m1=6;Gain_Beta_2_m2=1.5;Constant_Beta_3_m1=8;Constant_Omega_r_m1=0.2;Gain_Omega_r_m2=1.2;Gain_Omega_g_m2=0.8;
% xi2=0.45;omega_n2=5.73;xi3=0.9;omega_n3=3.42;Constant_tau_gc=100;eta_dt2=.71;Constant_Omega_g_m1=80;

%3rd fault scenario
Constant_Beta_1_m1=4;Gain_Beta_2_m2=1.8;Constant_Beta_3_m1=12;Constant_Omega_r_m1=1.2;Gain_Omega_r_m2=0.7;Gain_Omega_g_m2=1.7;
xi2=0.45;omega_n2=5.73;xi3=0.9;omega_n3=3.42;Constant_tau_gc=700;eta_dt2=0.3;Constant_Omega_g_m1=100;

%4th fault scenario
% Constant_Beta_1_m1=2;Gain_Beta_2_m2=3;Constant_Beta_3_m1=15;Constant_Omega_r_m1=1.7;Gain_Omega_r_m2=1.7;Gain_Omega_g_m2=0.7;
% xi2=0.45;omega_n2=5.73;xi3=0.9;omega_n3=3.42;Constant_tau_gc=-500;eta_dt2=.6;Constant_Omega_g_m1=130;

% %5th fault scenario
% Constant_Beta_1_m1=-5;Gain_Beta_2_m2=10;Constant_Beta_3_m1=3;Constant_Omega_r_m1=2.5;Gain_Omega_r_m2=0.9;Gain_Omega_g_m2=0.2;
% xi2=0.45;omega_n2=5.73;xi3=0.9;omega_n3=3.42;Constant_tau_gc=1500;eta_dt2=.25;Constant_Omega_g_m1=120;
 
%6th fault scenario
% Constant_Beta_1_m1=1;Gain_Beta_2_m2=2;Constant_Beta_3_m1=6;Constant_Omega_r_m1=0.5;Gain_Omega_r_m2=0.2;Gain_Omega_g_m2=2.8;
% xi2=0.45;omega_n2=5.73;xi3=0.9;omega_n3=3.42;Constant_tau_gc=2500;eta_dt2=0.1;Constant_Omega_g_m1=150;

% % %7th fault scenario
% Constant_Beta_1_m1=24;Gain_Beta_2_m2=5;Constant_Beta_3_m1=20;Constant_Omega_r_m1=3.5;Gain_Omega_r_m2=3;Gain_Omega_g_m2=5;
% xi2=0.25;omega_n2=8.73;xi3=0.95;omega_n3=1.42;Constant_tau_gc=900;eta_dt2=0.4;Constant_Omega_g_m1=50;

%8th fault scenario
% Constant_Beta_1_m1=-3;Gain_Beta_2_m2=5;Constant_Beta_3_m1=7;Constant_Omega_r_m1=2;Gain_Omega_r_m2=0.5;Gain_Omega_g_m2=1.5;
% xi2=0.45;omega_n2=5.73;xi3=0.9;omega_n3=3.42;Constant_tau_gc=-1000;eta_dt2=0.22;Constant_Omega_g_m1=100;

% %9th fault scenario
% Constant_Beta_1_m1=2;Gain_Beta_2_m2=3;Constant_Beta_3_m1=7;Constant_Omega_r_m1=2;Gain_Omega_r_m2=0.5;Gain_Omega_g_m2=1.5;
% xi2=0.45;omega_n2=5.73;xi3=0.9;omega_n3=3.42;Constant_tau_gc=800;eta_dt2=0.42;Constant_Omega_g_m1=110;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Apb1,Bpb1,Cpb1,Dpb1]=tf2ss([omega_n2^2],[1 2*xi2*omega_n2 omega_n2^2]);
[Apb2,Bpb2,Cpb2,Dpb2]=tf2ss([omega_n3^2],[1 2*xi3*omega_n3 omega_n3^2]);
%
Addt2=[-(B_dt+B_r)/J_r B_dt/N_g/J_r -K_dt/J_r; eta_dt2*B_dt/N_g/J_g -(eta_dt2*B_dt/N_g^2+B_g)/J_g eta_dt2*K_dt/N_g/J_g; 1 -1/N_g 0];
Bddt2=[1/J_r 0; 0 -1/J_g;0 0];
Cddt2=[1 0 0;0 1 0];
Dddt2=[0 0;0 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fault signals (choose the scenario of fault appearance)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %1st fault scenario
% D_Fault1=[Time' 1-[zeros(1,2000/Ts) ones(1,100/Ts) zeros(1,2300/Ts)]'];
% D_Fault2=[Time' 1-[zeros(1,2300/Ts) ones(1,100/Ts) zeros(1,2000/Ts)]'];
% D_Fault3=[Time' 1-[zeros(1,2600/Ts) ones(1,100/Ts) zeros(1,1700/Ts)]'];
% D_Fault4=[Time' 1-[zeros(1,1500/Ts) ones(1,100/Ts) zeros(1,2800/Ts)]'];
% D_Fault5=[Time' 1-[zeros(1,1000/Ts) ones(1,100/Ts) zeros(1,3300/Ts)]'];
% D_Fault6=[Time' 1-[zeros(1,2900/Ts) ones(1,100/Ts) zeros(1,1400/Ts)]'];
% D_Fault7=[Time' 1-[zeros(1,3400/Ts) (0:1/3000:2999/3000) ones(1,40/Ts) (2999/3000:-1/3000:0) zeros(1,900/Ts)]'];
% D_Fault8=[Time' 1-[zeros(1,3800/Ts) ones(1,100/Ts) zeros(1,500/Ts)]'];
% D_Fault9=[Time' 1-[zeros(1,4000/Ts) ones(1,200/Ts) zeros(1,200/Ts)]'];
% D_Fault10=[Time' 1-[zeros(1,3600/Ts) ones(1,100/Ts) zeros(1,700/Ts) ]'];


%%2nd fault scenario
% D_Fault1=[Time' 1-[zeros(1,1000/Ts) ones(1,100/Ts) zeros(1,3300/Ts)]'];
% D_Fault2=[Time' 1-[zeros(1,3900/Ts) ones(1,100/Ts) zeros(1,400/Ts)]'];
% D_Fault3=[Time' 1-[zeros(1,1600/Ts) ones(1,100/Ts) zeros(1,2700/Ts)]'];
% D_Fault4=[Time' 1-[zeros(1,500/Ts) ones(1,100/Ts) zeros(1,3800/Ts)]'];
% D_Fault5=[Time' 1-[zeros(1,4000/Ts) ones(1,100/Ts) zeros(1,300/Ts)]'];
% D_Fault6=[Time' 1-[zeros(1,2900/Ts) ones(1,100/Ts) zeros(1,1400/Ts)]'];
% D_Fault7=[Time' 1-[zeros(1,3400/Ts) (0:1/3000:2999/3000) ones(1,40/Ts) (2999/3000:-1/3000:0) zeros(1,900/Ts)]'];
% D_Fault8=[Time' 1-[zeros(1,1800/Ts) ones(1,100/Ts) zeros(1,2500/Ts)]'];
% D_Fault9=[Time' 1-[zeros(1,3000/Ts) ones(1,200/Ts) zeros(1,1200/Ts)]'];
% D_Fault10=[Time' 1-[zeros(1,2600/Ts) ones(1,100/Ts) zeros(1,1700/Ts) ]'];

%3nd fault scenario
D_Fault1=[Time' 1-[zeros(1,100/Ts) ones(1,100/Ts) zeros(1,4200/Ts)]'];
D_Fault2=[Time' 1-[zeros(1,2500/Ts) ones(1,100/Ts) zeros(1,1800/Ts)]'];
D_Fault3=[Time' 1-[zeros(1,900/Ts) ones(1,100/Ts) zeros(1,3400/Ts)]'];
D_Fault4=[Time' 1-[zeros(1,1200/Ts) ones(1,100/Ts) zeros(1,3100/Ts)]'];
D_Fault5=[Time' 1-[zeros(1,1700/Ts) ones(1,100/Ts) zeros(1,2600/Ts)]'];
D_Fault6=[Time' 1-[zeros(1,3200/Ts) ones(1,100/Ts) zeros(1,1100/Ts)]'];
D_Fault7=[Time' 1-[zeros(1,3400/Ts) (0:1/3000:2999/3000) ones(1,40/Ts) (2999/3000:-1/3000:0) zeros(1,900/Ts)]'];
D_Fault8=[Time' 1-[zeros(1,4200/Ts) ones(1,100/Ts) zeros(1,100/Ts)]'];
D_Fault9=[Time' 1-[zeros(1,2000/Ts) ones(1,200/Ts) zeros(1,2200/Ts)]'];
D_Fault10=[Time' 1-[zeros(1,3900/Ts) ones(1,100/Ts) zeros(1,400/Ts)]'];


% %4th fault scenario
% D_Fault1=[Time' 1-[zeros(1,250/Ts) ones(1,100/Ts) zeros(1,4050/Ts)]'];
% D_Fault2=[Time' 1-[zeros(1,3200/Ts) ones(1,100/Ts) zeros(1,1100/Ts)]'];
% D_Fault3=[Time' 1-[zeros(1,1000/Ts) ones(1,100/Ts) zeros(1,3300/Ts)]'];
% D_Fault4=[Time' 1-[zeros(1,800/Ts) ones(1,100/Ts) zeros(1,3500/Ts)]'];
% D_Fault5=[Time' 1-[zeros(1,2200/Ts) ones(1,100/Ts) zeros(1,2100/Ts)]'];
% D_Fault6=[Time' 1-[zeros(1,2800/Ts) ones(1,100/Ts) zeros(1,1500/Ts)]'];
% D_Fault7=[Time' 1-[zeros(1,3400/Ts) (0:1/3000:2999/3000) ones(1,40/Ts) (2999/3000:-1/3000:0) zeros(1,900/Ts)]'];
% D_Fault8=[Time' 1-[zeros(1,1200/Ts) ones(1,100/Ts) zeros(1,3100/Ts)]'];
% D_Fault9=[Time' 1-[zeros(1,3900/Ts) ones(1,200/Ts) zeros(1,300/Ts)]'];
% D_Fault10=[Time' 1-[zeros(1,4200/Ts) ones(1,100/Ts) zeros(1,100/Ts)]'];


% %5th fault scenario
% D_Fault1=[Time' 1-[zeros(1,3000/Ts) ones(1,100/Ts) zeros(1,1300/Ts)]'];
% D_Fault2=[Time' 1-[zeros(1,1300/Ts) ones(1,100/Ts) zeros(1,3000/Ts)]'];
% D_Fault3=[Time' 1-[zeros(1,500/Ts) ones(1,100/Ts) zeros(1,3800/Ts)]'];
% D_Fault4=[Time' 1-[zeros(1,200/Ts) ones(1,100/Ts) zeros(1,4100/Ts)]'];
% D_Fault5=[Time' 1-[zeros(1,2000/Ts) ones(1,100/Ts) zeros(1,2300/Ts)]'];
% D_Fault6=[Time' 1-[zeros(1,3600/Ts) ones(1,100/Ts) zeros(1,700/Ts)]'];
% D_Fault7=[Time' 1-[zeros(1,3400/Ts) (0:1/3000:2999/3000) ones(1,40/Ts) (2999/3000:-1/3000:0) zeros(1,900/Ts)]'];
% D_Fault8=[Time' 1-[zeros(1,2400/Ts) ones(1,100/Ts) zeros(1,1900/Ts)]'];
% D_Fault9=[Time' 1-[zeros(1,2700/Ts) ones(1,200/Ts) zeros(1,1500/Ts)]'];
% D_Fault10=[Time' 1-[zeros(1,3300/Ts) ones(1,100/Ts) zeros(1,1000/Ts)]'];

% % %6th fault scenario
% D_Fault1=[Time' 1-[zeros(1,3800/Ts) ones(1,100/Ts) zeros(1,500/Ts)]'];
% D_Fault2=[Time' 1-[zeros(1,2600/Ts) ones(1,100/Ts) zeros(1,1700/Ts)]'];
% D_Fault3=[Time' 1-[zeros(1,4000/Ts) ones(1,100/Ts) zeros(1,300/Ts)]'];
% D_Fault4=[Time' 1-[zeros(1,2900/Ts) ones(1,100/Ts) zeros(1,1400/Ts)]'];
% D_Fault5=[Time' 1-[zeros(1,600/Ts) ones(1,100/Ts) zeros(1,3700/Ts)]'];
% D_Fault6=[Time' 1-[zeros(1,1500/Ts) ones(1,100/Ts) zeros(1,2800/Ts)]'];
% D_Fault7=[Time' 1-[zeros(1,1800/Ts) (0:1/3000:2999/3000) ones(1,40/Ts) (2999/3000:-1/3000:0) zeros(1,2500/Ts)]'];
% D_Fault8=[Time' 1-[zeros(1,100/Ts) ones(1,100/Ts) zeros(1,4200/Ts)]'];
% D_Fault9=[Time' 1-[zeros(1,2000/Ts) ones(1,200/Ts) zeros(1,2200/Ts)]'];
% D_Fault10=[Time' 1-[zeros(1,3500/Ts) ones(1,100/Ts) zeros(1,800/Ts)]'];
% 
% %7th fault scenario
% D_Fault1=[Time' 1-[zeros(1,4200/Ts) ones(1,100/Ts) zeros(1,100/Ts)]'];
% D_Fault2=[Time' 1-[zeros(1,4000/Ts) ones(1,100/Ts) zeros(1,300/Ts)]'];
% D_Fault3=[Time' 1-[zeros(1,3700/Ts) ones(1,100/Ts) zeros(1,600/Ts)]'];
% D_Fault4=[Time' 1-[zeros(1,3500/Ts) ones(1,100/Ts) zeros(1,800/Ts)]'];
% D_Fault5=[Time' 1-[zeros(1,3000/Ts) ones(1,100/Ts) zeros(1,1300/Ts)]'];
% D_Fault6=[Time' 1-[zeros(1,2700/Ts) ones(1,100/Ts) zeros(1,1600/Ts)]'];
% D_Fault7=[Time' 1-[zeros(1,2500/Ts) (0:1/3000:2999/3000) ones(1,40/Ts) (2999/3000:-1/3000:0) zeros(1,1800/Ts)]'];
% D_Fault8=[Time' 1-[zeros(1,2100/Ts) ones(1,100/Ts) zeros(1,2200/Ts)]'];
% D_Fault9=[Time' 1-[zeros(1,1400/Ts) ones(1,200/Ts) zeros(1,2800/Ts)]'];
% D_Fault10=[Time' 1-[zeros(1,1000/Ts) ones(1,100/Ts) zeros(1,3300/Ts)]'];

% % 8th fault scenario
% D_Fault1=[Time' 1-[zeros(1,100/Ts) ones(1,100/Ts) zeros(1,4200/Ts)]'];
% D_Fault2=[Time' 1-[zeros(1,500/Ts) ones(1,100/Ts) zeros(1,3800/Ts)]'];
% D_Fault3=[Time' 1-[zeros(1,900/Ts) ones(1,100/Ts) zeros(1,3400/Ts)]'];
% D_Fault4=[Time' 1-[zeros(1,1200/Ts) ones(1,100/Ts) zeros(1,3100/Ts)]'];
% D_Fault5=[Time' 1-[zeros(1,1700/Ts) ones(1,100/Ts) zeros(1,2600/Ts)]'];
% D_Fault6=[Time' 1-[zeros(1,2900/Ts) ones(1,100/Ts) zeros(1,1400/Ts)]'];
% D_Fault7=[Time' 1-[zeros(1,3400/Ts) (0:1/3000:2999/3000) ones(1,40/Ts) (2999/3000:-1/3000:0) zeros(1,900/Ts)]'];
% D_Fault8=[Time' 1-[zeros(1,4200/Ts) ones(1,100/Ts) zeros(1,100/Ts)]'];
% D_Fault9=[Time' 1-[zeros(1,300/Ts) ones(1,200/Ts) zeros(1,3900/Ts)]'];
% D_Fault10=[Time' 1-[zeros(1,2200/Ts) ones(1,100/Ts) zeros(1,2100/Ts)]'];

% 9th fault scenario

% D_Fault2=[Time' 1-[zeros(1,100/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,2330/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,1830/Ts) ]'];
% Offset_Beta_2_m2=[Time' [zeros(1,100/Ts) 0.5*ones(1,10/Ts) zeros(1,5/Ts) 1*ones(1,10/Ts) zeros(1,5/Ts) 1.5*ones(1,10/Ts) zeros(1,5/Ts) 2*ones(1,10/Ts) zeros(1,5/Ts) 3*ones(1,10/Ts) zeros(1,2330/Ts) 0.5*ones(1,10/Ts) zeros(1,5/Ts) 1*ones(1,10/Ts) zeros(1,5/Ts) 1.5*ones(1,10/Ts) zeros(1,5/Ts) 2*ones(1,10/Ts) zeros(1,5/Ts) 3*ones(1,10/Ts) zeros(1,1830/Ts) ]'];
% 
% D_Fault5=[Time' 1-[zeros(1,500/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,2330/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,5/Ts) ones(1,10/Ts) zeros(1,1430/Ts) ]'];
% Offset_Omega_r_m2=[Time' [zeros(1,500/Ts) 0.1*ones(1,10/Ts) zeros(1,5/Ts) 0.2*ones(1,10/Ts) zeros(1,5/Ts) 0.5*ones(1,10/Ts) zeros(1,5/Ts) 1*ones(1,10/Ts) zeros(1,5/Ts) 2*ones(1,10/Ts) zeros(1,2330/Ts) 0.1*ones(1,10/Ts) zeros(1,5/Ts) 0.2*ones(1,10/Ts) zeros(1,5/Ts) 0.5*ones(1,10/Ts) zeros(1,5/Ts) 1*ones(1,10/Ts) zeros(1,5/Ts) 2*ones(1,10/Ts) zeros(1,1430/Ts) ]'];
% Offset_Omega_g_m2=[Time' [zeros(1,500/Ts) 2.5*ones(1,10/Ts) zeros(1,5/Ts) 4*ones(1,10/Ts) zeros(1,5/Ts) 5*ones(1,10/Ts) zeros(1,5/Ts) 6*ones(1,10/Ts) zeros(1,5/Ts) 8*ones(1,10/Ts) zeros(1,2330/Ts) 2.5*ones(1,10/Ts) zeros(1,5/Ts) 4*ones(1,10/Ts) zeros(1,5/Ts) 5*ones(1,10/Ts) zeros(1,5/Ts) 6*ones(1,10/Ts) zeros(1,5/Ts) 8*ones(1,10/Ts) zeros(1,1430/Ts) ]'];
 
 
% D_Fault1=[Time' 1-[zeros(1,300/Ts) ones(1,100/Ts) zeros(1,4000/Ts)]'];
% D_Fault3=[Time' 1-[zeros(1,700/Ts) ones(1,100/Ts) zeros(1,3600/Ts)]'];
% D_Fault4=[Time' 1-[zeros(1,1000/Ts) ones(1,100/Ts) zeros(1,3300/Ts)]'];
% D_Fault6=[Time' 1-[zeros(1,1900/Ts) ones(1,100/Ts) zeros(1,2400/Ts)]'];
% D_Fault7=[Time' 1-[zeros(1,1400/Ts) (0:1/3000:2999/3000) ones(1,40/Ts) (2999/3000:-1/3000:0) zeros(1,2900/Ts)]'];
% D_Fault8=[Time' 1-[zeros(1,4200/Ts) ones(1,100/Ts) zeros(1,100/Ts)]'];
% D_Fault9=[Time' 1-[zeros(1,3300/Ts) ones(1,200/Ts) zeros(1,900/Ts)]'];
% D_Fault10=[Time' 1-[zeros(1,2200/Ts) ones(1,100/Ts) zeros(1,2100/Ts)]'];

% %without Fault
% D_Fault1=[Time' 1-[zeros(1,4400/Ts)]'];
% D_Fault2=[Time' 1-[zeros(1,4400/Ts)]'];
% D_Fault3=[Time' 1-[zeros(1,4400/Ts)]'];
% D_Fault4=[Time' 1-[zeros(1,4400/Ts)]'];
% D_Fault5=[Time' 1-[zeros(1,4400/Ts)]'];
% D_Fault6=[Time' 1-[zeros(1,4400/Ts)]'];
% D_Fault7=[Time' 1-[zeros(1,4400/Ts)]'];
% D_Fault8=[Time' 1-[zeros(1,4400/Ts)]'];
% D_Fault9=[Time' 1-[zeros(1,4400/Ts)]'];
%  D_Fault10=[Time' 1-[zeros(1,4400/Ts)]'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Noise Seeds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

min_seed = 0;
max_seed = 999;
% Generate random seeds for 13 'Random Number' Generators blocks
seed = min_seed + (max_seed-min_seed).*rand(13, 1);
% Round up to integer
seed = ceil(seed);

%% Simulation 
open_system('FDI_measures.mdl');

tic
sim('FDI_measures.mdl');
toc

