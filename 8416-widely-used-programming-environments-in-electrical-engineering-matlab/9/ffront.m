function cond_front=ffront(ya,yb)
        % Functie care determina conditiile de frontiera la o
        % ecuatie diferentiala ordinara 
        
        % Initializarea vectorului cond_front in vederea 
        % formarii unui vector coloana
cond_front=zeros(2,1);
        % Implementarea conditiilor de frontiera
cond_front(1)=ya(1);
cond_front(2)=yb(1)+2;