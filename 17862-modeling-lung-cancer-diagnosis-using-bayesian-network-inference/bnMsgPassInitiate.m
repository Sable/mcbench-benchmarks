function [nodes, edges] = bnMsgPassInitiate(nodes, edges, root)
% BNMSGPASSINITIATE helper function for lungbayesdemo

% Reference: Neapolitan R., "Learning Bayesian Networks", Pearson Prentice Hall,
% Upper Saddle River, New Jersey, 2004.

N = numel(nodes);

for X = 1:N % for every node
    
    nodes(X).lambda = repmat(1, 1, length(nodes(X).values)); % l(x) = 1

    Z = nodes(X).parents;
    for pa = 1:length(Z) % for each parent of X
        edges(Z(pa),X).lambdaX = ones(1, length(nodes(Z(pa)).values)); % lX(z) = 1
    end  
    
    Y = nodes(X).children;
    for ch = 1:length(Y) % for each child of X
        edges(X,Y(ch)).peyeX = ones(1, length(nodes(X).values)); % peyeY(x)
    end
    
end

numRoots = length(root);
for rr = 1:numRoots
    for r = 1:length(nodes(root(rr)).values)
        nodes(root(rr)).peye(r) = nodes(root(rr)).CPT(r);
        nodes(root(rr)).P(r) = nodes(root(rr)).CPT(r);
    end
    childrenR = nodes(root(rr)).children;
    for cr = 1:length(childrenR)
        [nodes, edges] = bnMsgPassSendPiMsg(root(rr), childrenR(cr), nodes, edges, []); %A = []
    end
end



