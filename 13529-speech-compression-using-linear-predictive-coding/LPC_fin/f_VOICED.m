%function_main of voiced/unvoiced detection

function [voiced, pitch_plot] = f_VOICED(x, fs, fsize);

%func_vd_msf, func_vd_pg, func_vd_zc is called in this m file

% clear all
% close all
% clc
% INITIALIZATION:
% [x,fs]=wavread('s1omwb');%"t_16k_2s.wav" is the file I used. Change according 
%                       %to your case.
% length(x)
f=1;
b=1;        %index no. of starting data point of current frame
% fsize = 30e-3;    %frame size
frame_length = round(fs .* fsize);   %=number data points in each framesize 
                                %of "x"
N= frame_length - 1;        %N+1 = frame length = number of data points in 
                            %each framesize

%FRAME SEGMENTATION:
for b=1 : frame_length : (length(x) - frame_length),
    y1=x(b:b+N);     %"b+N" denotes the end point of current frame.
                %"y" denotes an array of the data points of the current 
                %frame
    y = filter([1 -.9378], 1, y1);  %pre-emphasis filter

    msf(b:(b + N)) = func_vd_msf (y);
    zc(b:(b + N)) = func_vd_zc (y);
    pitch_plot(b:(b + N)) = func_pitch (y,fs);
end

thresh_msf = (( (sum(msf)./length(msf)) - min(msf)) .* (0.67) ) + min(msf);
voiced_msf =  msf > thresh_msf;     %=1,0

thresh_zc = (( ( sum(zc)./length(zc) ) - min(zc) ) .*  (1.5) ) + min(zc);
voiced_zc = zc < thresh_zc;

thresh_pitch = (( (sum(pitch_plot)./length(pitch_plot)) - min(pitch_plot)) .* (0.5) ) + min(pitch_plot);
voiced_pitch =  pitch_plot > thresh_pitch;

for b=1:(length(x) - frame_length),
    if voiced_msf(b) .* voiced_pitch(b) .* voiced_zc(b) == 1,
%     if voiced_msf(b) + voiced_pitch(b) > 1,
        voiced(b) = 1;
    else
        voiced(b) = 0;
    end
end
voiced;
pitch_plot;

%PG has been ignored as no good enough threshold value could be determined


% figure;
% subplot(5,1,1), plot(x); title('original signal');
% subplot(5,1,2), plot(voiced,'b.-'); title('voiced=1, unvoiced=0');
% subplot(5,1,3), plot(voiced_msf,'r.-'); title('voiced-msf');
% subplot(5,1,4), plot(voiced_zc,'r.-'); title('voiced-zc');
% subplot(5,1,5), plot(voiced_pitch,'r.-'); title('voiced-pitch');
% 
% figure;
% plot(x);