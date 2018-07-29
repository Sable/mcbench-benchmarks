		% Incarcarea fisierului REZPAS.DAT continand 
		% solutiile obtinute in limbajul TURBO PASCAL
load rezpas.dat
		% Extragerea solutiei din fisierul incarcat
xpas=rezpas(:,1);
ypas=rezpas(:,2);
		% Incarcarea fisierului REZMATL.DAT continand 
		% solutiile obtinute in limbajul MATLAB
load rezmatl.dat
		% Extragerea solutiei din fisierul incarcat
xmatl=rezmatl(:,1);
ymatl=rezmatl(:,2);
		% Incarcarea a doua tabele cu rezultatele obtinute
tablpas=[xpas,ypas];
tablmatl=[xmatl,ymatl];
		% Definirea vectorului xx dupa care se va efectua 
		% cautarea in tabele
xx=0:0.1:20;
		% Cautarea in cele doua tabele
ypas_tab=table1(tablpas,xx);
ymatl_tab=table1(tablmatl,xx);
		% Calcularea diferentei dintre rezultatele 
		% obtinute cu cele doua metode
dif=ymatl_tab-ypas_tab;
		% Reprezentarea grafica a diferentei
plot(xx,dif)
		% Personalizarea reprezentarii grafice
		% - Etichetarea axelor
xlabel('x');
ylabel('Diferenta dintre cele doua solutii'); 