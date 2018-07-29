function t = timetic()
% TIMETIC Construct a timetic timing object.  
%
% t = timetic constructs a new timetic object.  A timetic object is like a
% tic/toc set, except each instance is independent.  This behavior permits
% multiple timetic sets to operate simultaneously, rather than only one
% with tic/toc.
%
% Additional, the timetic objects can be paused and restarted.
%
% Example:
%   t1 = timetic; t2 = timetic;
%   tic(t1);          % start timer 1
%   eig(rand(100));   % compute something
%   toc(t1); tic(t2); % print timer 1 and start timer 2
%   eig(rand(100));   % compute something else
%   toc(t1); toc(t2); % print timer 1 and timer 2
%
% See also TIC, TOC

%
% David Gleich
% Stanford University
% 27 September 2006
%

tdata = struct('state', 0, ...
           'elapsed', 0, ...
           'last_clock', clock);
       
% state is 0 if the timer is paused, 1 if the timer is running
% elapsed is the amount of committed time
% last_clock stores the data for the last clock call

    function et=update_elapsed()
        % this function updates the total committed elapsed time and 
        % saves the clock
        c = clock;
        tdata.elapsed = tdata.elapsed + tdata.state*etime(c, tdata.last_clock);
        tdata.last_clock = c;
        et = tdata.elapsed;
    end

    function pause()
        % this function commits the current time (update_elapsed) and
        % sets the timer to stopped
        update_elapsed();
        tdata.state = 0;
    end

    function start()
        % this function commits the current time (update_elapsed) and 
        % sets the timer to running
        % the update_elapsed function also stores the current clock,
        % so all new times are relative to this one
        update_elapsed();
        tdata.state = 1;
    end     

    function s=state()
        % get the internal running/stopped state for the display function
        s = tdata.state;
    end

    function et=elapsed()
        % compute the total elapsed time
        et = tdata.elapsed + tdata.state*etime(clock, tdata.last_clock);
    end

    function set(et)
        % set the total elapsed time, this function necessarily stops the
        % clock
        tdata.elapsed = et;
        tdata.state = 0;
        tdata.last_clock = clock;
    end

% construct the timetic structure
t = struct('start', @start, 'pause', @pause, ...
    'state', @state, 'elapsed', @elapsed, 'set', @set, ...
    'update_elapsed', @update_elapsed);

% declare the class
t = class(t,'timetic');

end