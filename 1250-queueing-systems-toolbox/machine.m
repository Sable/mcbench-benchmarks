%machine(lambda,mu,m,cw,cs)
%   This function finds the optimal number of servers
%   to be hired in order to maximize profit, or equivilently,
%   minimize the cost of repairmen and revenue lost to down machines.

function out = machine(lambda,mu,m,cw,cs)

cont = 1;
c = 1;
costlast = inf;
while cont == 1
    ld = fsqfindld(lambda,mu,c,m);
    costnow = cw*ld + cs*c;
    if costnow < costlast
        costlast = costnow;
        c = c + 1;
    end
    if costnow > costlast
        cont = 0;
    end
end

out = c;
    