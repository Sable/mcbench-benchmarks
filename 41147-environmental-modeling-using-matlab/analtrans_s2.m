% Steady state transport solutions for one fixed value of Da1 and various values of Pe 
x = [0:0.01:1];
Da1 = 1; 
c = exp(-Da1*x);
for Pe = [10 5 4 3 2 1 0.5 0.25];
    s = sqrt(0.25*Pe*Pe+Pe/Da1);
    mu1 = 0.5*Pe+s; mu2 = 0.5*Pe-s;
    s = mu2*exp(mu2)-mu1*exp(mu1);
    c = [c;(mu2*exp(mu2)*exp(mu1*x)-mu1*exp(mu1)*exp(mu2*x))./s];
end
plot (x,c);
legend('Pe=Inf','Pe=10','Pe=5','Pe=4','Pe=3','Pe=2','Pe=1','Pe=0.5','Pe=0.25');
xlabel ('x/L [-]'); ylabel ('c/c_{in} [-]');
