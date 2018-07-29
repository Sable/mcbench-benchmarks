function g = sigmoid(z)

% Computes sigmoid of z

g = 1.0 ./ (1.0 + exp(-z));
