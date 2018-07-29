function d = exp(p1)
%PREAL/EXP Overloaded EXP function for class preal.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    d=exp(double(p1)); % ... treat as double.
    return
end

tol=0.001;
d=ones(size(p1));
for k=1:numel(d)
    if any(abs(p1(k).units)>tol)
        error('Exponent must be non-dimensional (pure) number')
    end
    d(k)=exp(p1(k).value);
end