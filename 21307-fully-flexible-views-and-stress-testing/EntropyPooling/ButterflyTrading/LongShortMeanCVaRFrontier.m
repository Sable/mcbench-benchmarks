function [Exp,SDev,CVaR,Composition] = LongShortMeanCVaRFrontier(PnL,Probs,Butterflies,Options)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[J,N]=size(PnL);
P_0s=[];
D_s=[];
for n=1:N
    P_0s=[P_0s Butterflies(n).P_0];
    D_s=[D_s Butterflies(n).Delta];
end

Constr.Aeq=P_0s;
Constr.beq=Options.Budget;
if Options.DeltaNeutral
    Constr.Aeq=[Constr.Aeq
        D_s];
    Constr.beq=[Constr.beq
        0];
end
Constr.Aleq=[diag(P_0s)
    -diag(P_0s)];
Constr.bleq=[Options.Limit*ones(N,1)
        Options.Limit*ones(N,1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine expectation of minimum-variance portfolio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Exps=PnL'*Probs;
Scnd_Mom=PnL'*(PnL.*(Probs*ones(1,N))); Scnd_Mom=(Scnd_Mom+Scnd_Mom')/2;
Covs=Scnd_Mom-Exps*Exps';

MinSDev_Units = quadprog(Covs,zeros(N,1),Constr.Aleq,Constr.bleq,Constr.Aeq,Constr.beq,[],[]);
MinSDev_Exp=MinSDev_Units'*Exps;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine expectation of maximum-expectation portfolio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MaxExp_Units = linprog(-Exps,Constr.Aleq,Constr.bleq,Constr.Aeq,Constr.beq);
MaxExp_Exp=MaxExp_Units'*Exps;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% slice efficient frontier in NumPortf equally thick horizontal sections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Grid=[Options.FrontierSpan(1) : (Options.FrontierSpan(end)-Options.FrontierSpan(1))/(Options.NumPortf-1) : Options.FrontierSpan(end)];
TargetExp=MinSDev_Exp + Grid*(MaxExp_Exp-MinSDev_Exp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute composition, expectation, s.dev. and CVaR of the efficient frontier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Composition=[];
Exp=[];
SDev=[];
CVaR=[];
for i=1:Options.NumPortf

    % determine least risky portfolio for given expectation
    AEq=[Constr.Aeq
        Exps'];
    bEq=[Constr.beq
        TargetExp(i)];

    Units = quadprog(Covs,zeros(N,1),Constr.Aleq,Constr.bleq,AEq,bEq,[],[]);

    % store results
    Composition=[Composition
        Units'];

    Exp=[Exp
        Units'*Exps];
    SDev=[SDev
        sqrt(Units'*Covs*Units)];
    CVaR=[CVaR
        ComputeCVaR(Units,PnL,Options.Quant)];
end