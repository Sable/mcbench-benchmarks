% Function to calculate Threshold for BayesShrink

function threshold=bayes(X,sigmahat)

len=length(X);
sigmay2=sum(X.^2)/len;
sigmax=sqrt(max(sigmay2-sigmahat^2,0));
if sigmax==0 threshold=max(abs(X));
else threshold=sigmahat^2/sigmax;
end

