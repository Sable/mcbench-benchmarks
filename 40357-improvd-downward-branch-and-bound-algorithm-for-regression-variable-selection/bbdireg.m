function [B,vset,ops,ct] = bbdireg(Y,X,n,nc)
% BBDIREG: 
% Improved downwards branch and bound (BBDi) to select subset for least
% squares regression problems, Y = X*p, where X is independent, Y is
% dependent and p is parameter. 
% [B,vset,ops,ct] = bbdireg(y,x,n,nc) finds the best n-variable subset of
% X to minimize J = 0.5*(Y-A*p)'*(Y-A*p)
% Inputs: 
% y: each row is a dependent smaple, m columns
% x: each row is an independent sample, r columns
% n: subset size to be selected
% nc: the number of top solutions to be selected
% Outputs:
% B: The minimum J of nc top solutions
% vset: subset indices of nc top solutions
% ops: total number of operations spent.
% ct: total computation time spent
%
% By Yi Cao (c) at Cranfield University 17th February 2013
%
% Example
%{
r = 41;
m = 2;
n = 20;
N = 1000;
Y = randn(N,m);
X = randn(N,r);
nc = 10;
[B,vset,ops,ct] = bbdireg(Y,X,n,nc);
%}
% Reference: Kariwala, V., Ye, L. and Cao, Y, "Branch and Bound Method for
% Regression-Based Controlled Variable Selection", Computers & Chemical
% Engineering, to appear 2013 
%

% determin size of the problem
[N,r]=size(X);
if size(Y,1)~=N
    error('Y and X should have the same number of rows.')
end

% convert to standard problem J = 0.5*x'*inv(C)x;
C = X'*X; % should be rxr
invCo=inv(C);
cmin=min(eig(C));

Z = X'*Y;
bound=0;
fx=false(1,r);
rem=true(1,r);
crem=rem;
B=zeros(nc,1);
vset=zeros(nc,n);
ib=1;
ops=zeros(1,5);
invC=invCo;
p2=zeros(1,r);
y2=p2;
nf=0;
n2=n;
m2=r;
f=false;
downf=false;
t0=cputime;
bbm2sub(fx,rem);
[B,idx]=sort(B);
B = 0.5*(Y(:)'*Y(:) - B);
ct=cputime-t0;
vset=sort(vset(idx,:),2);

% Main recursive function
    function bbm2sub(fx0,rem0)
        ops(4)=ops(4)+1;
        fx=fx0;
        rem=rem0;
        nf=sum(fx);
        m2=sum(rem);
        n2=n-nf;
        while ~f && m2>=n2 && n2>=0
            if ~f && n2>0 && m2>n2 && ~downf %&& (bound>0 || m2-n2==1)
                downprune;          % downward pruning
            else
                downf=true;         % no need to check pruning conditions
            end
            if f || m2<n2 || n2<0
                return % no feasible solution
            elseif (m2==n2 && n2>1)  || (~n2 && (m2-n2>1 || ~downf))
                break  % no need to branch further
            end
            % downwards branching
            fx1=fx;
            rem1=rem;
            b0=bound;
            p0=p2;
            invC0=invC;
            p2(~rem)=Inf;
            [~,id]=min(p2);
            fx1(id)=true;
            rem1(id)=false;
            downf=false;
            if sum(rem1)+sum(fx)>n
                updateC(fx|rem1,id); % update C inverse required
            end
            bbm2sub(fx,rem1);        % recursive call
            downf=any(p0);
            invC=invC0;
            fx=fx1;
            rem=rem1;
            if b0<bound              % bound improved check pruning
                p0(~rem)=Inf;
                L=p0<=bound;
                if any(L)
                    rem=rem&~L;
                    downf=true;
                    fx=fx|L;
                end
            end
            f=false;
            p2=p0;
            nf=sum(fx);
            n2=n-nf;
            m2=sum(rem);
        end
        if ~f % terminal node update
            if m2==n2
                update(fx|rem);
            elseif ~n2
                update(fx);
            end
        end
    end

% Update C inverse
    function updateC(s,id)
        u = invC(s,id);
        d = invC(id,id);
        invC(s,s) = invC(s,s) - u*(d\u');
    end

% Downwards pruning function
    function downprune
        while ~downf
            f=false;
            downf=true;
            ops(2)=ops(2)+1;    % operation count
            ops(3)=ops(3)+m2;
            s=fx|rem;           % fix + candidate set
            rem0=rem;
            D=invC(s,s);
            y=Z(s,:);
            dy=D*y;
            b0=dy(:)'*y(:);     
            if b0 < bound       % current node pruning
                f = true;
                return;
            end
            dy2 = sum(dy.*dy,2);
            d=diag(D);
            alpha = (dy2./d)';
            p2(s)=b0-alpha;     % subnode pruning
            if m2-n2==1         % special case, discard one 
                ops(5)=ops(5)+1;
                p2(~rem)=0;
                [b,id]=max(p2);
                while b>bound   % find the optimal solution
                    s0=s;
                    s0(id)=false;
                    B(ib)=b;         %avoid sorting
                    vset(ib,:)=find(s0);
                    [bound,ib]=min(B);
                    p2(id)=0;
                    [b,id]=max(p2);
                end
                f=true;         % terminated branch serach
                return;
            end
            if bound>0 && m2-n2>1
                p2(~rem)=Inf;
                L=p2<bound;         % subnode pruning
                if any(L)
                    rem = rem & ~L;
                    fx = fx | L;
                    m2 = sum(rem);
                    nf = sum(fx);
                    n2 = n - nf;
                    if n2<=0
                        return
                    end
                end
            end
            rems=rem(s);
            if any(crem~=rem)
                cmin = 1/max(eig(D(rems,rems))); % update cmin
                crem=rem;
            end
            [sy,idx]=sort(dy2(rems));
            ind = find(rem);
            idx = ind(idx);
            pred=sum(sy(1:(m2-n2)))*cmin; % predictive downwards pruning
            if b0-pred<bound
                f=true;
                return
            end
            if bound>0 && m2-n2>1 % predictive subnode pruning downwards
                y2=p2;
                y2(idx(m2-n2+1:m2))=b0-pred-(sy(m2-n2+1:m2)-sy(m2-n2))*cmin;
                L=y2<bound;
                L(idx(1:m2-n2))=false;
                L(~rem)=false;
                if any(L)
                    rem = rem & ~L;
                    fx = fx | L;
                    m2 = sum(rem);
                    nf = sum(fx);
                    n2 = n - nf;
                    if n2<=0
                        return
                    end
                end
            end
            if bound>0 && n2>0 % predictive subnode pruning upwards
                y2(idx(1:m2-n2))=(sy(1:m2-n2)-sy(m2-n2+1))*cmin;
                L0=b0-pred+y2<=bound;
                L0(idx(m2-n2+1:m2))=false;
                L0(~rem0)=false;
                if any(L0(L))
                    f=true;
                    return
                end
                L0(~rem)=false;
                if any(L0)
                    downf=false;
                    rem(L0)=false;
                    m2=sum(rem);
                    if m2<=n2
                        return
                    end
                    updateC(rem|fx,L0);
                end
            end
            if downf
                return
            end
        end
    end

% Update function
    function update(s)
        z=Z(s,:)'/chol(C(s,s));
        ops(1)=ops(1)+1;
        lambda=z(:)'*z(:);
        if lambda>=bound
            B(ib)=lambda;         %avoid sorting
            vset(ib,:)=find(s);
            [bound,ib]=min(B);
        end
    end
        
end
