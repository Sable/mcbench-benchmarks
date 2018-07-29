function p3 = diff(p1)
%PREAL/DIFF Overloaded DIFF function for class preal.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    p3=diff(double(p1)); % ... treat as double.
    return
end

if isscalar(p1)
    p3=preal([]);
    return
end
if isvector(p1)
    p3=preal(ones(size(p1)));
    p3(end)=[];
    for k=1:numel(p3)
        p3(k)=p1(k+1)-p1(k);
    end
else
    error('preal/diff is only defined for vectors')
end