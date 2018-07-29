clear
    % Incarcarea directa a primului lot de date
Fisa(1).Nume='Tatiana';
Fisa(1).Varsta=26;
Fisa(1).Serviciu='DMI';
    % Incarcarea directa a setului al doilea de date
Fisa(2).Nume='Cristi';
Fisa(2).Varsta=27;
Fisa(2).Serviciu='Poli';
    % Incarcarea setului al treilea de date
Fisa(3).Nume='George';
Fisa(3).Varsta=27;
Fisa(3).Serviciu='Republica';
    % Afisarea structurii Fisa
disp('Afisarea informatiilor referitoare la structurile create')
Fisa
    % Incarcarea celulelor cu datele de introdus in campurile Nume si Serviciu
Cel_Nume={'Tatiana','Cristi','George'};
Cel_Serv={'DMI','Poli','Republica'};
    % Generarea structurii Fisa1
Fisa1=struct('Nume',Cel_Nume,'Varsta',{26 27 27},'Serviciu',Cel_Serv)
    % Afisarea datelor aferente celor doua structuri create
whos Fisa Fisa1
    % Afisarea numelor campurilor din structura Fisa
disp('Afisarea numelor campurilor din structura Fisa')
nume_campuri=fieldnames(Fisa)
    % Incarcarea intr-o matrice de tip celula a valorilor din campul Nume
for k=1:3
    date_nume{k}=getfield(Fisa,{k},'Nume');
end
    % Afisarea continutului matricei de tip celula date_nume
disp('Afisarea continutului matricei de tip celula date_nume')
date_nume
    % Modificarea elementului 3 din campul Nume 
Fisa=setfield(Fisa,{3},'Nume','Razvan');
    % Verificarea modificarii
disp('Verificarea elementului modificat')
b=getfield(Fisa,{3},'Nume')
    % Stergerea campului Serviciu
Fisa=rmfield(Fisa,'Serviciu');
    % Transformarea structurii Fisa in matrice de tip celula C
C=struct2cell(Fisa);
    % Afisarea matricei de tip celula cu campul sters
disp('Afisarea matricei de tip celula in care')
disp('s-a convertit structura cu campul sters')
C