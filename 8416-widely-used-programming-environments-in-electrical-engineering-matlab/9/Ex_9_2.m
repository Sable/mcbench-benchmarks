clear;
		% Setarea formatului de scriere a randurilor
format compact
        % Definirea functiei de integrat
F=inline('1./x');
		% Incarcarea vectorului x cu elementele cuprinse
		% intre limitele de integrare
x=1:1e-2:2;
		% Evaluarea functiei de integrat in aceste puncte
y=feval(F,x);
		% Incarcarea solutiei exacte
sol_exact=log(2); 
        % Calcularea aproximativa a integralei cu
		% ajutorul metodei lui Simpson
I_S=quad(F,1,2);
		% Calcularea erorii relative la aceasta metoda
eroare_S=abs(I_S-sol_exact)/sol_exact*100; 
		% Afisarea rezultatelor
disp(['Solutia exacta a integralei= ',num2str(sol_exact)]);
disp(' ');
disp('Solutia aproximativa a integralei');
disp(['prin metoda lui Simpson=', num2str(I_S)]); 
disp(['Eroarea relativa= ',num2str(eroare_S),' %']);
		% Calcularea aproximativa a integralei cu
		% ajutorul metodei lui Lobatto
I_L=quadl(F,1,2);
		% Calcularea erorii relative la aceasta metoda
eroare_L=abs(I_L-sol_exact)/sol_exact*100; 
		% Afisarea rezultatelor
disp(' ');
disp('Solutia aproximativa a integralei ');
disp(['prin metoda lui Lobatto=', num2str(I_L)]); 
disp(['Eroarea relativa= ',num2str(eroare_L),' %']);
		% Calcularea aproximativa a integralei cu
		% ajutorul metodei trapezelor
I_t=trapz(x,y);
		% Calcularea erorii relative la aceasta metoda
eroare_t=abs(I_t-sol_exact)/sol_exact*100; 
		% Afisarea rezultatelor
disp(' ');
disp('Solutia aproximativa a integralei ');
disp(['prin metoda trapezelor=', num2str(I_t)]); 
disp(['Eroarea relativa= ',num2str(eroare_t),' %']);
		% Generarea unui vector cu erorile obtinute 
		% la diferite metode
eror=[eroare_S, eroare_L,eroare_t];
		% Determinarea erorii minime
		%  - val_eroare contine valoarea minima 
		%    din vectorul eror
		%  - nr_eroare contine numarul elementului 
		%    minim din vectorul eror
[val_eroare, nr_eroare]=min(eror);
		% Afisarea erorii minime si a metodei cu ajutorul 
		% careia s-a obtinut
disp(' ');
disp(['Eroarea cea mai mica de ',num2str(val_eroare)]);
switch nr_eroare
    case 1
	    disp('s-a obtinut cu ajutorul metodei Simpson');
    case 2
	    disp('s-a obtinut cu ajutorul metodei Lobatto');
    case 3 
	    disp('s-a obtinut cu ajutorul metodei trapezelor');
end;