function [B,sset,ops,ctime,flag]=b3av(G1,Gd1,Wd,Wn,Juu,Jud,tlimit,nc)
% B3AV      Bidirectional Branch and Bound (B3) for Average Loss Criterion
%
%   [B,sset,ops,ctime,flag] = b3av(G1,Gd1,Wd,Wn,Juu,Jud,tlimit,nc) is a B3
%   implementation to select measurement subsets, which have the minimum
%   average loss in terms of self-optimizing control based on the
%   following static optimization problem:
%
%       min J = f(y,u,d)
%       s.t.
%           y = G1 * u + Gd1 * Wd * d + Wn * e
%
%  where y is measurement vector (ny), u is input vector (nu), d is disturance
%  vector (nd) and e is the control error vector (ny).
%
%  The average loss is defined based on the assumption that 
%
%       ||d||_2 = 1 and ||e||_1 = 1
%
% Inputs:
%   G1 = process model
%   Gd1 = disturbance model
%   Wd  = diagonal matrix containing magnitudes of disturbances
%   Wn = diagonal matrix containing magnitudes of implementation errors
%   Juu = \partial^2 J/\partial u^2
%   Jud = \partial^2 J/\partial u\partial d
%   tlimit defines the time limit to run the code. Default is Inf.
%   nc determines the number of best subsets to be selected. Default is 1.
%
% Outputs:
%   B     - nc x 1 vector of the average loss of selected subsets.
%   sset  - nc x nu indices of selected subsets
%   ops   - number of nodes evaluated.
%   ctime - computation time used
%   flag  - 0 if successful, 1 otherwise (for tlimit < Inf).
%
% References:
%  [1]    I. J. Halvorsen, S. Skogestad, J. C. Morud, and V. Alstad.
%  Optimal selection of controlled variables. Ind. Eng. Chem. Res.,
%  42(14):3273{3284, 2003.   
%  [2]   V. Kariwala, Y. Cao, and S. Janardhanan. Local self-optimizing 
%  control with average loss minimization. Ind. Eng. Chem. Res., 
%  47(4):1150-1158, 2008.
%  [3]    V. Kariwala and Y. Cao, Bidirectional Branch and Bound for
%  Controlled Variable Selection: Part III. Local Average Loss Minimization,
%  IEEE Transactions on Industrial Informatics, Vol. 6, No. 1, pp. 54—61,
%  2010.
%
%  See also b3msv, b3wc, pb3av, randcase

%  By Yi Cao at Cranfield University, 17th November 2009; 23rd February 2010.
%

% Example
%{
ny=30;
nu=15;
nd=5;
[G,Gd,Wd,Wn,Juu,Jud] = randcase(ny,nu,nd);
[B,sset,ops,ctime] = b3av(G,Gd,Wd,Wn,Juu,Jud);
% It takes about 2 seconds.
%}
%
    flag=false;
% Defaults    
    if nargin<8
        nc=1;
    end
    if nargin<7
        tlimit=Inf;
    end
% Initialization    
    ctime0=cputime;
    [r,n] = size(G1);
    % prepare matrices
    Y = [(G1*(Juu\Jud)-Gd1)*Wd Wn];
    G = G1/sqrtm(Juu);
    Y2=Y*Y';
    G2=G*G';
    diagY2=diag(Y2);
    diagG2=diag(G2);
    q2=diagY2./diagG2;
    p2=q2;
    ops=zeros(1,4);
    B=Inf(nc,1);
    sset=zeros(nc,n);
    ib=1;
    bound=Inf;
    % counters: 1) terminal; 2) nodes; 3) sub-nodes; 4) calls
    ops=[0 0 0 0];
    fx=false(1,r);
    rem=true(1,r);
    nf=0;
    n2=n;
    m2=r;
    % initial flags
    f=false;
    bf=false;
    downf=false;
    upf=false;
    E=eye(r);
    Gd=G;
    D=chol(Y2)'\G;
    D=chol(D'*D);
    db=trace(D\(D'\eye(n)));
    Dd=zeros(r);
    Ed=Dd;
    Zd=G';
    Xd=Y;
    % recursive solver
    bbavsub(fx,rem,0,db);
    % convert the bound to the average loss
    [B,idx]=sort(B/(6*(size(Wd,2)+n)));
    sset=sort(sset(idx,:),2);
    ctime=cputime-ctime0;
    
    function bbavsub(fx0,rem0,ub,db)
        if cputime-ctime0>tlimit
            flag=true;
            return;
        end
        ops(4)=ops(4)+1;
        fx=fx0;
        rem=rem0;
        nf=sum(fx);
        m2=sum(rem);
        n2=n-nf;
        while ~f && m2>n2 && n2>0   % Loop for second branchs
            while ~f && m2>n2 && n2>0 && (~downf || ~upf)
                % loop for bidirectional pruning
                if ~upf
                    [ub,db]=upprune(ub,db);   % upwards pruning
                end
                if ~f && m2>n2 && m2>0 && ~downf
                    [ub,db]=downprune(ub,db); % downwards pruning
                end
            end %pruning loop
            if f || m2<n2 || n2<0
                % pruned cases
                return
            elseif m2==n2 || ~n2
                % terminal nodes
                break
            end
            if m2-n2==1,
                % case for one more to remove
                p2(~rem)=Inf;
                if min(p2)<bound
                    idx=find(rem);
                    s=fx|rem;
                    S=s(ones(m2,1),:);
                    S((1:m2)+(idx-1)*m2)=false;
                    [B1,bidx]=sort([B;p2(rem)]);
                    B=B1(1:nc);
                    bound=B(nc);
                    ib=nc;
                    [J,I]=find(S');
                    iS=[sset;reshape(J,[],max(I))'];
                    sset=iS(bidx(1:nc),:);
                    bf=false;
                end
                return
            end
            if n2==1,
                % case for one more to fix
                q2(~rem)=Inf;
                if min(q2)<bound
                    idx=find(rem);
                    s=fx;
                    S=s(ones(m2,1),:);
                    S((1:m2)+(idx-1)*m2)=true;
                    [B1,bidx]=sort([B;q2(rem)]);
                    B=B1(1:nc);
                    bound=B(nc);
                    ib=nc;
                    [J,I]=find(S');
                    iS=[sset;reshape(J,[],max(I))'];
                    sset=iS(bidx(1:nc),:);
                    bf=false;
                end
                return
            end
            % save current working data for second branch
            fx1=fx;
            rem1=rem;
            b0=bound;
            p0=p2;
            q0=q2;
            ub0=ub;
            db0=db;
            X0=Xd;
            D0=Dd;
            Z0=Zd;
            E0=Ed;
            if n2<0.6*m2    %upward branching
                if m2-n2<100
                    p2(~rem)=0;
                    [b,id]=max(p2);
                else
                    q2(~rem)=inf;
                    [b,id]=min(q2);
                end
                fx(id)=true;
                rem1(id)=false;
                downf=true;
                upf=false;
                ub=q2(id);
                bbavsub(fx,rem1,ub,db);
                downf=false;
                upf=true;
                db0=p0(id);
                if p0(id)>=bound
                    return
                end
            else            % downward branching
                if n2<100
                    q2(~rem)=0;
                    [b,id]=max(q2);
                else
                    p2(~rem)=inf;
                    [b,id]=min(p2);
                end
                fx1(id)=true;
                downf=false;
                upf=true;
                rem1(id)=false;
                db=p2(id);
                bbavsub(fx,rem1,ub,db);
                downf=true;
                upf=false;
                ub0=q0(id);
                if q0(id)>=bound
                    return
                end
            end
            fx=fx1;
            rem=rem1;
            if b0>bound            % if improved bound in the first branch
                bf=false;
                q0(~rem)=0;
                L1=q0'>=bound;
                p0(~rem)=0;
                L2=p0'>=bound;
                if any(L1&L2)
                    return
                end
                if any(L1)
                    rem=rem&~L1;
                    downf=false;
                    if sum(L1)==1 && downf
                        db0=p0(L1);
                    else
                        db0=-1;
                    end
                end
                if any(L2)
                    rem=rem&~L2;
                    fx=fx|L2;
                    upf=false;
                    if sum(L2)==1 && upf
                        ub0=q0(L2);
                    else
                        ub0=-1;
                    end
                end
            end
            % recover save data before first branch
            f=false;
            p2=p0;
            q2=q0;
            ub=ub0;
            db=db0;
            nf=sum(fx);
            n2=n-nf;
            m2=sum(rem);
            Xd=X0;
            Dd=D0;
            Zd=Z0;
            Ed=E0;
        end
        if ~f   % terminal cases
            if m2==n2
                update(fx|rem);
            elseif ~n2
                update(fx);
            end
        end
    end

    function [ub,db]=downprune(ub,db)
        % downward pruning
        if ~downf 
            s0=fx|rem;
            id=p2==db;
            if sum(id)==1
                u=Ed(id,rem);
                x=u/Ed(id,id);
                NZ=Zd(:,rem)-Zd(:,id)*x;
                X=Ed(rem,rem)-u'*x;                
            else
                [R1,f]=chol(Y2(s0,s0));
                if f    % singular, hence prune
                    return
                end
                D=R1'\G(s0,:);
                [R,f]=chol(D'*D);
                if f    % singular, hence prune
                    return
                end
                R2=R1'\E(s0,rem);
                Gd=R1\D;
                Z=Gd(rem(s0),:)';
                NZ=R\(R'\Z);
                X=R2'*R2-Z'*NZ;
                if db<0
                    R1=R'\eye(n);
                    db=sum(sum(R1.*R1));
                end
            end
            Zd(:,rem)=NZ;
            Ed(rem,rem)=X;
            p2(rem)=db+sum(NZ.*NZ,1)./diag(X)';
            ops(2)=ops(2)+1;
            ops(3)=ops(3)+m2;
            downf=true;
        end
        L=p2>=bound;
        L(~rem)=false;
        if any(L)
            % perform downwards pruning
            if sum(L)==1 && upf
                ub=q2(L);
            else
                ub=-1;
            end
            upf=false;
            fx(L)=true;
            rem(L)=false;
            nf=sum(fx);
            m2=sum(rem);
            n2=n-nf;
        end
    end

    function [ub,db]=upprune(ub,db)
        % upwards pruning
        if ~upf
            id=ub==q2;
            if sum(id)==1
                u=Dd(rem,id);
                x=u/Dd(id,id);
                X2=Xd(rem,:)-x*Xd(id,:);
                D=Dd(rem,rem)-x*u';
            else
                [R1,f]=chol(G2(fx,fx));
                if f
                    return
                end
                R2=R1'\G2(fx,rem);
                X1=R1'\Y(fx,:);
                X2=Y(rem,:)-R2'*X1;
                D=G2(rem,rem)-R2'*R2;
                if ub<0
                    ub=sum(sum(X1.*X1));
                end
            end
            Xd(rem,:)=X2;
            Dd(rem,rem)=D;
            ops(2)=ops(2)+1;
            ops(3)=ops(3)+m2;
            q2(rem)=ub+sum(X2.*X2,2)./diag(D);
        end
%         r1=rem;
        q2(~rem)=0;
        L=q2>=bound;
        if any(L)
            % perform upwards pruning
            if sum(L)==1 && downf
                db=p2(L);
            else
                db=-1;
            end
            downf=false;
            rem(L)=false;
            m2=sum(rem);
            q2(L)=0;
        end
        upf=true;
    end

    function update(s)
        % terminal case to update bound
        [R,f]=chol(G2(s,s));
        if f
            return
        end
        X=R'\Y(s,:);
        ops(1)=ops(1)+1;
        lambda=sum(sum(X.*X));
        bf=lambda>bound;
        if ~bf,
            B(ib)=lambda;         %avoid sorting
            sset(ib,:)=find(s);
            [bound,ib]=max(B);
        end
    end
end
