function [M_, S_] = Prior2Posterior(M, Q, M_Q, S, G, S_G)
% Compute posterior moments

if Q ~= 0
    M_= M + S*Q'*inv(Q*S*Q')*(M_Q-Q*M);
else 
    M_ = M;
end

if G ~= 0
    S_= S + (S*G')*( inv(G*S*G')*S_G*inv(G*S*G') -inv(G*S*G') )*(G*S);
else
    S_ = S;
end

end
