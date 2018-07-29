function ccd( varargin )
% function ccd( argument )
% "Cool Change Directory", keeps a stack of directories you can index into
%
% usage:
% ccd <a directory>
%      -Adds the current directory to the top of the stack before changing
%       to the argument directory
% ccd ?
%      - lists the directory stack (with index numbers shown)
% ccd <integer value>
%      - changes directory to the specified directory in the stack 
%      NOTE: Stack remains unchanged.  If you want to add your local
%            directory to the stack, and then go to a previosly indexed
%            directory, do a "ccd .", followed by "ccd <index>"
% ccd clear
%      - clears the directory stack
% ccd pop
%      - removes the top entry from the stack, and then changes to that 
%        directory
% ccd [with no arguements]
%      - toggles through the directories in a cycle.  
%      - This option remembers where you last went in the stack and will
%        toggle from top to bottom (and then loop back to the top).
%      NOTE: stack remains unchanged
%
% HINT: add a few ccd calls in your startup.m file to "seed" it with some
%       commonly used directories if you like.
% HITE: to use tabbed-autocompletion, just use the normal "cd" command
%       and then at the very end hit <HOME c> to prepend the final 
%       command with a "c" (to make it "cool").
%
% by: Brendan Hannigan 9/30/2004, (inspired by scd.m by mark jones)

persistent dirStack
persistent stackSize
persistent pointer

%initialize the stack on the first call
if isempty(stackSize)
  dirStack = {};
  stackSize = 0;
  pointer = 0;
end

% did they pass in to many arguemtns?
if nargin > 1
  disp('ccd: too many input arguments, type ''help ccd'' for calling options');
  return;
end

% if called with no arguments, toggle through the directories (top down)
if nargin == 0
  if (stackSize > 0)
    pointer = pointer - 1;
    if (pointer < 1)
      pointer = stackSize;
    end
    target = dirStack{pointer};
    ccdCommand = ['cd(''' target ''')'];
    evalin('caller', ccdCommand);
    disp(pwd);
    return;
  else
    disp('ccd: directory stack is empty');
    return;
  end
end

% if we reach this point we have exaclty one argument
inputString = varargin{1};
numericInput = str2num(inputString);

% did they pass in a number?
if (~isempty(numericInput))
  index = round(numericInput);
  if index > stackSize
    disp(['ccd: invalid stack index, current directory stack size is ' num2str(stackSize)]);
    if (stackSize > 0)
      disp('current directory stack:');
    end
    for i = stackSize:-1:1
      disp([num2str(i) ' : ' dirStack{i}]);
    end
    return;
  elseif index < 1
    disp('ccd: invalid stack index, index must be greater than zero');
    return;
  else
    %here we have received a valid stack index
    target = dirStack{index};
    ccdCommand = ['cd(''' target ''')'];
    evalin('caller', ccdCommand);
    disp(pwd);
    return;
  end
  
else % else we have received a string as input

  % print the stack
  if (strcmp(inputString, '?'))
    if (stackSize > 0)
      disp('ccd: current directory stack:');
    else
      disp('ccd: empty stack');
    end
    for i = stackSize:-1:1
      disp([num2str(i) ' : ' dirStack{i}]);
    end
    return;
  end
  
  % pop top directory off the stack
  if (strcmp(inputString, 'pop'))
    % just return if there's no stack
    if (stackSize < 1)
      disp('ccd: empty stack');
      return;
    end
    if (stackSize == 1)
      inputString = 'clear';
      target = dirStack{stackSize};
      ccdCommand = ['cd(''' target ''')'];
      evalin('caller', ccdCommand);
      disp(pwd);
    else
      target = dirStack{stackSize};
      ccdCommand = ['cd(''' target ''')'];
      dirStack = dirStack(1:end-1);
      stackSize = stackSize - 1;
      if (pointer > stackSize)
        pointer = stackSize;
      end
      evalin('caller', ccdCommand);
      disp(pwd);
      return
    end
  end

  % clear the directory stack
  if (strcmp(inputString, 'clear'))
    disp('ccd: clearing directory stack');
    clear dirStack;
    dirStack = {};
    stackSize = 0;
    pointer = 0;
    return;
  end

  % go to a new directory
  % check for validity first
  validDir = what(inputString);
  [validSize temp] = size(validDir);
  if (validSize == 0)
    disp(['ccd: invalid directory: ' inputString]);
    return;
  end
 
  % we got a valid directory now
  currentDir = pwd;
  target = inputString;
  ccdCommand = ['cd(''' target ''')'];
  currentDir = pwd;
  if (~ismember(currentDir, dirStack))
    stackSize = stackSize + 1;
    dirStack{stackSize} = currentDir;
  end
  evalin('caller', ccdCommand);
  disp(pwd);
  return
end

return

