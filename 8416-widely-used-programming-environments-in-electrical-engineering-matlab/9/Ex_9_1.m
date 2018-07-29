clear; clf;
		% Gasirea valorii pentru care functia este minima
xmin=fminbnd('funct2',0,3);
		% Generarea unui vector cu pasul 0.1 avand 
		% elementele cuprinse intre limitele date
x=0:0.1:2.5;
		% Evaluarea functiei pentru valorile x
y=funct2(x);
		% Reprezentarea functiei pe intervalul dat
plot(x,y,'m-','LineWidth',[1.5])
hold on
		% Calcularea minimului functiei
ymin=funct2(xmin);
		% Marcarea minimului functiei
plot(xmin,ymin,'bx','MarkerSize',[16])
grid
        % Afisarea textului pe figura
h1=text(1.2,1.25,['xmin=',num2str(xmin)]);
h2=text(1.2,0.5,['f(xmin)=',num2str(ymin)]);
        % Setarea textului cu fonturi bold
set(h1,'FontWeight','Bold'); set(h2,'FontWeight','Bold');
		% Afisarea rezultatelor
disp('Functia are valoarea minima egala cu:'); disp(ymin);
disp('in punctul:'); disp(xmin);