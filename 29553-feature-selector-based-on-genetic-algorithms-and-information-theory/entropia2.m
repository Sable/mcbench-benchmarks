function H=entropia2(X,resolucao)
[L,Col]=size(X);
if L>Col
    X=X';
end
[L,Col]=size(X);
maximo=max(X')';
minimo=min(X')';
passo=(maximo-minimo)/resolucao;
for k=1:2
    if passo(k)==0;
        passo(k)=1;
    end
end
opera=0;
%entropy calculation:
H=0;
for k1=minimo(1):passo(1):maximo(1)
    for k2=minimo(2):passo(2):maximo(2)
        opera=opera+1;
        P=0;
        for contador=1:Col
            if and(X(1,contador)>=k1,X(1,contador)<k1+passo(1))
               if and(X(2,contador)>=k2,X(2,contador)<k2+passo(2))      
                  P=P+1;                              
               end
            end
        end                  
        p=P/Col;
        if p~=0
           H=H-p*log(p);
        end             
    end
end
