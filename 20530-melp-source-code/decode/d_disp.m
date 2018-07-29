function [f,state_disp]=d_disp(sig_in,state_disp,disperse) 
% Импульсный дисперсионный фильтр
% ПРЕДУСЛОВИЯ: размер f составляет 64+180 
% ВХОДНЫЕ ПАРАМЕТРЫ:
%   sig_in     - входной сигнал
%   state_disp - начальное состояние дисперсионного фильтра
%   disperse   - коэффициенты дисперсионного фильтра
% ВЫХОДНЫЕ ПАРАМЕТРЫ:
%   f          - выходной сигнал
%   state_disp - конечное состояние дисперсионного фильтра

buffer1=[state_disp,sig_in]; 
for i=1:180
    f(i)=buffer1(i:i+64)*disperse; 
end 
state_disp=sig_in(116:180);