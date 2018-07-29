function X=NIG(th,k,s,ts,J)

T=length(ts);
DXs=zeros(J,1);
for t=1:T
    Dt=ts(1)-0;
    if t>1
        Dt=ts(t)-ts(t-1);
    end
    l=1/k*(Dt^2);
    m=Dt;
    DS=IG(l,m,J);
    N=randn(J,1);
    
    DX=s*N.*sqrt(DS)+th*DS;
    DXs=[DXs DX];
end
X=cumsum(DXs,2);

