function LL = LogLik(x,Nu,Sigma)

InvS=inv(Sigma);
N=size(x,2);

Norm=-N/2*log(Nu*pi) + log(gamma((Nu+N)/2)) - log(gamma(Nu/2)) - 1/2*log(det(Sigma));

LL=0;
for t=1:size(x,1)
    Ma2 = x(t,:)*InvS*x(t,:)';
    LL = LL + Norm - (Nu+N)/2 * log(1+Ma2/Nu);
end