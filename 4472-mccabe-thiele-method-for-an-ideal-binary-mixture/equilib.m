% McCabe and Thiele Graphical Method for Binary Distillation 
% Author's Data: Housam BINOUS
% Department of Chemical Engineering
% National Institute of Applied Sciences and Technology
% Tunis, TUNISIA
% Email: binoushousam@yahoo.com 

% Function equilib, called by main program, gives the 
% relationship between liquid and vapor mole fractions 
% for the low boiling component of binary mixture 
% with constant relative volatility alpha=2.45 

function f=equilib(x)

global y

alpha=2.45;

f=y-alpha*x/(1+(alpha-1)*x);

end
