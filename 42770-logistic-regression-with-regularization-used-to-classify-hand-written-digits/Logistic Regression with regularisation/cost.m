function [J, grad] = cost(theta, X, y, lambda)

% Computes the cost of usingtheta as the parameter for regularized 
% logistic regression and the gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples
J = 0;
grad = zeros(size(theta));

% Compute cost function
templog(:,1) = log(sigmoid(X*theta));
templog(:,2) = log(1-(sigmoid(X*theta)));
tempy(:,1) = y;
tempy(:,2) = 1-y;
temp = templog.*tempy;

% Formula for cost function. Note theta0 not involved in reglarization
J = (1/m)*(-sum(temp(:,1))-sum(temp(:,2))) + ...
    (lambda/(2*m))*sum(theta(2:end,1).^2);

% Compute gradient 
% theta0 not calclated with regularization
grad(1,1) = (1/m)*sum((sigmoid(X*theta)-y).*X(:,1)); 
grad(2:end,1)=((1/m)*((sigmoid(X*theta)-y)'*X(:,2:end)))'+(lambda/m)*theta(2:end);

grad = grad(:);