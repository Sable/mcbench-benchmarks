function Ia=solar(Va,Suns,TaC)
% Datos del arreglo solar MSX-60
% Calcula la corriente dado el voltaje, iluminaction y la temperatura
% Ia = solar (Va,G,T)= vector de voltaje
% Ia,Va = vector de corriente y ovoltaje
% G = numero de Suns(1 Sun = 1000W/m^2)
% T = Temp en grados Celcius
k = 1.38e-23; % Constante de Boltzman's
q = 1.60e-19; % Carga  de un electron
% Entre las siguientes constantes aqui,y el modelo sera
n=2;      % Factor de calidad del diodo, factor
            % n =2 para cristalino, <2 para amorfo
vg= 1.12;    %Voltaje de la banda, 1.12eV para xtal Si,
            % 1.75 para Si amorfo
Ns = 36;    % Numero de celdas  en serie (diodos)

T1 = 273 + 25;
Voc_T1 = 21.06/Ns;
% Voltaje de circuito abierto por celda a temperatura T1
Isc_T1 = 3.80;
% Corriente de cortocircuito de la celda a temparatura T1
T2 = 273 + 75;
Voc_T2 = 17.05/Ns;
% Voltaje de circuito abierto por celda a temperatura T2
Isc_T2 = 3.92;
TaC=25;
Suns=1;
% Corriente de cortocircuito de la celda a temparatura T2
TaK = 273 + TaC; %Temperatura de trabajo del arreglo
KO = (Isc_T2 - Isc_T1)/(T2 - T1);           % Ecuacion (4)
IL_T1 = Isc_T1 * Suns;                      % Ecuacion (3)
IL = IL_T1 + KO*(TaK - T1);                 % Ecuacion (2)
IO_T1 = Isc_T1/(exp(q*Voc_T1/(n*k*T1))-1);
IO= IO_T1*(TaK/T1).^(3/n).*exp(-q*vg/(n*k).*((1./TaK)-(1/T1)));
Xv = IO_T1*q/(n*k*T1) * exp(q*Voc_T1+T1/(n*k*T1)); % Ecuacion (8)
dVdI_V0c = - 1.15/Ns /2;
% dV/dI a Voc por celda desde la garficas del fabricante
Rs = - dVdI_V0c - 1/Xv;                   % Ecuacion (7)
A=0.8
Va=0:8
Vt_Ta =A * k * TaK / q; % = A* kT/q
Vc = Va/Ns;
Ia = zeros(size(Vc));
% Metodo de Newton
for j=1:5;
    Ia = Ia-(IL - Ia -IO.*(exp((Vc + Ia.*Rs)./Vt_Ta)-1))./(-1 - (IO.*(exp((Vc+Ia.*Rs)./Vt_Ta) -1)).*Rs./Vt_Ta);
end
plot(Ia)
for i=1:8
P(i)=Va(i)*Ia(i);
end


