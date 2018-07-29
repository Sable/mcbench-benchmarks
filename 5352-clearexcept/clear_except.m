
function clear_except(varargin)

% The following function clears the command workspace except the 
% variables specified by the user. 

error(nargchk(1,inf,nargin)); % Checks for zero input arguments

s = evalin('caller','who'); % Get contents of command workspace

cnt = 0; % Count that keeps track of no. of inputs
for ii = 1:1:nargin
    for jj = 1:1:length(s)
        if strcmp(varargin{ii},s{jj}) % Compare command workspace contents with the user specified variables.
            cnt = cnt + 1;
            index(cnt) = jj;
        end
    end
end

if cnt < nargin 
        error('MATLAB:clear_except:Unidentified', ... % If any of the input arguments not present in workspace generate an error. 
        'One of the variables not present in the workspace');
end

e = length(s)-cnt; % This variable ensures if somebody by mistake calls this function with
                   % all variables of workspace as input arguments then the variables should
                   % not be cleared.

t ={};
for k = 1:1:nargin % Create the cell array of the variables that need to be cleared.
    for ii = 1:1:index(k)-1;
        t(ii) = {[s{ii} ' ']};
    end
    for ii = index(k)+1:1:length(s)
        t(ii) = {[s{ii} ' ']};
    end
    s = t;
    clear t;
end
if e == 0 % If e is zero, it implies that all the variables present in the workspace 
          % have been given as input arguments to the function and hence
          % all of them needs to be preserved.
    return;
else
    evalin('caller',['clear ',s{:}]); % Clear the variables that are not in the input argument list.
end