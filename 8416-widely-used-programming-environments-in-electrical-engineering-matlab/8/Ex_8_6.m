clear, clf
        % Introducerea nodurilor dupa o functie definita
x=0:0.01:5;	
y=-3+2.*x-0.7.*x.^2;
        % Introducerea unei valori eronate
y(100)=4;
        % Reprezentarea nodurilor considerate
figure(1)
plot(x,y,'b')
        % Calcularea valorii medii si a abaterii standard
medie=mean(y)
abat_std=std(y)
        % Filtrarea valorilor eronate
eronate=abs(y-medie) > 3*abat_std;
y1=y(~eronate);
x1=x(~eronate);
        % Reprezentarea nodurilor fara valoarea eronata
figure(2)
plot(x1,y1,'r');