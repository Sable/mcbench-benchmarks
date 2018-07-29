function alwaysontop(hFig)
% ALWAYSONTOP adds a pushtool to the figure toolbar for the "Always on top"-option.
%
% ALWAYSONTOP 
%     adds the pushtool to the current figure.
%
% ALWAYSONTOP(hFig)
%     adds the pushtool to the figure with handle hFig.
%
% ALWAYSONTOP('auto')
%     adds the pushtool to the each new created figure automatically.
%
% ALWAYSONTOP('remove')
%     remove the automatically adding of pushtools to new figures.
%
% See also: UISWITCHRENDERER (in FileExchange)
%
% Version v1.3
% last update: 21-Dec-2011
% Author: Elmar Tarajan [MCommander@gmx.de]

persistent lh_add
%
if nargin == 0
   hFig = gcf;
end% if
%
if ishandle(hFig)
   add_pushtool(hFig)
else
   switch hFig
      case 'auto'
         lh_add = addlistener(0,'ObjectChildAdded',@(a,b) add_pushtool(gcf));
      case 'remove'
         if ~isempty(lh_add)
            delete(lh_add)
         end% if
   end% switch
end% if

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function add_pushtool(hFig)
%-------------------------------------------------------------------------------
hToolbar = findall(hFig,'Type','uitoolbar');
if ~isempty(hToolbar) && isempty(findall(hFig,'Type','uipushtool','Tag','alwaysontop'))
   %
   warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
   jf = get(hFig,'JavaFrame');
   %
   hPush = uipushtool( ...
      'parent',hToolbar, ...
      'separator','on', ...
      'HandleVisibility','off', ...
      'TooltipString','always on top', ...
      'cdata',icon('on'), ...
      'tag','alwaysontop', ...
      'clickedcallback',{@update_pushtool,jf,'on'});
   %
end% if
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_pushtool(hPush,data,jf,action)
%-------------------------------------------------------------------------------
switch action
   case 'on'
%      jf.fFigureClient.getWindow.setAlwaysOnTop(1)
      jf.fHG1Client.getWindow.setAlwaysOnTop(1)
      set(hPush,'cdata',icon('off'),'clickedcallback',{@update_pushtool,jf,'off'})
   case 'off'
      % jf.fFigureClient.getWindow.setAlwaysOnTop(0)
      jf.fHG1Client.getWindow.setAlwaysOnTop(0)
      set(hPush,'cdata',icon('on'),'clickedcallback',{@update_pushtool,jf,'on'})
end% switch
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function img = icon(action)
%-------------------------------------------------------------------------------
img(:,:,1) = [ ...
   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
   NaN NaN NaN NaN NaN NaN NaN NaN NaN .82 .86 .81 NaN NaN NaN NaN
   NaN NaN NaN NaN NaN NaN NaN NaN NaN .86 1.0 .83 .80 NaN NaN NaN
   NaN NaN NaN NaN NaN NaN NaN NaN NaN .86 1.0 .98 .78 .78 NaN NaN
   NaN NaN NaN NaN NaN NaN NaN NaN .82 .84 .97 .88 .86 .69 .74 NaN
   NaN NaN .85 .86 .86 .85 .82 .82 .86 1.0 .92 .83 .89 .93 .63 NaN
   NaN NaN .76 1.0 .99 .96 .90 .84 1.0 .92 .89 .68 .65 .63 .73 NaN
   NaN NaN .78 .74 1.0 .98 .95 .94 .92 .89 .63 .73 NaN NaN NaN NaN
   NaN NaN NaN .77 .72 .98 .90 .85 .85 .70 .74 NaN NaN NaN NaN NaN
   NaN NaN NaN NaN .63 .70 .91 .81 .81 .76 .72 NaN NaN NaN NaN NaN
   NaN NaN NaN .76 .47 .73 .69 .85 .86 .85 .66 NaN NaN NaN NaN NaN
   NaN NaN .79 .53 .84 .41 .60 .66 .92 .92 .63 NaN NaN NaN NaN NaN
   NaN NaN .60 .68 .48 .74 NaN .75 .65 .93 .62 NaN NaN NaN NaN NaN
   NaN .66 .49 .56 .79 NaN NaN NaN .70 .63 .58 NaN NaN NaN NaN NaN
   .70 .38 .55 .64 .65 .66 .68 .69 .70 .72 .73 .74 .76 .77 .78 .79
   .75 .72 .71 .72 .72 .72 .73 .74 .75 .76 .76 .77 .77 .78 .79 .79
   ];
img(:,:,2) = [ ...
   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
   NaN NaN NaN NaN NaN NaN NaN NaN NaN .61 .26 .60 NaN NaN NaN NaN
   NaN NaN NaN NaN NaN NaN NaN NaN NaN .26 .65 .25 .60 NaN NaN NaN
   NaN NaN NaN NaN NaN NaN NaN NaN NaN .25 .55 .57 .22 .59 NaN NaN
   NaN NaN NaN NaN NaN NaN NaN NaN .61 .25 .50 .30 .32 .18 .57 NaN
   NaN NaN .39 .26 .28 .36 .50 .61 .26 .61 .36 .26 .29 .33 .16 NaN
   NaN NaN .16 .66 .55 .50 .37 .26 .61 .36 .35 .18 .16 .16 .57 NaN
   NaN NaN .57 .16 .63 .45 .43 .46 .36 .35 .16 .57 NaN NaN NaN NaN
   NaN NaN NaN .57 .16 .56 .34 .28 .30 .19 .57 NaN NaN NaN NaN NaN
   NaN NaN NaN NaN .49 .16 .42 .21 .22 .22 .46 NaN NaN NaN NaN NaN
   NaN NaN NaN .76 .47 .73 .16 .30 .25 .28 .27 NaN NaN NaN NaN NaN
   NaN NaN .79 .53 .84 .41 .47 .16 .32 .32 .18 NaN NaN NaN NaN NaN
   NaN NaN .60 .68 .48 .74 NaN .57 .16 .33 .16 NaN NaN NaN NaN NaN
   NaN .66 .49 .56 .79 NaN NaN NaN .57 .16 .32 NaN NaN NaN NaN NaN
   .70 .38 .55 .64 .65 .66 .68 .69 .70 .72 .73 .74 .76 .77 .78 .79
   .75 .72 .71 .72 .72 .72 .73 .74 .75 .76 .76 .77 .77 .78 .79 .79
   ];
switch action
   case 'on'
      img(:,:,2) = img(:,:,1);
      img(:,:,3) = img(:,:,1);       
   case 'off'
      img(:,:,3) = img(:,:,2);
end% switch
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% I LOVE MATLAB! You too? :) %%%