function exc=lpc_residual(lpcs,sig_in) 
% Определение остатка предсказания
% ВХОДНЫЕ ПЕРЕМЕННЫЕ: 
%   lpcs   - коэффициенты ЛП 
%   sig_in - входной сигнал 
% ВЫХОДНЫЕ ПЕРЕМЕННЫЕ:  
%   exc    - сигнал остатка предсказания 

exc=filter([1,lpcs],1,sig_in);
exc=exc(11:end);