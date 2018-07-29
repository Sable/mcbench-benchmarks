% Author: Housam Binous

% Non-Newtonian Fluid Model Determination (for Bingham fluid)

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

function f=objective2(x)

tau0=x(1);
nu=x(2);

% representative values of volumetric flow rate vs applied pressure
% gradient for horizontal flow in a pipe

dPGexp=[10000 20000 30000 40000 50000 60000 70000 80000 90000 100000];
Qexp=1e-5*[5.37 26.4 68.9 129 235 336 487 713 912 1100];

% computing sum of squared differences

f=0;

for i=1:10
    Qtheo(i)=feval(@volflowrate2,[dPGexp(i),tau0,nu]);
    f=f+(Qtheo(i)-Qexp(i))^2;
end
