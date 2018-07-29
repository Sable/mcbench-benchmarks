clear all
clc
melp_init;              % инициализация переменных и констант

for i=1:(Nframe-1)    % покадровый анализ речевого сигнала
    % Обновление буфера фильтра Чебышева 4-го порядка
    sig_in(1:FRL)=sig_in(FRL+1:FRL*2); 
    %Обновление буфера ФНЧ с частотой среза 1000 Гц(ОТ)
    sig_1000(1:FRL)=sig_1000(FRL+1:FRL*2); 
    % Обновление буфера полосовых фильтров
    melp_bands(:,1:FRL)=melp_bands(:,FRL+1:FRL*2);
    % обновление огибающих речи в полосах
    melp_envelopes(:,1:FRL)=melp_envelopes(:,FRL+1:FRL*2); 
    
    % Взятие нового кадра речи
    sig_origin=s((i-1)*FRL+1:i*FRL); 
    
    % Ослабление постоянной составляющей
    [sig_in(FRL+1:FRL*2),cheb_s]=filter(dcr_num,dcr_den,sig_origin,cheb_s); 
    
    % Вычисление целочисленного значения ОТ
    [sig_1000(FRL+1:FRL*2),butter_s]=filter(butt_1000num,butt_1000den,...
        sig_in(FRL+1:FRL*2),butter_s);  % ФНЧ с частотой среза 1000 Гц 
    cur_intp=intpitch(sig_1000,160,40); % целочисленное значение ОТ
    
    % АНАЛИЗ СИГНАЛА ПО ПОЛОСАМ 
    % Получение полос и огибающих сигнала
    [melp_bands(:,FRL+1:FRL*2),state_b,melp_envelopes(:,FRL+1:FRL*2),...
        state_e]=melp_5b(sig_in(FRL+1:FRL*2),state_b,state_e); 
    
    % Вычисление дробного значения ОТ 
    [p2,vp(1)]=pitch2(melp_bands(1,:),cur_intp); 
    
    % Анализ вокализованности полос 
    vp(2:5)=melp_bpva(melp_bands,melp_envelopes,p2); 
    r2=vp(1); %вокализованность первой полосы
    
    % Определение джиттера 
    if vp(1)<0.5 
        jitter=1; 
    else
        jitter=0;
    end

    % LPC анализ
    koef_lpc=melp_lpc(sig_in(81:280)); 
    koef_lpc=koef_lpc.*0.994.^(2:11);   % умножение на коэффициент 
                                        % расширения полосы частот 
    % Определение остатка предсказания
    e_resid=lpc_residual(koef_lpc,sig_in); 
    
    % Окончательное определение вокализованности полос
    peak=sqrt(e_resid(106:265)*e_resid(106:265)'/160)/...
        (sum(abs(e_resid(106:265)))/160); % Определение пикового значения
    if peak>1.34 
        vp(1)=1; 
    end
    if peak>1.6
        vp(2:3)=1; 
    end 
    
    % Окончательное определение ОТ
    temp_s(1:6)=0; 
    [fltd_resid,temp_s]=filter(butt_1000num,butt_1000den,e_resid,temp_s); 
    temp(1:5)=0; 
    fltd_resid=[temp,fltd_resid,temp]; 
    [p3,r3]=pitch3(sig_in,fltd_resid,p2,pavg); 
    
    % Вычисление усиления 
    G=melp_gain(sig_in,vp(1),p2); 
    Gs(i,:)=G;
    % Обновление среднего значения ОТ
    [pavg,buffer]=melp_APU(p3,r3,G(2),buffer); 
    
    % Преобразование коэффициентов ЛП в ЛСЧ
    LSF=melp_lpc2lsf(koef_lpc); 
    
    % Расширение минимального расстояния
    LSF=lsf_clmp(LSF); 
    
    % Многоуровневое векторное квантование 
    MSVQ=melp_msvq(koef_lpc,LSF); 
    
    % Квантование усиления
    QG=melp_Qgain(G2p,G); 
    G2p=G(2); % обновление значения усиления для предыдущего кадра
    
    % Квантование ОТ
    if vp(1)>0.6 
        Qpitch=melp_Qpitch(p3);
    end
    
    % Определение амплитуд фурье-спектра
    lsfs=d_lsf(MSVQ);           % определение вектора квантованных ЛСЧ
    lpc2=melp_lsf2lpc(lsfs);    % преобразование ЛСЧ в коэффициенты ЛП
    tresid2=lpc_residual(lpc2,sig_in(76:285)); % Определение остатка 
                                % предсказания по квантованным КЛП
    resid2=tresid2.*hamming(200)';  % применение окна Хэмминга
    resid2(201:512)=0;              % дополнение нулями
    magf=abs(fft(resid2));          % амплитуды фурье-спектра
    [fm,Wf]=find_harm(magf,p3);     % определение гармоник основной частоты 
    
    % Квантование амплитуд фурье-спектра 
    QFM=melp_FMCQ(fm,Wf); 
    
    % Формирование кадра передачи
    c(i).ls=MSVQ; 
    c(i).QFM=QFM; 
    c(i).G=QG; 
    if vp(1)>0.6 
        c(i).pitch=Qpitch; 
        c(i).vp=vp(2:5); 
        c(i).jt=jitter; 
    else
        c(i).pitch=0;
        c(i).vp=0; 
        c(i).jt=0; 
    end 
end