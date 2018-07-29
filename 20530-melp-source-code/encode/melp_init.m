% инициализация переменных и констант
global FMCQ_CODEBOOK; 
global Wf; 
global stage1 stage2;

coeff; 
stage;  
codebook_fmcq1;  
codebook_fmcq2; 

% Источник речевого сигнала 
[file, path]=uigetfile('*.wav','Open Speech Signal');
S=strcat(path,file);
s=wavread(S)'; 
s=s*32767; 
FRL=180; % Длина кадра
Nframe=fix(length(s)/FRL); % Число кадров во входном сигнале 
% Начальные условия
sig_in(1:FRL*2)=0;             % входной сигнал
sig_1000(1:FRL*2)=0;           % сигнал на входе ФНЧ (1000 Гц)
melp_bands(1:5,1:FRL*2)=0;     % полосовые сигналы
% начальные состояния 
cheb_s(1:4)=0; 
butter_s(1:6)=0; 
state_b(1:5,1:6)=0;
state_e(1:4,1:2)=0; 
state_t(1:4,1:6)=0;
state_syn(1:10)=0;  % !!!!!!!!!!!!!!
melp_envelopes(1:4,1:FRL*2)=0; % огибающие полосовых сигналов
pre_intp=40; 
frame_num=320;
buffer=[50,50,50]; % буфер медианного фильтра ОТ
pavg=50;    % значение ОТ для случая низкой корреляции значений ОТ, 
            % определенных по речевому сигналу и сигналу остатка 
G2p=20;     % значение усиления для предыдущего кадра