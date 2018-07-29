function f=LSF_clmp(LSF) 
% Регулирует расстояние между граничными ЛСЧ
% ВХОДНЫЕ ПАРАМЕТРЫ: 
%   LSF - ЛСЧ 
% ВЫХОДНЫЕ ПАРАМЕТРЫ:  
%   f   - выровненные ЛСЧ

f=LSF*4000/pi;   
dmin=50;         
for m=1:9 
    d=f(m+1)-f(m); 
    if d<dmin 
        s1=(dmin-d)/2; 
        s2=s1; 
        if (m==1)&&(f(m)<dmin) 
            s1=f(m)/2; 
        elseif m>1 
            temp=f(m)-f(m-1); 
            if temp<dmin 
                s1=0; 
            elseif temp<2*dmin 
                s1=(temp-dmin)/2; 
            end
        end
        if (m==9)&&(f(m+1)>4000-dmin)
            s2=(4000-f(m+1))/2; 
        elseif m<9 
            temp=f(m+2)-f(m+1); 
            if temp<dmin 
                s2=0; 
            elseif temp<2*dmin 
                s2=(temp-dmin)/2; 
            end
        end
        f(m)=f(m)-s1;
        f(m+1)=f(m+1)+s2; 
    end 
end