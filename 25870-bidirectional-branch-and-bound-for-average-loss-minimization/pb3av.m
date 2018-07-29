function [B,sset,ops,ctime,flag]=pb3av(G1,Gd1,Wd,Wn,Juu,Jud,n,tlimit,nc)
% PB3AV Partial Bidirectional Branch and Bound (PB3) for Average Loss Criterion 
%
%   [B,sset,ops,ctime,flag] = pb3av(G1,Gd1,Wd,Wn,Juu,Jud,n,tlimit,nc) is an
%   implementation of PB3 algorithm to select measurements, whose 
%   combinations can be used as controlled variables. The measurements are 
%   selected to provide minimum average loss in terms of self-optimizing
%   control based on the following static optimization problem:
%
%       min J = f(y,u,d)
%       s.t.
%           y = G1 * u + G_d1 * Wd * d + Wn * e
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
%   n is the number of measurements to be selected, nu <= n <= ny.
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
%  42(14):3273-3284, 2003.  
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

% Example.
%{
ny=40;
nu=15;
nd=5;
[G,Gd,Wd,Wn,Juu,Jud] = randcase(ny,nu,nd);
[B,sset,ops,ctime] = pb3av(G,Gd,Wd,Wn,Juu,Jud,25);
% It takes about 4 seconds
%}

