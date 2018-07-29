function X=VG(m,s,kappa,ts,J)

T=length(ts);
dXs=zeros(J,1);
for t=1:T
    dt=ts(1)-0;
    if t>1
        dt=ts(t)-ts(t-1);
    end
    d_tau=kappa*gamrnd(dt/kappa,1,J,1);
    dX=normrnd(m*d_tau,s*sqrt(d_tau));

    dXs=[dXs dX];
end
X=cumsum(dXs,2);

