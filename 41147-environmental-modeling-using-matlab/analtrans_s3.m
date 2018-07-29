% Steady state transport solutions for one fixed value of Pe and various values of Da1
x = [0:0.01:1];
Pe = 1; Da1 = 16;
s = sqrt(0.25*Pe*Pe+Pe/Da1);
mu1 = 0.5*Pe+s; mu2 = 0.5*Pe-s;
s = mu2*exp(mu2)-mu1*exp(mu1);
c = (mu2*exp(mu2)*exp(mu1*x)-mu1*exp(mu1)*exp(mu2*x))./s;
for Da1 = [8 4 2 1 0.5 0.25 0.125];
    s = sqrt(0.25*Pe*Pe+Pe/Da1);
    mu1 = 0.5*Pe+s; mu2 = 0.5*Pe-s;
    s = mu2*exp(mu2)-mu1*exp(mu1);
    c = [c;(mu2*exp(mu2)*exp(mu1*x)-mu1*exp(mu1)*exp(mu2*x))./s];
end
plot (x,c);
legend('Da_1=16','Da_1=8','Da_1=4','Da_1=2','Da_1=1','Da_1=0.5','Da_1=0.25','Da_1=0.125');
xlabel ('x/L [-]'); ylabel ('c/c_{in} [-]');