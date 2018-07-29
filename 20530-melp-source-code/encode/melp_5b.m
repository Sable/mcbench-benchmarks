function [bands,state_b,envelopes,state_e]=melp_5b(sig_in,state_b,state_e) 
% Расчет 5 полосовых сигналов и огибающих для 2-5 полос 
% ВХОДНЫЕ ПЕРЕМЕННЫЕ: 
%   sig_in  - входной сигнал 
%   state_b - исходные состояния полосовых фильтов 
%   state_e - исходные состояния фильтров огибающих 
% ВЫХОДНЫЕ ПЕРЕМЕННЫЕ:
%   bands     - полосовые сигналы 
%   state_b   - конечные состояния полосовых фильтов 
%   envelopes - огибающие полосовых сигналов
%   state_e   - конечные состояния фильтров огибающих

global butt_bp_num butt_bp_den 
global smooth_num smooth_den 

for i=1:5  % фильтрация в каждой из 5 полос
    [bands(i,:),state_b(i,:)]=filter(butt_bp_num(i,:),butt_bp_den(i,:),...
        sig_in,state_b(i,:)); 
end 
temp1=abs(bands(2:5,:)); % абсолютные значения полосовых (2-5) сигналов
for i=1:4 
    [envelopes(i,:),state_e(i,:)]=filter(smooth_num(1,:),...
        smooth_den(1,:),temp1(i,:),state_e(i,:)); % сглаживающий фильтр
end