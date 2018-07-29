function x_best = miprog(c,A,b,Aeq,beq,lb,ub,yidx,o)
%MIPROG
% Branch and bound algorithm for linear mixed integer programs
% x_best = miprog(c,A,b,Aeq,beq,lb,ub,yidx,[options])
%
%   min c'*x s.t. A*x <= b Aeq*x == beq lb <= x <= ub x(yidx) in [0,1,2,...]
% 
%   where yidx is a logical index vector such that
%   x(yidx) are the integer variables
% 
% Input:
% c,A,b,Aeq,beq,lb,ub - problem matrices
% yidx - a logical index vector such that y = x(yidx)
% options - (optional) mipoptions 
% 
% Output:
% x_best - best integer solution found
% 
% See Also:
% mip_gridoptim, gridoptions
% 
% Programmed by Thomas Trötscher 2009
%  

tic;
if nargin<9
    o = mipoptions();
end

if nargin<8
    error('MIPROG: Too few input arguments')
end

if ~islogical(yidx) || sum(yidx)<1 || length(c) ~= length(yidx)
    error('MIPROG: yidx must be a logical vector the size of x with at least one true element')
end

%% Init
%add upper and lower bounds to A
Ab = speye(length(yidx));
if ~isempty(lb)
    A = [A; -Ab];
    b = [b; -lb];
end
if ~isempty(ub)
    A = [A; Ab];
    b = [b; ub];
end
%delete all-zero rows
b = b(any(A,2),:);
A = A(any(A,2),:);

%Which lp solver are we using? Do som initializing...
if strcmp(o.solver,'bp')
    e = [zeros(size(Aeq,1),1); -ones(size(A,1),1)];
    A = [Aeq;A];
    b = [beq;b];
    opts=[];
    sol=1;
elseif strcmp(o.solver,'linprog')
    e=[];
    opts = optimset('Display','off');
    sol=2;
elseif strcmp(o.solver,'clp')
    e=[];
    opts=[];
    sol=3;
elseif strcmp(o.solver,'qsopt')
    e=[];
    opts=[];
    sol=5;
else
    error('MIPROG: Wrong lp solver')
end

%Assume no initial best integer solution
%Add your own heuristic here to find a good incumbent solution, store it in
%f_best,y_best,x_best
f_best = inf;
y_best = [];
x_best = [];

%Variable for holding the objective function variables of the lp-relaxation
%problems
f = inf(o.maxNodes,1);
f(1) = 0;
fs = inf;
numIntSol = double(~isempty(y_best));

%Set of problems
S = nan(sum(yidx),1);
D = zeros(sum(yidx),1);

%The priority in which the problems shall be solved
priority = [1];
%The indices of the problems that have been visited
visited = nan(o.maxNodes,1);

%Plot each iteration?
i=0;
if o.iterplot
    figure;
    hold on;
    title('Bounds')
    xlabel('Iteration')
    ylabel('Obj. fun. val')
