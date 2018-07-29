function  [nodes, edges] = bnMsgPassSendPiMsg(Z, X, nodes, edges, A) 
%BNMSGPASSSENDPIMSG helper function for lungbayesdemo

% Reference: Neapolitan R., "Learning Bayesian Networks", Pearson Prentice Hall,
% Upper Saddle River, New Jersey, 2004.


childrenZ = nodes(Z).children;
childrenZ = setdiff(childrenZ, X);

for z = 1:length(nodes(Z).values) % for each values of z
    v = nodes(Z).peye(z);
    for y = 1:length(childrenZ)
        v = v * edges(Z, childrenZ(y)).lambdaX(z);
    end
    edges(Z,X).peyeX(z) = v;

end

parentsX = nodes(X).parents;
if isempty(intersect(A,X))
     
    w = 1;
    for pa = 1:length(parentsX) % for each parent of X
        w = kron(edges(parentsX(pa),X).peyeX, w); % need peyeX as a row
    end
    
    prob = shiftdim(nodes(X).CPT, length(size(nodes(X).CPT))-1); % so that x is the first dimension in prob
    for x = 1:length(nodes(X).values)
        nodes(X).peye(x) = prob(x,:) * w'; % % consider P(x | ... )
    end
    nodes(X).P = nodes(X).lambda .* nodes(X).peye;
    nodes(X).P = nodes(X).P ./ sum(nodes(X).P); % normalize
    
    childrenX = nodes(X).children;
    for cx = 1:length(childrenX)
        nodes = bnMsgPassSendPiMsg(X, childrenX(cx), nodes, edges, A);
    end
end

if any(nodes(X).lambda ~= 1)
  W = setdiff(parentsX, union(A,Z));
  for w = 1:length(W)
      [nodes, edges] = bnMsgPassSendLambdaMsg(X, W(w), nodes, edges, A);
  end
end