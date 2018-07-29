function X = UnconAnaMMV(Y, HforVec, AforVec, err, lambda, Hnormfac, Anormfac)

% Solves problem of the form:
% min ||Y-HX|| + lambda*||AX||_2,1

% Inputs
% Y - n x r observation vectors
% Hforvec - n x N measurement operator
% Aforvec - M X N sparsifyng operator
% err - error tolerance
% lambda - lagrangian multiplier
% Hnormfac - maximum eigenvalue of H
% Anormfac - maximum eigenvalue of A

% Outputs
% X - N x r input vectors to be recovered

% Converting input measurement matrix to operator
explicitH = ~(ischar(HforVec) || isa(HforVec, 'function_handle'));
if (explicitH)
    HOp = opMatrix(HforVec); clear HforVec
else
    HOp = HforVec;
end
% Converting input sparsifying matrix to operator
explicitA = ~(ischar(AforVec) || isa(AforVec, 'function_handle'));
if (explicitA)
    AOp = opMatrix(AforVec); clear HforVec
else
    AOp = AforVec;
end

r = size(Y,2); % number of observations/inputs

H = opMatWrapper(HOp, r); % wrapper for handling matrix inputs
A = opMatWrapper(AOp, r); % wrapper for handling matrix inputs

alpha = 1.05*(Hnormfac^2);
c = 1.05*(Anormfac^2);

X = H(Y,2); % Initialize X
Z = A(X,1).*0; % Initialize Z
N = size(X,1); % length of each input vector
M = size(Z,1); % length of transform domain sparse vector

maxIter = 250; % Define the maximum number of iterations

iter = 0;
while iter < maxIter
    iter = iter + 1;
    
    W = A(X,1);
    for i = 1:M
        D(i,:) = (1/norm(W(i,:)));
    end
    
    B = X + (1/alpha)*H(Y-H(X,1),2);
    Z = diag(1./((alpha/lambda)*(1./D) + c))*(c*Z + A(B - A(Z,2),1));
    X = B - A(Z,2);
    
    if norm(Y-H(X,1),'fro') < err
        break;
    end
end

end