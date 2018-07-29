% Author: Housam Binous

% VLE Computations using Matlab

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

function f=EQUIL(T)

global PAR y x G1 G2 PS1 PS2

% gas constant

R=1.987;

% total pressure in mmHg

P=760;

% Antoine's equations

PS1=10^(PAR(1)-PAR(3)/(PAR(5)+T));
PS2=10^(PAR(2)-PAR(4)/(PAR(6)+T));

% Wilson model

A12=PAR(10)/PAR(9)*exp(-PAR(7)/(R*(273.15 + T)));
A21=PAR(9)/PAR(10)*exp(-PAR(8)/(R*(273.15 + T)));

G1=exp(-log(x + A12*(1 - x)) + (1 - x)*(A12/(x + A12*...
    (1 - x)) - A21/(A21*x + 1 - x)));
     
G2=exp(-log(1 - x + A21*(x)) + (x)*(A21/(1 - x + ...
    A21*(x)) - A12/(A12*(1 - x) + x)));

% Dalton's law

f=P-PS1*G1*x-PS2*G2*(1-x);

% vapor mole fraction using modified Raoult's law

y=G1*x*PS1/P;

end
