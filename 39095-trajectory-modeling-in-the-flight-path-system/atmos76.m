function rho = atmos76 (h)

% U.S. Standard 1976 atmosphere model

% linear interpolation - 0 to 1000 kilometers

% input

%  h = altitude (kilometers)

% output

%  rho = atmospheric density (kg/km^3)

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global ad76

if (h > 1000.0)
    rho = 0.0;
    return;
end

% compute index and interpolation factor

for i = 1:1:2001
    xi = 0.5 * (i - 1);
    xim1 = xi - 0.5;

    if (h <= xi)
        if (i == 1)
            xinfac = 0;
            index = 1;
        else
            xinfac = (h - xim1) / (xi - xim1);
            index = i - 1;
        end
        break;
    end
end

y1 = ad76(index);

y2 = ad76(index + 1);

% atmospheric density

rho = y1 + xinfac * (y2 - y1);
