function [ AF ] = AutoCorrelationF( X,m )
AF=zeros(m,1);

for i=1:length(AF)
X1=X(1:end-i);
X1=X1-mean(X1);
    
X2=X(i+1:end);
X2=X2-mean(X2);
AF(i)=mean(X1.*X2)/sqrt((var(X1)*var(X2)));
end

end