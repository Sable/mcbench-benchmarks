clear, clc
        % Definirea variabilelor simbolice
syms ud uq Rs Ls Rr Lr id iD iq iQ M w
syms diddt diqdt diDdt diQdt        
        % Variabilele utilizate care nu corespund exact cu simbolurile utilizate
        % - w - omega
        % - diddt - d(id)/dt  si  diqdt - d(iq)/dt
        % - diDdt - d(iD)/dt  si  diQdt - d(iQ)/dt
        % Incarcarea celor patru ecuatii 
eq1=-ud+Rs*id+Ls*diddt+M*diddt+M*diDdt;
eq2=-uq+Rs*iq+Ls*diqdt+M*diqdt+M*diQdt;
eq3=Rr*iD+Lr*diDdt+M*diddt+M*diDdt+w*Lr*iQ+w*M*(iq+iQ);
eq4=Rr*iQ+Lr*diQdt+M*diqdt+M*diQdt-w*Lr*iD-w*M*(id+iD);
        % Rezolvarea sistemului de ecuatii
        % avand ca variabile independente cele 4 derivate ale curentilor
        % Rezultatele obtinute sunt intocmai derivatele curentilor
SOL=solve(eq1,eq2,eq3,eq4,'diddt,diqdt,diDdt,diQdt');
        % Extragerea solutiei din structura returnata
diddt=SOL.diddt;
diqdt=SOL.diqdt;
diDdt=SOL.diDdt;
diQdt=SOL.diQdt;
        % Afisarea solutiei
disp('did/dt = '),pretty(diddt)
disp('diq/dt = '),pretty(diqdt)
disp('diD/dt = '),pretty(diDdt)
disp('diQ/dt = '),pretty(diQdt)
        % Verificarea solutiei prin inlocuirea rezultatelor in sistemul de ecuatii
Verif1=simple(-ud+Rs*id+Ls*diddt+M*diddt+M*diDdt);
Verif2=simple(-uq+Rs*iq+Ls*diqdt+M*diqdt+M*diQdt);
Verif3=simple(Rr*iD+Lr*diDdt+M*diddt+M*diDdt+w*Lr*iQ+w*M*(iq+iQ));
Verif4=simple(Rr*iQ+Lr*diQdt+M*diqdt+M*diQdt-w*Lr*iD-w*M*(id+iD));
        % Formarea unei vectori cu erorile obtinute
        % (daca toate elementele sale sunt nule, solutia este buna)
Eroare=[Verif1,Verif2,Verif3,Verif4]