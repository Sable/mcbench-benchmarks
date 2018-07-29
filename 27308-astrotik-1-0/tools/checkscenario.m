% ASTROTIK by Francesco Santilli

function [orbits0,t0,mi,R,mi0,J] = checkscenario(scenario)

    if ~isa(scenario,'struct')
        error('Wrong class of an input argument.')
    end
    
    f(1) = isfield(scenario,'orbits0');
    f(2) = isfield(scenario,'t0');
    f(3) = isfield(scenario,'mi');
    f(4) = isfield(scenario,'R');
    f(5) = isfield(scenario,'mi0');
    
    if ~all(f)
        error('Missing field in scenario structure.')
    end
    
    orbits0 = scenario.orbits0;
    t0      = scenario.t0;
    mi      = scenario.mi;
    R       = scenario.R;
    mi0     = scenario.mi0;
    
    [J,D] = check(orbits0,2);
    check(t0,1)
    check(mi,1)
    check(R,1)
    check(mi0,0)
    
    if ~(D==3 || D==5)
        error('Wrong size of input arguments.')
    end
    
    if ~(length(t0)==J && length(mi)==J && length(R)==J)
        error('Wrong size of input arguments.')
    end
    
    if any(mi < 0)
        error('mi must be a positive value.')
    end
    
    if any(R < 0)
        error('R must be a positive value.')
    end
    
    if mi0 <= 0
        error('mi0 must be a strictly positive value.')
    end
    
end