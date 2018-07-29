function p3 = sqrt(p1)
%PREAL/SQRT Overloaded square root for class preal.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    p3=sqrt(double(p1)); % ... treat as double.
    return
end

p3=preal(ones(size(p1)));
for k=1:numel(p3)
    p3(k).value=sqrt(p1(k).value);
    p3(k).units=p1(k).units/2;
end