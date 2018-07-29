clear all
        % Declararea variabilei simbolice x
syms x
        % Dezvoltarea in serie Taylor pana la ordinul 6 
        % a functiei f(x)=ln(x) in jurul valorii x=1    
T=taylor(log(x),6,1);
        % Afisarea rezultatului nesimplificat
pretty(T)