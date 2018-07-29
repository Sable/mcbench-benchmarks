function beta = l1plusTV(H, Ht, A, At, y, sizeImage, TVlambda, p, normfac, err, insweep, decfac, tol)

% Algorithm for solving problems of the form:
% min ||x||_p + TVlambda*TV(A'x)s.t. ||y-Hx||_2 < err

% Inputs
% H - Forward Measurement Operator
% Ht - Backward Measurement Operator
% A - Sparsifying Forward Transform
% At - Sparsifying Backward Transform
% y - collected data
% sizeImage - size of Image matrix
% TVlambda - multiplication factor for TV norm
% p - non-convex norm (default 1)
% normfac - highest singular value of A (default 1)
% err - two norm mismatch (default 1e-6)
% insweep - number of sweeps for internal loop (default 50)
% decfac - lambda decrease factor for outside loop (default 0.5)
% tol - tolerance for convergence (default 1e-4)

% copyright (c) Angshul Majumdar 2010

N = sizeImage;
c = 4;

if nargin < 9
    p = 1;
end
if nargin < 10
    normfac = 1;
end
if nargin < 11
    err = 1e-6;
end
if nargin < 12
    insweep = 50;
end
if nargin < 13
    decfac = 0.5;
end
if nargin < 14
    tol = 1e-4;
end

alpha = 1.1*normfac;
x_initial = Ht(y);
z_initial = zeros(length(TV(x_initial)),1);

x = x_initial; z = z_initial;

lambdaInit = decfac*max(abs(Ht(y))); lambda = lambdaInit;

f_current = norm(y-H(x_initial)) + lambda*norm(x,p) + TVlambda*norm(TV(At(x)),1);

while lambda > lambdaInit*tol
    lambda
    for i = 1:insweep
        f_previous = f_current;
        
        Wtilde = abs(x).^(p-2);
        W = 1 + (lambda/2)*Wtilde;

        b = x + (1/alpha)*(Ht(y-H(x)));
        btilde = (1./sqrt(W)).*b;
        z = (c*z + weightedTV(b-weightedTVtrans(z)))./((2*alpha/TVlambda)*(abs(weightedTV(x))).^(2-p)+c);
        x = 1./sqrt(W).*btilde - (1./sqrt(W)).*weightedTVtrans(z);
        
        f_current = norm(y-H(x_initial)) + lambda*norm(x,p) + TVlambda*norm(TV(x),1);
        
        if norm(f_current-f_previous)/norm(f_current + f_previous)<tol
            break;
        end
    end
    if norm(y-H(x))<err
        break;
    end
    lambda = decfac*lambda;
end
beta = x;

%%%%%% Functions for computing TV and TVtranspose %%%%%%%

    function wFvec = weightedTV(Xvec)
        wFvec = TV((1./sqrt(W)).*Xvec);
    end

    function wXvec = weightedTVtrans(Fvec)
        wXvec = (1./sqrt(W)).*TVtrans(Fvec);
    end

    function Fvec = TV(Xvec)
        Ivec = At(Xvec); % image pixels
        X = reshape(Ivec,N(1),N(2)); % sparse transform coefficients
        
        FX = zeros(N);
        FY = zeros(N);
        
        FX(1:end-1,:) = diff(X);
        FY(:,1:end-1) = diff(X')';
        
        Fvec = [FX(:)' FY(:)']';
    end

    function Xvec = TVtrans(Fvec)
        FX = reshape(Fvec(1:end/2),N(1),N(2));
        FY = reshape(Fvec(1+end/2:end),N(1),N(2));

        DX = zeros(N(1)+1,N(2));
        DY = zeros(N(1),N(2)+1);
        DX(2:end-1,:) = FX(1:end-1,:);
        DY(:,2:end-1) = FY(:,1:end-1);
        
        XT = -diff(DX);
        YT = -diff(DY')';
                
        X = XT + YT; % image
        Xvec = A(X(:));
    end
end