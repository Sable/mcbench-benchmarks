clear all
syms a b c x
        % Rezolvarea primei ecuatii
sol1=solve(a*x^2+b*x+c)
pretty(sol1)
        % Rezolvarea ecuatiei a doua
sol2=solve('cos(2*x)+sin(x)=1')
        % Transformarea solutiei simbolice in numerica
numsol2=double(sol2)
        % Reprezentarea grafica a functiei pe intervalul dat
ezplot('cos(2*x)+sin(x)-1',[0, 2*pi])
hold on
grid
        % Marcarea solutiilor obtinute pe grafic
plot(numsol2,zeros(size(numsol2)),'rd')