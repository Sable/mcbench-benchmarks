function [THD_U,THD_I,K_U,K_I,MaxHarm_I,MaxIHarm_I,MaxHFHarm_I,MaxHarm_U,MaxIHarm_U,MaxHFHarm_U,Order_Harm,Order_IHarm,Order_HFHarm] = IEC_Harmonics_final(f,Vn,Inom,U1,U2,U3,I1,I2,I3,U1_time,U2_time,U3_time,I1_time,I2_time,I3_time,figures)
% This function will calculate the Harmonics spectrum values according to
% the IEC 61000-4-7 Norm which spesify the need for 10 min Voltage and
% current measured signals of the system under study and calulate the
% Harmonics mean values every 10 Periods of the measured signal (In this case 50 Hz signal)
% This Fucntion inputs are:
%           1- The nominal values of the measured signal: Frequency,
%           Voltage, and the current. For example f = 50%Hz
%                                                 Vn = 400%V (Phase to Phase Voltage of the grid)
%                                                 Inom = 475%A (The nominal
%                                                 current of the system under measurement)
%           2- The measured Voltages and current signals with there time
%           measurement signals (U1,U2,U3,I1,I2,I3,U1_time,U2_time,U3_time,I1_time,I2_time,I3_time)
%           3- figures is an input of 1 or 0 in order to activate showing the figures of the different  harmonics spectrums figures calculated in this function.
%PS: This function assume that you have the same sampling rate of the
%different measured signals and that all measured signals has the same
%length.
Fn = f;
Un = Vn;
In = Inom;
Delta_Time_Orginal = I1_time(2)-I1_time(1);
F_Sample = abs(1/Delta_Time_Orginal);
%------------------------------------------------------------------------------------------------------
%---------------------- The Harmonics Spectrum of the complet input signal ----------------------------
%------------------------------------------------------------------------------------------------------
Tp = length(I3_time);
T_S = abs(Tp*Delta_Time_Orginal);
[nyquist_number_I1,Bezugsfrequenz_I1,Signal_amp_I1] = Fast_Harmonics (I1,F_Sample,T_S);
[nyquist_number_I2,Bezugsfrequenz_I2,Signal_amp_I2] = Fast_Harmonics (I2,F_Sample,T_S);
[nyquist_number_I3,Bezugsfrequenz_I3,Signal_amp_I3] = Fast_Harmonics (I3,F_Sample,T_S);
[nyquist_number_U1,Bezugsfrequenz_U1,Signal_amp_U1] = Fast_Harmonics (U1,F_Sample,T_S);
[nyquist_number_U2,Bezugsfrequenz_U2,Signal_amp_U2] = Fast_Harmonics (U2,F_Sample,T_S);
[nyquist_number_U3,Bezugsfrequenz_U3,Signal_amp_U3] = Fast_Harmonics (U3,F_Sample,T_S);
if figures
    figure;
    subplot(2,1,1);
    plot([0:nyquist_number_I1]*Bezugsfrequenz_I1,Signal_amp_I1);ylabel('amplitude Currents [A]');title('Harmonic spectrom');hold on
    plot([0:nyquist_number_I2]*Bezugsfrequenz_I2,Signal_amp_I2,'-.r');hold on
    plot([0:nyquist_number_I3]*Bezugsfrequenz_I3,Signal_amp_I3,'--k');hold off
    subplot(2,1,2);
    plot([0:nyquist_number_U1]*Bezugsfrequenz_U1,Signal_amp_U1);xlabel('frequency [Hz]'),ylabel('amplitude Voltages [V]');hold on
    plot([0:nyquist_number_U2]*Bezugsfrequenz_U2,Signal_amp_U2,'-.r');hold on
    plot([0:nyquist_number_U3]*Bezugsfrequenz_U3,Signal_amp_U3,'.k','MarkerSize',0.1);hold off
