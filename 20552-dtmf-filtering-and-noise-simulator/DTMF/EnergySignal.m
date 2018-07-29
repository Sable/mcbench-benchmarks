function [E,ES,Iszero] = EnergySignal(X);

%Computes the energy of the Signal
%Input Variables
%    X       = Input Signal
%
% Output Variables
%    E       = Energy
%    EG      = Energy Signal
%    Iszero  = Returns 1 for zero Energy signal else 0 

ES = (abs(X)).^2;

E = 0;
for i = 1:length(X);
    E = E+ES(i);
end

if E == 0
    Iszero = 1;
else 
    Iszero = 0;
end
