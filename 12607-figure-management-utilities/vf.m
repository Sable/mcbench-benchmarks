function fighandle=vf(varargin)
% fighandle=vf(figs)      View one or more Figures.
% This simple function brings the group of figures specified by "figs" to 
% the front. No tiling or rearrangment of the figures is done.
% If "figs" is empty then all of the figures are brought to the front.
%   "fighandle" has the figure handles of the figures brought forward.
%   Examples:
%       vf(a) where "a" is a vector of figure handles.
%       a=vf, vf a, vf [1,6,8], a=vf(1,6,8), vf 1 a 6
% Note that the command line format is supported.

%   Copyright 2006 Mirtech, Inc.
%   created 08/22/2006  by Mirko Hrovat on Matlab Ver. 7.2
%   Mirtech, Inc.       email: mhrovat@email.com

figs=[];    
if nargin>0
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
end

% set this to "on" so that all figures with "HandleVisibility" set to off can be seen.
set(0,'ShowHiddenHandles','on')     
% Below are two alternative methods to find all of the figures.
% Second method should be more foolproof.
% allhands=get(0,'Children');
allhands=findobj('Type','figure');
set(0,'ShowHiddenHandles','off')
if isempty(figs),
    figs=sort(allhands)';
else
    [tmp,indx]=intersect(figs,allhands);    %#ok tmp not used, view figures that exist
    figs=figs(sort(indx));                  % order the figures as specified
end
if isempty(figs),
    warning('MATLAB:EmptyValue','There are no figures to select.')
else
    for n=numel(figs):-1:1,
        figure(figs(n))                         % bring figure to front.
    end
end

if nargout==1,
    fighandle=figs;
end
