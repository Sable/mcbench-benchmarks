function d = log10(p1)
%PREAL/LOG10 Overloaded logarithm function for class preal.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    d=log10(double(p1)); % ... treat as double.
    return
end

tol=0.001;
d=ones(size(p1));
for k=1:numel(d)
    if any(abs(p1(k).units)>tol)
        error('Trancendental functions cannot take dimensional arguments')
    end
    d(k)=log10(p1(k).value);
end