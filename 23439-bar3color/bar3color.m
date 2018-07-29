function hh = bar3(varargin)
%BAR3   3-D bar graph.
%   BAR3(Y,Z) draws the columns of the M-by-N matrix Z as vertical 3-D
%   bars.  The vector Y must be monotonically increasing or
%   decreasing. 
%
%   BAR3(Z) uses the default value of Y=1:M.  For vector inputs,
%   BAR3(Y,Z) or BAR3(Z) draws LENGTH(Z) bars.  The colors are set by
%   the colormap.
%
%   BAR3(Y,Z,WIDTH) or BAR3(Z,WIDTH) specifies the width of the
%   bars. Values of WIDTH > 1, produce overlapped bars.  The default
%   value is WIDTH=0.8
%
%   BAR3(...,'detached') produces the default detached bar chart.
%   BAR3(...,'grouped') produces a grouped bar chart.
%   BAR3(...,'stacked') produces a stacked bar chart.
%   BAR3(...,LINESPEC) uses the line color specified (one of 'rgbymckw').
%
%   BAR3(AX,...) plots into AX instead of GCA.
%
%   H = BAR(...) returns a vector of surface handles in H.
%
%   Example:
%       subplot(1,2,1), bar3(peaks(5))
%       subplot(1,2,2), bar3(rand(5),'stacked')
%
%   See also BAR, BARH, and BAR3H.

%   Mark W. Reichelt 8-24-93
%   Revised by CMT 10-19-94, WSun 8-9-95
%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 1.30.6.5 $  $Date: 2005/04/28 19:55:59 $

error(nargchk(1,inf,nargin,'struct'));
[cax,args] = axescheck(varargin{:});

[msg,x,y,xx,yy,linetype,plottype,barwidth,zz] = makebars(args{:},'3');
if ~isempty(msg), error(msg); end %#ok

m = size(y,2);
% Create plot
cax = newplot(cax);
fig = ancestor(cax,'figure');

next = lower(get(cax,'NextPlot'));
hold_state = ishold(cax);
edgec = get(fig,'defaultaxesxcolor');
facec = 'flat';
h = []; 
cc = ones(size(yy,1),4);

if ~isempty(linetype)
    facec = linetype;
end
mycolor = zz;
mycolor(:,1:4:end) = mycolor(:,1:4:end) + mycolor(:,2:4:end);
mycolor(:,4:4:end) = mycolor(:,4:4:end) + mycolor(:,3:4:end);
mycolor(1:6:end,:) = mycolor(1:6:end,:)+mycolor(2:6:end,:);
mycolor((4:5):6:end,:) = mycolor((4:5):6:end,:)+mycolor((2:3):6:end,:);
%mycolor(5:6:end,:) = mycolor(5:6:end,:)+mycolor(3:6:end,:);

for i=1:size(yy,2)/4
    acolor = mycolor(:,(i-1)*4+(1:4)).*cc;
    h = [h,surface('xdata',xx+x(i),...
            'ydata',yy(:,(i-1)*4+(1:4)), ...
            'zdata',zz(:,(i-1)*4+(1:4)),...
            'cdata',acolor, ...
            'FaceColor',facec,...
            'EdgeColor',edgec,...
            'tag','bar3',...
            'parent',cax)];
end

if length(h)==1
    set(cax,'clim',[1 2]);
end

if ~hold_state, 
  % Set ticks if less than 16 integers
  if all(all(floor(y)==y)) && (size(y,1)<16) 
      set(cax,'ytick',y(:,1));
  end
  
 xTickAmount = sort(unique(x(1,:))); 
 if length(xTickAmount)<2
     set(cax,'xtick',[]);
 elseif length(xTickAmount)<=16
      set(cax,'xtick',xTickAmount);
 end  %otherwise, will use xtickmode auto, which is fine
  
  hold(cax,'off'), view(cax,3), grid(cax,'on')
  set(cax,...
      'NextPlot',next,...
      'ydir','reverse');
  if plottype==0,
    set(cax,'xlim',[1-barwidth/m/2 max(x)+barwidth/m/2])
  else
    set(cax,'xlim',[1-barwidth/2 max(x)+barwidth/2])
  end

  dx = diff(get(cax,'xlim'));
  dy = size(y,1)+1;
  if plottype==2,
    set(cax,'PlotBoxAspectRatio',[dx dy (sqrt(5)-1)/2*dy])
  else
    set(cax,'PlotBoxAspectRatio',[dx dy (sqrt(5)-1)/2*dy])
  end
end

if nargout>0, 
    hh = h; 
end
