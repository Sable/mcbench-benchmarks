clear all
        % Desemnarea variabilei x ca si simbolica
x=sym('x');
		% Incarcarea functiei de integrat
F=1/x    
        % Calcularea integralei nedefinite
I1=int(F)
        % Calcularea integralei definite intre limitele 1 si 2
I2=int(F,1,2)