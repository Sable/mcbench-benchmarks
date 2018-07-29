function result = CORREL(X,Y)
% Correlation coefficient between two vectors
c = corrcoef(X,Y);
result = c(1,2);