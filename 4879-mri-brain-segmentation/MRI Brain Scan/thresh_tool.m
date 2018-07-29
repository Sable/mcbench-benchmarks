function level = thresh_tool(im,cmap)
%THRESH_TOOL - GUI tool for selecting threshold level
%
%  Example 1 - nonblocking behavior:
%    x=imread('rice.png');
%    thresh_tool(x) %no return value, so MATLAB keeps running
%
%  Example 2 - blocking behavior:
%    x=imread('rice.png');
%    lev=thresh_tool(x) %MATLAB waits for GUI tool to finish first

% Copyright 2004-2010 The MathWorks, Inc.

max_colors=1000;    %practical limit

%calculate bins centers
color_range = double(limits(im));
if isinteger(im)
  %try direct indices first
  num_colors=diff(color_range)+1;
  if num_colors<max_colors %okay
    di=1;                               %inherent bins
  else %too many levels
    num_colors=max_colors;                  %practical limit 
    di=diff(color_range)/(num_colors-1);
  end
else %noninteger
  %try infering discrete resolution first (intensities often quantized)
  di=min(diff(sort(unique(im(:)))));
  num_colors=diff(color_range)/di+1;
  if num_colors>max_colors %too many levels
    num_colors=max_colors;                  %practical limit
    di=diff(color_range)/(num_colors-1);
  end
end
bin_ctrs = [color_range(1):di:color_range(2)];
FmtSpec=['%.' num2str(ceil(-log10(di))) 'f'];

%new figure - interactive GUI tool for level segmenting
h_fig=figure;
if nargin>1 & isstr(cmap) & strmatch(lower(cmap),'gray')
  full_map=gray(num_colors);
else
  full_map=jet(num_colors);
end
setappdata(h_fig,'im',im)
setappdata(h_fig,'FmtSpec',FmtSpec)

%top left - input image
h_ax1=axes('unit','norm','pos',[0.05 0.35 0.4 0.60]);
subimage(im,full_map)
axis off, title('Input Image')

%top right - segmented (eventually)
h_ax2=axes('unit','norm','pos',[0.55 0.35 0.4 0.60]);
axis off
setappdata(h_fig,'h_ax2',h_ax2)

%next to bottom - intensity distribution
h_hist=axes('unit','norm','pos',[0.05 0.1 0.9 0.2]);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bin_ctrs=[0:double(max(im(:)))];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n=hist(double(im(:)),bin_ctrs);
bar(bin_ctrs,n)
axis([color_range limits(n(2:end))])
set(h_hist,'xtick',[],'ytick',[])
title('Intensity Distribution')

%very bottom - colorbar
h_cbar=axes('unit','norm','pos',[0.05 0.05 0.9 0.05],'tag','thresh_tool_cbar');
subimage(color_range,[0.5 1.5],1:num_colors,full_map)
set(h_cbar,'ytick',[],'xlim',color_range)
axis normal

%colorbar tick locations
set(h_cbar,'xtick',color_range)

%threshold level - initial guess (graythresh)
lo=double(color_range(1));
hi=double(color_range(2));
norm_im=(double(im)-lo)/(hi-lo);
norm_level=graythresh(norm_im);     %GRAYTHRESH assumes DOUBLE range [0,1]
my_level=norm_level*(hi-lo)+lo;

%display level as vertical line
axes(h_hist)
h_lev=vline(my_level,'-');
set(h_lev,'LineWidth',2,'color',0.5*[1 1 1],'UserData',my_level)
setappdata(h_fig,'h_lev',h_lev)

%attach draggable behavior for user to change level
move_vline(h_lev,@update_plot);

axes(h_cbar)
y_lim = get(h_cbar,'ylim');

% PLACE TEXT LOCATION ON COLORBAR (Laurens)
%h_text = text(my_level,mean(y_lim),num2str(round(my_level)));
h_text = text(my_level,mean(y_lim),'dummy','HorizontalAlignment','Center');
if nargin<2
  text_color=0.5*[1 1 1];
else
  text_color='m';
end
set(h_text,'FontWeight','Bold','color',text_color,'Tag','cbar_text')
movex_text(h_text,my_level)
%%%%%%%%%%%%%%%%%%%%%%%%

%segmented image
bw=(im>my_level);
axes(h_ax2)
hold on
subimage(bw), axis off, axis ij
hold off
title('Segmented')

update_plot

%add reset button (resort to initial guess)
h_reset = uicontrol('unit','norm','pos',[0.0 0.95 .1 .05]);
set(h_reset,'string','Reset','callback',@ResetOriginalLevel)

if nargout>0
  h_done=uicontrol('unit','norm','pos',[0.9 0.95 0.1 0.05]);
  set(h_done,'string','Done','callback',@DeleteDoneButton)
  set(h_fig,'WindowStyle','modal')
  waitfor(h_done)
  if ishandle(h_fig)
    h_lev=getappdata(gcf,'h_lev');
    level=mean(get(h_lev,'xdata'));
    delete(h_fig)
  else
    warning('User aborted; no return value.')
    level=[];
  end
end


function DeleteDoneButton(hObject,varargin)
delete(hObject)


function ResetOriginalLevel(hObject,varargin)
h_lev = getappdata(gcf,'h_lev');
init_level = get(h_lev,'UserData');
set(h_lev,'XData',init_level*[1 1])
text_obj = findobj('Type','Text','Tag','cbar_text');
movex_text(text_obj,init_level)
update_plot


function update_plot
im=getappdata(gcf,'im');
h_lev=getappdata(gcf,'h_lev');
my_level=mean(get(h_lev,'xdata'));
h_ax2=getappdata(gcf,'h_ax2');
h_im2=findobj(h_ax2,'type','image');
%segmented image
bw=(im>my_level);
rgb_version=repmat(double(bw),[1 1 3]);
set(h_im2,'cdata',rgb_version)
