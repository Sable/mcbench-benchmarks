% Use is m.file to test the frequency calculater function for that you will
% need the Angle.mat file which contain a real measured signal with
% freuqncy changing between 50 Hz to 55% in three differnt ways:
% 1- A jump (step change) of the frequency
% 2- ramp change of the freuqnecy with 10 Hz/s
% 3- ramp change of the frequency with 20 Hz/s
% for using this file you will need the: "Frequency_Calculation_Function"
% Author: Aubai Al Khatib datum: 19.09.2013 
clear
clc
if 1 == 0
    Sample = 10000;%Hz
    f_test = 50;%Hz
    t = 0:1/Sample:1;
    y = sin(2*pi*f_test*t);
    [f,f_time] = Frequency_Calculation_Function(y,t);
    figure(1);
    subplot(1,1,2);
    plot(f_time,f);ylim([49,56]);grid on;xlim([80,120]);xlabel('Time in S');ylabel('Frequency in Hz');
    subplot(1,2,2);
    plot(t,y);grid on;xlabel('Time in S');ylabel('Amplitude in V');
else
    load('Angle.mat')
    [f,f_time] = Frequency_Calculation_Function(U1,U1_time);
    figure(1);
    subplot(2,1,1);
    plot(f_time,f);ylim([49,56]);grid on;xlim([80,120]);xlabel('Time in S');ylabel('Frequency in Hz');
    subplot(2,1,2);
    plot(U1_time,U1);grid on;xlim([80,120]);xlabel('Time in S');ylabel('Amplitude in V');
    figure(2);
    subplot(2,1,1);
    plot(f_time,f);ylim([49,56]);grid on;xlim([104.5,108.5]);xlabel('Time in S');ylabel('Frequency in Hz');
    subplot(2,1,2);
    plot(U1_time,U1);grid on;xlim([104.5,108.5]);xlabel('Time in S');ylabel('Amplitude in V');
end

