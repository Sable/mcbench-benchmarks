    % Generarea matricei A
A=[11 12 13 14;21 22 23 24;31 32 33 34;41 42 43 44]
    % Incercarea diferitelor functii destinate manipularii matricelor
A1=diag(A)'
A2=diag(A,2)
A3=fliplr(A)
A4=flipud(A)	
A5=reshape(A,2,8)
A6=rot90(A)
A7=rot90(A,2)
    % Incercarea diferitelor functii destinate analizei matriceale
D=det(A)
Y=inv(A)
