clear all
        % Desemnarea variabilei x ca si simbolica
x=sym('x');
        % Calcularea celor trei limite
lim0=limit(1/x,x,0)
lim0_minus=limit(1/x,x,0,'left')
lim0_plus=limit(1/x,x,0,'right')