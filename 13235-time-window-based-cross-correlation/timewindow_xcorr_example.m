%--------------------------
% timewindow_corr.m example
%--------------------------
clear
clc
close all

%Specify cross-correlation parameters:
%-------------------------------------
sample_frequency=50e3; %sample frequency in Hz
time_window=2e-3; %time window length in seconds
time_step=1e-3; %time step in seconds
max_lag_time=1e-3; %maximum lag time in seconds

%Generate a sample signal:
%---------------------------
ITD_list=[-600:300:600]*1e-6; %list of input time delays in seconds
T_noise=50e-3; %length of a white noise burst
NZ=round(max(abs(ITD_list*sample_frequency))*1.1); %zero padding
input_1=[];
input_2=[];
for n_list=1:length(ITD_list)
    noise_sample=rand(1,round(T_noise*sample_frequency))*2-1;
    sample_shift=abs(round(sample_frequency*ITD_list(n_list)));
    if ITD_list(n_list)<0
        input_1=[input_1 zeros(1,NZ) noise_sample zeros(1,NZ)];
        input_2=[input_2 zeros(1,NZ+sample_shift) noise_sample zeros(1,NZ-sample_shift)];
    else
        input_1=[input_1 zeros(1,NZ+sample_shift) noise_sample zeros(1,NZ-sample_shift)];
        input_2=[input_2 zeros(1,NZ) noise_sample zeros(1,NZ)];
    end
end

%Process sample signals using timewindow_xcorr.m:
%------------------------------------------------

%No normalization:
%-----------------
[lag_time,twin,xcl]=...
    timewindow_xcorr(input_1,input_2,sample_frequency,...
    time_window,time_step,max_lag_time);

%Plot results:
%-------------
figure;
pcolor(twin,lag_time*1e3,xcl')
shading flat
colormap(1-gray)
hold on
for n_list=1:length(ITD_list)
    plot(xlim,[1 1]*ITD_list(n_list)*1e3,'r:','LineWidth',2)
end
xlabel('Time (secs)','FontSize',16,'FontName','Times New Roman')
ylabel('Lag time (msecs)','FontSize',16,'FontName','Times New Roman')
title('''timewindow\_xcorr.m'' Example','FontSize',16,'FontName','Times New Roman')
screen_size = get(0,'ScreenSize');
set(gca,'FontSize',16,'FontName','Times New Roman','Ytick',[-1:.25:1])
set(gcf,'Color','w','Position',[screen_size(3)/4 screen_size(4)/4 screen_size(3)/2 screen_size(4)/2],'Menu','none')

%With normalization:
%-------------------
[lag_time,twin,xcl]=...
    timewindow_xcorr(input_1,input_2,sample_frequency,...
    time_window,time_step,max_lag_time,1);

%Plot results:
%-------------
figure;
pcolor(twin,lag_time*1e3,xcl')
shading flat
colormap(1-gray)
hold on
for n_list=1:length(ITD_list)
    plot(xlim,[1 1]*ITD_list(n_list)*1e3,'r:','LineWidth',2)
end
xlabel('Time (secs)','FontSize',16,'FontName','Times New Roman')
ylabel('Lag time (msecs)','FontSize',16,'FontName','Times New Roman')
title('''timewindow\_xcorr.m'' Example (with normalization)','FontSize',16,'FontName','Times New Roman')
screen_size = get(0,'ScreenSize');
set(gca,'FontSize',16,'FontName','Times New Roman','Ytick',[-1:.25:1])
set(gcf,'Color','w','Position',[screen_size(3)/4 screen_size(4)/4 screen_size(3)/2 screen_size(4)/2],'Menu','none')
