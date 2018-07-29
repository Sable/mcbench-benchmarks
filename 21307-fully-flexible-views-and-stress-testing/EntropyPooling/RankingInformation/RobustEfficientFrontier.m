function [ExpVal,Vol, Weights] = RobustEfficientFrontier(TargetVols, Estimate, Constr)

N=size(Estimate.Cov,1);
p=size(Constr.Aeq,1);
q=size(Constr.Aleq,1);

[F,G]=pcacov(Estimate.Cov);
GF=[diag(sqrt(G))*F' zeros(N,1)];

[E,L]=pcacov(Estimate.Sigma_c);
LE=[diag(sqrt(L))*E' zeros(N,1)];

Aeq=[Constr.Aeq zeros(p,1)];
beq=Constr.beq;
Aleq=[Constr.Aleq zeros(q,1)];
bleq=Constr.bleq;

m=[Estimate.Mu_c
    -1];

Weights=[];
Vol=[];
ExpVal=[];

for i=1:length(TargetVols)

    cvx_begin
    
        variable x(N+1);
        maximize( x'*m );
        subject to
        Aeq*x == beq;
        Aleq*x <= bleq;
        norm(LE*x) <= x(N+1);
        norm(GF*x) <= TargetVols(i);
    
    cvx_end
    
    w=x(1:N);
    Weights=[Weights
        w'];
    Vol=[Vol
        sqrt(w'*Estimate.Cov*w)];
    ExpVal=[ExpVal
        w'*Estimate.ExpVal];
end
