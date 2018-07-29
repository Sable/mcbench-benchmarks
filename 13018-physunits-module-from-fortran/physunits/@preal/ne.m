function L = ne(p1,p2)
%PREAL/ne Overloaded NE (~=) operator for class preal.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    L=ne(double(p1),double(p2)); % ... treat as double.
    return
end

p1=preal(p1);
p2=preal(p2);
tol=0.001;
if isscalar(p1)
    p1=preal(p1.value*ones(size(p2)),p1.units);
elseif isscalar(p2)
    p2=preal(p2.value*ones(size(p1)),p2.units);
elseif ndims(p1)==ndims(p2)&size(p1)==size(p2)
    % do nothing
else
    error('Array dimensions must agree')
end

L=false(size(p1));
for k=1:numel(L)
    if any(abs(p1(k).units-p2(k).units)>tol)
        error('Attempt to compare dimensionally inconsistent preals')
    end
    L(k)=ne(p1(k).value,p2(k).value);
end