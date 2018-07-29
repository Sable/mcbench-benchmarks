function [Xsqp FUN FEVALS] = LocalSearch(X,Dat)

lb=Dat.FieldD(:,1);
ub=Dat.FieldD(:,2);
Aeq=[]; %AeqX=Beq
Beq=[];
A=[]; %AX<=B
B=[];

options=optimset('MaxFunEvals',1e4,'Display','off',...
    'algorithm','active-set','UseParallel','never');

[Xsqp FUN , ~, Options] = ...
    fmincon(@(X)LSearch(X,Dat),X,A,B,Aeq,Beq,lb,ub,[],options);

FEVALS=Options.funcCount;
for nvar=1:size(X,2)
    if isnan(Xsqp(1,nvar))
        Xsqp=X;
        break;
    end
end

function J=LSearch(X,Dat)
sop=Dat.sop;
J=sop(X,Dat);
