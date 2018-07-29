%% Returnerar dT för varm och kall ström för 
%% 
%% Motström
%% T(1) är kallvatten ut
%% T(2n) är varmvatten ut

%% 1 2 .. n
%% <-------- kv in
%% -------->
%%n+1 .. 2*n 

function der = dTlabvvx(T,par)

n = length(T)/2;

rho = par(1);
cp = par(2);
Fk = par(3);
Fv = par(4);
k = par(5);
Tkin = par(6);
Tvin = par(7);
Atot = par(8);
Vtot = par(9);

V = Vtot/n;
A = Atot/n;

%Kall
for i = 1:(n-1),
   dT(i) = 1/(rho*cp*V)*(rho*cp*Fk*(T(i+1)-T(i))+k*A*(T(i+n)-T(i)));
end
dT(n) = 1/(rho*cp*V)*(rho*cp*Fk*(Tkin-T(n))+k*A*(T(n+n)-T(n)));

dT(n+1) = 1/(rho*cp*V)*(rho*cp*Fv*(Tvin-T(n+1))-k*A*(T(n+1)-T(1)));
for i = (n+2):2*n,
   dT(i) = 1/(rho*cp*V)*(rho*cp*Fv*(T(i-1)-T(i))-k*A*(T(i)-T(i-n)));
end

der = dT';


