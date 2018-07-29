function [nodes, edges, A, ahat] = bnMsgPassNetUpdate(nodes, edges, A, ahat, V, vhat)
% BNMSGPASSUPDATE helper function for lungbayesdemo

% Reference: Neapolitan R., "Learning Bayesian Networks", Pearson Prentice Hall,
% Upper Saddle River, New Jersey, 2004.


A = union(A, V);
ahat = union(ahat, vhat);

for v = 1:length(nodes(V).values) % for each node value
    if v ~= vhat
        nodes(V).lambda(v) = 0;
        nodes(V).peye(v) = 0;
        nodes(V).P(v) = 0;
    else
        nodes(V).lambda(vhat) = 1;
        nodes(V).peye(vhat) = 1;
        nodes(V).P(vhat) = 1;
    end
end

Z = nodes(V).parents;
Z = setdiff(Z,A);
for pa = 1:length(Z)
    [nodes, edges] = bnMsgPassSendLambdaMsg(V, Z(pa), nodes, edges, A);
end

childrenV = nodes(V).children;

for cv = 1:length(childrenV)
    [nodes, edges] = bnMsgPassSendPiMsg(V,childrenV(cv), nodes, edges, A);
end
