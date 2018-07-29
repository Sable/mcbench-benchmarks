clear all, clc
    % Desemnarea unor variabile simbolice
syms x
	% Generarea functiilor f, g si h, 
    % care sunt diferite exprimari ale aceluasi polinom
f=x^3-6*x^2+11*x-6;
g=(x-1)*(x-2)*(x-3);
h=x*(x*(x-6)+11)-6;
        % Afisarea celor trei functii
disp('Cele trei functii considerate')
pretty(f)
pretty(g)
pretty(h)
        % Simplificarea utilizand functia collect
disp('Simplificarea utilizand functia collect')
pretty(collect(g))
        % Simplificarea utilizand functia expand
disp('Simplificarea utilizand functia expand')
pretty(expand(h))
        % Simplificarea utilizand functia factor
disp('Simplificarea utilizand functia factor')
pretty(factor(f))
        % Simplificarea utilizand functia simplify
disp('Simplificarea utilizand functia simplify')
pretty(simplify(f))
        % Simplificarea utilizand functia simple
disp('Simplificarea utilizand functia simple')
pretty(simple(f))
pretty(simple(g))
pretty(simple(h))