function [acc,estimated]=sim_NN(W1,W2,b1,b2,X,t)
[L,Col]=size(X);
error=0;
estimated=zeros(1,Col);
for k=1:Col
    estimated(k)=W2*logsig(W1*X(:,k)+b1)+b2;
    estimated_aprox=sign(estimated(k));
    if not(estimated_aprox==t(k))
        error=error+1;
    end
end
acc=(Col-error)/Col;
