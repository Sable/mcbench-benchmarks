function display(p)
%PREAL/DISPLAY  Command window display of a preal.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    display(double(p));
    return
end

disp(' ');
disp([inputname(1),' = ']);
disp(' ');
if isscalar(p)
    disp(['  ',char(p)]);
else
    s=[];
    for k=1:ndims(p)
        s=[s,num2str(size(p,k)),'x'];
    end
    disp(['  ',s(1:end-1),' preal array'])
end
disp(' ');