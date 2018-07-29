function [x, itr] = ALH( x, f, g, G, H, Dg, Hg, e, k, eta)
%AUGMENTED_LAGRANGIAN
itr = 0;            		%initialize iteration counter
numV = length(x);           % number or variables
numC = size(g(x), 1);      % number of constraints / dual variables
y = zeros(numC, 1 );         %Lagrange multipliers

ALk = @(x)(f(x) - y'*g(x) + 0.5*k*(norm(g(x)))^2);  	% Augmented Lagrangian
DALk = @(x)(G(x) - Dg(x)*y + k*Dg(x)*g(x));         	% gradient of Augmented Lagrangian

%Hessian of Augmented Lagrangian
    function HA = HALk(x)
        HA = H(x)+ k*Dg(x)*Dg(x)';
        for i = 1:numC
            HA =  HA - Hg{i}(x)*y(i) + k*Hg{i}(x)*gi(i);                          % hessian of AL
        end
    end

while (norm(g(x)) >= e)
    gi = g(x);
    
    [x, nsteps] = newton(x, ALk, DALk, @HALk, e, eta, true);
    y = y - k * g(x);
    
    itr = itr + 1;
    fprintf( 'Iteration: %d Newton Steps: %d Constraint Violation: %s x: %s \n', itr, nsteps, num2str(g(x)'), num2str(x'));
end

fprintf('Augmented Langragian method\n');
fprintf('Number of Iterations:  %d\n', itr);
for i = 1:numV
    fprintf('x(%d):            %8.4f\n', i, x(i));
end
fprintf('f(x):            %8.4f\n', f(x));

fprintf('g(x):            %s\n', num2str(g(x)'));
fprintf('k:            %f\n', k);
end

function [x, itr] = newton(x, f, G, H, e, eta, isprint)
itr = 0;            %initialize iteration counter
numV = length(x);   % number or variables

%Computation loop
while norm(G(x)) > e
    % primal regularization
    lambda = 1e-5;
    [~,p] = chol((H(x) + lambda * eye(numV )));
    while p ~= 0
        lambda = 10 * lambda;
        [~,p] = chol((H(x) + lambda * eye(numV )));
    end
    
    dxs =  -((H(x) + lambda * eye(numV ))\G(x));
    alpha = 1;
    
    while ((f(x + alpha * dxs) - f(x)) >= eta * alpha * G(x)' *dxs);
        alpha = alpha/2;
    end
    
    x = x + alpha * dxs;
    itr = itr + 1;  %counter+1
    if isprint
        fprintf( 'Iteration: %d f(x): %f x: %s e: %f \n', itr, f(x), num2str(x'), e);
    end
end
end
