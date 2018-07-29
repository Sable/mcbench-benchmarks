function varargout = glinkaxes(varargin)
%GLINKAXES   Synchronize limits of interactively specified 2-D axes
%   GLINKAXES waits for user to click on axes to be synchronized until user
%   presses the RETURN. Upon RETURN key press, all clicked axes are linked
%   and maintains the same limits for x-, y-, and z-axis.
%
%   GLINKAXES(OPTION) links the axes according to the specified option. The
%   OPTION argument can be one of the following strings:
%      'x'   ...link x-axis only
%      'y'   ...link y-axis only
%      'xy'  ...link x-axis and y-axis
%      'off' ...remove linking
%
%   GLINKAXES(N) or GLINKAXES(N,option) may be used to specify number of
%   axes to synchronize.
%
%   AX = GLINKAXES(...) to return the handles of the selected axes.
%
%   See also: linkaxes, ginput.

% Revision 1 (April 14, 2011)
% Written by: Takeshi Ikuma
% Created: March 24, 2011
% Revision History:
% Rev. 1 (4/14/11) - corrected GLINKAXES(OPTION) parsing bug

error(nargchk(0,2,nargin));

% must have at least 2 axes
if (findobj(0,'type','axes')<2)
   warning('glinkaxes:NoFigureOpen','No figure to be linked. GLINKAXES is exiting.');
end

% if not given, use xy
if nargin<1
   how_many = [];
   option = '';
elseif nargin<2
   if isnumeric(varargin{1})
      how_many = varargin{1};
      option = '';
   else
      how_many = [];
      option = varargin{1};
   end
else
   how_many = varargin{1};
   option = varargin{2};
end

if isempty(how_many)
   how_many = -1;
else
   if numel(how_many)~=1 || isinf(how_many) || isnan(how_many) || how_many<=0 || how_many~=fix(how_many)
      error('glinkaxes:NeedPositiveInt', 'Requires a positive integer.');
   end
end
if isempty(option)
   option = 'xy';
else
   if ~ischar(option) || ~any(strcmpi(option,{'x','y','xy','off'}))
      error('glinkaxes:InvalidOption','OPTION input argument must be one of ''x'', ''y'', ''xy'', or ''off''.');
   end
end

% Suspend figure functions
figs = findobj(get(0,'children'),'type','figure');
Nfig = numel(figs);
states = cell(1,Nfig);
toolbars = cell(1,Nfig);
ptButtons = cell(Nfig,1);
ptStates = cell(Nfig,2);
for n = 1:Nfig
   states{n} = uisuspend(figs(n));
   
   toolbars{n} = findobj(allchild(figs(n)),'flat','Type','uitoolbar');
   if ~isempty(toolbars{n})
      ptButtons{n} = [uigettool(toolbars{n},'Plottools.PlottoolsOff'), ...
         uigettool(toolbars{n},'Plottools.PlottoolsOn')];
      ptStates(n,:) = get (ptButtons{n},'Enable');
      set (ptButtons{n},'Enable','off');
   end
end
c = onCleanup(@()ocufcn(figs,states,toolbars,ptButtons,ptStates));   % set cleanup function to undo the suspension at termination time

% set up mouse click interaction callbacks for all figures
fig = gcf;
ax = [];
for n = 1:Nfig
   set(figs(n),'WindowButtonUpFcn',@wbufcn,'WindowKeyReleaseFcn',@wkrfcn);
end

% We need to pump the event queue on unix before calling WAITFORBUTTONPRESS
drawnow

% Wait until user finish selecting axes
uiwait(fig);

% Turn off the callbacks
for n = 1:Nfig
   set(figs(n),'WindowButtonUpFcn',{},'WindowKeyReleaseFcn',{});
end

% Run linkaxes if more than 1 axes are selected
if numel(ax)>1, linkaxes(ax,option); end

% output argument processing
if nargout > 0
   varargout{1} = ax;
end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % buttondown callback, stole from ginpnut.m
   function wbufcn(~,~)
      
      % get handle to the object that was clicked on
      obj = gco;
      
      % traverse up until get axes
      while ~isempty(obj) && ~strcmp(get(obj,'type'),'axes')
         obj = get(obj,'parent');
      end
      
      if isempty(obj), return; end

      ax = [ax obj];
      
      if numel(ax)==how_many
         uiresume(fig);
      end
      
   end

   function wkrfcn(~,event)
      
      if strcmp(event.Key,'return')
         uiresume(fig);
      end
      
   end

end

% OnCleanup Function
function ocufcn(figs,states,toolbars,ptButtons,ptStates)

for nn = 1:numel(figs)
   
   if ishghandle(figs(nn)) % restore only if figure is still open
      uirestore(states{nn});
      if ~isempty(toolbars) && ~isempty(ptButtons{nn})
         set (ptButtons{nn}(1),'Enable',ptStates{nn,1});
         set (ptButtons{nn}(2),'Enable',ptStates{nn,2});
      end
   end
end

end

% Copyright (c) 2011, Takeshi Ikuma
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%   * Redistributions of source code must retain the above copyright
%     notice, this list of conditions and the following disclaimer.
%   * Redistributions in binary form must reproduce the above copyright
%     notice, this list of conditions and the following disclaimer in the
%     documentation and/or other materials provided with the distribution.
%   * Neither the names of its contributors may be used to endorse or
%     promote products derived from this software without specific prior
%     written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
