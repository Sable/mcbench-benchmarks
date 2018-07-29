function flicker_Calculation_complete (j,i,n,Sk,Sn,Alpha,Un,Kp,Ki,Fn,F_Sample,Tp,Simulation_dynamic_cut_time,N10,N120,File_save_name,I1_Ns,I2_Ns,I3_Ns,U1_NS,U2_NS,U3_NS)
%--initial Input data for the Flicker simulated fictious grid--
%Fn = 50;%noninal frequency in Hz
%F_Sample = 0.00025;%1/Hz Used in FAMOS (Delta X)
%Fs = 1/F_Sample; %in Hz & must be greater than 2000 Hz 
%Simulation_dynamic_cut_time = 0.06;% In FAMOS Used
%Simulation_Time = 40;%run time of the simulation Used in Matlab simulink & FAMOS
%--Please state which measurement you want to analysis:
%--i=1 for continuous operation
%--i=2 for switching operation
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
%-----------------end-----------------------

%---------Loading measured data-------------
%IFN = 'Input_Data_MATLAB_'; % The name of the Input Data file 
%loadfile = strcat(IFN,j);
%open (loadfile);
%-----------------end-----------------------
%----Starting the fictatious grid simulation--------------------
%options = simset( 'SrcWorkspace' , 'current' );
assignin('base', 'Alpha',eval('Alpha'));
assignin('base', 'Tp',eval('Tp'));
assignin('base', 'I1_Ns',eval('I1_Ns'));
assignin('base', 'I2_Ns',eval('I2_Ns'));
assignin('base', 'I3_Ns',eval('I3_Ns'));
assignin('base', 'U1_NS',eval('U1_NS'));
assignin('base', 'U2_NS',eval('U2_NS'));
assignin('base', 'U3_NS',eval('U3_NS'));
sim('Flickermeter6140021_new_GL_Final_3ph');
%-----------------end-----------------------
%-------Saving Needed signals--------% 
savefile = sprintf('Simulation_results_%d_%d',j,Alpha);
Time_1 = Ufic_t.time; % X-axis for Simulation Time

Ufic_t_1 = Ufic_t.signals.values(:,1); % Y-axis Ufic_1
Ufic_t_2 = Ufic_t.signals.values(:,2);% Y-axis Ufic_2
Ufic_t_3 = Ufic_t.signals.values(:,3);% Y-axis Ufic_3

U0_t_1 = U0_t_3ph.signals.values(:,1);% Y-axis U0_1
U0_t_2 = U0_t_3ph.signals.values(:,2);% Y-axis U0_2
U0_t_3 = U0_t_3ph.signals.values(:,3);% Y-axis U0_3

ku_psyk_1 = ku_psyk.signals.values(:,1);% Y-axis ku_psyk_1
ku_psyk_2 = ku_psyk.signals.values(:,3);% Y-axis ku_psyk_2
ku_psyk_3 = ku_psyk.signals.values(:,5);% Y-axis ku_psyk_3

f1 = Frequency_signal_realization.signals.values(:,1);% Y-axis f1
f2 = Frequency_signal_realization.signals.values(:,2);% Y-axis f2
f3 = Frequency_signal_realization.signals.values(:,3);% Y-axis f3

U1N_NS_PU = Voltage_signal_realization.signals(1,1).values(:,1);% Y-axis U1N_NS_PU
U2N_NS_PU = Voltage_signal_realization.signals(1,2).values(:,1);% Y-axis U2N_NS_PU
U3N_NS_PU = Voltage_signal_realization.signals(1,3).values(:,1);% Y-axis U3N_NS_PU
save (savefile, 'Time_1','Ufic_t_1','Ufic_t_2','Ufic_t_3','U0_t_1','U0_t_2','U0_t_3','ku_psyk_1','ku_psyk_2','ku_psyk_3','f1','f2','f3', 'F_Sample', 'Simulation_dynamic_cut_time', 'Tp');
%------------ Cut now ---------------
Ufic_t_1 = Ufic_t_1((Simulation_dynamic_cut_time/F_Sample):end);
Ufic_t_2 = Ufic_t_2((Simulation_dynamic_cut_time/F_Sample):end);
Ufic_t_3 = Ufic_t_3((Simulation_dynamic_cut_time/F_Sample):end);
U0_t_1 = U0_t_1((Simulation_dynamic_cut_time/F_Sample):end);
U0_t_2 = U0_t_2((Simulation_dynamic_cut_time/F_Sample):end);
U0_t_3 = U0_t_3((Simulation_dynamic_cut_time/F_Sample):end);


