function [x, itr] = newton_constrained(x, f, g, G, H, Dg, Hg, e, ~, ~)
%Constrained Newtion

itr = 0;            %initialize iteration counter
eta = .1;

numV = length(x);           % number or variables
numC = size(g(x),1);        % number of constraints / dual variables

stopVal = inf;            	%stopping value
y = zeros(numC, 1 );        %Lagrange multipliers

%Computation loop
while norm(stopVal) > e
    
    %Langragian
    gi = g(x);
    L = f(x) - gi(1)* y(1);
    for i = 2:numC
        L =  L - gi(i)* y(i) ;
    end
    
    %Hessian of the Langragian
    HL = H(x) - Hg{1}(x)* y(1);
    for i = 2:numC
        HL =  HL - Hg{i}(x)* y(i) ;
    end
    
    % primal regularization
    lambda = 1e-5;
    [~,p] = chol(HL);
    while p ~= 0
        lambda = 10 * lambda;
        [~,p] = chol((HL + lambda * eye(numV)));
        HL = HL + lambda * eye(numV);
    end
    
    % dual regularization
    beta = eps;
    while ( rank(Dg(x)) ~= numC )
        beta = beta * 10;
    end
    
    dx_dy = ([HL, -Dg(x) ; Dg(x)', beta*eye( numC)])\([ -G(x) + Dg(x) * y ; -g(x)]);
    
    %use Armijo rule for choosing the step size
    alpha = 1;
    
    x = x + alpha*dx_dy(1:numV);
    y = y + alpha*dx_dy(numV+1:end);
    
    stopVal = G(x) - Dg(x) * y;		%stopping value
    itr = itr+1;                                                      %counter+1
    fprintf( 'Iteration: %d Norm Lagragian: %f Constraint Violation: %s f(x): %f x: %s\n', itr, norm(L), num2str(g(x)'), f(x), num2str(x'));
    
end

fprintf('Modified Newton’s method\n');
fprintf('Number of Iterations:  %d\n', itr);
for i = 1:numV
    fprintf('x(%d):            %8.4f\n', i, x(i));
end
fprintf('f(x):            %8.4f\n', f(x));

fprintf('g(x):            %s\n', num2str(g(x)'));

end

