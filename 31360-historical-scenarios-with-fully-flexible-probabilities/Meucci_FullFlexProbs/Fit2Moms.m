function p=Fit2Moms(X,m,S)
% This script uses Entropy Pooling to compute a double-decay covariance matrix, as described in  
% A. Meucci, "Personalized Risk Management: Historical Scenarios with Fully Flexible Probabilities"
% GARP Risk Professional, Dec 2010, p 47-51
% 
%  Most recent version of article and code available at
%  http://www.symmys.com/node/150

[T,N]=size(X);
Aeq = ones(1,T);  % constrain probabilities to sum to one...
beq=1;
Aeq = [Aeq   % ...constrain the first moments...
    X'];
beq=[beq
    m];
SecMom=S+m*m';  % ...constrain the second moments...
for k=1:N
    for l=k:N
        Aeq = [Aeq
            (X(:,k).*X(:,l))'];
        beq=[beq
            SecMom(k,l)];
    end
end
p_0=ones(T,1)/T;
p = EntropyProg(p_0,[],[],Aeq ,beq); % ...compute posterior probabilities


