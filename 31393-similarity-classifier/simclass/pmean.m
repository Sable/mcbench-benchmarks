function y = pmean(x,p)

%calculates generalized mean
y = (sum(x.^p,1)/size(x,1)).^(1/p);

