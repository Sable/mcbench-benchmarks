function f=d_lsf(codeword)
% Определение вектора квантованных ЛСЧ
% ВХОДНЫЕ ПАРАМЕТРЫ:
%   codeword - индексы вектора ЛСЧ в 4-х КК
% ВЫХОДНЫЕ ПАРАМЕТРЫ:
%   f        - вектор квантованных ЛСЧ

global stage1; 
global stage2; 

temp(1,:)=stage1((codeword(1)-1)*10+1:codeword(1)*10); 
temp(2,:)=stage2(1,(codeword(2)-1)*10+1:codeword(2)*10); 
temp(3,:)=stage2(2,(codeword(3)-1)*10+1:codeword(3)*10); 
temp(4,:)=stage2(3,(codeword(4)-1)*10+1:codeword(4)*10); 

f=sum(temp);