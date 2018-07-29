%% This only an example file the results obtained from this file does not
%% give a real feeling of the expected output of the
%% Flicker_Calculation_function
% This m.file in only used to generate a set of measured data and try to
% show how this measured data can be used in the Flicker function in order
% to calculate the flicker values according to the IEC 61400-21.
% this m.file calls two other m.files which are: 
% 1- IEC_Analysis_Function_Matlab_2007: which will calculate the amount of power in the generated three phase voltages and currents accordint to the IEC 61400-21 norm
% 2- Flicer_Calculation_function: which in its turn will also call another
% two m.files.
% - the first called m.file is used to run the follwing Module
% Flickermeter6140021_new_GL_Final_3ph.mdl which will simulate the effect
% of the Fictitious grid descriped by the IEC 61400-21
% - the second called m.file is taken from Matlab file exchange service in
% order to calculate the long and short flicker values according to the IEC
% 61400-21 & IEC 61400-15
% Author: Msc.Eng. Aubai AlKhatib   Date: 23.09.2013
clear global
clc
F_Sample = 1000;%Hz
t = 0:(1/F_Sample):10;%Time in S
fn = 50;%Hz
U1 = 400 * sin(2*fn*pi*t);%Sine wave 1
U2 = 400 * sin((2*fn*pi*t) - (120*pi/180));%Sine wave 2
U3= 400 * sin((2*fn*pi*t) + (120*pi/180));%Sine wave 3
I1 = 5000 * sin(2*fn*pi*t);%Sine wave 1
I2 = 5000 * sin((2*fn*pi*t) - (120*pi/180));%Sine wave 2
I3 = 5000 * sin((2*fn*pi*t) + (120*pi/180));%Sine wave 3
[Ua1rms,Ub1rms,Uc1rms,Ia1rms,Ib1rms,Ic1rms,P1pos,Q1pos,U1pos,Iact1pos,Ireac1pos,cosphi1pos,time] = IEC_Analysis_Function_Matlab_2007(U1,U2,U3,I1,I2,I3,t,fn);
figure(1);
subplot(2,1,1)
plot(t,U1);hold on; plot(t,U2,'r');hold on; plot(t,U3,'g');xlim([0,0.2]);hold off;
subplot(2,1,2)
plot(t,I1);hold on; plot(t,I2,'r');hold on; plot(t,I3,'g');xlim([0,0.2]);hold off;
%i = 2;%an operation selector
%Sn = 1700;%rated apparent power in kW
%n = 20; % Short cicuit Ratio in %
%Alpha = 30;% Fictiious grid impedance phase angle in degree
%Un = 400;% Nominal Voltage Low voltage side in V
%Sk = 105;%Short cicuit apparent power in MVA
%Kp = 50;% Regulater gain for PLL in simulink
%Ki = 1400;% Regulater gain for PLL in simulink
%N10 = 2;% Number of switching operation with in 10 min
%N120 = 24;% Number of switching operation with in 2 h
i = 1;
endval = 1;
endval1 = 2;
Sn = mean(P1pos)/1000;
Sk = 105;
n = 20;
Un = 400;
Fn = 50;
Kp = 50;
Ki = 1400;
F_Sample = 1/F_Sample;
Simulation_dynamic_cut_time = 0.1;
N10 = 2;
N120 = 24;
Flicker_Caclulation_function (endval,endval1,Sn,Sk,n,Un,Fn,i,Kp,Ki,F_Sample,Simulation_dynamic_cut_time,N10,N120,U1,U2,U3,I1,I2,I3,t)
clear
clc
load('Complete_Results_30.mat');
