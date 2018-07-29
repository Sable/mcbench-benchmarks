function fighandle=dockfig(varargin)
% fighandle=dockfig(figs)      DOCK one or more FIGures.
%   "fighandle" is an array of handle numbers for the figures.
%   "figs" is an array of figure handles.
%       If "figs" is empty then all figures are docked.
%   Examples: 
%       figh=dockfig([4,3,5]), dockfig, dockfig 4 3 5
% Note that the command line format is supported.

%   Copyright 2006 Mirtech, Inc.
%   created 09/20/2006  by Mirko Hrovat on Matlab Ver. 7.2
%   Mirtech, Inc.       email: mhrovat@email.com
figs=[];  
if nargin>0,
    for n=1:length(varargin),
        arg=varargin{n};
        if ischar(arg),
            tmp=str2num(arg);   %#ok
            if isempty(tmp),    % since it is empty then it may be a variable
                tmp = evalin('base',arg);
                if isempty(tmp),
                    error ('  Syntax error in argument!'),
                end
            end  % isempty(tmp)
        else
            tmp=arg;
        end  % ischar(arg)
        figs=[figs,tmp];
    end  % for
end  % if nargin
if isempty(figs),       figs=0;     end

% set this to "on" so that all figures with "HandleVisibility" set to off can be seen.
set(0,'ShowHiddenHandles','on')     
% Below are two alternative methods to find all of the figures.
% Second method should be more foolproof.
% allhands=get(0,'Children');
allhands=findobj('Type','figure');
set(0,'ShowHiddenHandles','off')
if figs==0,
    figs=sort(allhands)';
else
    [tmp,indx]=intersect(figs,allhands);    %#ok tmp not used, view figures that exist
    figs=figs(sort(indx));                  % order the figures as specified
end
numfigs=numel(figs);

if isempty(figs),
    warning('MATLAB:EmptyValue','There are no figures to dock.')
else
    for n=numfigs:-1:1,
        set(figs(n),'WindowStyle','docked');
        figure(figs(n))             % bring figure to front.
    end
end

if nargout==1,
    fighandle=figs;
end
