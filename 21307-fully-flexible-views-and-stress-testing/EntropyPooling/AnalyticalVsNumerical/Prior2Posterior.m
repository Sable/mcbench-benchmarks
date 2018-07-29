function [M_, S_]=Prior2Posterior(M,Q,M_Q,S,G,S_G)

M_=M+S*Q'*inv(Q*S*Q')*(M_Q-Q*M);
S_=S+(S*G')*( inv(G*S*G')*S_G*inv(G*S*G') -inv(G*S*G') )*(G*S);
