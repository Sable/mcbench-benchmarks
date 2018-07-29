function X = SynthMMV(Y, HforVec, err, normfac)

% Solves problem of the form:
% min ||X||_2,1 s.t. ||Y-HX|| < err

% Inputs
% Y - n x r observation vectors
% H - n x N projection operator
% err - error tolerance
% normfac - maximum eigenvalue of projection operator

% Outputs
% X - N x r input vectors to be recovered

% Converting input matrix to operator
explicitA = ~(ischar(HforVec) || isa(HforVec, 'function_handle'));
if (explicitA)
    HOp = opMatrix(HforVec); clear HforVec
else
    HOp = HforVec;
end

r = size(Y,2); % number of observations/inputs

H = opMatWrapper(HOp, r); % wrapper for handling matrix inputs

alpha = 1.05*(normfac^2);

X = H(Y,2); % Initialize X
N = size(X,1); % length of each input vector

maxIter = 100; % Define the maximum number of iterations
tol = 1e-4; % tolerance level
decfac = 0.5; % decrease factor for lambda

lambdaInit = decfac*max(max((abs(X)))); lambda = lambdaInit;

while lambda > lambdaInit*tol
    iter = 0;
    while iter < maxIter
        iter = iter + 1;
        for i = 1:N
            D(i,:) = (1/norm(X(i,:))).*abs(X(i,:));
        end
    
        B = X + (1/alpha)*H(Y-H(X,1),2);
    
        Xvec = SoftTh(B(:),(lambda/alpha).*D(:));
        X = reshape(Xvec,[N r]);
        
    end
    if norm(Y-H(X,1),'fro') < err
        break;
    end
    lambda = decfac*lambda;
end

    function  z = SoftTh(s,thld)
        z = sign(s).*max(0,abs(s)-thld); 
    end
end