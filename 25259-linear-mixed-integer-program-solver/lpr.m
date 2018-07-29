function [x,fval,flag] = lpr(c,A,b,Aeq,beq,e,s,d,yidx,sol,opts)
%LPR
% Function to solve the lp-relaxation problem. Used by branch and bound
% algorithm.
% [x,fval,flag] = lpr(c,A,b,Aeq,beq,e,s,d,yidx,sol,opts)
%
% See Also:
% miprog
%
% Thomas Trötscher 2009
%

%Calculate the extra constraints imposed by s
%if s is all NaN then no new constraints
sidx = ~isnan(s);
ydiag = double(yidx);
if any(sidx)
    ydiag(yidx) = d;
    l = length(yidx);  
    Y = spdiags(ydiag,0,l,l);
    %Remove zero entries
    Y = Y(any(Y,2),:);
end
if sol==1
    %BP
    if any(sidx)
        A = [A; Y];
        b = [b; s(sidx)];
        e = [e; zeros(sum(sidx),1)];
    end
    [x,y,s,w,how] = bp([],A,b,c,e,[],[],[],[],opts);
    fval = c'*x;
    if strcmp(how,'optimal solution')
        flag = 1;
    elseif strcmp(how,'infeasible dual')
        flag = -5;
    elseif strcmp(how,'infeasible primal')
        flag = -2;
    else
        warning(['BP: ',how])
        flag = -7;
    end
elseif sol==2
    %linprog
    if any(sidx)
        A = [A; Y];
        b = [b; s(sidx).*d(sidx)];
    end
    [x,fval,flag] = linprog(c,A,b,Aeq,beq,[],[],[],opts);
elseif sol==3
    %CLP
    if any(sidx)
        A = [A; Y];
        b = [b; s(sidx).*d(sidx)];
    end
    %[x,lambda,status,fval] = clp([],c,A,b,Aeq,beq,-inf(size(A,2),1),inf(size(A,2),1),opts,-inf(size(b,1),1));
    [x,lambda,status] = clp([],c,A,b,Aeq,beq,[],[],opts);
    fval = c'*x;
    if status==0
        flag=1; %converged
    elseif status==1
        flag=-2; %infeasible
    else
        warning('CLP: unbounded')
        flag=-3; %unbounded
    end
elseif sol==5
    %QSopt
    if any(sidx)
        A = [A; Y];
        b = [b; s(sidx).*d(sidx)];
    end
    [x,z,status] = qsopt(c,A,b,Aeq,beq,[],[],opts);
    fval = c'*x;
    if status==1
        flag=1; %converged
    elseif status==2
        flag=-2; %infeasible
    elseif status==3
        flag=-3; %unbounded
    else
        %time/iter/other
        warning(['QSOPT: ',num2str(status)])
        flag=-7;
    end
end