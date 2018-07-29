function [nodes, edges] = bnMsgPassSendLambdaMsg(Y, X, nodes, edges, A)
% BNMSGPASSSENDLAMBDAMSG helper function for lungbayesdemo

% Reference: Neapolitan R., "Learning Bayesian Networks", Pearson Prentice Hall,
% Upper Saddle River, New Jersey, 2004.

childrenX = nodes(X).children;
parentsY = nodes(Y).parents;
myx = find(parentsY == X); % dimension associated with X in the probabilities among all the parents of Y
parentsY = setdiff(parentsY, X);

 
for x = 1:length(nodes(X).values)
   t = [];
    w = 1;
    for k = 1:length(parentsY)
        w = kron(edges(parentsY(k),Y).peyeX, w); % assume peyeX is a row
    end
    
    s = size(nodes(Y).CPT);
    if size(s) > 2
        prob = shiftdim(nodes(Y).CPT, length(s)-1); % so that y is in the first dim
    else
        prob = nodes(Y).CPT;
    end
    
    for y = 1:length(nodes(Y).values)
         
         if size(s)> 2 % there are more than 2 dimensions
             temp = prob(y,:); % fix for value y
             temp = reshape(temp, s(1:end-1)); % reshape as it was before fixing the value y
             temp = shiftdim(temp, myx-1); % so that x is in the first dimension
             t(y,:) = temp(x,:);
         else
            t(y,:) = prob(x,y);
         end
    
         
    end
    
    edges(X,Y).lambdaX(x) = sum(nodes(Y).lambda * t * w');

    c = 1;
    for u = 1:length(childrenX)
        c = c * edges(X, childrenX(u)).lambdaX(x);
    end
    nodes(X).lambda(x) = c;
    nodes(X).P(x) = nodes(X).lambda(x) * nodes(X).peye(x); %TODO ALPHA
end
  
nodes(X).P = nodes(X).P ./ sum(nodes(X).P); % normalize

Z = nodes(X).parents;
Z = setdiff(Z,A);
for z = 1:length(Z)
    [nodes, edges] = bnMsgPassSendLambdaMsg(X, Z(z), nodes, edges, A);
end

childrenX = setdiff(childrenX, Y);
for cx = 1: length(childrenX)
   [nodes, edges] = bnMsgPassSendPiMsg(X, childrenX(cx), nodes, edges, A);
end

