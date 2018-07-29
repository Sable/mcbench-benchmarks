% This is a function for generation Mackey-Glass Time Series
% nm = 3000
% MG Series is periodic for tau<17 otherwise non-periodic
% Initial values are generated randomly using rand function
% Eular's method is for solving MG diffrential equation
% ds(t)/dt = 0.2s(t-tau)/(1+s(t-tau)^10) - 0.1s(t)

function mydata = mgts(nm);
tau = 30;
for t = 0:nm-1
    if t<= tau
        s(t+1) = rand;
    else
        s(t+1) = 0.9*s(t)+(0.2*s(t-tau))/(1+s(t-tau)^10);
    end
end
mgs = s';

mydata = mgs(1001:1500)';
t=1001:1500;
plot(t, mydata);