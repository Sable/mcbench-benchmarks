function StepThru(mfile,ws)
%STEPTHRU automatically steps through specified m-file
%
%   STEPTHRU(MFILE) sets breakpoints at all but first line comment and
%   executes MFILE in order to step through it using debugger.
%
%       Line comments begin with % character. 
%
%       No breakpoint is generated if the text 'nobkpt' is 
%       anywhere in the line comment.
%
%   STEPTHRU(MFILE,WS) executes MFILE in specified
%   workspace (ie, 'caller' or 'base' valid).

%This utility intended to simplify MATLAB script demos
%v2 Apr2004 rbemis@mathworks.com (added npbkpt option)
%v1 Oct2002 rbemis@mathworks.com

% Copyright 2004-2010 The MathWorks, Inc.

% find pure comment lines to set breakpoints
fid=fopen([mfile '.m']);
line_num=0;
while ~feof(fid) %read 1 line at-a-time
  dummy=NoLeadingBlanks(fgetl(fid));
  line_num=line_num+1;
  if length(dummy)>0 %nonempty line
    if dummy(1)=='%' & line_num>1 %comment line but not line1
      if strfind(lower(dummy),'nobkpt') %no breakpoint this line
        eval(['dbclear in ' mfile ' at ' num2str(line_num)])
      else
        eval(['dbstop in ' mfile ' at ' num2str(line_num)])
      end
    end
  end
end %file empty
fclose(fid);

%open file in Editor
edit(mfile)

% execute m-file (in specified workspace)
if nargin>1 %workspace specified
  evalin(ws,mfile)
else %default=local workspace (ie, this function)
  eval(mfile)
end
dbclear all


% helper function to remove any leading blanks
%--------------------------------------------------
function str1 = NoLeadingBlanks(str1)
Done=false;
while ~Done %keep looking
  if length(str1)==0 %empty string
    Done=true; %get out
  else %check first character
    if str1(1)==' ' %leading blank detected
      str1=str1(2:end); %remove it
    else %any other character
      Done=true; %leave it, done
    end
  end
end %stripped!
