function y = simple_fitness(x)
y = 100*(x(1)^2 - x(2))^2 + (1 - x(3))^2 + abs(0.4 - x(2));
