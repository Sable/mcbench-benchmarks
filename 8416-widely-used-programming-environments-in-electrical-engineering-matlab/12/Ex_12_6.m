clear all
        % Declararea variabilei simbolice k
syms k
        % Calcularea primei sume
S1=symsum(k,1,k)
        % Afisarea rezultatului nesimplificat
pretty(S1)
        % Simplificarea rezultatului
S1=simple(S1)
        % Afisarea rezultatului simplificat
pretty(S1)
        % Calcularea sumei a doua
S2=symsum(1/(k*(k+1)),1,inf)