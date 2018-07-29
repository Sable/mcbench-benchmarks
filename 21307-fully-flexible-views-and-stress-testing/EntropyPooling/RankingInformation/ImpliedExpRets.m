function M=ImpliedExpRets(S,w)

M_=S*w;

s=sqrt(mean(diag(S)));
M=M_/mean(M_)*.5*s;
