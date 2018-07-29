function [m,S]=DoubleDecay(X,lmd_c,lmd_s)

[T,N]=size(X);
m=zeros(N,1);

p_c=exp(-lmd_c*(T-(1:T)'));
p_c=repmat( p_c/sum(p_c),1,N);
S_1=(p_c.*X)'*X;
C = corrcov(S_1);

p_s=exp(-lmd_s*(T-(1:T)'));
p_s=repmat( p_s/sum(p_s),1,N);
S_2=(p_s.*X)'*X;
[R,s] = corrcov(S_2);

S=diag(s)*C*diag(s);

