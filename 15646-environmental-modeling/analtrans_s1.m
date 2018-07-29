% Steady state transport solutions for one Pe=0 and various values of Da2
x = [0:0.01:1];
Da2 = 8; mu1 = sqrt(Da2); mu2 = -mu1;
s = mu2*exp(mu2)-mu1*exp(mu1);
c = (mu2*exp(mu2)*exp(mu1*x)-mu1*exp(mu1)*exp(mu2*x))./s
for Da2 = [4 2 1 0.5 0.25 0.125];
    s = sqrt(Da2); mu1 = s; mu2 = -s;
    s = mu2*exp(mu2)-mu1*exp(mu1);
    c = [c;(mu2*exp(mu2)*exp(mu1*x)-mu1*exp(mu1)*exp(mu2*x))./s];
end
plot (x,c);
legend('Da_2=8','Da_2=4','Da_2=2','Da_2=1','Da_2=0.5','Da_2=0.25','Da_2=0.125');
xlabel ('x/L [-]'); ylabel ('c/c_{in} [-]');