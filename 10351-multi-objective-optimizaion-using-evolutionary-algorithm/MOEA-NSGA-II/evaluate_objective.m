function f = evaluate_objective(x,problem)

% Function to evaluate the objective functions for the given input vector
% x. x has the decision variables

switch problem
    case 1
        f = [];
        %% Objective function one
        f(1) = 1 - exp(-4*x(1))*(sin(6*pi*x(1)))^6;
        sum = 0;
        for i = 2 : 6
            sum = sum + x(i)/4;
        end
        %% Intermediate function
        g_x = 1 + 9*(sum)^(0.25);
        %% Objective function one
        f(2) = g_x*(1 - ((f(1))/(g_x))^2);
    case 2
        f = [];
        %% Intermediate function
        g_x = 0;
        for i = 3 : 12
            g_x = g_x + (x(i) - 0.5)^2;
        end
        %% Objective function one
        f(1) = (1 + g_x)*cos(0.5*pi*x(1))*cos(0.5*pi*x(2));
        %% Objective function two
        f(2) = (1 + g_x)*cos(0.5*pi*x(1))*sin(0.5*pi*x(2));       
        %% Objective function three
        f(3) = (1 + g_x)*sin(0.5*pi*x(1));
end
