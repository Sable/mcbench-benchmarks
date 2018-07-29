function g=melp_msvq(lpcs,f) 
% Квантование коэффициентов линейного предсказания
% ВХОДНЫЕ ПАРАМЕТРЫ: 
%   lpcs - коэффициенты ЛП 
%   f    - соответствующие ЛСЧ
% ВЫХОДНЫЕ ПАРАМЕТРЫ: 
%   g    - индекс в кодовой книге 

global stage1; 
global stage2; 

%Расчет весовых коэффициентов для функции искажений
for j=1:10 
    w(j)=1+exp(-i*f(j)*(1:10))*lpcs'; 
end 
w=abs(w); 
w=w.^0.3; 
w(9)=w(9)*0.64; 
w(10)=w(10)*0.16; 

% d(m,1)    - оценка 
% d(m,2:11) - разность вектора и кодового слова
% d(m,12:15)- кодовое слово 
d(1:8,1:12)=10000000; 
% Определение индекса вектора КК первого уровня
for s=1:128 
    delta=f-stage1((s-1)*10+1:s*10); 
    temp=w*(delta.^2)'; 
    m=1; 
    while m<9 
        if temp<d(m,1) 
            d(m+1:9,:)=d(m:8,:); 
            d(m,1)=temp; 
            d(m,2:11)=delta; 
            d(m,12)=s; 
            break; 
        end
        m=m+1;
    end
end
% Определение индексов векторов КК второго уровня
for s=1:3 
    e=d; 
    d(1,2:11)=e(1,2:11)-stage2(s,1:10); 
    d(1,1)=w*(d(1,2:11).^2)'; 
    d(1,12:12+s)=[e(1,12:11+s),1]; 
    for m=2:8 
        delta=e(m,2:11)-stage2(1,1:10); 
        temp=w*(delta.^2)'; 
        for num=1:(m-1) 
            if temp<d(num,1) 
                d(num+1:9,:)=d(num:8,:); 
                d(num,1)=temp; 
                d(num,2:11)=delta; 
                d(num,12:11+s)=e(1,12:11+s); 
                d(num,12+s)=1; 
                break; 
            end
        end
        if temp>=d(m-1,1)
            d(m,2:11)=delta; 
            d(m,1)=temp; 
            d(m,12:12+s)=[e(1,12:11+s),1]; 
        end
    end
    for j=1:8
        for k=2:64 
            delta=e(j,2:11)-stage2(s,(k-1)*10+1:k*10); 
            temp=w*(delta.^2)'; 
            for n=1:8 
                if temp<d(n,1) 
                    d(n+1:9,:)=d(n:8,:); 
                    d(n,1)=temp; 
                    d(n,2:11)=delta; 
                    d(n,12:11+s)=e(j,12:11+s); 
                    d(n,12+s)=k; 
                    break; 
                end
            end
        end
    end
end
g=d(1,12:15); % индексы векторов 4 КК