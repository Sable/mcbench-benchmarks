function p3 = max(p1)
%PREAL/MAX Overloaded MAX function for class preal.
% Note: Unlike datafun/max preal/max returns the largest single element of
% the array, resulting in one scalar.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    p3=max(double(p1)); % ... treat as double.
    return
end

p1=preal(p1);
p3=p1(1);
for k=2:numel(p1)
    if p1(k)>p3
        p3=p1(k);
    end
end