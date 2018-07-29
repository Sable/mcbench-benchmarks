function [p_, KLdiv, exitflag] = optimizeEntropy(p, A, b, Aeq, beq, options)

% number of inequality constraints
K_ = size(A, 1);
% number of equality constraints
K  = size(Aeq, 1);
A_ = A';
%b_ = b';
Aeq_ = Aeq';
beq_ = beq';
x0   = zeros(K_ + K, 1);
InqMat = -eye(K_ + K); 
InqMat(K_ + 1:end, :) = [];
InqVec = zeros(K_, 1);

lnp = log(p);

% uses analytic gradient and Hessian during optimization
if nargin < 6
    options = optimset(... 
        'Display', 'iter', ... 
        'GradObj', 'on', ... 
        'Hessian', 'on', ...
        'TolFun', 1e-10, ... 
        'TolX', 1e-10, ... 
        'TolCon', 1e-10, ... 
        'MaxFunEvals', 5000, ... 
        'MaxIter', 5000);
end
    
% minimize negative Lagrange function (i.e. maximize Lagrange function)
if ~K_
    % equality constraints only
    [v, dummy, exitflag] = fminunc(@nestedfunU, x0, options);
    if exitflag > 0
        lnp_ = lnp - 1 - Aeq_ * v;
    else
        lnp_ = lnp;
    end
else
    % inequality (and equality) constraints
    [lv, dummy, exitflag] = fmincon(@nestedfunC, x0, InqMat, InqVec, [], [], [], [], [], options);
    if exitflag > 0
        % inequality Lagrange multipliers
        l = lv(1:K_);
        % equality Lagrange multipliers
        v = lv(K_ + 1:end);
        lnp_ = lnp - 1 - A_ * l - Aeq_ * v;
    else
        lnp_ = lnp;
    end
end

p_ = exp(lnp_);

if nargout > 1
    if exitflag > 0
        KLdiv = p_' * (lnp_ - lnp);
    else
        KLdiv = NaN;
    end
end

    % sub-function -- equality case
    function [mL, g, H] = nestedfunU(v)
        lnx = lnp - 1 - Aeq_ * v;
        % robustificaton
        lnx = max(lnx, -150.0); 
        x = exp(lnx);   
        % Lagrange dual function
        L = x' * (lnx - lnp + Aeq_ * v) - beq_ * v; 
        % take neg values since we want to maximize
        mL = -L;
        
        % gradient and Hessian
        g = beq - Aeq * x;    
        H = Aeq * ((x * ones(1, K)) .* Aeq_);
    end

    % sub-function -- inequality case
    function [mL, g, H] = nestedfunC(lv)
        % inequality Lagrange multiplier
        l = lv(1:K_); 
        % equality Lagrange multiplier
        v = lv(K_ + 1:end); 
        lnx = lnp - 1 - A_ * l - Aeq_ * v;
        % robustification
        lnx = max(lnx, -150.0); 
        x = exp(lnx);
        % Lagrange dual function
        L = x' * (lnx - lnp) + l' * (A * x - b) + v' * (Aeq * x - beq);
        % take neg values since we want to maximize
        mL = -L; 
    
        % gradient and Hessian
        g = [b - A * x; beq - Aeq * x];    
        H = [A * ((x * ones(1, K_)) .* A_), A * ((x * ones(1, K)) .* Aeq_);...
            Aeq * ((x * ones(1, K_)) .* A_), Aeq * ((x * ones(1, K)) .* Aeq_)];  
    end
end