%------Getting Pst & S using the flickermeter-----------------------
Fs = 1/F_Sample; %in Hz & must be greater than 2000 Hz 
[P_st_fic1 S_fic1] = flicker_sim (Ufic_t_1, Fs, Fn);
[P_st_fic2 S_fic2] = flicker_sim (Ufic_t_2, Fs, Fn);
[P_st_fic3 S_fic3] = flicker_sim (Ufic_t_3, Fs, Fn);
[P_st_01 S_01] = flicker_sim (U0_t_1, Fs, Fn);
[P_st_02 S_02] = flicker_sim (U0_t_2, Fs, Fn);
[P_st_03 S_03] = flicker_sim (U0_t_3, Fs, Fn);
P_st_fic_ave = (P_st_fic1+P_st_fic2+P_st_fic3)/3;% P_st_fic average value for the 3 phases
%-----------------end-----------------------
%------Calculating c & kf & Pst & Plt according to IEC-----------------
Sk_fic = n*Sn;%Short cicuit apparent power in KVA of the Fictiious grid
ku_psyk_max_1 = max(ku_psyk_1);
ku_psyk_max_2 = max(ku_psyk_2);
ku_psyk_max_3 = max(ku_psyk_3);
ku_psyk_max_ave = (ku_psyk_max_1+ku_psyk_max_2+ku_psyk_max_3)/3;
d_max_ave = 100*ku_psyk_max_ave*(Sn/Sk);
if (i == 1)
    cpsyk_1 = P_st_fic1*(Sk_fic/Sn);
    cpsyk_2 = P_st_fic2*(Sk_fic/Sn);
    cpsyk_3 = P_st_fic3*(Sk_fic/Sn);
    Pst_1 = cpsyk_1*(Sn/Sk);
    Pst_2 = cpsyk_2*(Sn/Sk);
    Pst_3 = cpsyk_3*(Sn/Sk);
    Plt_1 = Pst_1;
    Plt_2 = Pst_2;
    Plt_3 = Pst_3;
    Pst_ave = (Pst_1+Pst_2+Pst_3)/3;
    Plt_ave = Pst_ave;
    cpsyk_ave = (cpsyk_1+cpsyk_2+cpsyk_3)/3;
    save (File_save_name,'Pst_ave','Plt_ave','P_st_fic_ave','ku_psyk_max_ave','Ufic_t_1','cpsyk_ave','Pst_1','Pst_2','Pst_3','cpsyk_1','cpsyk_2','cpsyk_3');
elseif (i == 2)
    kf_psyk_1 = (1/130)*P_st_fic1*(Sk_fic/Sn)* (Tp^0.31);
    kf_psyk_2 = (1/130)*P_st_fic2*(Sk_fic/Sn)* (Tp^0.31);
    kf_psyk_3 = (1/130)*P_st_fic3*(Sk_fic/Sn)* (Tp^0.31);
    Pst_1 = 18*(N10^0.31)*kf_psyk_1*(Sn/(Sk*1000));
    Plt_1 = 8*(N120^0.31)*kf_psyk_1*(Sn/(Sk*1000));
    Pst_2 = 18*(N10^0.31)*kf_psyk_2*(Sn/(Sk*1000));
    Plt_2 = 8*(N120^0.31)*kf_psyk_2*(Sn/(Sk*1000));
    Pst_3 = 18*(N10^0.31)*kf_psyk_3*(Sn/(Sk*1000));
    Plt_3 = 8*(N120^0.31)*kf_psyk_3*(Sn/(Sk*1000));
    Pst_ave = (Pst_1+Pst_2+Pst_3)/3;
    Plt_ave = (Plt_1+Plt_2+Plt_3)/3;
    kf_psyk_ave = (kf_psyk_1+kf_psyk_2+kf_psyk_3)/3;
    save (File_save_name,'Pst_ave','Plt_ave','P_st_fic_ave','ku_psyk_max_ave','Ufic_t_1','kf_psyk_ave','Pst_1','Pst_2','Pst_3','kf_psyk_1','kf_psyk_2','kf_psyk_3','ku_psyk_max_1','ku_psyk_max_2','ku_psyk_max_3');
else
    f1 = warndlg('Please Enter a correct value for i', 'Warning');
end
 %-----------------end-----------------------   
 
