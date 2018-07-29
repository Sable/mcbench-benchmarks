%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hrtparam.m
%
%% This function evaluate several room acoustic parameters, with the signal
%% processing done by Hirata method.
%%
%% [s]=hrtparam(IR1,IR2,fs,flag)
%%
%% The input are two room impulse response (IR1 and IR2) measured at the
%% same point and its sampling frequency. The flag variable indicates if 
%% the function should generate (1) or not (0) the Schroeder decay plots.
%% The output it a text file with the value of several parameter for each
%% frequency band. If desired, returns a matrix with this values, where the
%% first line contains the frequency band central frequencies, instead of
%% text.

function [saida]=hrtparam(IR1,IR2,fs,flag)

if size(IR1,1) < size(IR2,1)         %condiciona o tamanho das sequencias
   IR2 = IR2(1:size(IR1,1));
elseif size(IR1,1) > size(IR2,1)
   IR1 = IR1(1:length(IR2));
end

banda1 = filtros(IR1,fs);
banda2 = filtros(IR2,fs);

for n = 1:size(banda1,2)
    s(1,n) = ceil(1000*2^(n-5));
    aux = banda1(:,n).*banda2(:,n);
    comeco = inicio(aux);
    aux = aux(comeco:end);  
    [s(2,n),s(3,n),s(4,n),s(5,n),s(6,n)] = energeticos(aux,fs);
    [s(7,n),s(8,n),s(9,n),s(10,n)] = reverberacao(aux,fs,flag);
end

if nargout == 1
    saida = s;
    saida(1,9) = (['A']);
    saida(1,10) = (['C']);
    saida(1,11) = (['L']);
else
    tabela(s,size(banda1,2))
end