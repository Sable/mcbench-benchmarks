function [xalt, xlat] = geodet6(req, rpolar, rsc)

% convert geocentric eci position vector to
% geodetic altitude and latitude

% input

%  req    = equatorial radius (kilometers)
%  rpolar = polar radius (kilometers)
%  rsc    = spacecraft eci position vector (kilometers)

% output

%  xalt = geodetic altitude (kilometers)
%  xlat = geodetic latitude (radians)
%         (+north, -south; -pi/2 <= xlat <= +pi/2)

% reference

% "New solutions for the geodetic
% coordinate transformation", G. C. Jones

% Journal of Geodesy (2002) 76: 437-446

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% convergence criterion

eps = 1.0d-8;

% components of eci position vector

x = rsc(1);
y = rsc(2);
z = rsc(3);

% flattening factor

flat = (req - rpolar) / req;

rhostar = req * flat * (2.0 - flat);

rho = sqrt(x^2 + y^2);

if (z < 0.0)
    
    z = -z;
    
    southern = 1;
    
else
    
    southern = 0;
    
end

if (z > 0.0)
    
    if (rho > 0.0)
        
        if ((rho^2 + z^2 / (1.0 - flat)^2) >= req^2)
            
            t = atan(z / (rho * (1.0 - flat)));
            
        elseif (rho <= (rhostar + z / (1.0 - flat)))
            
            t = atan((z * (1.0 - flat) + rhostar) / rho);
            
        else
            
            t = atan(z * (1.0 - flat) / (rho - rhostar));
            
        end
        
        t_old = t + 0.1;
        
        while (abs(t_old - t) > eps)
            
            awrk = ((1.0 - flat) * z + rhostar * sin(t)) / rho;
            
            f = atan (awrk);
            
            fprime = rhostar * cos(t) / (rho * (1.0 + awrk^2));
            
            t_old = t;
            
            t = t - (f - t) / (fprime - 1.0);
        end
        
        xlat = atan(tan(t) / (1.0 - flat));
        
    else
        
        xlat = pi / 2.0;
        
        xalt = z - req * (1.0 - flat);
        
    end
    
else
    
    xlat = 0.0;
    
    xalt = rho - req;
    
end

xalt = rho * cos(xlat) + z * sin(xlat) ...
    - req * sqrt(1.0 - flat * (2.0 - flat) * (sin(xlat))^2);

if (southern == 1)
    
    xlat = -xlat;
    
end




