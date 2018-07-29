function f=melp_FMCQ(mag,Wf) 
% векторный квантователь амплитуд Фурье-спектра
% ВХОДНЫЕ ПЕРЕМЕННЫЕ:
%   mag - амплитуды Фурье-спектра
%   Wf  - веса для Евклидова расстояния гармоник Фурье
% ВЫХОДНЫЕ ПЕРЕМЕННЫЕ:
%   f   - индекс в КК амплитуд Фурье-спектра

global FMCQ_CODEBOOK; 

temp=1000; 
for n=1:256 
    u=FMCQ_CODEBOOK(n,1:10)-mag; 
    rms=Wf*(u.*u)'; 
    if rms<temp 
        temp=rms; 
        f=n; 
    end 
end