disp('Solutia ecuatiei diferentiale fara conditii initiale')
        % Rezolvarea ecuatiei diferentiale fara conditii initiale
[f,g]=dsolve('Df=3*f+4*g','Dg=-4*f+3*g')
        % Vizualizarea pe ecran a solutiei
pretty([f,g])
disp('Solutia ecuatiei diferentiale cu conditii initiale')
        % Rezolvarea ecuatiei diferentiale cu conditii initiale
[f,g]=dsolve('Df=3*f+4*g','Dg=-4*f+3*g','f(0)=0','g(0)=1')
        % Vizualizarea pe ecran a solutiei
pretty([f,g])
        % Rezolvarea ecuatiei diferentiale fara conditii initiale
        % precizand un singur parametru de iesire
S=dsolve('Df=3*f+4*g','Dg=-4*f+3*g')
        % Convertirea structurilor obtinute ca solutie 
        % in matrice de tip celula 
sol_f=struct2cell(f)
sol_g=struct2cell(g)