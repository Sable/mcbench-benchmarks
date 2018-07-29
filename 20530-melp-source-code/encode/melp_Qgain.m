function Q=melp_Qgain(G2p,G)
% Квантование усиления 
% ВХОДНЫЕ ПАРАМЕТРЫ: 
%   G2p - усиление для предыдущего кадра 
%   G   - усиления для текущего кадра 
% ВЫХОДНЫЕ ПАРАМЕТРЫ:
%   Q   - квантованные усиления 

if G(1)<10 
    G(1)=10; 
end 
if G(1)>77 
    G(1)=77; 
end

if (abs(G2p-G(2))<5)&&(abs(G(1)-0.5*(G(2)+G2p))<3)
    Q(1)=0; 
else
    gain_max=max(G2p,G(2))+6;
    gain_min=min(G2p,G(2))-6; 
    if gain_min<10 
        gain_min=10; 
    end
    if gain_max>77
        gain_max=77; 
    end
    delta=(gain_max-gain_min)/7;
    temp=G(1)-gain_min; 
    Q(1)=1+fix(temp/delta); 
    if Q(1)>7 
        Q(1)=7; 
    end
end

delta=67/32;                % шаг квантования
Q(2)=fix((G(2)-10)/delta); 
if Q(2)>31 
    Q(2)=31; 
end