function clear(varargin)
%CLEAR  Clear variables and functions from memory. 
%   Added functionality CLEAR MOST
%
%   CLEAR MOST removes all variables, globals, function and MEX links, but
%   leaves all breakpoints in their current state.
%
%   CLEAR removes all variables from the workspace.
%   CLEAR VARIABLES does the same thing.
%   CLEAR GLOBAL removes all global variables.
%   CLEAR FUNCTIONS removes all compiled MATLAB and MEX-functions.
%
%   CLEAR ALL removes all variables, globals, functions and MEX links.
%   CLEAR ALL at the command prompt also clears the base import list.
%
%
%   CLEAR IMPORT clears the base import list.  It can only be issued at the 
%   command prompt. It cannot be used in a function.
%
%   CLEAR CLASSES is the same as CLEAR ALL except that class definitions
%   are also cleared. If any objects exist outside the workspace (say in 
%   userdata or persistent in a locked program file) a warning will be
%   issued and the class definition will not be cleared. CLEAR CLASSES must
%   be used if the number or names of fields in a class are changed.
%
%   CLEAR JAVA is the same as CLEAR ALL except that java classes on the
%   dynamic java path (defined using JAVACLASSPATH) are also cleared. 
%
%   CLEAR VAR1 VAR2 ... clears the variables specified. The wildcard
%   character '*' can be used to clear variables that match a pattern. For
%   instance, CLEAR X* clears all the variables in the current workspace
%   that start with X.
%
%   CLEAR -REGEXP PAT1 PAT2 can be used to match all patterns using regular
%   expressions. This option only clears variables. For more information on
%   using regular expressions, type "doc regexp" at the command prompt.
%
%   If X is global, CLEAR X removes X from the current workspace, but
%   leaves it accessible to any functions declaring it global. 
%   CLEAR GLOBAL X completely removes the global variable X. 
%   CLEAR GLOBAL -REGEXP PAT removes global variables that match regular
%   expression patterns.
%   Note that to clear specific global variables, the GLOBAL option must
%   come first. Otherwise, all global variables will be cleared.
%
%   CLEAR FUN clears the function specified. If FUN has been locked by
%   MLOCK it will remain in memory. Use a partial path (see PARTIALPATH) to
%   distinguish between different overloaded versions of FUN.  For
%   instance, 'clear inline/display' clears only the INLINE method for
%   DISPLAY, leaving any other implementations in memory.
%
%   CLEAR ALL, CLEAR FUN, or CLEAR FUNCTIONS also have the side effect of
%   removing debugging breakpoints and reinitializing persistent variables
%   since the breakpoints for a function and persistent variables are
%   cleared whenever the program file changes or is cleared.
%
%   Use the functional form of CLEAR, such as CLEAR('name'), when the
%   variable name or function name is stored in a string.
%
%   Examples for pattern matching:
%       clear a*                % Clear variables starting with "a"
%       clear -regexp ^b\d{3}$  % Clear variables starting with "b" and
%                               %    followed by 3 digits
%       clear -regexp \d        % Clear variables containing any digits
%
%   See also CLEARVARS, WHO, WHOS, MLOCK, MUNLOCK, PERSISTENT, IMPORT.

%   By: Jonathan Sullivan


if length(varargin) == 1 && strcmpi(varargin{1},'most')
    
    % Save current breakpoints
    s = dbstatus('-completenames');
    
    % Runs the builtin clear all
    evalin('caller','builtin(''clear'',''all'');');
    
    % Loads the breakpoints
    dbstop(s);
else
    
    % Runs the builtin clear function
    varargin = [{'varargin'} varargin];
    assignin('caller','varargin',varargin);
    evalin('caller','builtin(''clear'',varargin{:});');
    
end