end
%% Branch and bound loop
while i==0 || isinf(f_best) || (~isempty(priority) &&  ((f_best-min(fs(priority)))/abs(f_best+min(fs(priority))) > o.Delta) &&  i<o.maxNodes)
    %Is the parent node less expensive than the current best
    if i==0 || fs(priority(1))<f_best
        %Solve the LP-relaxation problem
        i=i+1;
        s = S(:,priority(1));
        d = D(:,priority(1));
        [x,this_f,flag] = lpr(c,A,b,Aeq,beq,e,s,d,yidx,sol,opts);

        %Visit this node
        visited(i) = priority(1);
        priority(1) = [];
        if flag==-2 || flag==-5
            %infeasible, dont branch
            if i==1
                error('MIPROG: Infeasible initial LP problem. Try another LP solver.')
            end
            f(i) = inf;
        elseif flag==1
            %convergence
            f(i) = this_f;  
            if this_f<f_best
                y = x(yidx);
                %fractional part of the integer variables -> diff
                diff = abs(round(y)-y);
                if all(diff<o.intTol)
                    %all fractions less than the integer tolerance
                    %we have integer solution
                    numIntSol = numIntSol+1;
                    f_best = this_f;
                    y_best = round(x(yidx));
                    x_best = x;
                else
                    if o.branchCriteria==1
                        %branch on the most fractional variable
                        [maxdiff,branch_idx] = max(diff,[],1);
                    elseif o.branchCriteria==2
                        %branch on the least fractional variable
                        diff(diff<o.intTol)=inf;
                        [mindiff,branch_idx] = min(diff,[],1);
                    elseif o.branchCriteria==3
                        %branch on the variable with highest cost
                        cy = c(yidx);
                        cy(diff<o.intTol)=-inf;
                        [maxcost,branch_idx] = max(cy,[],1);
                    elseif o.branchCriteria==4
                        %branch on the variable with lowest cost
                        cy = c(yidx);
                        cy(diff<o.intTol)=inf;
                        [mincost,branch_idx] = min(cy,[],1);  
                    else
                        error('MIPROG: Unknown branch criteria.')
                    end
                    %Branch into two subproblems
                    s1 = s;
                    s2 = s;
                    d1 = d;
                    d2 = d;
                    s1(branch_idx)=ceil(y(branch_idx));
                    d1(branch_idx)=-1; %direction of bound is GE
                    s2(branch_idx)=floor(y(branch_idx));
                    d2(branch_idx)=1; %direction of bound is LE
                    nsold = size(S,2);
                    
                    % add subproblems to the problem tree
                    S = [S s1 s2];
                    D = [D d1 d2];
                    fs = [fs f(i) f(i)];
                    
                    nsnew = nsold+2;

                    if o.branchMethod==1 || (o.branchMethod==13 && numIntSol<6)
                        %depth first, add newly branched problems to the
                        %beginning of the queue
                        priority = [nsold+1:nsnew priority];
                    elseif o.branchMethod==2
                        %breadth first, add newly branched problems to the
                        %end of the queue
                        priority = [priority nsold+1:nsnew];
                    elseif o.branchMethod==3 || (o.branchMethod==13 && numIntSol>=6)
                        %branch on the best lp solution
                        priority = [nsold+1:nsnew priority];
                        [dum,pidx] = sort(fs(priority));
                        priority=priority(pidx);
                    elseif o.branchMethod==4
                        %branch on the worst lp solution
                        priority = [nsold+1:nsnew priority];
                        [dum,pidx] = sort(-fs(priority));
                        priority=priority(pidx);
                    else
                        error('MIPROG: Unknown branch method.')
                    end     
                end
            end
            if (strcmp(o.display,'improve') || strcmp(o.display,'iter')) && (f(i)==f_best || i==1) 
                disp(['It. ',num2str(i),'. Best integer solution: ',num2str(f_best),' Delta ',num2str(max([100*(f_best-min(fs(priority)))/abs(f_best+min(fs(priority))) 0 100*isinf(f_best)])),'%']);
                %disp(['Queue: ', num2str(length(priority))]);
            end
        else
            error('MIPROG: Problem neither infeasible nor solved, try another solver or reformulate problem!')
        end
        if strcmp(o.display,'iter')
            disp(['It. ',num2str(i),'. F-val(It): ',num2str(f(i)),' Delta ',num2str(max([100*(f_best-min(fs(priority)))/abs(f_best+min(fs(priority))) 0 100*isinf(f_best)])),'%. Queue len. ', num2str(length(priority))]);
        end
        if o.iterplot
            plot(i,[f_best min(fs(priority))],'x')
            if i==1
                legend('MIP','LP')
            end
            drawnow;
        end
    else %parent node is more expensive than current f-best -> don't evaluate this node
        priority(1) = [];
    end
end

if ~strcmp(o.display,'off')
    disp(['Iteration ', num2str(sum(~isnan(visited))), '. Optimization ended.']);
    if isempty(priority) || f_best<min(fs(priority))
        disp('Found optimal solution!')
    elseif ~isinf(f_best)
        disp(['Ended optimization. Current delta ',num2str(max([100*(f_best-min(fs(priority)))/f_best 0 100*isinf(f_best)])),'%']);
    else
        disp(['Did not find any integer solutions']);
    end
    disp(['Time spent ', num2str(toc), ' seconds']);
    disp(['Objective function value: ',num2str(f_best)]);
end