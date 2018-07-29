% This M-file demonstates the use of the function  'min_by_random_search'
% type:  help min_by_random_search for more information
%
% In this example the target function is two-dimensional,
% and has multiple local minima.

% set search region
%             x        y
region = [1       -2 ;      % min
                7        5];       % max

% call minimization function
vopt = min_by_random_search( ...
    @min_by_random_search_test_func, region )

%%% display the optimal solution
close all;
x = region(1,1) : 0.1: region(2,1);
y = region(1,2) : 0.1: region(2,2);
inmat = [];
for ii = 1:length(x)
    for jj = 1:length(y)
        v = [x(ii) ; y(jj)];
        inmat = [inmat , v];
    end
end
Z = min_by_random_search_test_func(inmat);
Zmat = reshape(Z, length(y), length(x));
[C,h] = contour(x,y,Zmat,15);
set(h,'ShowText','on','TextStep',get(h,'LevelStep'))
colorbar;
hold on;
plot(vopt(1),vopt(2),'rx','linewidth',20);
xlabel('x');
ylabel('y');

clc;
'Minimum point at:'
x_opt = vopt(1)
y_opt = vopt(2)
