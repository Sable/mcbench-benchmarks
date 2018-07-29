function p3 = eps(p1)
%PREAL/EPS  Overloaded EPS function for class preal.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    p3=eps(double(p1)); % ... treat as double.
    return
end

p3=preal(ones(size(p1)));
for k=1:numel(p3)
    p3(k).value=eps(p1(k).value);
    p3(k).units=p1(k).units;
end