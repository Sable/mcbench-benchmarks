function X=JumpDiffusionMerton(m,s,l,a,D,ts,J)

T=ts(end);
% simulate number of jumps; 
N=poissrnd(l*T,J,1);

Jumps=[];
L=length(ts);
for j=1:J
    % simulate jump arrival time
    t=T*rand(N(j),1);
    t=sort(t);

    % simulate jump size
    S=a+D*randn(N(j),1);
    
    % put things together
    CumS=cumsum(S);
    for n=1:L
        Events=sum(t<=ts(n));
        Jumps_ts(n)=0;
        if Events
            Jumps_ts(n)=CumS(Events);
        end
    end

    Jumps=[Jumps
        Jumps_ts];
end
for l=1:L
    Dt=ts(l);
    if l>1
        Dt=ts(l)-ts(l-1);
    end
    D_Diff(:,l)=m*Dt + s*sqrt(Dt)*randn(J,1);
end

X=[zeros(J,1) cumsum(D_Diff,2)+Jumps];