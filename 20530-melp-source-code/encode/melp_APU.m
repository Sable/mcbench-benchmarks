function [pavg,buffer]=melp_APU(p3,rp3,G2,buffer) 
% Медианный фильтр
% ВХОДНЫЕ ПЕРЕМЕННЫЕ: 
% p3     - окончательное значение ОТ
% rp2    - соответствующая корреляция p3 
% G2     - усиление для второго подкадра 
% buffer - буфер значений ОТ 
% ВЫХОДНЫЕ ПЕРЕМЕННЫЕ:  
% pavg   - среднее значение ОТ 
% buffer - обновленный буфер 

if (rp3>0.8)&&(G2>30) 
    buffer=[buffer(2:3),p3]; 
else
    buffer=buffer*0.95+2.5;
end 
pavg=median(buffer);