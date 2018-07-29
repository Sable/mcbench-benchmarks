function Constr=SetUpConstraints(Securities);

N=length(Securities);

P_0s=[];
D_s=[];
for n=1:N
    P_0s=[P_0s Securities(n).P_0];
    D_s=[D_s Securities(n).P_D];
end
Constr.Aeq=[P_0s
    D_s];
Constr.beq=[0
    0];
Constr.Aleq=[diag(P_0s)
    -diag(P_0s)];
Constr.bleq=[10000*ones(N,1)
        10000*ones(N,1)];