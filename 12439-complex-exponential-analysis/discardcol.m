function [Xprime] = discardcol(k, X)

if size(X,2) == 1
    Xprime = [];
    fprintf('\nYou cannot discard columns of a column vector.');
    return;
end

if k > size(X,2)
    fprintf('\nCannot loose column %d when X has only %d columns.', k, size(X,2));
    Xprime = [];
    return;
end

if k == 1
  Xprime = X(:,k+1:size(X,2));
elseif k == size(X,2)
  Xprime = X(:,1:k-1);
else 
  Xprime = [X(:,1:k-1) X(:,k+1:size(X,2))];
end
