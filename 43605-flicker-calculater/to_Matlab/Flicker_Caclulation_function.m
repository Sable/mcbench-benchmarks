function Flicker_Caclulation_function (endval,endval1,Sn,Sk,n,Un,Fn,i,Kp,Ki,F_Sample,Simulation_dynamic_cut_time,N10,N120,U1N_NS,U2N_NS,U3N_NS,I1_NS,I2_NS,I3_NS,time) 
% Initial Input data for calculating a complete flicker valuses of a
% meassured data.
% endval1 is the number of calculation to be done (for different Grid phase
% angle
% Sn is Appparent power in kW
% Sk is Short circuit apparent power in MW
% n is % the rate between Sfic/Sn as defined by IEC norm
% Un is Nominal Voltage where the measurment were done in V.
% Fn is Nominal Frequency of the grid were the measurment were done in Hz.
% i is a selector between i = 1 Continuous operation and i = 2 and switching operation.
% Kp Proportional Gain Factor of the PLL Block.
% Ki Integral Gain Factor of the PLL Block.
% F_Sample is Sampling Frequencz used in recording the measurments in S.
% Simulation_dynamic_cut_time is the estimated time needed by the PI
% controller when calculating the Frequency. (this simulation dynamic time
% need to be removed)
% N10 is Number of switching operation with in 10 min (As given in IEC norm)
% N120 is Number of switching operation with in 2 h (As given in IEC norm)
% dataname is the measured data name that should be analyized and it should
% have the format .mat and need to contain the measured three phase
% voltages and current signals with there time axie.
% this file assume that the measured three pahse voltage and current are identical and have the same:
% 1- Sampling rate (time intervals)
% 2- data length (Which is according to the IEC 10 min of measured data)
% This function will also call the Flickermeter simulater (File ID: #24423
% by Patrik Jourdan 12 Jun 2009 (Updated 11 Jan 2010)) in order to
% calculate the flicker values calculated by the Fictitious grid module (so
% called Flickermeter6140021_new_GL_Final_3ph.mdl).
% Please refer to the PDF documentation file in order to get more
% information on how this function works
Sfic = (n*Sn)/1000;% Fictitious Short cicuit apparent power grid in MW
P_st_fic_complete_ave = 0;
P_st_complete_ave = 0;
P_lt_complete_ave = 0;
if i == 2
    P_st_fic_complete = zeros(1,endval);
    P_st_complete = zeros(1,endval);
    P_lt_complete = zeros(1,endval);
    kf_psyk_complete = zeros(1,endval);
    ku_psyk_complete = zeros(1,endval);
    kf_psyk_complete_ave = 0;
    ku_psyk_complete_ave = 0;
    save ('Initial values','time','U1N_NS','U2N_NS','U3N_NS','I1_NS','I2_NS','I3_NS','endval','endval1','Sn','Sk','n','Sfic','Un','Fn','i','Kp','Ki','F_Sample','Simulation_dynamic_cut_time','N10','N120','P_st_fic_complete','P_st_complete','P_lt_complete','kf_psyk_complete','ku_psyk_complete','P_st_fic_complete_ave','P_st_complete_ave','P_lt_complete_ave','kf_psyk_complete_ave','ku_psyk_complete_ave')
elseif i == 1
    P_st_fic_complete = zeros(1,endval);
    P_st_complete = zeros(1,endval);
    P_lt_complete = zeros(1,endval);
    c_psyk_complete = zeros(1,endval);
    c_psyk_complete_ave = 0;
    save ('Initial values','time','U1N_NS','U2N_NS','U3N_NS','I1_NS','I2_NS','I3_NS','endval','endval1','Sn','Sk','n','Sfic','Un','Fn','i','Kp','Ki','F_Sample','Simulation_dynamic_cut_time','N10','N120','P_st_fic_complete','P_st_complete','P_lt_complete','c_psyk_complete','P_st_fic_complete_ave','P_st_complete_ave','P_lt_complete_ave','c_psyk_complete_ave')
else
end
clear
load 'Initial values'
%-------------------------------------------------------------------------------------End--------------------------------------------------------------------------------------------
for jj=1:endval1
    prompt4 = {'Please Enter The new phase angle Alpha in degree'};
    name = 'Initial Input data';
    numlines = 1;
    defaultanswer4 = {'30'};
    answer4 = inputdlg(prompt4,name,numlines,defaultanswer4);
    Alpha = str2double(answer4{1});
    if jj>1 && i == 2
        save ('Initial values','time','U1N_NS','U2N_NS','U3N_NS','I1_NS','I2_NS','I3_NS','endval','endval1','Sn','Sk','n','Sfic','Un','Fn','i','Kp','Ki','F_Sample','Simulation_dynamic_cut_time','N10','N120','j','jj','Sequence_Path','Searchdir','P_st_fic_complete','P_st_complete','P_lt_complete','kf_psyk_complete','ku_psyk_complete','P_st_fic_complete_ave','P_st_complete_ave','P_lt_complete_ave','kf_psyk_complete_ave','ku_psyk_complete_ave')
        clear
        load 'Initial values'
    elseif jj>1 && i == 1
        save ('Initial values','time','U1N_NS','U2N_NS','U3N_NS','I1_NS','I2_NS','I3_NS','endval','endval1','Sn','Sk','n','Sfic','Un','Fn','i','Kp','Ki','F_Sample','Simulation_dynamic_cut_time','N10','N120','j','jj','Alpha','P_st_fic_complete','P_st_complete','P_lt_complete','c_psyk_complete','P_st_fic_complete_ave','P_st_complete_ave','P_lt_complete_ave','c_psyk_complete_ave')
        clear
        load 'Initial values'
    end
    for j=1:endval
        if i == 2
            save ('Initial values','time','U1N_NS','U2N_NS','U3N_NS','I1_NS','I2_NS','I3_NS','endval','endval1','Sn','Sk','n','Sfic','Un','Fn','i','Kp','Ki','F_Sample','Simulation_dynamic_cut_time','N10','N120','j','jj','Alpha','P_st_fic_complete','P_st_complete','P_lt_complete','kf_psyk_complete','ku_psyk_complete','P_st_fic_complete_ave','P_st_complete_ave','P_lt_complete_ave','kf_psyk_complete_ave','ku_psyk_complete_ave')
            I1_NS = [time' I1_NS'];
            I2_NS = [time' I2_NS'];
            I3_NS = [time' I3_NS'];
            U1_NS = [time' U1N_NS'];
            U2_NS = [time' U2N_NS'];
            U3_NS = [time' U3N_NS'];
            savenamerowdata = sprintf('Input_Data_Matlab_%d',j);
            save (savenamerowdata,'I1_NS','I2_NS','I3_NS','U1_NS','U2_NS','U3_NS','j','i');
            loadfile = [savenamerowdata];
            load ([loadfile '.mat'])
            % Input info for the Fictitious grid Module & Flickermeter
            % afterword and the name of the saved result file
            Tp = eval(sprintf('Simulation_Time_%d',j));
            Fs = 1/F_Sample; %in Hz & must be greater than 2000 Hz
            File_save_name = sprintf('Final_results_%d_%d',j,Alpha);
            filesavename = File_save_name;
            flicker_Calculation_complete (j,i,n,Sk,Sn,Alpha,Un,Kp,Ki,Fn,F_Sample,Tp,Simulation_dynamic_cut_time,N10,N120,File_save_name);
            loadfile_final = [File_save_name];
            load ([loadfile_final '.mat'])
            P_st_fic_complete(j) = P_st_fic_ave;
            P_st_complete(j) = Pst_ave;
            P_lt_complete(j) = Plt_ave;
            kf_psyk_complete(j) = kf_psyk_ave;
            ku_psyk_complete(j) = ku_psyk_max_ave;
            P_st_fic_complete_ave = mean(P_st_fic_complete);
            P_st_complete_ave = mean(P_st_complete);
            P_lt_complete_ave = mean(P_lt_complete);
            kf_psyk_complete_ave = mean(kf_psyk_complete);
            ku_psyk_complete_ave = mean(ku_psyk_complete);
            complet_results = sprintf('Complete_Results_%d',Alpha);
            save (complet_results,'P_st_fic_complete','P_st_complete','P_lt_complete','kf_psyk_complete','ku_psyk_complete','P_st_fic_complete_ave','P_st_complete_ave','P_lt_complete_ave','kf_psyk_complete_ave','ku_psyk_complete_ave');
            save ('Initial values','time','U1N_NS','U2N_NS','U3N_NS','I1_NS','I2_NS','I3_NS','endval','endval1','Sn','Sk','n','Sfic','Un','Fn','i','Kp','Ki','F_Sample','Simulation_dynamic_cut_time','N10','N120','j','jj','Alpha','P_st_fic_complete','P_st_complete','P_lt_complete','kf_psyk_complete','ku_psyk_complete','P_st_fic_complete_ave','P_st_complete_ave','P_lt_complete_ave','kf_psyk_complete_ave','ku_psyk_complete_ave')
            clear
            load 'Initial values'
        elseif i == 1
            save ('Initial values','time','U1N_NS','U2N_NS','U3N_NS','I1_NS','I2_NS','I3_NS','endval','endval1','Sn','Sk','n','Sfic','Un','Fn','i','Kp','Ki','F_Sample','Simulation_dynamic_cut_time','N10','N120','j','jj','Alpha','P_st_fic_complete','P_st_complete','P_lt_complete','c_psyk_complete','P_st_fic_complete_ave','P_st_complete_ave','P_lt_complete_ave','c_psyk_complete_ave')
            load('Initial values.mat')
            I1_Ns = [time' I1_NS'];
            I2_Ns = [time' I2_NS'];
            I3_Ns = [time' I3_NS'];
            U1_NS = [time' U1N_NS'];
            U2_NS = [time' U2N_NS'];
            U3_NS = [time' U3N_NS'];
            Tp = time(end);
            %Fs = 1/F_Sample;
            %Simulation_Time = Cut_Time;
            savenamerowdata = sprintf('Input_Data_Matlab_%d',j);
            save (savenamerowdata,'I1_Ns','I2_Ns','I3_Ns','U1_NS','U2_NS','U3_NS','j','i','Tp');
            loadfile = [savenamerowdata];
            load ([loadfile '.mat'])
            % Input info for the Fictitious grid Module & Flickermeter
            % afterword and the name of the saved result file
            File_save_name = sprintf('Final_results_%d_%d',j,Alpha);
            flicker_Calculation_complete (j,i,n,Sk,Sn,Alpha,Un,Kp,Ki,Fn,F_Sample,Tp,Simulation_dynamic_cut_time,N10,N120,File_save_name,I1_Ns,I2_Ns,I3_Ns,U1_NS,U2_NS,U3_NS);
            loadfile_final = [File_save_name];
            load ([loadfile_final '.mat'])
            P_st_fic_complete(j) = P_st_fic_ave;
            P_st_complete(j) = Pst_ave;
            P_lt_complete(j) = Plt_ave;
            c_psyk_complete(j) =  cpsyk_ave;
            P_st_fic_complete_ave = mean(P_st_fic_complete);
            P_st_complete_ave = mean(P_st_complete);
            P_lt_complete_ave = mean(P_lt_complete);
            c_psyk_complete_ave = mean(c_psyk_complete);
            complet_results = sprintf('Complete_Results_%d',Alpha);
            save (complet_results,'P_st_fic_complete','P_st_complete','P_lt_complete','c_psyk_complete','P_st_fic_complete_ave','P_st_complete_ave','P_lt_complete_ave','c_psyk_complete_ave');
            save ('Initial values','time','endval','U1N_NS','U2N_NS','U3N_NS','I1_NS','I2_NS','I3_NS','endval1','Sn','Sk','n','Sfic','Un','Fn','i','Kp','Ki','F_Sample','Simulation_dynamic_cut_time','N10','N120','j','jj','Alpha','P_st_fic_complete','P_st_complete','P_lt_complete','c_psyk_complete','P_st_fic_complete_ave','P_st_complete_ave','P_lt_complete_ave','c_psyk_complete_ave')
            clear
            load 'Initial values'
        else
        end
        button = questdlg('The next Row Data calculation is about to start do you want to finish running this M-file?', ...
            'Exit Dialog','Yes','No','No');
        switch button
            case 'Yes',
                disp('Exiting MATLAB');
                %Save variables to matlab.mat
                save
            case 'No',
                quit cancel;
        end
    end
    button = questdlg('The next calculation for a new phase angle of the fictious grid Alpha is about to start do you want to finish running this M-file?', ...
        'Exit Dialog','Yes','No','No');
    switch button
        case 'Yes',
            disp('Exiting MATLAB');
            %Save variables to matlab.mat
            save
        case 'No',
            quit cancel;
    end
end






