function value = calculateValue(s0,price,inFlow,turbFlow,spillFlow,C2A,n)
% Calculate the revenue generated at each time step for given turbine and
% spill flows.
%
% Copyright (c) 2012, MathWorks, Inc.
%%
% Initialize Value
value = zeros(n,1);

% Intialize Storage Vector
s = zeros(n,1);
s(1) = s0;

% Loop through time, calculate storage at each time step and calculate
% revenue from storage and turbine flow
for ii = 2:n
    s(ii) = s(ii-1)+(inFlow(ii-1) - turbFlow(ii-1) - spillFlow(ii-1))*C2A;
    value(ii) = price(ii)*turbFlow(ii)*(0.00001*(s(ii)+s(ii-1))/2+10)/1000;
end