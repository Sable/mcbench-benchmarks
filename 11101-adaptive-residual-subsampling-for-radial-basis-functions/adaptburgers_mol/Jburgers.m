function J = Jburgers(t,u,epsilon,D1,D2)
% Jacobian
J = epsilon*D2 - (diag(D1*u) + repmat(u,1,length(u)).*D1);