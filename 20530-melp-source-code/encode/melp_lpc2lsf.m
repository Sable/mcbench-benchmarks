function f=melp_lpc2lsf(a)
% Конвертирует коэффициенты ЛП в ЛСЧ 
% ВХОДНЫЕ ПЕРЕМЕННЫЕ:  a - параметры ЛП 
% ВЫХОДНЫЕ ПЕРЕМЕННЫЕ: f - параметры ЛСЧ 
% В данной функции все параметры полиномов выстроены по возрастанию

P(1,1)=1; 
P(2,1)=1; 

for i=1:5 
    P(1,i+1)=a(i)+a(11-i)-P(1,i);
    P(2,i+1)=a(i)-a(11-i)+P(2,i); 
end 
P(:,6)=P(:,6)/2; % Получение уравнений для корней (в порядоке убывания) 
P=fliplr(P); 

b(1:6,1:6)=0; 
b(1,1)=1; 
b(2,2)=1; 
for i=1:4 
    b(i+2,1:i+2)=2*[0,b(i+1,1:i+1)]-[b(i,1:i),0,0]; 
end 

P=P*b; 
f1=0; % Получение полиномов P и Q 

for ii=1:2 
    k=pi/60; 
    y1=sum(P(ii,:));
    i=1; 
    while i<61 
        cosx=cos(i*k); 
        y2=cosx.^(1:5)*P(ii,2:6)'+P(ii,1); 
        if y2==0 
            f1=[f1,i*k]; 
            i=i+1; 
            cosx=cos(i*k); 
            y2=cosx.^(1:5)*P(ii,2:6)'+P(ii,1); 
        elseif y1*y2<0 
            x1=(i-1)*k; 
            x2=i*k; 
            for j=1:4 
                x=(x1+x2)/2; 
                cosx=cos(x); 
                temp=cosx.^(1:5)*P(ii,2:6)'+P(ii,1); 
                if temp==0 
                    f1=[f1,x]; 
                    break; 
                elseif temp*y2<0 
                    x1=x; 
                else
                    x2=x;
                    y2=temp; 
                end
            end
            if temp~=0
                f1=[f1,(x1+x2)/2]; 
            end
        end
        y1=y2;
        i=i+1; 
    end
end
temp=size(f1);
m=temp(2); 
f(1:10)=0; 
if m==11 
    f(1:10)=0; 
    f((1:5)*2-1)=f1(2:6); 
    f((1:5)*2)=f1(7:11); 
end