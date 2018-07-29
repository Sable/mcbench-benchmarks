function output = waitinput(prompt,t,s)
%WAITINPUT  Prompt for user input, but no longer than t seconds.
%   output = WAITINPUT('Input something',t) gives the user the prompt in the
%   text string and then waits for input from the keyboard by t seconds.
%   R is the result. When user not specified s argument R will be a double,
%   or if argument s i s eqal to 's', R will be a char. For other s
%   argument function return an error.
%   Function works only with alphanumeric characters.   
%
%   Example:
%           waitinput('what is your name? ',10,'s')
%
%   This function is inspired by Matlab INPUT function and GetKeyWait by
%   Jos (10584) from File Exchange:
%   http://www.mathworks.com/matlabcentral/fileexchange/8297-getkeywait
%
%   See also INPUT, KEYBOARD.
%
%   Copyright 2010 Grzegorz Knor

% check number of arguments
if nargin<2
    error('Not enough input arguments.')
elseif nargin>3
    error('Too many input arguments.')
end

if t<=0
    error('t must be a positive value.')
end

if nargin == 2
    s = 'd';
end

if ~strcmp(s,'s') && ~strcmp(s,'S') && ~strcmp(s,'d') && ~strcmp(s,'D')
    error('The second argument to WAITINPUT must be ''s'', or ''d''.')
end

fprintf('%s',prompt)

output = NaN;
idx = 1;

tt = timer;
tt.timerfcn = 'uiresume';
tt.startdelay = t;


fh = figure('keypressfcn',@call, ...
    'windowstyle','modal',...
    'position',[0 0 1 1],...
    'Name','GETKEYWAIT', ...
    'visible','off',...
    'userdata',-1) ;
try
    % Wait for something to happen or the timer to run out
    start(tt) ;
    uiwait ;
catch %#ok<CTCH>
    % Something went wrong, return NaN.
    output = NaN ;
end

% clean up the timer and figure
stop(tt) ;
delete(tt) ;
close(fh) ;

% return the output
if isnan(output)
    return
end
if strcmp(s,'s') || strcmp(s,'S')
    output = char(output);
else
    output = str2double(char(output));
end

% function call
    function call(src,evnt)
        fprintf('%s',evnt.Character)
        
        set(src,'Userdata',double(evnt.Character));
        
        if double(evnt.Character)~=13
            output(idx) = evnt.Character;
            idx = idx+1;
        else
            uiresume;
        end
    end
end