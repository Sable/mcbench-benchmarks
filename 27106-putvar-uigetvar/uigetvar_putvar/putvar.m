function putvar(varargin)
% Assigns variables from the current workspace down into the base MATLAB workspace
% usage: putvar(var1)
% usage: putvar(var1,var2, ...)
%
% putvar moves variables from the current matlab
% workspace down to the base matlab workspace.
% putvar is something that can be used while
% in a debugging session, to retain the value
% of a variable, saving it into the base matlab
% workspace. putvar is also a way to return a
% specific variable, avoiding the use of a
% return argument (for whatever reason you might
% have.)
%
% putvar cannot assign variables that are not
% already in existence in the caller workspace.
%
%
% arguments: (input)
%  var1, var2 ... - Matlab variables in the
%       current workspace, that will then be
%       assigned into the base matlab workspace.
%
%       Alternatively, you can supply the names
%       of these variables, as strings.
%
%       If a variable with that name already
%       exists in the base workspace, it will
%       be overwritten, with a warning message
%       generated. That warning message can be
%       disabled by the advance command:
%
%       warning('off','PUTVAR:overwrite')
%
%
% Example:
% % First, save the function testputvar.m on your search path.
% % in MATLAB itself, try this.
%
% ==================
% function testputvar
% A = 3;
% B = 23;
% C = pi/2;
% D = 'The quick brown fox';
% putvar(A,'C',D)
% ==================
% 
% % Next, clear your workspace. Clear ensures that no
% % variables exist initially in the base workspace. Then
% % run the function testputvar, and finally execute the
% % who command, all at the command line.
%
% >> clear
% >> testputvar
% >> who
% 
% % Your variables are:
% % A  C  D
%
% % The output from who tells it all. Inside the function
% % testputvar, we had defined four variables, A, B, C and D.
% % But after testputvar terminates, its variables will fall
% % into the bit bucket, disappearing into limbo. The putvar
% % call inside testputvar ensures that the variables A, C
% % and D are returned into the base workspace, yet no return
% % arguments were provided.
%
%
% See also: uigetvar, uigetdir, uigetfile, who, whos
%
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 2.0
% Release date: 4/08/2010

if nargin < 1
  % no variables requested for the assignment,
  % so this is a no-op
  return
end

% how many variables do we need to assign?
nvar = numel(varargin);

% get the list of variable names in the caller workspace.
% callervars will be a cell array that lists the names of all
% variables in the caller workspace.
callervars = evalin('caller','who');

% likewise, basevars is a list of the names of all variables
% in the base workspace.
basevars = evalin('base','who');

% loop over the variables supplied
for i = 1:nvar
  % what was this variable called in the caller workspace?
  varname = inputname(i);
  vari = varargin{i};
  
  if ~isempty(varname)
    % We have a variable name, so assign this variable
    % into the base workspace
    
    % First though, check to see if the variable is
    % already there. If it is, we will need to set
    % a warning.
    if ismember(varname,basevars)
      warning('PUTVAR:overwrite', ...
        ['Input variable #',num2str(i),' (',varname,')', ...
        ' already exists in the base workspace. It will be overwritten.'])
    end
    
    % do the assign into the indicated name
    assignin('base',varname,varargin{i})
    
  elseif ischar(vari) && ismember(vari,callervars)
    % the i'th variable was a character string, that names
    % a variable in the caller workspace. We can assign
    % this variable into the base workspace.
    
    % First though, check to see if the variable is
    % already there. If it is, we will need to set
    % a warning.
    varname = vari;
    if ismember(varname,basevars)
      warning('PUTVAR:overwrite', ...
        ['Input variable #',num2str(i),' (',varname,')', ...
        ' already exists in the base workspace. It will be overwritten.'])
    end
    
    % extract the indicated variable contents from
    % the caller workspace.
    vari = evalin('caller',varname);
    
    % do the assign into the indicated name
    assignin('base',varname,vari)
    
  else
    % we cannot resolve this variable
    warning('PUTVAR:novariable', ...
      ['Did not assign input variable #',num2str(i), ...
      ' as no caller workspace variable was available for that input.'])
    
  end
  
end


