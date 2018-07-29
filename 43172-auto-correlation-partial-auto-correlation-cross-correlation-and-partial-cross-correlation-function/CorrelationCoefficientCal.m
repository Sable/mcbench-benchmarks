function Y=CorrelationCoefficientCal(X,Y)
X=X-mean(X);
Y=Y-mean(Y);
Y=mean(X.*Y)/sqrt((var(X)*var(Y)));
end