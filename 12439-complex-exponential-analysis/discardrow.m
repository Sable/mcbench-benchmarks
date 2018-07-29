function [Xprime] = discardrow(k, X)

if size(X,1) == 1
    Xprime = [];
    fprintf('\nYou cannot discard rows of a row vector.');
    return;
end

if k > size(X,1)
    fprintf('\nCannot loose column %d when X has only %d columns.', k, size(X,2));
    Xprime = [];
    return;
end

if k == 1
  Xprime = X(k+1:size(X,1),:);
elseif k == size(X,1)
  Xprime = X(1:k-1,:);
else 
  Xprime = [X(1:k-1,:); X(k+1:size(X,1),:)];
end
