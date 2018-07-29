function [level,level2,bw] = manual_thresh(im,cmap,defaultLevel) %mainfunction
%   manual_thresh  Interactively select intensity levels band for image thresholding.
%   manual_thresh launches a GUI (graphical user interface) for thresholding
%   an intensity input image, IM. IM is displayed in the top of the figure . A 
%   colorbar and IM's histogram are displayed on the bottom. lines on the
%   histogram indicates the current threshold levels. The segmented image
%   (with the intensity levels between the low and high threshold levels is
%    displayed as a upper layer with tranperent background on the top of the image.  To change the
%   level, click and drag the lines or use the editable text or sliders. The output image updates automatically.
% 
%   There are two ways to use this tool.
% 
% Mode 1 - nonblocking behavior:
%    manual_thresh  (IM) launches GUI tool.  You can continue using the MATLAB
%   Desktop.  Since no results are needed, the function does not block
%   execution of other commands.
% 
%    manual_thresh  (IM,CMAP) allows the user to specify the colormap, CMAP.  If
%   not specified, the default colormap is used.
% 
%    manual_thresh  (IM,CMAP,DEFAULTLEVEL) allows the user to specify the
%   default low threshold level. If not specified, DEFAULTLEVEL is determined
%   by GRAYTHRESH. Valid values for DEFAULTLEVEL must be consistent with
%   the data type of IM for integer intensity images: uint8 [0,255], uint16
%   [0,65535], int16 [-32768,32767].
% 
%   Example
%       x = imread('coins.png');
%       manual_thresh(x)          %no return value, so MATLAB keeps running
% 
% Mode 2 - blocking behavior:
%   [LOW LEVEL, HIGH LEVEL] =  manual_thresh (...) returns the user selected levels, LOW LEVEL $ HIGH LEVEL, and
%   MATLAB waits for the result before proceeding.  This blocking behavior
%   mode allows the tool to be inserted into an image processing algorithm
%   to support an automated workflow.
% 
%   [LOW LEVEL, HIGH LEVEL,BW] = manual_thresh(...) also returns the thresholded binary 
%   output image, BW.
% 
%   Example
%       x = imread('coins.png');
%        [LOW LEVEL, HIGH LEVEL]  = manual_thresh(x')    %MATLAB waits for GUI tool to finish

% By Yishay Tauber JSC,Physics department,Bar Ilan University,Israel.
% Based on thresh_tool by Robert Bemis found in MATLAB CENTRAL
 


%defensive programming
error(nargchk(1,3,nargin))
error(nargoutchk(0,3,nargout))

%validate defaultLevel within range
if nargin>2 %user specified DEFAULTLEVEL
  dataType = class(im);
  switch dataType
    case {'uint8','uint16','int16'}
      if defaultLevel<intmin(dataType) | defaultLevel>intmax(dataType)
        error(['Specified DEFAULTLEVEL outside class range for ' dataType])
      elseif defaultLevel<min(im(:)) | defaultLevel>max(im(:))
        error('Specified DEFAULTLEVEL outside data range for IM')
      end
      case{ 'double','single'}
      %okay, do nothing
    otherwise
      error(['Unsupport image type ' dataType])
  end %switch
end

max_colors=1000;    %practical limit

%calculate bins centers
color_range = double(limits(im));
if isinteger(im)
  %try direct indices first
  num_colors = diff(color_range)+1;
  if num_colors<max_colors %okay
    di = 1;                                 %inherent bins
  else %too many levels
    num_colors = max_colors;                %practical limit
    di = diff(color_range)/(num_colors-1);
  end
else %noninteger
  %try infering discrete resolution first (intensities often quantized)
  di = min(diff(sort(unique(im(:)))));
  num_colors = round(diff(color_range)/di)+1;
  if num_colors>max_colors %too many levels
    num_colors = max_colors;                %practical limit
    di = diff(color_range)/(num_colors-1);
  end
end
bin_ctrs = [color_range(1):di:color_range(2)];
%new figure - interactive GUI tool for level segmenting
scrsz = get(0,'ScreenSize');

h_fig = figure('Position',[ scrsz(3)/10 scrsz(4)/10 8*scrsz(3)/10 8*scrsz(4)/10]);
set(h_fig,'ToolBar','Figure')
if nargin>1 && isstr(cmap) && strcmp(lower(cmap),'jet')
  full_map = jet(num_colors);
elseif nargin>1 && isnumeric(cmap) && length(size(cmap))==2 && size(cmap,2)==3
  full_map = cmap;
else
full_map = gray (num_colors);
end
  h_ax1 = axes('unit','norm','pos',[0.1 0.25 0.8 0.7]);
setappdata(h_fig,'im',im)
%top  - input image
 colormap(full_map);
imagesc(im);
axis image
axis off
 hold on
sizeim=size(im);
layer=ones (sizeim(1),sizeim(2));
back=ind2rgb(layer,[1 0 0]);
threshimage=image(back);
axis image
axis off
setappdata (h_fig,'threshimage',threshimage);
% bottom - color bar
cbar=colorbar('location','southoutside');
set(cbar,'unit','norm','Position',[0.05 0.05 0.9 0.05]);
set(cbar,'xlim',[0 color_range(2)],'xtick',[0 color_range(2)])


%next to bottom - intensity distribution
h_hist = axes('unit','norm','pos',[0.05 0.1 0.9 0.1]);
n = hist(double(im(:)),bin_ctrs);
bar(bin_ctrs,n)

axis([[0 color_range(2)+1] limits(n(2:end-1))]) %ignore saturated end scaling
set(h_hist,'xtick',[],'ytick',[])
title('Intensity Distribution')
%threshold level - initial guess (graythresh)
lo = double(color_range(1));
  hi = double(color_range(2));
if nargin>2 %user specified default level
  low_level = defaultLevel;
else %graythresh default
  
  norm_im = (double(im)-lo)/(hi-lo);
  norm_level = graythresh(norm_im); %GRAYTHRESH assumes DOUBLE range [0,1]
  low_level = norm_level*(hi-lo)+lo;
end
high_level=hi;
%uicontrols (text edit & slider)
low_level_edit = uicontrol('Style','edit','unit','norm','Position',[0.055,0.8,0.05,0.03]);
set(low_level_edit,'BackgroundColor','white','String',num2str(floor(low_level)),'callback',@low_level_edit_Callback);
setappdata(h_fig,'low_level_edit',low_level_edit);
high_level_edit = uicontrol('Style','edit','unit','norm','Position',[0.055,0.72,0.05,0.03]);
set(high_level_edit,'BackgroundColor','white','String',num2str(ceil(high_level)),'callback',@high_level_edit_Callback);
setappdata(h_fig,'high_level_edit',high_level_edit);
low_level_slider=uicontrol('Style','slider','unit','norm','Position',[0.005,0.77,0.1,0.03]);
high_level_slider=uicontrol('Style','slider','unit','norm','Position',[0.005,0.69,0.1,0.03]);
set (low_level_slider,'Value',low_level,'Min',lo,'Max',hi,'SliderStep',[(1/(hi-lo)) 0.1],'callback',@low_level_slider_Callback);
set (high_level_slider,'Value',low_level,'Min',lo,'Max',hi,'SliderStep',[(1/(hi-lo)) 0.1],'callback',@high_level_slider_Callback);
setappdata(h_fig,'low_level_slider',low_level_slider);
setappdata(h_fig,'high_level_slider',high_level_slider);
uicontrol('Style','text','String','low:','unit','norm','Position',[0.005,0.8,0.05,0.03]);
uicontrol('Style','text','String','high:','unit','norm','Position',[0.005,0.72,0.05,0.03]);
%display level as vertical line
axes(h_hist)
h_lev = vline(low_level,'-');
h_lev2 = vline(high_level,'-');
set(h_lev,'LineWidth',2,'color',0.5*[1 0 0],'UserData',low_level)
set(h_lev2,'LineWidth',2,'color',0.5*[0 0 1],'UserData',high_level)
setappdata(h_fig,'h_lev',h_lev)
setappdata(h_fig,'h_lev2',h_lev2)
%attach draggable behavior for user to change level
move_vlines(h_lev,h_lev2,@update_plot);

update_plot

%add reset button 
h_reset = uicontrol('unit','norm','pos',[0.0 0.95 .1 .05]);
set(h_reset,'string','Reset','callback',@ResetOriginalLevel)

if nargout>0 %return result(s)
  h_done = uicontrol('unit','norm','pos',[0.9 0.95 0.1 0.05]);
  set(h_done,'string','Done','callback','delete(gcbo)') %better
  %inspect(h_fig)
  set(h_fig,'WindowStyle','modal')
  waitfor(h_done)
  if ishandle(h_fig)
    h_lev = getappdata(gcf,'h_lev');
    level = mean(get(h_lev,'xdata'));
    h_lev2 = getappdata(gcf,'h_lev2');
    level2 = mean(get(h_lev2,'xdata'));
    if nargout>2
          thresh = getappdata(gcf,'threshimage');
       bw = logical(get(thresh,'AlphaData'));
    end
    delete(h_fig)
  else
    warning('THRESHTOOL:UserAborted','User Aborted - no return value')
    level = [];
  end
end

end %manual_thresh (mainfunction)


function ResetOriginalLevel(hObject,varargin) %subfunction
h_lev = getappdata(gcf,'h_lev');
init_level = get(h_lev,'UserData');
set(h_lev,'XData',init_level*[1 1])
h_lev2 = getappdata(gcf,'h_lev2');
high_level = get(h_lev2,'UserData');
set(h_lev2,'XData',high_level*[1 1])
update_plot
end %ResetOriginalLevel (subfunction)


function update_plot %subfunction
im = getappdata(gcf,'im');
h_lev = getappdata(gcf,'h_lev');
h_lev2 = getappdata(gcf,'h_lev2');
low_level = mean(get(h_lev,'xdata'));
high_level = mean(get(h_lev2,'xdata'));
text1=getappdata(gcf,'low_level_edit');
text2=getappdata(gcf,'high_level_edit');
slider1=getappdata(gcf,'low_level_slider');
slider2=getappdata(gcf,'high_level_slider');
 set (text1,'String',num2str(floor(low_level))); set (slider1,'Value',floor(low_level));
 set (text2,'String',num2str(ceil(high_level))); set (slider2,'Value',ceil(high_level));
h_ax1 = getappdata(gcf,'threshimage');
%segmented image using upper layer with tranperent background
bw = (((im>=low_level).*(im<=high_level)));
 set(h_ax1, 'AlphaData', bw);

end %update_plot (subfunction)


%function rgbsubimage(im,map), error('DISABLED')


%----------------------------------------------------------------------
function move_vlines(handle1,handle2,DoneFcn) %subfunction
%move_vlines implements horizontal movement of two lines.
%
%  
%Note: This tools strictly requires MOVEX_TEXT, and isn't much good
%      without VLINE by Brandon Kuczenski, available at MATLAB Central.
%<http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=1039&objectType=file>

% This seems to lock the axes position
set(gcf,'Nextplot','Replace')
set(gcf,'DoubleBuffer','on')

h_ax=get(handle1,'parent');
h_fig=get(h_ax,'parent');
setappdata(h_fig,'h_vline',handle1)
setappdata(h_fig,'h_vline2',handle2)
if nargin<3, DoneFcn=[]; end
setappdata(h_fig,'DoneFcn',DoneFcn)
set(handle1,'ButtonDownFcn',@DownFcn)
set(handle2,'ButtonDownFcn',@DownFcn2)
  function DownFcn(hObject,eventdata,varargin) %Nested--%
    set(gcf,'WindowButtonMotionFcn',@MoveFcn)           %
    set(gcf,'WindowButtonUpFcn',@UpFcn)                 %
  end %DownFcn------------------------------------------%
function DownFcn2(hObject,eventdata,varargin) %Nested--%
    set(gcf,'WindowButtonMotionFcn',@MoveFcn2)           %
    set(gcf,'WindowButtonUpFcn',@UpFcn)                 %
  end %DownFcn------------------------------------------%

  function UpFcn(hObject,eventdata,varargin) %Nested----%
    set(gcf,'WindowButtonMotionFcn',[])                 %
    DoneFcn=getappdata(hObject,'DoneFcn');              %
    if isstr(DoneFcn)                                   %
      eval(DoneFcn)                                     %
    elseif isa(DoneFcn,'function_handle')               %
      feval(DoneFcn)                                    %
    end                                                 %
  end %UpFcn--------------------------------------------%

  function MoveFcn(hObject,eventdata,varargin) %Nested------%
    h_vline=getappdata(hObject,'h_vline');                  %
    h_ax=get(h_vline,'parent');                             %
    cp = get(h_ax,'CurrentPoint');                          %
    h_fig=get(h_ax,'parent');
    high_level=get (getappdata(h_fig,'h_vline2'),'XData');
    xpos = cp(1); 
    x_range=get(h_ax,'xlim');%
    x_range=[x_range(1) high_level(1)];                               %
    if xpos<x_range(1), xpos=x_range(1); end                %
    if xpos>x_range(2), xpos=x_range(2); end                %
    XData = get(h_vline,'XData');                           %
    XData(:)=xpos;                                          %
    set(h_vline,'xdata',XData)                              %
                      
    
  end %MoveFcn----------------------------------------------%
function MoveFcn2(hObject,eventdata,varargin) %Nested------%
    h_vline=getappdata(hObject,'h_vline2');                  %
    h_ax=get(h_vline,'parent');                             %
    cp = get(h_ax,'CurrentPoint');                          %
    h_fig=get(h_ax,'parent');
    low_level=get (getappdata(h_fig,'h_vline'),'XData');
    xpos = cp(1); 
    x_range=get(h_ax,'xlim');%
    x_range=[low_level(1) x_range(2)];                               %
    if xpos<x_range(1), xpos=x_range(1); end                %
    if xpos>x_range(2), xpos=x_range(2); end       
    XData = get(h_vline,'XData');                           %
    XData(:)=xpos;                                          %
    set(h_vline,'xdata',XData)                              %
    
  end %MoveFcn----------------------------------------------%

end %move_vlines(subfunction)



%----------------------------------------------------------------------
function [x,y] = limits(a) %subfunction
% LIMITS returns min & max values of matrix; else scalar value.
%
%   [lo,hi]=LIMITS(a) returns LOw and HIgh values respectively.
%
%   lim=LIMITS(a) returns 1x2 result, where lim = [lo hi] values

if nargin~=1 | nargout>2 %bogus syntax
  error('usage: [lo,hi]=limits(a)')
end

siz=size(a);

if prod(siz)==1 %scalar
  result=a;                         % value
else %matrix
  result=[min(a(:)) max(a(:))];     % limits
end

if nargout==1 %composite result
  x=result;                         % 1x2 vector
elseif nargout==2 %separate results
  x=result(1);                      % two scalars
  y=result(2);
else %no result
  ans=result                        % display answer
end

end %limits (subfunction)





%--------------------------------------------------------------------------------------------------------------
function hhh=vline(x,in1,in2) %subfunction
% function h=vline(x, linetype, label)
% 
% Draws a vertical line on the current axes at the location specified by 'x'.  Optional arguments are
% 'linetype' (default is 'r:') and 'label', which applies a text label to the graph near the line.  The
% label appears in the same color as the line.
%
% The line is held on the current axes, and after plotting the line, the function returns the axes to
% its prior hold state.
%
% The HandleVisibility property of the line object is set to "off", so not only does it not appear on
% legends, but it is not findable by using findobj.  Specifying an output argument causes the function to
% return a handle to the line, so it can be manipulated or deleted.  Also, the HandleVisibility can be 
% overridden by setting the root's ShowHiddenHandles property to on.
%
% h = vline(42,'g','The Answer')
%
% returns a handle to a green vertical line on the current axes at x=42, and creates a text object on
% the current axes, close to the line, which reads "The Answer".
%
% vline also supports vector inputs to draw multiple lines at once.  For example,
%
% vline([4 8 12],{'g','r','b'},{'l1','lab2','LABELC'})
%
% draws three lines with the appropriate labels and colors.
% 
% By Brandon Kuczenski for Kensington Labs.
% brandon_kuczenski@kensingtonlabs.com
% 8 November 2001

% Downloaded 8/7/03 from MATLAB Central
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=1039&objectType=file

if length(x)>1  % vector input
    for I=1:length(x)
        switch nargin
        case 1
            linetype='r:';
            label='';
        case 2
            if ~iscell(in1)
                in1={in1};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            label='';
        case 3
            if ~iscell(in1)
                in1={in1};
            end
            if ~iscell(in2)
                in2={in2};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            if I>length(in2)
                label=in2{end};
            else
                label=in2{I};
            end
        end
        h(I)=vline(x(I),linetype,label);
    end
else
    switch nargin
    case 1
        linetype='r:';
        label='';
    case 2
        linetype=in1;
        label='';
    case 3
        linetype=in1;
        label=in2;
    end

    
    
    
    g=ishold(gca);
    hold on

    y=get(gca,'ylim');
    h=plot([x x],y,linetype);
    if length(label)
        xx=get(gca,'xlim');
        xrange=xx(2)-xx(1);
        xunit=(x-xx(1))/xrange;
        if xunit<0.8
            text(x+0.01*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
        else
            text(x-.05*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
        end
    end     

    if g==0
    hold off
    end
    set(h,'tag','vline','handlevisibility','off')
end % else

if nargout
    hhh=h;
end

end %vline (subfunction)
%callbacks for the uicontrols
function low_level_edit_Callback (hObject, eventdata)
      level=str2double(get(hObject,'String')) ;
      h_lev = getappdata(gcf,'h_lev');
      h_lev2 = getappdata(gcf,'h_lev2');
            high=get(h_lev2,'XData');
             slidermin=floor(get(getappdata(gcf,'low_level_slider'),'Min'));
     if (level<=slidermin)
         set(hObject,'String',num2str(slidermin));
         set(h_lev,'XData',slidermin*[1 1])
     elseif (level<high(1))
      set(h_lev,'XData',level*[1 1])
      else
      set(h_lev,'XData',high);
           end                 
       feval(@update_plot)
end
function high_level_edit_Callback (hObject, eventdata)
      level=str2double(get(hObject,'String')) ;
      h_lev = getappdata(gcf,'h_lev');
      h_lev2 = getappdata(gcf,'h_lev2');      
     low=get(h_lev,'XData');
     slidermax=ceil(get(getappdata(gcf,'high_level_slider'),'Max'));
     if (level>=slidermax)
         set(hObject,'String',num2str(slidermax));
         set(h_lev2,'XData',slidermax*[1 1])
     elseif (level>low(1))
      set(h_lev2,'XData',level*[1 1])
           else
      set(h_lev2,'XData',low)
                  end                 
       feval(@update_plot)
end
function low_level_slider_Callback (hObject, eventdata)
level=get(hObject,'Value') ;
      h_lev = getappdata(gcf,'h_lev');
      h_lev2 = getappdata(gcf,'h_lev2');
      high=get(h_lev2,'XData');
                  if (level<high(1))
      set(h_lev,'XData',level*[1 1]);
            else
      set(h_lev,'XData',high);
     set (text,'String',num2str(ceil(high(1))));
          end                 
       feval(@update_plot)
end
function high_level_slider_Callback (hObject, eventdata)
      level=get(hObject,'Value') ;
      h_lev = getappdata(gcf,'h_lev');
      h_lev2 = getappdata(gcf,'h_lev2');      
     low=get(h_lev,'XData');
           if (level>low(1))
      set(h_lev2,'XData',level*[1 1])
            else
      set(h_lev2,'XData',low)
             end                 
       feval(@update_plot)
end