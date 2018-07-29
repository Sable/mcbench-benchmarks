function f=melp_lsf2lpc(lsfs) 
% Конвертер LSF в LPC 
% ВХОДНЫЕ ПАРАМЕТРЫ: 
% lsfs - ЛСЧ 
% ВЫХОДНЫЕ ПАРАМЕТРЫ:  
% f    - коэффициенты ЛП 

lsfs=pi*lsfs/4000; 
for i=1:5 
    for j=1:2 
        w(j,i)=lsfs((i-1)*2+j); 
    end 
end 
w=cos(w); 
for i=1:2 
    temp=[1 -2*w(i,5) 1]; 
    P=temp; 
    for j=1:4 
        temp=[1 -2*w(i,j) 1]; 
        w0=[P 0 0;0 P 0;0 0 P]; 
        P=temp*w0; 
    end
    Q(i,:)=P;
end 
f=([Q(1,:) 0]+[0 Q(1,:)]+[Q(2,:) 0]-[0 Q(2,:)])/2; 
f=f(2:11);