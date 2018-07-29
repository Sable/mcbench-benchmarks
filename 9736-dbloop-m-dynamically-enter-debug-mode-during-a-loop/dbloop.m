function dbloop(key)
%DBLOOP Tool for dynamically creating breakpoints inside a loop
%   DBLOOP is the syntax without any arguments. Place the command inside a
%   FOR or WHILE loop where you want the possibility to enter debug mode.
%   When the code is running, press the "k" key, and the code will stop at
%   the next execution of that DBLOOP command. Just as you would continue
%   from a KEYBOARD command or debug point, use the RETURN or DBCONT
%   command to continue.
%
%   If the DBLOOP command is in a loop executed in the base workspace, the
%   code will stop at the call to DBSTACK inside this DBLOOP file.
%
%   DBLOOP KEY can be used to change the keyboard key (rather than the
%   default "k") that you press to enter debug mode. KEY must be a single
%   character. By using DBLOOP multiple times in the same code loop with
%   each call using a different KEY, this syntax allows you to control
%   stopping at various locations. See the example below for details.
%
%   DBLOOP 'ANY' allows you to stop the loop at the press of any key.  This
%   cannot be used in conjunction with multiple DBLOOP KEY settings.
%
%   DBLOOP 'CLOSE' closes the figure that is used to catch the keystrokes.
%   Use it after your loop exits, or if you quit your loop before it has a
%   chance to complete. Alternatively, you can manually close the figure,
%   or use "close force".
%
%   NOTE 1: If you exit your loop early, you'll want to use "dbloop close",
%   and you'll probably want to clear the breakpoint that DBLOOP set in
%   your code. See "doc dbclear" for more info.
%
%   NOTE 2: When running MATLAB without the desktop, you may have to hold
%   down the KEY or press it many times to stop in the debugger. In older
%   versions, you may have to click on the figure window in the taskbar
%   before pressing the KEY.
%
%   Example:
%       function example4dbloop
%       % The example is best illustrated if this code is copied/pasted
%       %  into a function M-file named "example4dbloop.m". Then you can
%       %  run the example, and press either "k", "1", or "2" to debug.
%       mmax = 5;
%       for n=1:500
%           % With no input arguments, this command will allow you
%           %   enter debug mode when a "k" is pressed
%           dbloop
%           disp(sprintf('Loop ran %u times.',n))
%           % This command will allow you to enter debug 
%           %   mode when a "1" is pressed
%           dbloop 1
%           disp(sprintf('Like I said, the loop ran %u times.',n))
%           for m=1:mmax
%               % Alternatively, this command will allow you to  
%               %   enter debug mode when a "2" is pressed
%               dbloop 2
%               disp(sprintf('This second loop ran %u of %u times',m,mmax))
%           end
%       end
%       dbloop close
%
%   See also KEYBOARD DBSTOP RETURN DBCONT DBSTACK DBSTATUS

%   Greg Aloe
%   v1.0 - 2003.10.12 - Initial release.
%   v1.1 - 2006.01.23 - Clarified help, renamed from keepgoing to dbloop.
%   v2   - 2006.03.24 - Removed restriction when using with other figures.
%                       Added "dbloop any" option.
%                       Added "dbloop close" option.
%                       Thanks to Tim Farajian for his suggestions.

% Define the default key
defaultKey = 'k';
deadKey = char(1);

% Find the "dbloop key catcher" figure, or create it if it doesn't exist
hf = findall(0,'Tag','DB_LOOP_KEY_CATCHER');

% If a key wasn't defined, use the default
if nargin==0
    key = defaultKey;
end

% Close the figure if requested
if strcmpi(key,'close')
    close(hf)
    return
end

if isempty(hf)
    % Make the figure elusive
    hf = figure('Tag','DB_LOOP_KEY_CATCHER', ...
        'Units','Normalized','Position',[1.1 1.1 .2 .1], ...
        'Menubar','None','CurrentCharacter',deadKey, ...
        'IntegerHandle','Off','NumberTitle','Off', ...
        'Name','dbloop key catcher','Resize','Off', ...
        'HandleVisibility','off');
end

% Get the function stack for setting/clearing breakpoints
dbs = dbstack;

% Make the "key catcher" figure active so we can assuredly catch keys
figure(hf)
drawnow

% If a specified key was pressed, make a breakpoint so it stops on the next
% execution, or else clear that potential breakpoint
cc = get(hf,'CurrentCharacter');
if strcmpi(cc,key) || (strcmpi(key,'any') && ~strcmp(cc,deadKey))
    dbstop('in',dbs(end).name,'at',num2str(dbs(end).line));
    % Reset the CurrentCharacter so it doesn't stop on every iteration
    set(hf,'CurrentCharacter',deadKey)
else
    dbclear('in',dbs(end).name,'at',num2str(dbs(end).line));
end
