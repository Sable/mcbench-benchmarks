function X=MergeMargCop(W,F,U)

[J,K]=size(W);
X=0*U;
for k=1:K
    dd = interp1(F(:,k),W(:,k),U(:,k),'linear','extrap');
    X(:,k) = dd;
end
