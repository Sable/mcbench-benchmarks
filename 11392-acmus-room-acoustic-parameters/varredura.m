%% varredura.m
%% This function generates a log sine sweep excitation signal.
%%
%% [c,B,A] = varredura(fs,tempo,f0,f1)
%%
%% The input are the sampling frequency fs, the duration of the signal
%% (tempo), the initial frequency f0 and the final frequency f1.
%% The output are the excitation signal c, and the coefficients (B and A)
%% of a band pass IIR filter (f0 till f1).

function [c,B,A] = varredura(fs,tempo,f0,f1)

t=(0:1/fs:tempo);
c = chirp(t,f0,t(end),f1,'log',-90);    %aqui esta setado para varredura logaritmica de senos.
                                        %E preciso permitir se escolher se
                                        %linear e a defasagem inicial.
[B,A] = butter(4,[f0/fs f1/fs]);        %usar este filtro apos a deconvolucao.