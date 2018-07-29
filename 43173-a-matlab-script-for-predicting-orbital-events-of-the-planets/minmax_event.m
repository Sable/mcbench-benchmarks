function minmax_event(objfunc, prtfunc, ti, tf, dt, dtsml)

% predict minima/maxima events

% input

%  objfunc = name of objective function
%  prtfunc = name of display results function
%  ti      = initial simulation time
%  tf      = final simulation time
%  dt      = step size used for bounding minima
%  dtsml   = small step size used to determine whether
%            the function is increasing or decreasing

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% convergence tolerance

tolm = 1.0e-10;

% initialization

df = 1;

t = ti;

while (1)
    
    % find where function first starts decreasing
    
    while (1)
        
        if (df <= 0)
            break;
        end
        
        t = t + dt;
        
        ft = feval(objfunc, t);
        
        ftemp = feval(objfunc, t - dtsml);
        
        df = ft - ftemp;
        
    end
    
    % function decreasing - find where function
    % first starts increasing
    
    while (1)
        
        el = t;
        
        t = t + dt;
        
        ft = feval(objfunc, t);
        
        ftemp = feval(objfunc, t - dtsml);
        
        df = ft - ftemp;
        
        if (df > 0)
            break;
        end
        
    end
    
    er = t;
    
    % calculate minimum using Brent's method
    
    [tmin, fmin] = minima(objfunc, el, er, tolm);
    
    el = er;
    
    % print results at extrema
    
    prtevent(objfunc, prtfunc, tmin);
    
    % check for end of simulation
    
    if (t >= tf)
        
        break;
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function prtevent (objfunc, prtfunc, topt)

% display orbital conditions

% input

%  objfunc = objective function
%  prtfunc = display results function
%  topt    = extrema time

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global smu jdtdbi

global iplanet1 iplanet2 pnames

% evaluate objective function

froot = feval(objfunc, topt);

jdate = jdtdbi + topt;

feval(prtfunc, jdate);

if (iplanet1 ~= 0)
    
    fprintf('\n\n');
    
    textstr = horzcat('heliocentric orbital elements and state vector of ', pnames(iplanet1, 1:7));
    
    disp(textstr);
    fprintf ('(mean ecliptic and equinox J2000)');
    fprintf ('\n---------------------------------\n');
    
    [r, v] = pecliptic(jdate, iplanet1, 11);
    
    oev = eci2orb1 (smu, r, v);
    
    oeprint1(smu, oev, 3);
    
    svprint(r, v);
    
end

if (iplanet2 ~= 0)
    
    fprintf('\n\n');
    
    textstr = horzcat('heliocentric orbital elements and state vector of ', pnames(iplanet2, 1:7));
    
    disp(textstr);
    fprintf ('(mean ecliptic and equinox J2000)');
    fprintf ('\n---------------------------------\n');
    
    [r, v] = pecliptic(jdate, iplanet2, 11);
    
    oev = eci2orb1 (smu, r, v);
    
    oeprint1(smu, oev, 3);
    
    svprint(r, v);
    
end

