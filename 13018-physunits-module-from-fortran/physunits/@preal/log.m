function d = log(p1)
%PREAL/LOG Overloaded logarithm function for class preal.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    d=log(double(p1)); % ... treat as double.
    return
end

tol=0.001;
d=ones(size(p1));
for k=1:numel(d)
    if any(abs(p1(k).units)>tol)
        error('Trancendental functions cannot take dimensional arguments')
    end
    d(k)=log(p1(k).value);
end