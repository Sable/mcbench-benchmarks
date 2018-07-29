% Steady state transport solutions for one fixed value of Da2 and various values of Pe
x = [0:0.01:1];
Da2 = 1;
mu1 = sqrt(Da2); mu2 = -mu1;
s = mu2*exp(mu2)-mu1*exp(mu1);
c = (mu2*exp(mu2)*exp(mu1*x)-mu1*exp(mu1)*exp(mu2*x))./s;
for Pe = [0.0625 0.125 0.25 0.5 1 2 4 8 16];
    s = sqrt(0.25*Pe*Pe+Da2);
    mu1 = 0.5*Pe+s; mu2 = 0.5*Pe-s;
    s = mu2*exp(mu2)-mu1*exp(mu1);
    c = [c;(mu2*exp(mu2)*exp(mu1*x)-mu1*exp(mu1)*exp(mu2*x))./s];
end
plot (x,c);
legend('Pe=0','Pe=0.0625','Pe=0.125','Pe=0.25','Pe=0.5','Pe=1','Pe=2','Pe=4','Pe=8','Pe=16');
xlabel ('x/L [-]'); ylabel ('c/c_{in} [-]');
