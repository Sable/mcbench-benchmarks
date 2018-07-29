if 1 == 1
    clc;
    clear
    close all;
    %clear all;
    prompt1 = {'Please Enter The nominal Frequency in Hz','Please Enter the nominal Voltage','Please Enter the Frequency of the needed Harmonics to be used as test signal(as a matrix so it can be more than one harmonic order)','Please Enter the Amplitute of the needed Harmonics to be used as test signal(with same order of the Frequency)','Please Enter the Sampling frequency for the test signal', 'Please Eneter the Length of the testing signal in number of periods'};
    name = 'Initial Input data';
    numlines = 1;
    defaultanswer1 = {'50','230','[3*50 7*50 15.5*50 4000]','[0.65 0.45 0.1 0.01]','20000','20'};
    answer1 = inputdlg(prompt1,name,numlines,defaultanswer1);
    freq = str2num(answer1{1});
    Un = str2num(answer1{2});
    fH = str2num(answer1{3});
    F_Sample = str2num(answer1{5});
    a = str2num(answer1{4});
    Len = str2num(answer1{6})/50;%#ok<*ST2NM>
    %Generating the time signal
    t = 0:1/F_Sample:Len;
    %generating a test signal
    x = Un*sqrt(2)* sin(2*pi*freq*t);
    %Generating Harmonics signal
    x1 = 0;
    for i=1:length(fH)
    x1 = ((Un*sqrt(2))*a(i)) * sin(2*pi*fH(i)*t)+x1; 
    end
    %The Complete Signal
    a = Un*sqrt(2);
    fRads =2*pi*freq;
    y = 0;
%     y = (0.65*a * sin(3*fRads * t)) ...
%         + (0.55*a * sin(5*fRads * t))...
%         + (0.45*a * sin(7*fRads * t))...
%         + (0.35*a * sin(9*fRads * t))...
%         + (0.25*a * sin(11*fRads * t))...
%         + (0.15*a * sin(13*fRads * t))...
%         + (0.05*a * sin(15*fRads * t));
    y = x + x1+y;
    figure;
    plot(t,x,'--r');xlim([0,0.06]);xlabel('Time in S');ylabel('Amplituate in V');title('Orginal signal without harmonics Vs. signal with harmonics');hold on;
    plot(t,y);grid on; hold off;
else
    t = U1N_time;
    F_Sample = 1/(t(3)-t(2));
    y = U1N;
    freq = 50;
    Un = 230;
    Len = length(t);
end
U1 = y;U2 = y;U3 = y;I1 = y;I2 = y;I3 = y;U1_time = t;U2_time = t;U3_time = t;I1_time = t;I2_time = t;I3_time = t;
[THD_U,THD_I,K_U,K_I,MaxHarm_I,MaxIHarm_I,MaxHFHarm_I,MaxHarm_U,MaxIHarm_U,MaxHFHarm_U,Order_Harm,Order_IHarm,Order_HFHarm] = IEC_Harmonics_final(50,230,230,U1,U2,U3,I1,I2,I3,U1_time,U2_time,U3_time,I1_time,I2_time,I3_time,1);
