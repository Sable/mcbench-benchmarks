function p3 = sum(p1)
%PREAL/SUM Overloaded SUM function for class preal.
% Note: Unlike datafun/sum preal/sum sums all elements of an array,
% resulting in one scalar.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    p3=sum(double(p1)); % ... treat as double.
    return
end

p1=preal(p1);
p3=p1(1);
for k=2:numel(p1)
    p3=p3+p1(k);
end