end
%**********************************************************************
%---------------------- Creating a grouping matrix --------------------
%**********************************************************************
Sampling_Time = Delta_Time_Orginal;
T_10_period = 10/Fn;
F_Sample_Orginal = 1/Sampling_Time;
if abs(F_Sample_Orginal) < 20000
    F_Sample_Complete_Data = 20000;
    [p, q] = rat(abs(Delta_Time_Orginal/(1/F_Sample_Complete_Data)));
    I1_Resampled = resample(I1,p,q);
    I2_Resampled = resample(I2,p,q);
    I3_Resampled = resample(I3,p,q);
    U1_Resampled = resample(U1,p,q);
    U2_Resampled = resample(U2,p,q);
    U3_Resampled = resample(U3,p,q);
    t_P = I1_time(1):((q/p)/F_Sample_Orginal):(I1_time(end)+((q/p)/F_Sample_Orginal));
    tt = length(t_P);
    if length(t_P) == length(I1_Resampled)
        I1_Resampled_time = t_P;
        I2_Resampled_time = t_P;
        I3_Resampled_time = t_P;
        U1_Resampled_time  = t_P;
        U2_Resampled_time  = t_P;
        U3_Resampled_time  = t_P;
    else if length(t_P) < length(I1_Resampled)
            for kk = 1:abs(length(I1_Resampled)-length(t_P))
                t_P(tt+kk) = ((q/p)/F_Sample_Orginal)+t_P(tt+kk-1);
            end
            I1_Resampled_time = t_P;
            I2_Resampled_time = t_P;
            I3_Resampled_time = t_P;
            U1_Resampled_time  = t_P;
            U2_Resampled_time  = t_P;
            U3_Resampled_time  = t_P;
        elseif length(t_P) > length(I1_Resampled)
            t_P = t_P(1:length(I1_Resample));
            I1_Resampled_time = t_P;
            I2_Resampled_time = t_P;
            I3_Resampled_time = t_P;
            U1_Resampled_time  = t_P;
            U2_Resampled_time  = t_P;
            U3_Resampled_time  = t_P;
        end
    end
    Delta_Time_Complete_Data = 1/F_Sample_Complete_Data;
    Sampling_Time_New = Delta_Time_Complete_Data;
    Sampling_frq_New = (1/Sampling_Time_New)/1000;
    Sample_New = T_10_period*Sampling_frq_New*1000;
    ii= 1;
    Points = 2^ii;
    while Points < Sample_New
        Points = 2^ii;
        ii = ii+1;
    end
else if abs(F_Sample_Orginal) > 20000
        F_Sample_Complete_Data = 20000;
        [p, q] = rat(abs(Delta_Time_Orginal/(1/F_Sample_Complete_Data)));
        I1_Resampled = resample(I1,p,q);
        I2_Resampled = resample(I2,p,q);
        I3_Resampled = resample(I3,p,q);
        U1_Resampled = resample(U1,p,q);
        U2_Resampled = resample(U2,p,q);
        U3_Resampled = resample(U3,p,q);
        t_Q = I1_time(1):((q/p)/F_Sample):I1_time(end);
        I1_Resampled_time = t_Q;
        I2_Resampled_time = t_Q;
        I3_Resampled_time = t_Q;
        U1_Resampled_time  = t_Q;
        U2_Resampled_time  = t_Q;
        U3_Resampled_time  = t_Q;
        Delta_Time_Complete_Data = 1/F_Sample_Complete_Data;
        %Sampling_Time_New = Delta_Time_Complete_Data;
        Sampling_frq_New = (1/Sampling_Time_Complete_Data)/1000;
        Sample_New = T_10_period*Sampling_frq_New*1000;
        ii= 1;
        Points = 2^ii;
        while Points < Sample_New
            Points = 2^ii;
            ii = ii+1;
        end
    else
        I1_Resampled = I1;
        I2_Resampled = I2;
        I3_Resampled = I3;
        U1_Resampled = U1;
        U2_Resampled = U2;
        U3_Resampled = U3;
        I1_Resampled_time = I1_time;
        I2_Resampled_time = I2_time;
        I3_Resampled_time = I3_time;
        U1_Resampled_time  = U1_time;
        U2_Resampled_time  = U2_time;
        U3_Resampled_time  = U3_time;
        F_Sample_Complete_Data = 20000;
        Delta_Time_Complete_Data = I1_Resampled_time(2)-I1_Resampled_time(1);
        Sampling_frq = 1/Delta_Time_Complete_Data;
        T_10_period = 10/Fn;
        Sample = T_10_period*Sampling_frq;
        ii= 1;
        Points = 2^ii;
        while Points < Sample
            Points = 2^ii;
            ii = ii+1;
        end
    end
