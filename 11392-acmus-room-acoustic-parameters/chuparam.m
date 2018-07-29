%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chuparam.m
%
%% This function evaluate several room acoustic parameters, with the signal
%% processing done by Chu method.
%%
%% [s]=chuparam(IR,fs,flag)
%%
%% The input is a room impulse response and its sampling frequency. The
%% flag variable indicates if the function should generate (1) or not (o)
%% the Schroeder decay plots.
%% The output it a text file with the value of several parameter for each
%% frequency band. If desired, returns a matrix with this values, where the
%% first line contains the frequency band central frequencies, instead of
%% text.


function [saida]=chuparam(IR,fs,flag)

banda = filtros(IR,fs);
ruido = banda(round(.9*length(banda)):end,:).^2;
RMS = sum(ruido)/length(ruido);
    
for n = 1:size(banda,2)
    s(1,n) = ceil(1000*2^(n-5));
    comeco = inicio(banda(:,n));
    aux = banda(comeco:end,n).^2-RMS(n);    
    [s(2,n),s(3,n),s(4,n),s(5,n),s(6,n)] = energeticos(aux,fs);
    [s(7,n),s(8,n),s(9,n),s(10,n)] = reverberacao(aux,fs,flag);
end

if nargout == 1
    saida = s;
    saida(1,9) = (['A']);
    saida(1,10) = (['C']);
    saida(1,11) = (['L']);
else
    tabela(s,size(banda,2))
end