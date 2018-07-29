function [pc,cor_pc]=double_ck(sig_in,p,Dth)
% Определение ОТ с удвоенной точностью
% ВХОДНЫЕ ПАРАМЕТРЫ: 
%   sig_in - входной сигнал 
%   p      - дробное значение ОТ 
%   Dth    - пороговое значение 
% ВЫХОДНЫЕ ПАРАМЕТРЫ: 
%   pc     - значение ОТ (с двойной точностью) 
%   cor_pc - соответствующая корреляция 

pmin=20;                            % минимальное значение ОТ 
[pc,cor_pc]=fpr(sig_in,round(p));   % улучшение дробного значения ОТ  
for n=1:7                           % поиск лучшего ОТ  
    k=9-n;                          % значение делителя
    temp_pit=round(pc/k);           % временное значение ОТ
    if temp_pit>=pmin 
        [temp_pit,temp_cor]=fpr(sig_in,temp_pit); 
                                    % улучшение дробного значения ОТ
        if temp_pit<30 
            temp_cor=double_ver(sig_in,temp_pit,temp_cor); 
        end                         % удаление низкого ОТ 
        if temp_cor>Dth*cor_pc
            [pc,cor_pc]=fpr(sig_in,round(temp_pit)); 
                                    % улучшение дробного значения ОТ
            break; 
        end
    end
end
if pc<30 
    cor_pc=double_ver(sig_in,pc,cor_pc); % удаление низкого ОТ 
end