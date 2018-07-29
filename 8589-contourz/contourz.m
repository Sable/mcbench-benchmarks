function handles = contourz(xi,yi,zi,vi,vv,theColor)
%CONTOURZ   3D contour plot on a surface
%   Similar to contour3 but contours are drawn over any surface
%   This function is also used to create clabels.
%
%   Syntax:
%      H = CONTOURZ(X,Y,Z,V,VV,COLOR)
%      H = CONTOURZ('clabel')
%
%   Inputs:
%      XI, YI   2-D arrays
%      ZI       Surface where contours will be drawn, defined at XI,YI
%      VI       2-D array to contour, defined at XI,YI
%      VV       Contour levels or number of contours [ 10 ]
%      COLOR    Color of contours, otherwise a patch is created
%      'clabel' Clabels are created manually as by clabel(cs,'manual')
%               Clabels are done clicking with left mouse button
%               until click with other button
%
%   Outputs:
%      H   handles of lines, patches for contours or handles for labels
%          (marker and text) for clabels
%
%   Comments:
%      This may be useful if you wanna add contours to a
%      surface created by surf(x,y,z,v).
%      Notice that if v = z, is the same as use contour3
%
%   Example:
%      figure
%      [x,y,v] = peaks;
%      z=-(x.^2+y.^2);
%      surf(x,y,z,'facecolor','none','edgealpha',.1)
%      hold on
%      contourz(x,y,z,v);
%      view(2)
%      contourz('clabel');
%      view(3)
%
%   MMA 8-2004, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

handles = [];

% --------------------------------------------------------------------
% clabel
% --------------------------------------------------------------------
if isequal(xi,'clabel')
  is_hold = ishold;
  hold on
  vw = view;
  %view(2);
  h=[];
  while 1
    [x,y,mouse] = ginput(1);
    if mouse ~= 1
      break
    end
    tag = get(gco,'tag');
    if isequal(tag,'contourz')
      % get closest point:
      xdata = get(gco,'xdata');
      ydata = get(gco,'ydata');
      zdata = get(gco,'zdata');
      dist = (xdata-x).^2 + (ydata-y).^2;
      i=find(dist == min(dist));

      level = get(gco,'userdata');  
      p=plot3(xdata(i),ydata(i),zdata(i),'r+');
      t=text(xdata(i),ydata(i),zdata(i),num2str(level), ...
        'HorizontalAlignment','left');

      h=[h;p;t];
    end
  end
  view(vw)
  handles = h;

  if ~is_hold
    hold off
  end

  return
end

% --------------------------------------------------------------------
% contour
% --------------------------------------------------------------------
if nargin < 4
  disp('» contourz: arguments required');
  return
end

if nargin == 4
  vv    = 10;
end
if nargin == 5 & isstr(vv)
  theColor=vv;
  vv = 10;
end

do_line = 1;
eval('lineColor = theColor;','lineColor = [];')
if isempty(lineColor)
  do_line  = 0;
else
  if ~isempty(str2num(lineColor)); % allow colors as ['r g b'] (as string)
    lineColor = str2num(lineColor);
  end
end

c_xz = contours(xi,zi,vi,vv);
c_yz = contours(yi,zi,vi,vv);

i = 1;
n = 1;
if isempty(c_xz) | isempty(c_yz)
  return
end

while 1
  lev(n) = c_xz(1,i);
  nvals  = c_xz(2,i);
  x{n}   = c_xz(1,i+1:i+nvals);
  y{n}   = c_yz(1,i+1:i+nvals);
  z{n}   = c_xz(2,i+1:i+nvals);
  i = i+nvals+1;
  if i > size(c_xz,2)
    break
  else
    n=n+1;
  end
end

h=[];
for n=1:length(x)
  if do_line
    p=plot3(x{n},y{n},z{n},'color',lineColor,'userdata',lev(n),'tag','contourz'); hold on
  else
    xdata = [x{n} nan];
    ydata = [y{n} nan];
    zdata = [z{n} nan];
    level = lev(n);
    vdata = [repmat(level,size(x{n})) nan];
    p = patch('XData',xdata,'YData',ydata,'ZData',zdata, ...
              'CData',vdata,'userdata',level,'tag','contourz', ...
              'facecolor','none','edgecolor','flat');
  end
  h=[h;p];
end

handles = h;
