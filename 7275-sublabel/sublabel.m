function [htext,hnewax]=sublabel(varargin)
% function [htext]=sublabel
%  sublabel labels sub-plots from haxes in order as "a", "b",
%  "c".  By default it puts them 12 points from the upper left corner. 
%
% can also be called:
%   [htext]=sublabel(ax,dx,dy)
% where ax are the axes handles to be labeled.  dx and dy are offsets from
% the upper left corner (in points).   
%  
% Can also be called:
%   [htext]=sublabel(ax,dx,dy,varargin);
%   [htext]=sublabel(varargin);
%   [htext]=sublabel(ax,varargin);
%   [htext]=sublabel(ax,dx,varargin);
% where varargin is any pair of properties valid for text objects
%  eg:
%    >> haxes(1) = subplot(2,1,1);
%    >> plot(1:10);
%    >> haxes(2) = subplot(2,1,2);
%    >> plot(1:2:20);
%    >> htext=sublabel(haxes);
% Or:
%    >> htext =
%    sublabel(haxes,'fontsize',8,'fontweight','bold','backgroundcolor','g');
%    >> htext =
%    sublabel(haxes,24,36,'fontsize',8,'fontweight','bold','backgroundcolor','g');
  
% $Revision: 1.1 $ $Date: 2005/04/04 15:36:24 $ $Author: jklymak $	
% J. Klymak.  August 8, 2000...
  
fsize = 12; % default fontsize, points....
fname = 'times'; % font...
  
haxes=flipud(datachildren(gcf));
toffset=12;
roffset=12;
num = 0;
while ~isempty(varargin) & ~isstr(varargin{1})
  num = num+1;
  if ~isempty(varargin{1})
    if num==1
      haxes=varargin{1};
    elseif num==2
      toffset=varargin{1};
    elseif num==3
      roffset=varargin{1}
    else
      error('invalid parameter/value pair.');
    end;
  end;
  varargin=varargin(2:end);
end;


for i=1:length(haxes)
  uni = get(haxes(i),'units');
  hnewax(i)=axes('units',uni,'pos',get(haxes(i),'pos'));
  set(hnewax(i),'visible','off','units','points');
  poss = get(hnewax(i),'pos'); % this is how big the axis is in points...
  axis([poss(1) poss(1)+poss(3) poss(2) poss(2)+poss(4)]);
  x = poss(1)+roffset;
  y = poss(2)+toffset;
  set(hnewax(i),'ydir','rev');  
  htext(i)=text(x,y,0,sprintf('%c',['a'+i-1]),'fontname', ...  
                fname,'fontsize',fsize,'backgroundcolor','w',varargin{:});
  set(hnewax(i),'visible','off','units',uni,'hittest','off');
  setappdata(hnewax(i),'NonDataObject',[]); % Used by DATACHILDREN.M.
                                            % This makes it
                                            % invulnerable to zooming etc
end;

return;

