function gridcolor(ax,grdStyle,gridvec,grdColor)
%GRIDCOLOR Adjust x, y and/or z grid color
%   GRIDCOLOR(AX,GRDSTYLE,GRDX,GRDY,GRDCOLOR) adjust the color of the grid
%      on the xgrid and/or ygrid of axis ax.
%      AX is the axis handle
%      GRDSTYLE is the style of the grid line (e.g. '--')
%      GRIDVEC is 1x3 vector of 0 or 1 to turn x, y and z grid 'off' or
%      'on', respectively.
%      
%      GRDCOLOR is the color of the grid line and is given as a cell array
%      (e.g. {'r','k'},{[1 0 0],'k'},{[1 0 0],[0 0 0]}). The cell array needs
%      to be of size 1x3 if zgrid is defined. If only one color is given
%      then all grids (if on) will be that color (e.g. {'r'}).
%      GRIDCOLOR is typically called at the end of the plotting
%
%   Example1 (regular plot):
%
%      figure(1)
%      t = 0:0.1:10;
%      plot(t,sin(t))
%      title('Example plot')
%      xlabel('x-axis')
%      ylabel('y-axis')
%      gridcolor(gca,'--',[1 1 0],{[1 0 0],'g',''})
%
%   Example2 (pcolor, works only if a second axis is added):
%
%      figure(2)
%      pcolor(magic(25));
%      shading flat
%      ax1=gca;
%      set(ax1,'Visible','off')
%      ax2 = copyobj(ax1,gcf);
%      ax2 = axes('Box','on','Color','none');
%      title('Example plot')
%      xlabel('x-axis')
%      ylabel('y-axis')
%      gridcolor(ax2,'--',[0 1 0],{[0.7 0.7 0.7]})
%
%   Example3 (imagesc, works only if a second axis is added):
%
%      figure(3)
%      imagesc(magic(25));
%      ax1=gca;
%      set(ax1,'Visible','off')
%      ax2 = copyobj(ax1,gcf);
%      ax2 = axes('Box','on','Color','none');
%      title('Example plot')
%      xlabel('x-axis')
%      ylabel('y-axis')
%      gridcolor(ax2,'--',[1 1 0],{[0.7 0.7 0.7],'k',''})
%
%   Example4 (3d plot):
%
%      figure(4)
%      t = 0:0.1:10;
%      plot3(t,sin(t),cos(t))
%      title('Example plot')
%      xlabel('x-axis')
%      ylabel('y-axis')
%      zlabel('z-axis')
%      gridcolor(gca,'--',[1 1 1],{[1 0 0],'g','m'})

% Author: Arnaud Laurent
% Creation : Nov 26th 2012
% MATLAB version: R2012a
%
% Notes: This is a personal implementation of a solution found in
% Matlab Central at the following link:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/266403
%
% Last modified: 26/11/2012

% Get original colors
xcol = get(ax,'XColor');
ycol = get(ax,'YColor');
zcol = get(ax,'ZColor');
xlabcol = get(get(ax,'xlabel'),'color');
ylabcol = get(get(ax,'ylabel'),'color');
zlabcol = get(get(ax,'zlabel'),'color');

% Check color input
if ~iscell(grdColor)
    error('Grid color must be a cell array!')
elseif numel(grdColor)<2
    grdColor = {grdColor{1},grdColor{1},grdColor{1}};
end

% Set grid lines
set(ax,'GridLineStyle',grdStyle);

if gridvec(1)
    set(ax,'Xcolor',grdColor{1},'Xgrid','on');
end

if gridvec(2)
    set(ax,'Ycolor',grdColor{2},'Ygrid','on');
end

if gridvec(3)
    set(ax,'Zcolor',grdColor{3},'Zgrid','on');
end

% Change grid lines color
axpos = get(ax,'Position');
set(ax,'Position',axpos)
Caxes = copyobj(ax,gcf);
set(Caxes,'Position',axpos,'color', 'none', 'xcolor', xcol, 'xgrid', 'off',...
    'ycolor', ycol, 'ygrid','off', 'zcolor', zcol, 'zgrid', 'off');
set(get(ax,'xlabel'),'color',xlabcol)
set(get(ax,'ylabel'),'color',ylabcol)
set(get(ax,'zlabel'),'color',zlabcol)
