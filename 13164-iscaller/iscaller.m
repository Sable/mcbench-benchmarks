function valOut=iscaller(varargin)
%ISCALLER Determine caller function.
%   TF = ISCALLER(S) returns a true if the function containing ISCALLER is 
%   called by the function named S
%   TF = ISCALLER(S1,S2,...) returns a true if the function containing 
%   ISCALLER is called by the function named S1, S2 or ...
%   S = ISCALLER returns the name of the caller function in string S
%
%   Examples:
%   We have three caller functions:
%
%       function caller1
%       %CALLER1 calles example function
%       calledFunction
%
%       function caller2
%       %CALLER2 calles example function
%       calledFunction
%
%       function caller3
%       %CALLER3 calles example function
%       calledFunction
%
%   All calling the following function:
%
%       function calledFunction
%       %CALLEDFUNCTION Finds out by which function it is called
%
%       %iscaller with string input returns true or false
%       disp('Example1:')
%       if iscaller('caller1','caller2')
%           disp('calledFunction is called by caller1 or caller2')
%       else
%           disp('calledFunction is not called by caller1 or caller2')
%       end
%
%       %iscaller without input returns name of caller
%       disp('Example2:')
%       switch iscaller
%           case 'caller1'
%               disp('calledFunction is called by caller1')
%           case 'caller2'
%               disp('calledFunction is called by caller2')
%           case 'caller3'
%               disp('calledFunction is called by caller3')
%       end
%
%   If we now run CALLER1, CALLEDFUNCTION returns:
%       Example1:
%       calledFunction is called by caller1 or caller2
%       Example2:
%       calledFunction is called by caller1
%
%   If we run CALLER2:
%       Example1:
%       calledFunction is called by caller1 or caller2
%       Example2:
%       calledFunction is called by caller2
%
%   And if we run CALLER3
%       Example1:
%       calledFunction is not called by caller1 or caller2
%       Example2:
%       calledFunction is called by caller3
% 
%   See also: DBSTACK, FUNCTION, MFILENAME

%   Eduard van der Zwan, 29-Nov-2006
stack=dbstack;
%stack(1).name is this function
%stack(2).name is the called function
%stack(3).name is the caller function
if length(stack)>=3
    callerFunction=stack(3).name;
else
    callerFunction='';
end
if nargin==0
    valOut=callerFunction;
elseif iscellstr(varargin)
    valOut=ismember(callerFunction,varargin);
else
    error('All input arguments must be a string.')
end    