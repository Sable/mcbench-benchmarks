function root_event(objfunc, prtfunc, tfinal)

% predict root-finding events

% input

%  objfunc = name of objective function
%  prtfunc = name of display results function
%  tfinal  = final simulation time (days)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global jdtdbi

% root-finding tolerance

rtol = 1.0d-10;

% compute initial value of objective function

fxnew = feval(objfunc, 0.0);

% root-finding step size (days)

dtstep = 0.25;

% initialize final time

tf = 0.0;

while (1)
    
    % initialize root-bracketed flag
    
    irflg = 0;
    
    % save current value of objective function
    
    fxold = fxnew;
    
    % set initial time to final time
    
    ti = tf;
    
    % increment final time
    
    tf = ti + dtstep;
    
    % compute current value of objective function
    
    fxnew = feval(objfunc, tf);
    
    % check to see if the user-defined objective
    % function has been bracketed during this step
    
    if (fxnew * fxold < 0)
        
        irflg = 1;
        
    end
    
    % check if time to bail out
    
    if (tf >= tfinal)
        
        fprintf('\n');
        
        break;
        
    end
    
    % if bracketed, find root of objective function and print results
    
    if (irflg == 1)
        
        % find root of objective function
        
        [troot, froot] = brent(objfunc, ti, tf, rtol);
        
        % evaluate converged solution
        
        jdtdb = jdtdbi + troot;
        
        % print converged solution
        
        feval(prtfunc, jdtdb);
        
    end
    
end


