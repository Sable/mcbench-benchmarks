%% dechirp.m
%%
%% ir = dechirp(gravacao,B,A,n)
%%
%% This function deconvolves the excitation signal (sine sweep) with the
%% room response to this excitation signal, giving the related room impulse
%% response.
%% The input variables are a stereo audio signal (gravação), where the
%% first channel is the room response and the second channel is a copy of
%% the excitation signal. B and A are the filter coefficients of the filter
%% given by the "varredura.m" function. n is the size of the desired
%% impulse response (it's recommend to be twice bigger as the excitation
%% signal).

function ir = dechirp(gravacao,B,A,n)

ir = real(ifft(fft(gravacao(:,1),n)./fft(gravacao(:,2),n)));
ir = filter(B,A,ir);