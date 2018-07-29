clear
    % Generarea vectorilor cu informatii asupra elementelor matricei rare
    % - vectorul continand indicele randurilor
rand=[1 2 7 7 4 3];
    % - vectorul continand indicele coloanelor
col=[1 2 3 4 5 7];
    % - vectorul continand valorile elementelor
val=[1 2 5 2 3 4];
A=sparse(rand,col,val,7,7)
    % Convertirea matricei rare in matrice plina
B=full(A)