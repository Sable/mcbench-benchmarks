function [X,Y,Z]=elipsod0(lambda,theta,eta)
% [X,Y,Z]=elipsod0(lambda,theta,eta)
% defines ellipsoidal coordinates
%b=1; c=2*b; b2=b^2; c2=c^2; cb=c2-b2;
X=eta.*theta.*lambda/2; 
Y=real(sqrt((eta.^2-1).*(theta.^2-1).*...
    (1-lambda.^2)/3));
Z=real(sqrt((eta.^2-4).*(4-theta.^2).*...
     (4-lambda.^2)/12)); 