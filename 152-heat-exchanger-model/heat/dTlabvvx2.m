%% Returnerar dT för varm och kall ström för 
%% 
%% Motström
%% T(1) är kallvatten ut
%% T(2n) är varmvatten ut
%% T(n) är kallvatten in
%% T(n+1) är varmvatten in
%%

%% 1 2 .. n
%% <-------- kv in
%% -------->
%%n+1 .. 2*n 

%In kommer 1:n-1, n+1:2n, dvs 2n-2 st

function der = dTlabvvx2(T,par)
n = length(T)/2; %9

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

T = [T(1:n); Tkin; Tvin; T(n+1:2*n)];

%Kall
for i = 1:n,
   dT(i) = 1/(rho*cp*V)*(rho*cp*Fk*(T(i+1)-T(i))+k*A*(T(i+n+1)-T(i)));
end

%Varm
for i = (n+3):2*n+2,
   dT(i) = 1/(rho*cp*V)*(rho*cp*Fv*(T(i-1)-T(i))-k*A*(T(i)-T(i-n-1)));
end

der = [dT(1:n) dT(n+3:2*n+2)]';