end
%----------------------------------------------------------------------
%--------------- Zeros Results Array Definition -----------------------
%----------------------------------------------------------------------
%--------------- Try --------------------
LOWPASS_CUTOFF = 100;% Filter cutoff frequency is 100 Hz
LOWPASS_ORDER = 4;% Filter order is 4
[b_bw, a_bw] = butter(LOWPASS_ORDER, LOWPASS_CUTOFF / (F_Sample_Complete_Data / 2), 'low');
Filter = filter(b_bw, a_bw, U1_Resampled);
%--------------- End --------------------
null_L1 = find(diff(Filter < 0));
null_L1_x = Zeros_finding(Filter,I1_Resampled_time');
Tp = length(U1_Resampled_time);
len = length(null_L1_x);
%len_1_period = (1/Fn)/Delta_Time_Complete_Data;
%len_10_period = (10*(1/Fn))/Delta_Time_Complete_Data;
Results_U_H1 = zeros(50,length(0:20:len-30));
Results_U_H2 = zeros(50,length(0:20:len-30));
Results_U_H3 = zeros(50,length(0:20:len-30));
Results_U_IH1 = zeros(39,length(0:20:len-30));
Results_U_IH2 = zeros(39,length(0:20:len-30));
Results_U_IH3 = zeros(39,length(0:20:len-30));
Results_U_HF1 = zeros(35,length(0:20:len-30));
Results_U_HF2 = zeros(35,length(0:20:len-30));
Results_U_HF3 = zeros(35,length(0:20:len-30));
Results_P = zeros(length(0:20:len-30));
Results_Q = zeros(length(0:20:len-30));
%----------------------------------------------------------------------
%--------------------------- End --------------------------------------
%----------------------------------------------------------------------
%**********************************************************************
%----------------------------------END---------------------------------
%**********************************************************************
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%**********************************************************************
%--------------------------- Gruoping ---------------------------------
%**********************************************************************
j = 0;
jj = 1;
while j < len-30 % t < t2+0.1
    data_I1 = I1_Resampled(null_L1(j+3):null_L1(j+23)+1);
    data_I2 = I2_Resampled(null_L1(j+3):null_L1(j+23)+1);
    data_I3 = I3_Resampled(null_L1(j+3):null_L1(j+23)+1);
    data_U1 = U1_Resampled(null_L1(j+3):null_L1(j+23)+1);
    data_U2 = U2_Resampled(null_L1(j+3):null_L1(j+23)+1);
    data_U3 = U3_Resampled(null_L1(j+3):null_L1(j+23)+1);
    data_I1_time = I1_Resampled_time(null_L1(j+3):null_L1(j+23)+1);
    %------------------- Cut End --------------------------------------
    %------------------------------------------------------------------
    %--------- Data Resampling with the new Delta_10_Periods ----------
    %------------------------------------------------------------------
    delta = (null_L1_x(j+23)-null_L1_x(j+3))/Points;
    %Rampe = null_L1_x(j+3):delta:(((Points-1)*delta)+null_L1_x(j+3));
    iii=2;
    Rampe = zeros();
    Rampe(1) = null_L1_x(j+3);
    while iii <= Points
        Rampe(iii) = delta+Rampe(iii-1);
        iii = iii+1;
    end
    F_Sample_10_Periods = 1/delta;
    if abs(F_Sample_10_Periods) < F_Sample_Complete_Data
        F_Sample_New = F_Sample_10_Periods;
        [p, q] = rat(abs(Delta_Time/(1/F_Sample_New)));
        I1_Resampled_10_Period = resample(data_I1,p,q);
        I2_Resampled_10_Period = resample(data_I2,p,q);
        I3_Resampled_10_Period = resample(data_I3,p,q);
        U1_Resampled_10_Period = resample(data_U1,p,q);
        U2_Resampled_10_Period = resample(data_U2,p,q);
        U3_Resampled_10_Period = resample(data_U3,p,q);
        t_P = data_I1_time(1):(1/F_Sample_New):(data_I1_time(end)+(1/F_Sample_New));
        I1_Resampled_time_10_Period = t_P;
        I2_Resampled_time_10_Period = t_P;
        I3_Resampled_time_10_Period = t_P;
        U1_Resampled_time_10_Period  = t_P;
        U2_Resampled_time_10_Period  = t_P;
        U3_Resampled_time_10_Period  = t_P;
    else if abs(F_Sample_10_Periods) > F_Sample_Complete_Data
            F_Sample_New = F_Sample_10_Periods;
            [p, q] = rat(abs(Delta_Time_Complete_Data/(1/F_Sample_New)));
            I1_Resampled_10_Period = resample(data_I1,p,q);
            I2_Resampled_10_Period = resample(data_I2,p,q);
            I3_Resampled_10_Period = resample(data_I3,p,q);
            U1_Resampled_10_Period = resample(data_U1,p,q);
            U2_Resampled_10_Period = resample(data_U2,p,q);
            U3_Resampled_10_Period = resample(data_U3,p,q);
            for kk=1:length(I1_Resampled_10_Period)-1
                I1_Resample_10_Period_Final(kk) =  ((I1_Resampled_10_Period(kk)+I1_Resampled_10_Period(kk+1))/2);
                I2_Resample_10_Period_Final(kk) =  ((I2_Resampled_10_Period(kk)+I2_Resampled_10_Period(kk+1))/2);
                I3_Resample_10_Period_Final(kk) =  ((I3_Resampled_10_Period(kk)+I3_Resampled_10_Period(kk+1))/2);
                U1_Resample_10_Period_Final(kk) =  ((U1_Resampled_10_Period(kk)+U1_Resampled_10_Period(kk+1))/2);
                U2_Resample_10_Period_Final(kk) =  ((U2_Resampled_10_Period(kk)+U2_Resampled_10_Period(kk+1))/2);
                U3_Resample_10_Period_Final(kk) =  ((U3_Resampled_10_Period(kk)+U3_Resampled_10_Period(kk+1))/2);
            end
            if length(I1_Resample_10_Period_Final) > length(Rampe)
                I1_Resample_10_Period_Final = I1_Resample_10_Period_Final(1:length(Rampe));
                I2_Resample_10_Period_Final = I2_Resample_10_Period_Final(1:length(Rampe));
                I3_Resample_10_Period_Final = I3_Resample_10_Period_Final(1:length(Rampe));
            else if length(I1_Resample_10_Period_Final) < length(Rampe)
                    error('Please check the Resampled data something wrong there :(')
                end
            end
            t_Q = Rampe(1):((q/p)/F_Sample_Complete_Data):Rampe(end);
            if length(t_Q) == length(I1_Resampled_10_Period)
                I1_Resampled_time_10_Period = t_Q;
                I2_Resampled_time_10_Period = t_Q;
                I3_Resampled_time_10_Period = t_Q;
                U1_Resampled_time_10_Period  = t_Q;
                U2_Resampled_time_10_Period  = t_Q;
                U3_Resampled_time_10_Period  = t_Q;
            else if length(t_Q) > length(I1_Resampled_10_Period)
                    I1_Resampled_time_10_Period = t_Q(1:length(I1_Resampled_10_Period));
                    I2_Resampled_time_10_Period = t_Q(1:length(I2_Resampled_10_Period));
                    I3_Resampled_time_10_Period = t_Q(1:length(I3_Resampled_10_Period));
                    U1_Resampled_time_10_Period = t_Q(1:length(U1_Resampled_10_Period));
                    U2_Resampled_time_10_Period = t_Q(1:length(U2_Resampled_10_Period));
                    U3_Resampled_time_10_Period = t_Q(1:length(U3_Resampled_10_Period));
                else if length(t_Q) < length(I1_Resampled_10_Period)
                        I1_Resampled_time_10_Period = [t_Q t_Q(end)+((q/p)/F_Sample_Complete_Data)];
                        I2_Resampled_time_10_Period = [t_Q t_Q(end)+((q/p)/F_Sample_Complete_Data)];
                        I3_Resampled_time_10_Period = [t_Q t_Q(end)+((q/p)/F_Sample_Complete_Data)];
                        U1_Resampled_time_10_Period = [t_Q t_Q(end)+((q/p)/F_Sample_Complete_Data)];
                        U2_Resampled_time_10_Period = [t_Q t_Q(end)+((q/p)/F_Sample_Complete_Data)];
                        U3_Resampled_time_10_Period = [t_Q t_Q(end)+((q/p)/F_Sample_Complete_Data)];
                    end
                end
            end
        else
            error('Please check the Delta Value of the 10 Period signal')
        end
    end
    %------------------------------------------------------------------
    %---------------- Data Re-sampling End ----------------------------
    %------------------------------------------------------------------
    %----------------Spectrum Calculation------------------------------
    %------------------------------------------------------------------
    Tp_10_Period_Resampled = length(I1_Resampled_time_10_Period);
    Delta_Time_10_Period_Resampled = I1_Resampled_time_10_Period(2)-I1_Resampled_time_10_Period(3);
    F_Sample_10_Period_Resampled = abs(1/Delta_Time_10_Period_Resampled);
    T_S_10_Period_Resampled = abs(Tp*Delta_Time_10_Period_Resampled);
    %----------------------------------------------------------------------
    [nyquist_number_I1_Resampled_10_Period,Bezugsfrequenz_I1_Resampled_10_Period,Signal_amp_I1_Resampled_10_Period] = Fast_Harmonics_1 (I1_Resample_10_Period_Final,F_Sample_10_Period_Resampled,T_S_10_Period_Resampled);
    [nyquist_number_I2_Resampled_10_Period,Bezugsfrequenz_I2_Resampled_10_Period,Signal_amp_I2_Resampled_10_Period] = Fast_Harmonics_1 (I2_Resample_10_Period_Final,F_Sample_10_Period_Resampled,T_S_10_Period_Resampled);
    [nyquist_number_I3_Resampled_10_Period,Bezugsfrequenz_I3_Resampled_10_Period,Signal_amp_I3_Resampled_10_Period] = Fast_Harmonics_1 (I3_Resample_10_Period_Final,F_Sample_10_Period_Resampled,T_S_10_Period_Resampled);
    [nyquist_number_U1_Resampled_10_Period,Bezugsfrequenz_U1_Resampled_10_Period,Signal_amp_U1_Resampled_10_Period] = Fast_Harmonics_1 (U1_Resample_10_Period_Final,F_Sample_10_Period_Resampled,T_S_10_Period_Resampled);
    [nyquist_number_U2_Resampled_10_Period,Bezugsfrequenz_U2_Resampled_10_Period,Signal_amp_U2_Resampled_10_Period] = Fast_Harmonics_1 (U2_Resample_10_Period_Final,F_Sample_10_Period_Resampled,T_S_10_Period_Resampled);
    [nyquist_number_U3_Resampled_10_Period,Bezugsfrequenz_U3_Resampled_10_Period,Signal_amp_U3_Resampled_10_Period] = Fast_Harmonics_1 (U3_Resample_10_Period_Final,F_Sample_10_Period_Resampled,T_S_10_Period_Resampled);
    Figure_Show = 0;
    if Figure_Show == 1
        figure;
        subplot(2,1,1);
        plot([0:nyquist_number_data_I1]*Bezugsfrequenz_data_I1,Signal_amp_data_I1);ylabel('amplitude Currents [A]');title('Harmonic spectrom');hold on
        plot([0:nyquist_number_data_I2]*Bezugsfrequenz_data_I2,Signal_amp_data_I2,'-.r');hold on
        plot([0:nyquist_number_data_I3]*Bezugsfrequenz_data_I3,Signal_amp_data_I3,'--k');hold off
        subplot(2,1,2);
        plot([0:nyquist_number_data_U1]*Bezugsfrequenz_data_U1,Signal_amp_data_U1);xlabel('frequency [Hz]'),ylabel('amplitude Voltages [A]');hold on
        plot([0:nyquist_number_data_U2]*Bezugsfrequenz_data_U2,Signal_amp_data_U2,'-.r');hold on
        plot([0:nyquist_number_data_U3]*Bezugsfrequenz_data_U3,Signal_amp_data_U3,'.k','MarkerSize',0.1);hold off
    end
    % Grouping U1
    data_specM_x_H = [0:nyquist_number_U1_Resampled_10_Period]*Bezugsfrequenz_U1_Resampled_10_Period;
    deta_specM_x_V = data_specM_x_H';
    data_specM_Y_V = Signal_amp_U1_Resampled_10_Period';
    data_specM = data_specM_Y_V;
    i = 11;
    ii = 1;
    while i < 502
        harm_calc = sqrt(power(data_specM(i-1),2)+power(data_specM(i),2)+power(data_specM(i+1),2));
        iTxt = (i-1)/10;
        Results_U_H1(ii,jj) = harm_calc;
        if i < 392
            iharm_calc = sqrt(power(data_specM(i+2),2)+power(data_specM(i+3),2)+power(data_specM(i+4),2)+power(data_specM(i+5),2)+power(data_specM(i+6),2)+power(data_specM(i+7),2)+power(data_specM(i+8),2));
            Results_U_IH1(ii,jj) = iharm_calc;
        end
        if i <= 360
            j1 = (i-1)*4+360+1;
            j_end = j1+40;
            hfharm_calc = 0;
            while j1 <= j_end
                hfharm_calc = hfharm_calc+power(data_specM(j1),2);
                j1 =j1+1;
            end
            hfharm_calc = sqrt(hfharm_calc);
            j1 = 200*(i-1)/10+1900;
            Results_U_HF1(ii,jj) = hfharm_calc;
        end
        i = i+10;
        ii = ii+1;
    end
    % Grouping U2
    data_specM_x_H = [0:nyquist_number_U2_Resampled_10_Period]*Bezugsfrequenz_U2_Resampled_10_Period;
    deta_specM_x_V = data_specM_x_H';
    data_specM_Y_V = Signal_amp_U2_Resampled_10_Period';
    data_specM = data_specM_Y_V;
    i = 11;
    ii = 1;
    while i < 502
        harm_calc = sqrt(power(data_specM(i-1),2)+power(data_specM(i),2)+power(data_specM(i+1),2));
        iTxt = (i-1)/10;
        Results_U_H2(ii,jj) = harm_calc;
        if i < 392
            iharm_calc = sqrt(power(data_specM(i+2),2)+power(data_specM(i+3),2)+power(data_specM(i+4),2)+power(data_specM(i+5),2)+power(data_specM(i+6),2)+power(data_specM(i+7),2)+power(data_specM(i+8),2));
            Results_U_IH2(ii,jj) = iharm_calc;
        end
        if i <= 360
            j1 = (i-1)*4+360+1;
            j_end = j1+40;
            hfharm_calc = 0;
            while j1 <= j_end
                hfharm_calc = hfharm_calc+power(data_specM(j1),2);
                j1 =j1+1;
            end
            hfharm_calc = sqrt(hfharm_calc);
            j1 = 200*(i-1)/10+1900;
            Results_U_HF2(ii,jj) = hfharm_calc;
        end
        i = i+10;
        ii = ii+1;
    end
    % Grouping U3
    data_specM_x_H = [0:nyquist_number_U3_Resampled_10_Period]*Bezugsfrequenz_U3_Resampled_10_Period;
    deta_specM_x_V = data_specM_x_H';
    data_specM_Y_V = Signal_amp_U3_Resampled_10_Period';
    data_specM = data_specM_Y_V;
    i = 11;
    ii = 1;
    while i < 502
        harm_calc = sqrt(power(data_specM(i-1),2)+power(data_specM(i),2)+power(data_specM(i+1),2));
        iTxt = (i-1)/10;
        Results_U_H3(ii,jj) = harm_calc;
        if i < 392
            iharm_calc = sqrt(power(data_specM(i+2),2)+power(data_specM(i+3),2)+power(data_specM(i+4),2)+power(data_specM(i+5),2)+power(data_specM(i+6),2)+power(data_specM(i+7),2)+power(data_specM(i+8),2));
            Results_U_IH3(ii,jj) = iharm_calc;
        end
        if i <= 360
            j1 = (i-1)*4+360+1;
            j_end = j1+40;
            hfharm_calc = 0;
            while j1 <= j_end
                hfharm_calc = hfharm_calc+power(data_specM(j1),2);
                j1 =j1+1;
            end
            hfharm_calc = sqrt(hfharm_calc);
            j1 = 200*(i-1)/10+1900;
            Results_U_HF3(ii,jj) = hfharm_calc;
        end
        i = i+10;
        ii = ii+1;
    end
    % Grouping I1
    data_specM_x_H = [0:nyquist_number_I1_Resampled_10_Period]*Bezugsfrequenz_I1_Resampled_10_Period;
    %deta_specM_x_V = data_specM_x_H';
    data_specM_Y_V = Signal_amp_I1_Resampled_10_Period';
    data_specM = data_specM_Y_V;
    i = 11;
    ii = 1;
    while i < 502
        harm_calc = sqrt(power(data_specM(i-1),2)+power(data_specM(i),2)+power(data_specM(i+1),2));
        iTxt = (i-1)/10;
        Results_I_H1(ii,jj) = harm_calc;
        if i < 392
            iharm_calc = sqrt(power(data_specM(i+2),2)+power(data_specM(i+3),2)+power(data_specM(i+4),2)+power(data_specM(i+5),2)+power(data_specM(i+6),2)+power(data_specM(i+7),2)+power(data_specM(i+8),2));
            Results_I_IH1(ii,jj) = iharm_calc;
        end
        if i <= 360
            j1 = (i-1)*4+360+1;
            j_end = j1+40;
            hfharm_calc = 0;
            while j1 <= j_end
                hfharm_calc = hfharm_calc+power(data_specM(j1),2);
                j1 =j1+1;
            end
            hfharm_calc = sqrt(hfharm_calc);
            j1 = 200*(i-1)/10+1900;
            Results_I_HF1(ii,jj) = hfharm_calc;
        end
        i = i+10;
        ii = ii+1;
    end
    % Grouping I2
    data_specM_x_H = [0:nyquist_number_I2_Resampled_10_Period]*Bezugsfrequenz_I2_Resampled_10_Period;
    %deta_specM_x_V = data_specM_x_H';
    data_specM_Y_V = Signal_amp_I2_Resampled_10_Period';
    data_specM = data_specM_Y_V;
    i = 11;
    ii = 1;
    while i < 502
        harm_calc = sqrt(power(data_specM(i-1),2)+power(data_specM(i),2)+power(data_specM(i+1),2));
        iTxt = (i-1)/10;
        Results_I_H2(ii,jj) = harm_calc;
        if i < 392
            iharm_calc = sqrt(power(data_specM(i+2),2)+power(data_specM(i+3),2)+power(data_specM(i+4),2)+power(data_specM(i+5),2)+power(data_specM(i+6),2)+power(data_specM(i+7),2)+power(data_specM(i+8),2));
            Results_I_IH2(ii,jj) = iharm_calc;
        end
        if i <= 360
            j1 = (i-1)*4+360+1;
            j_end = j1+40;
            hfharm_calc = 0;
            while j1 <= j_end
                hfharm_calc = hfharm_calc+power(data_specM(j1),2);
                j1 =j1+1;
            end
            hfharm_calc = sqrt(hfharm_calc);
            j1 = 200*(i-1)/10+1900;
            Results_I_HF2(ii,jj) = hfharm_calc;
        end
        i = i+10;
        ii = ii+1;
    end
    % Grouping I3
    data_specM_x_H = [0:nyquist_number_I3_Resampled_10_Period]*Bezugsfrequenz_I3_Resampled_10_Period;
    %deta_specM_x_V = data_specM_x_H';
    data_specM_Y_V = Signal_amp_I3_Resampled_10_Period';
    data_specM = data_specM_Y_V;
    i = 11;
    ii = 1;
    while i < 502
        harm_calc = sqrt(power(data_specM(i-1),2)+power(data_specM(i),2)+power(data_specM(i+1),2));
        iTxt = (i-1)/10;
        Results_I_H3(ii,jj) = harm_calc;
        if i < 392
            iharm_calc = sqrt(power(data_specM(i+2),2)+power(data_specM(i+3),2)+power(data_specM(i+4),2)+power(data_specM(i+5),2)+power(data_specM(i+6),2)+power(data_specM(i+7),2)+power(data_specM(i+8),2));
            Results_I_IH3(ii,jj) = iharm_calc;
        end
        if i <= 360
            j1 = (i-1)*4+360+1;
            j_end = j1+40;
            hfharm_calc = 0;
            while j1 <= j_end
                hfharm_calc = hfharm_calc+power(data_specM(j1),2);
                j1 =j1+1;
            end
            hfharm_calc = sqrt(hfharm_calc);
            j1 = 200*(i-1)/10+1900;
            Results_I_HF3(ii,jj) = hfharm_calc;
        end
        i = i+10;
        ii = ii+1;
    end
    if 0 == 1
        v_alpha = sqrt(2)/3*(data_U1-0.5*data_U2-0.5*data_U3);
        v_beta = sqrt(2)/3*(sqrt(3)/2*data_U2-sqrt(3)/2*data_U3);
        I_alpha = sqrt(2)/3*(data_I1-0.5*data_I2-0.5*data_I3);
        I_beta = sqrt(2)/3*(sqrt(3)/2*data_I2-sqrt(3)/2*data_I3);
        P = 3*(v_alpha*I_alpha+v_beta*I_beta);
        Q = 3*(-v_alpha*I_beta+v_beta*I_alpha);
        Results_P(jj) = P;
        Results_Q(jj) = Q;
    end
    j = j+20; % Calculation every 10 Periods
    jj = jj+1;
end
%**********************************************************************
%----------------------------------END---------------------------------
%**********************************************************************
%-------------------------- Normalization -----------------------------
%**********************************************************************
Results_U_H1_pu = Results_U_H1/sqrt(2)/Un;
Results_U_H2_pu = Results_U_H2/sqrt(2)/Un;
Results_U_H3_pu = Results_U_H3/sqrt(2)/Un;
Results_I_H1_pu = Results_I_H1/sqrt(2)/In;
Results_I_H2_pu = Results_I_H2/sqrt(2)/In;
Results_I_H3_pu = Results_I_H3/sqrt(2)/In;
%----------------------------------------------------------------------
Results_U_IH1_pu = Results_U_IH1/sqrt(2)/Un;
Results_U_IH2_pu = Results_U_IH2/sqrt(2)/Un;
Results_U_IH3_pu = Results_U_IH3/sqrt(2)/Un;
Results_I_IH1_pu = Results_I_IH1/sqrt(2)/In;
Results_I_IH2_pu = Results_I_IH2/sqrt(2)/In;
Results_I_IH3_pu = Results_I_IH3/sqrt(2)/In;
%----------------------------------------------------------------------
Results_U_HF1_pu = Results_U_HF1/sqrt(2)/Un;
Results_U_HF2_pu = Results_U_HF2/sqrt(2)/Un;
Results_U_HF3_pu = Results_U_HF3/sqrt(2)/Un;
Results_I_HF1_pu = Results_I_HF1/sqrt(2)/In;
Results_I_HF2_pu = Results_I_HF2/sqrt(2)/In;
Results_I_HF3_pu = Results_I_HF3/sqrt(2)/In;
%**********************************************************************
%------------------------ End -----------------------------------------
%**********************************************************************
% ------------------- Mean and Max Value Calculation ------------------
% *********************************************************************
[~, colum] = size(Results_I_H1_pu);
if colum > 1
MeanHarm_U1 = mean(Results_U_H1_pu');
MeanHarm_U2 = mean(Results_U_H2_pu');
MeanHarm_U3 = mean(Results_U_H3_pu');
MeanHarm_I1 = mean(Results_I_H1_pu');
MeanHarm_I2 = mean(Results_I_H2_pu');
MeanHarm_I3 = mean(Results_I_H3_pu');
%----------------------------------------------------------------------
MeanIHarm_U1 = mean(Results_U_IH1_pu');
MeanIHarm_U2 = mean(Results_U_IH2_pu');
MeanIHarm_U3 = mean(Results_U_IH3_pu');
MeanIHarm_I1 = mean(Results_I_IH1_pu');
MeanIHarm_I2 = mean(Results_I_IH2_pu');
MeanIHarm_I3 = mean(Results_I_IH3_pu');
%----------------------------------------------------------------------
MeanHFHarm_U1 = mean(Results_U_HF1_pu');
MeanHFHarm_U2 = mean(Results_U_HF2_pu');
MeanHFHarm_U3 = mean(Results_U_HF3_pu');
MeanHFHarm_I1 = mean(Results_I_HF1_pu');
MeanHFHarm_I2 = mean(Results_I_HF2_pu');
MeanHFHarm_I3 = mean(Results_I_HF3_pu');
%----------------------------------------------------------------------
MaxHarm_U = max(max(MeanHarm_U1,MeanHarm_U2),MeanHarm_U3);
MaxHarm_I = max(max(MeanHarm_I1,MeanHarm_I2),MeanHarm_I3);
MaxIHarm_U = max(max(MeanIHarm_U1,MeanIHarm_U2),MeanIHarm_U3);
MaxIHarm_I = max(max(MeanIHarm_I1,MeanIHarm_I2),MeanIHarm_I3);
MaxHFHarm_U = max(max(MeanHFHarm_U1,MeanHFHarm_U2),MeanHFHarm_U3);
MaxHFHarm_I = max(max(MeanHFHarm_I1,MeanHFHarm_I2),MeanHFHarm_I3);
else
MeanHarm_I1 = Results_I_H1_pu;
MeanHarm_I2 = Results_I_H2_pu;
MeanHarm_I3 = Results_I_H3_pu;
MeanHarm_U1 = Results_U_H1_pu;
MeanHarm_U2 = Results_U_H2_pu;
MeanHarm_U3 = Results_U_H3_pu;
%----------------------------------------------------------------------
MeanIHarm_U1 = Results_U_IH1_pu;
MeanIHarm_U2 = Results_U_IH2_pu;
MeanIHarm_U3 = Results_U_IH3_pu;
MeanIHarm_I1 = Results_I_IH1_pu;
MeanIHarm_I2 = Results_I_IH2_pu;
MeanIHarm_I3 = Results_I_IH3_pu;
%----------------------------------------------------------------------
MeanHFHarm_U1 = Results_U_HF1_pu;
MeanHFHarm_U2 = Results_U_HF2_pu;
MeanHFHarm_U3 = Results_U_HF3_pu;
MeanHFHarm_I1 = Results_I_HF1_pu;
MeanHFHarm_I2 = Results_I_HF2_pu;
MeanHFHarm_I3 = Results_I_HF3_pu;
%----------------------------------------------------------------------
MaxHarm_U = max(max(MeanHarm_U1,MeanHarm_U2),MeanHarm_U3);
MaxHarm_I = max(max(MeanHarm_I1,MeanHarm_I2),MeanHarm_I3);
MaxIHarm_U = max(max(MeanIHarm_U1,MeanIHarm_U2),MeanIHarm_U3);
MaxIHarm_I = max(max(MeanIHarm_I1,MeanIHarm_I2),MeanIHarm_I3);
MaxHFHarm_U = max(max(MeanHFHarm_U1,MeanHFHarm_U2),MeanHFHarm_U3);
MaxHFHarm_I = max(max(MeanHFHarm_I1,MeanHFHarm_I2),MeanHFHarm_I3);
end
%**********************************************************************
%------------------------------- End ----------------------------------
%**********************************************************************
%--------------- Order (x-axie) Calculation and Ploting ---------------
%**********************************************************************
Order_Harm = 1:1:50;
Order_IHarm = 1:1:39;
%Order_HFHarm = 1:1:35;
%Order_HFHarm = 2100:1:2134;
Order_HFHarm = 2100:200:8900;
if figures
    figure;
    subplot(2,3,1)
    bar(Order_Harm,MaxHarm_I);xlabel('Order Number');ylabel('Current Hamonics Levels I/In in pu');title('Current Harmonics spectrom')
    subplot(2,3,2)
    bar(Order_IHarm,MaxIHarm_I);xlabel('Order Number');ylabel('Current Hamonics Levels I/In in pu');title('Current interharmonics spectrom')
    subplot(2,3,3)
    bar(Order_HFHarm,MaxHFHarm_I);xlabel('Frequency in Hz');ylabel('Current Hamonics Levels I/In in pu');title('Current Higher Frequencies spectrom')
    subplot(2,3,4)
    bar(Order_Harm,MaxHarm_U);xlabel('Order Number');ylabel('Voltage Hamonics Levels U/Un in pu');title('Voltage Harmonics spectrom')
    subplot(2,3,5)
    bar(Order_IHarm,MaxIHarm_U);xlabel('Order Number');ylabel('Voltage Hamonics Levels U/Un in pu');title('Voltage interharmonics spectrom')
    subplot(2,3,6)
    bar(Order_HFHarm,MaxHFHarm_U);xlabel('Frequency in Hz');ylabel('Voltage Hamonics Levels U/Un in pu');title('Voltage Higher Frequencies spectrom')
end
%**********************************************************************
%------------------------------- End ----------------------------------
%**********************************************************************
%-------------------------- K, THD Factor  ----------------------------
%**********************************************************************
THD_U = sqrt(sum((MaxHarm_U(2:end).^2)'))/(MaxHarm_U(1));
THD_I = sqrt(sum((MaxHarm_I(2:end).^2)'))/(MaxHarm_I(1));
K_U = sqrt(sum((MaxHarm_U(2:end).^2)')/(MaxHarm_U(1)+sum((MaxHarm_U(2:end).^2)')));
K_I = sqrt(sum((MaxHarm_I(2:end).^2)')/(MaxHarm_I(1)+sum((MaxHarm_I(2:end).^2)')));
%**********************************************************************
%------------------------------- End ----------------------------------
%**********************************************************************
%------------------------ Saving Results ------------------------------
%**********************************************************************
save('Harmonics','THD_U','THD_I','K_U','K_I','MaxHarm_I','MaxHarm_U','MaxIHarm_I','MaxIHarm_U','MaxHFHarm_I','MaxHFHarm_U','MaxHarm_I','Order_IHarm','Order_Harm','Order_HFHarm')
%**********************************************************************
%------------------------------- End ----------------------------------
%**********************************************************************
end




