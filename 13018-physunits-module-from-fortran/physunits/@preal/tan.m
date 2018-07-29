function d = tan(p1)
%PREAL/TAN Overload the tangent function for class preal.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    d=tan(double(p1)); % ... treat as double.
    return
end

tol=0.001;
d=ones(size(p1));
for k=1:numel(d)
    if any(abs(p1(k).units(1:end))>tol)
        error('Trancendental functions cannot take dimensional arguments')
    end
    d(k)=tan(p1(k).value);
end