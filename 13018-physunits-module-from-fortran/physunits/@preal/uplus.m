function p3 = uplus(p1)
%PREAL/UPLUS Overloaded unary plus operator for class preal.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    p3=double(p1); % ... treat as double.
    return
end

p3=p1;