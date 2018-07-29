% hour of the day.
function hod = mydatehod (epoch, epoch0)
    if (nargin < 2),  epoch0 = [];  end
    sod = mydatesod (epoch, epoch0);
    hod = sod ./ 3600;
end
