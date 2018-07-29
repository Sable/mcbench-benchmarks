%% dirreverb.m
%%
%% [ITDG,L] = dirreverb(ir,Fs,ponto1,ponto2)
%%
%% Evaluates the "initial time delay gap" e o "sound level" (L) of the
%% impulse response ir, with sampling frequency Fs. 
%% Two points should be given, ponto1 is the sample where the direct sound
%% begins, and ponto2 is the sample where the first reflexion begins. There
%% is no automatic process to determine this points. One should choose it
%% by eye.

function [ITDG,L] = dirreverb(ir,Fs,ponto1,ponto2)

ITDG = (ponto2-ponto1)/Fs;
L = 10*log10(sum(ir(ponto1:ponto2).^2)/sum(ir(ponto2:end).^2))

%% Obs: os pontos serao definidos fora desta funcao, possivelmente pela
%% "tecnica do olho"! Esses pontos devem ser dados em amostras, e nao em
%% segundos.
%% Tambem sera necessario tomar cuidado com o fim do sinal. Seria
%% interessante usar o ponto de truncamento do Lundeby por exemplo, ou
%% algum ponto 30dB abaixo do maximo, por exemplo, para truncar o sinal.
%% Esse truncamento tambem devera ser feito antes de chamar a funcao