% Default inputs and outputs
    flag=false;
    if nargin<9
        nc=1;
    end
    if nargin<8
        tlimit=Inf;
    end
    ctime0=cputime;
    [r,m] = size(G1);
    if nargin<7
        n=m;
    end
    if n<m
        error('n must larger than number of inputs.')
    end
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
    % initialize flags
    f=false;
    bf=false;
    downf=false;
    upf=false;
    upff=m>=n2;
    E=eye(r);
    Gd=G;
    D=chol(Y2)'\G;
    D=chol(D'*D);
    b0=trace(D\(D'\eye(m)));
    Ed=zeros(r);
    Zd=G';
    % the recursive solver
    bbavsub(fx,rem,b0);
    % convert bound to loss
    [B,idx]=sort(B/(6*(size(Wd,2)+n)));
    sset=sort(sset(idx,:),2);
    ctime=cputime-ctime0;
    
    function bf0=bbavsub(fx0,rem0,b0)
        % recursive solver
        bf0=m;
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
        while ~f && m2>n2 && n2>=0  % Loop for second branchs
            while ~f && m2>n2 && n2>0 && (~downf || ~upf || ~bf)
                % Loop for bidirection pruning
                if (~upf || ~bf) && n2 <= m %&& bound < Inf
                    % upwards pruning
                    b0=upprune(b0);
                else
                    upf=true;
                end
                if ~f &&  m2>n2 && m2>0 && (~downf || ~bf)
                    % downwards pruning
                    b0=downprune(b0);
                end
                bf=true;
            end %pruning loop
            if f || m2<n2 || n2<0
                % pruned cases
                return
            elseif m2==n2 || ~n2
                % terminal cases
                break
            end
            if m2-n2==1     % one more element to be removed
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
            if n2==1,   % one more element to be fixed
                if upff
                    q2(~rem)=0;
                    [b,idk]=max(q2);
                else
                    p2(~rem)=Inf;
                    [b,idk]=min(p2);
                end
                s=fx;
                s(idk)=true;
                bf0=update(s)+1;
                if bf0<0
                    return;
                end
                rem(idk)=false;
                m2=m2-1;
                downf=false;
                upf=true;
                b0=p2(idk);
                continue
            end
            % save data for bidirectional branching
            fx1=fx;
            rem1=rem;
            b1=bound;
            p0=p2;
            q0=q2;
            n20=n2;
            bb=b0;
            upff0=upff;
            Z0=Zd;
            E0=Ed;
            if n2<0.8*m2    %upward branching
                p2(~rem)=0;
                [b,id]=max(p2);
                fx(id)=true;
                rem1(id)=false;
                upf=false;
                upff=false;
                bf0=bbavsub(fx,rem1,b0)+n20;
                if p0(id)>=bound
                    return
                end
                if bf0<0
                    return
                end
                downf=false;
                upf=true;
                upff=upff0;
                bb=p0(id);
            else            % downward branching
                p2(~rem)=Inf;
                [b,id]=min(p2);
                fx1(id)=true;
                downf=false;
                rem1(id)=false;
                bf0=bbavsub(fx,rem1,b)+n20;
                if upff0 && q2(id)>=bound
                    return
                end
                downf=true;
                upf=false;
                upff=false;
                if bf0<0
                    return
                end
            end
            fx=fx1;
            rem=rem1;
            % check pruning conditions
            if b1>bound
                bf=false;
                p0(~rem)=0;
                L2=p0'>=bound;
                if any(L2)
                    rem=rem&~L2;
                    fx=fx|L2;
                end
                if upff0
                    q0(~rem)=0;
                    L2=q0'>=bound;
                    if any(L2)
                        rem=rem&~L2;
                        if sum(L2)==1
                            bb=p0(L2);
                        else
                            bb=-1;
                        end
                    end
                end
            end
            % Recover data saved before the first branch
            f=false;
            p2=p0;
            q2=q0;
            nf=sum(fx);
            n2=n-nf;
            m2=sum(rem);
            b0=bb;
            Ed=E0;
            Zd=Z0;
        end
        if ~f       % terminal cases
            if m2==n2
                bf0=update(fx|rem);
            elseif ~n2
                bf0=update(fx);
            end
        end
    end

    function b0=upprune(b0)
        % Partially upwards pruning
        if ~upf
            upf=true;
            R1=chol(Y2(fx,fx));     % nf x nf
            X1=R1'\G(fx,:);         % nf x m
            D=X1'*X1;               % m x m
            tD=sort(eig(D),'descend');
            ops(2)=ops(2)+1;
            k1=(m-n2+1);
            x=sum(tD(1:k1));
            k2=k1*k1;
            if k2<=x*bound
                upff=false;
                return
            end
            bf0=sum(cumsum(1./tD)<bound);
            if bf0<m-n2           % current node is not optimal
                f=true;
                return
            end
            if bf0>m-n2+1          % no any sub-node pruning
                upff=false;
                return
            end
            ops(3)=ops(3)+m2;
            Z=R1'\Y2(fx,rem);
            X2=X1'*Z-G(rem,:)';
            eta=diag(Y2(rem,rem))'-sum(Z.*Z,1);
            q2(rem)=k2./(x+sum(X2.*X2,1)./eta);
            upff=true;
        end
        if upff
            L=q2>=bound;
            L(~rem)=false;
            if any(L)
                downf=false;
                rem(L)=false;
                m2=sum(rem);
                if sum(L)==1
                    b0=p2(L);
                else
                    b0=-1;
                end
            end
        end
    end

    function b0=downprune(b0)
        % downwards pruning
        if ~downf
            s0=fx|rem;
            id=p2==b0;
            if sum(id)==1
                u=Ed(id,rem);
                x=u/Ed(id,id);
                NZ=Zd(:,rem)-Zd(:,id)*x;
                X=Ed(rem,rem)-u'*x;                
            else
                R1=chol(Y2(s0,s0));
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
                if b0<0
                    R1=R'\eye(m);
                    b0=sum(sum(R1.*R1));
                end
            end
            Zd(:,rem)=NZ;
            Ed(rem,rem)=X;
            p2(rem)=b0+sum(NZ.*NZ,1)./diag(X)';
            ops(2)=ops(2)+1;
            ops(3)=ops(3)+m2;
            downf=true;
        end
        L=p2>=bound;
        L(~rem)=false;
        if any(L)
            upf=false;
            upff=false;
            fx(L)=true;
            rem(L)=false;
            nf=sum(fx);
            m2=sum(rem);
            n2=n-nf;
        end
    end

    function bf0=update(s)
        X=chol(Y2(s,s))'\G(s,:);
        tD=cumsum(1./sort(eig(X'*X),'descend'));
        bf0=sum(tD<bound)-m;
        bf=bf0<0;
        ops(1)=ops(1)+1;
        if ~bf,
            B(ib)=tD(end);         %avoid sorting
            sset(ib,:)=find(s);
            [bound,ib]=max(B);
        end
    end
end
