clear; clf;
		% Introducerea punctelor definite
t=[0,0.3,0.8,1.1,1.6,2.3]';	
y=[0.5,0.82,1.14,1.25,1.35,1.4]';	
		% Se reprezinta cu O-uri negre puntele date
plot(t,y,'Ko');
hold on;	
        %Generarea matricei coeficientilor sistemului
A=[ones(size(t)),exp(-t),t.*exp(-t)];
        % Rezolvarea sistemului de ecuatii
a=A\y
        % Extragerea coeficientilor functiei de aproximare
a0=a(1); a1=a(2); a2=a(3);
        % Generarea punctelor in care se calculeaza
        % valorile functiei de aproximare
tt=linspace(0,2.5,200);
		% Calcularea valorilor functiei de aproximare
yy=a0+a1.*exp(-tt)+a2.*tt.*exp(-tt);
        % Reprezentarea grafica a functiei de aproximare
plot(tt,yy,'b','LineWidth', 1.5);
        % Personalizarea reprezentarii grafice
grid on;
xlabel('t');	
ylabel('y');