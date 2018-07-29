function mia_Xpixval(arg1, arg2)
% mia_Xpixval display information about image pixels in axial image
% in the case of 3Dcursor mode
%
% Matlab library function for mia_gui utility. 
% University of Debrecen, PET Center/LB 2003


%   PIXVAL ON turns on interactive display of information about image pixels
%   in the current figure. PIXVAL installs a black bar at the bottom of the
%   figure which displays the (x,y) coordinates for whatever pixel the
%   cursor is currently over, and the color information for that pixel. If
%   the image is binary or intensity, the color information is a single
%   intensity value. If the image is indexed or RGB, the color information
%   is an RGB triplet. The values displayed are the actual data values,
%   regardless of the class of the image array, or whether the data is in
%   normal image range.
%
%   If you click on the image and hold down the mouse button while you move
%   the cursor, PIXVAL also displays the Euclidean distance between the
%   point you clicked on and current cursor location. PIXVAL draws a line
%   between these points to indicate the distance being measured. When you
%   release the mouse button, the line and the distance display disappear.
%
%   You can move the display bar by clicking on it and dragging it to
%   another place in the figure.
%
%   PIXVAL OFF turns interactive display off in the current figure. You can
%   also turn off the display by clicking the button on the right side of
%   the display bar.
%
%   PIXVAL toggles interactive display on or off in the current figure.
%
%   PIXVAL(FIG,OPTION) applies the PIXVAL command to the figure specified
%   by FIG. OPTION is string containing 'on' or 'off'.
%
%   See also IMPIXEL, IMPROFILE.

%   Copyright 1993-2001 The MathWorks, Inc.  
%   $Revision: 1.19 $  $Date: 2001/01/18 15:30:19 $


error(nargchk(0,2,nargin));

if nargin==0
   arg1 = gcf;
end


if ischar(arg1) % execute a callback
   switch lower(arg1)
   case 'pixvalmotionfcn'
      PixvalMotionFcn;
   case 'buttondownonimage'
      ButtonDownOnImage;
   case 'backtonormalpixvaldisplay'
      BackToNormalPixvalDisplay;
   case 'movedisplaybar'
      MoveDisplayBar;
   case 'on'
      mia_Xpixval(gcf, 'on');
   case 'off'
      mia_Xpixval(gcf, 'off');
   case 'deletedisplaybar'
      DeleteDisplayBar;
   otherwise
      error(['Unknown PIXVAL command or callback: ' arg1 '.']);
   end 
   
elseif ishandle(arg1)
   images = findobj(arg1, 'type', 'image');
   if isempty(images)
      return
   end
   
   figureHandle = get(get(images(1), 'parent'), 'parent');
     
   if nargin>1   % mia_Xpixval(handle, 'on|off')
      if ischar(arg2)
         if strcmp(lower(arg2), 'off')
            action = 'destroy';
         elseif strcmp(lower(arg2), 'on')
            action = 'create';
         else
            error(['Unknown PIXVAL input string: ' arg2]);
         end
      else
         error('Invalid input arguments');
      end
   else  % mia_Xpixval(handle) or mia_Xpixval
      % Toggle the state
      displayBar = findobj(figureHandle, 'tag', 'pixel value display bar');
      if isempty(displayBar)
         action = 'create';
      else
         action = 'destroy';
      end 
   end
      
   % Put things in the Images' UserData so that pixel value display works
   switch action
   case 'destroy'
      displayBar = findobj(figureHandle, 'tag', 'pixel value display bar');
      if ~isempty(displayBar)
         DeleteDisplayBar(displayBar);
      end  
      
   case 'create'
      otherDisplayBar = findobj(figureHandle, 'tag', 'pixel value display bar');
      if ~isempty(otherDisplayBar)
         % mia_Xpixval is already ON for this figure.
         return
      end
      
      % Save the interactive state of the figure. UICLEARMODE now
      % does everything that UISUSPEND used to do. It calls
      % SCRIBECLEARMODE to take care of SCRIBE.  We WILL be
      % restoring the state - this is a change.  UICLEARMODE also
      % registers a way to disable mia_Xpixval
      dbud.oldFigureUIState = uiclearmode(figureHandle,'mia_Xpixval',figureHandle,'off');
      AxisHandle = findobj(figureHandle, 'type', 'axes');
      dbud.xLim = get(AxisHandle,'XLim');% for zoom mode
      dbud.yLim = get(AxisHandle,'YLim');% for zoom mode 
      dbud.old_pt = 0;% for zoom mode 
      
      % Make sure the SCRIBE toolbar doesn't go away
      plotedit(figureHandle,'locktoolbarvisibility');
      
      % Make sure that the Motion function doesn't interrupt itself
      set(figureHandle, 'Interruptible', 'off', 'busyaction', 'queue');
      
      % Make sure that the Image's Button Down & Up functions will queue
      set(images, 'Interruptible', 'off', 'BusyAction', 'Queue');
         
      % dbud is the UserData structure which is going into the display bar
      dbud.figureHandle = figureHandle;
      dbud.displayMode = 'normal';
      
      figPos = get(dbud.figureHandle, 'position');
      tempStr = sprintf(' %g, %g = %6.4f,%6.4f,%6.4f  dist = %3.3f', ...
        -0.9999,-0.9999,pi/10,pi/10,pi/10,pi*100);
            
      % Calculate the position vector of the display bar      
      tempTxt = uicontrol('Parent', dbud.figureHandle, 'horiz', 'left', ...
         'Style', 'text', 'Units', 'pixels', 'visible', 'off', 'fontname', ...
         'FixedWidth','String', tempStr, 'position', [0 0 figPos(3) 20]);
      extent= get(tempTxt, 'extent');
      txtHt = extent(4); 
      txtWid = extent(3)+txtHt; % Leave room for the close button
      delete(tempTxt);
      
      % Create position vectors for Text, Frame, and Close Button
      pos = [0 0 (min(txtWid,figPos(3))-txtHt)*1/2 txtHt];
      btnSide = pos(4)-4;  % In pixels
      btnPos = [pos(1)+pos(3)+2 pos(2)+2 btnSide btnSide];
      frmPos = [pos(1)+pos(3) 0 txtHt txtHt];
      
      % Create a frame for the display bar. I do this because of a bug in 
      % MATLAB 5.2 where the text field pops to the front of the button each
      % time it is updated.  It should stay behind in which case, all we would
      % need is the text uicontrol and the button.  We can take the frame out
      % if the bug gets fixed.  Make sure the frame doesn't fall behind the 
      % text control, otherwise you can't execute the text control's buttondown
      % function (another MATLAB 5.2 bug).

      dbud.DisplayFrame = uicontrol('Parent', figureHandle, ...
         'style', 'frame', ...
         'Units', 'pixels', ...
         'Position', frmPos, ...
         'Background', [0 0 0], ...
         'BusyAction', 'queue', ...
         'Interruptible', 'off');
      
      % Create the display bar
      dbud.buttonDownImage = 0;  % Image 0 never exists      
      DisplayBar = uicontrol('Parent', figureHandle, ...
         'Style','text', ...
         'Units','pixels', ...
         'Position',pos, ...
         'Foreground', [1 1 .5], ...
         'Background', [0 0 0], ...
         'Horiz','left', ...
         'Tag', 'pixel value display bar', ...
         'String','', ...
         'fontname', 'FixedWidth', ...
         'BusyAction', 'queue', ...
         'enable', 'inactive', ...
         'Interruptible', 'off');
%      'ButtonDownFcn', 'mia_Xpixval(''MoveDisplayBar'')', ...
%          'DeleteFcn', 'mia_Xpixval(''DeleteDisplayBar'')', ...
      
      % Create the close button
      dbud.CloseButton = uicontrol('Parent', figureHandle, ...
         'style', 'pushbutton', ...
         'units', 'pixels', ...
         'position', btnPos, ...
         'BusyAction', 'queue', ...
         'Interruptible', 'off');
%      'DeleteFcn', 'mia_Xpixval(''DeleteDisplayBar'')', ...
%      'String', 'X', ...
%      'Callback', 'mia_Xpixval(''DeleteDisplayBar'')', ...
      
      % Register the motion function and button up function
      set(figureHandle, 'WindowButtonMotionFcn',...
         'mia_Xpixval(''PixvalMotionFcn'')')
      
      set(DisplayBar, 'UserData', dbud);
      PixvalMotionFcn(DisplayBar);
   end
   
else 
   error('Invalid input argument.')
end 



%%%
%%%  Sub-function - PixvalMotionFcn
%%%

function PixvalMotionFcn(displayBar)

if nargin < 1
   displayBar = findobj(gcbf, 'Tag', 'pixel value display bar');
end

if isempty(displayBar)
   % Pixval is in a half-broken state.  Another function (like zoom) has
   % restored pixval callbacks and PIXVAL has already been uninstalled.
   % Call uisuspend to gracefully get rid of the callbacks.

   % Note 7/21/98 - Since we are now using UICLEARMODE instead of
   % UISUSPEND, I think that we should never get into this
   % state.  It will only happen if a user writes a function
   % which calls UIRESTORE without ever calling UICLEARMDOE or
   % SCRIBECLEARMODE.  We'll leave this code here just to be safe.
   uisuspend(gcbf);
   return
end

dbud = get(displayBar, 'UserData');
pt = get(dbud.figureHandle, 'CurrentPoint');
x = pt(1,1); y = pt(1,2);

if strcmp(dbud.displayMode, 'normal') 
   % See if we're above the displayBar
   dbpos = get(displayBar, 'Position');
   left   = dbpos(1);
   bottom = dbpos(2);
   width  = dbpos(3);
   height = dbpos(4);
   % On the line below, we look to see if x<=left+width+height because
   % there is a frame next to the text object, see note above about the
   % MATLAB 5.2 bug we're working around
   if x>=left & x<=left+width+height & y>=bottom & y<=bottom+height
      % We're hovering above the display bar
      
      % Look to see if we are above the Close button
      cp = get(dbud.CloseButton, 'Position');
      if  x>=cp(1) & x<=cp(1)+cp(3) & y>=cp(2) & y<=cp(2)+cp(4)
         if isfield(dbud, 'oldPointer') % Switch back to the default pointer
            set(dbud.figureHandle, 'Pointer', dbud.oldPointer, ...
               'PointerShapeCData', dbud.oldPointerShapeCData, ...
               'PointerShapeHotSpot', dbud.oldPointerShapeHotSpot);
            dbud = rmfield(dbud, {'oldPointer', ... 
                  'oldPointerShapeCData', 'oldPointerShapeHotSpot'});
         end
      else
         % Save the default pointer if there is one
         if ~isfield(dbud, 'oldPointer') % We still have the default pointer
            dbud.oldPointer = get(dbud.figureHandle, 'Pointer');
            dbud.oldPointerShapeCData = get(dbud.figureHandle, 'PointerShapeCData');
            dbud.oldPointerShapeHotSpot = get(dbud.figureHandle, 'PointerShapeHotSpot');
         end
         setptr(dbud.figureHandle, 'hand'); 
      end
   else 
      % We're not hovering over the display bar 
      [imageHandle,imageType,img,x,y] = OverImage(dbud.figureHandle);
      if imageHandle ~= 0       
         % Save old pointer and get a new one (use Custom pointer for non-Windows machine)
         if ~isfield(dbud, 'oldPointer') % We still have the default pointer
            dbud.oldPointer = get(dbud.figureHandle, 'Pointer');
            dbud.oldPointerShapeCData = get(dbud.figureHandle, 'PointerShapeCData');
            dbud.oldPointerShapeHotSpot = get(dbud.figureHandle, 'PointerShapeHotSpot');
         end
         if strcmp(computer, 'PCWIN')
            set(dbud.figureHandle, 'Pointer', 'cross');
         else
            [pointerShape, pointerHotSpot] = CreatePointer;
            set(dbud.figureHandle, 'Pointer', 'custom', ...
               'PointerShapeCData', pointerShape, ...
               'PointerShapeHotSpot', pointerHotSpot);
         end
         
         % Update the Pixel Value display
         UpdatePixelValues(imageHandle, imageType, displayBar,img,x,y );
      else
         if isfield(dbud, 'oldPointer') % Switch back to the default pointer
            set(dbud.figureHandle, 'Pointer', dbud.oldPointer, ...
               'PointerShapeCData', dbud.oldPointerShapeCData, ...
               'PointerShapeHotSpot', dbud.oldPointerShapeHotSpot);
            dbud = rmfield(dbud, {'oldPointer', ... 
                  'oldPointerShapeCData', 'oldPointerShapeHotSpot'});
            set(displayBar, 'String', '');
         end
      end
   end
elseif strcmp(dbud.displayMode, 'distance') 
   % If we're in distance mode and in another image, clean up a bit.
   [imageHandle,imageType,img,x,y]= OverImage(dbud.figureHandle);
   if imageHandle~=0 
      if imageHandle==dbud.buttonDownImage
         UpdatePixelValues(imageHandle, imageType, displayBar,img,x,y);
      end
   end
end
set(displayBar, 'UserData', dbud);

%%%
%%%  Sub-function - OverImage
%%%

function [imageHandle,imageType,img,x,y] = OverImage(figHandle)
% Return the index of which image we are over, and return a 0 if we
% aren't above an image.

images = findobj(figHandle, 'type', 'image');
if isempty(images)
   imageHandle=0; imageType=''; img=[]; x=0; y=0;
   return
end
% Make sure that the Image's Button Down & Up functions will queue
set(images, 'ButtonDownFcn', 'mia_Xpixval(''ButtonDownOnImage'')', ...
   'Interruptible', 'off', 'BusyAction', 'Queue');
axHandles = get(images, {'Parent'});
axPositions = get([axHandles{:}], {'Position'});
axCurPt = get([axHandles{:}], {'CurrentPoint'});

% Loop over the axes, see if we are above any of them
imageHandle = 0;  
for k=1:length(axHandles)
   XLim = get(axHandles{k}, 'XLim');
   YLim = get(axHandles{k}, 'YLim');
   pt = axCurPt{k};
   x = pt(1,1); y = pt(1,2);
   if x>=XLim(1) & x<=XLim(2) & y>=YLim(1) & y<=YLim(2)
      imageHandle = images(k);
      break;
   end
end

% Figure out image type
if imageHandle ~= 0
   [img,flag] = getimage(imageHandle);
      
   switch flag
   case 1
      imageType = 'indexed';
   case {2,3}  % Grayscale or binary
      imageType = 'intensity';
   case 4
      imageType = 'rgb';
   otherwise
      error(['Invalid image, GETIMAGE returned flag = ' flag '.']);
   end
else
   imageHandle=0; imageType=''; img=[]; x=0; y=0;
end



   
%%%
%%%  Sub-function - UpdatePixelValues
%%%

function UpdatePixelValues(imageHandle, imageType, displayBar, img, x, y)
%   This is the motion callback for when we are displaying
%   pixels.  Either we are in automatic display mode and the
%   mouse pointer is moving around or we are in normal mode
%   and there has been a button-down but not yet a button up.
%   I get the current point and update the string.

global old_pt_zoom_x x0_pan_x;%temp for zoom and pan

dbud = get(displayBar, 'UserData');
[rows, cols, colors] = size(img);
y = min(y,rows);% y > rows happens in some case /LB
rp = axes2pix(rows, get(imageHandle,'YData'),y);
cp = axes2pix(cols, get(imageHandle,'XData'),x);
r = min(rows, max(1, round(rp)));
c = min(cols, max(1, round(cp)));

if strcmp(imageType,'indexed')
   map=get(dbud.figureHandle, 'Colormap');
   idx = img(r,c);
   if ~isa(idx, 'double'),
      idx = double(idx)+1;
   end
   idx = round(idx);
   if idx<=size(map,1)
      pixel = map(idx,:);
   else
      pixel = map(end,:);
   end
else   
   pixel = double(img(r,c,:));
end

% figure out the new string
figureHandle = get(get(imageHandle, 'parent'), 'parent');
switch dbud.displayMode
case 'normal'   % Just display intensity information
	FigDataIn = get(figureHandle,'Userdata');
    ImVolume = get(FigDataIn.ImaHandlerX,'UserData');
    %x = ImVolume.Z; 
    %y = ImVolume.Y;
    %z = ImVolume.X;
    %pixel(1) = ImVolume.PixInt;
    
	if isa(img, 'uint8')
     pixval_str = sprintf(' %g,%g,%g = %3d',round(ImVolume.X),round(y), round(x),pixel(1));
	elseif isa(img, 'int16')
     pixval_str = sprintf(' %g,%g,%g = %5d',round(ImVolume.X),round(y), round(x), pixel(1));
	else
     pixval_str = sprintf(' %g,%g,%g = %5.1f',round(ImVolume.X),round(y), round(x),pixel(1));
	end
   set(displayBar, 'String', pixval_str, 'UserData', dbud);
case 'distance'
    mouseclick = get(gcf,'SelectionType');
    if strcmp(mouseclick,'normal')
		FigDataIn = get(figureHandle,'Userdata');
		fighandlerZ = FigDataIn.ImaHandlerZ;
		fighandlerY = FigDataIn.ImaHandlerY;
		FigData = FigDataIn.CData;
	
        set(fighandlerZ,'CData',squeeze(FigData(:,:,size(FigData,3) - round(rp) + 1 )));
        set(fighandlerY,'CData',rot90(squeeze(FigData(round(cp),:,:))));
	
        ImVolume = get(FigDataIn.ImaHandlerX,'UserData');
        ImVolume.Z = y;
        ImVolume.Y = x;
        ImVolume.PixInt = pixel(1);    
        set(FigDataIn.ImaHandlerX,'UserData',ImVolume);
        
		if isa(img, 'uint8')
         pixval_str = sprintf(' %g,%g,%g = %3d',round(ImVolume.X),round(y), round(x),pixel(1));
		elseif isa(img, 'int16')
         pixval_str = sprintf(' %g,%g,%g = %5d', round(ImVolume.X),round(y), round(x), pixel(1));
		else
         pixval_str = sprintf(' %g,%g,%g = %5.1f',round(ImVolume.X),round(y), round(x),pixel(1));
		end
        set(displayBar, 'String', pixval_str, 'UserData', dbud);
    elseif strcmp(mouseclick,'extend') % zoom mode
        CurrentAxes = findobj(figureHandle, 'type', 'axes');
        %set(CurrentAxes,'Units','pixel');
        new_pt = get(0,'PointerLocation');
        dy = (new_pt(2) - old_pt_zoom_x(2))/abs(old_pt_zoom_x(2))*5;
        zoomFactor = (1-dy);
        xLim=get(CurrentAxes,'XLim');
        yLim=get(CurrentAxes,'YLim');
     	xLimNew = [0 zoomFactor*diff(xLim)] + xLim(1) + (1-zoomFactor)*diff(xLim)/2;
        yLimNew = [0 zoomFactor*diff(yLim)] + yLim(1) + (1-zoomFactor)*diff(yLim)/2;	
		set(CurrentAxes,'XLim',xLimNew,'YLim',yLimNew);    
        old_pt_zoom_x  = new_pt;
    elseif strcmp(mouseclick,'alt') % pan mode
        currentPoint = get(figureHandle,'CurrentPoint');
        CurrentAxes = findobj(figureHandle, 'type', 'axes');
        set(CurrentAxes,'Units','pixel');
        dx = currentPoint - x0_pan_x;
        x0_pan_x = currentPoint;
        ap = get(CurrentAxes,'Position');
        xLim = get(CurrentAxes,'XLim');
        yLim = get(CurrentAxes,'YLim');
        set(CurrentAxes,'XLim',xLim-(diff(xLim)*dx(1)/ap(3)), ...
           'YLim',yLim+(diff(yLim)*dx(2)/ap(4)));
       set(CurrentAxes,'Units','normalized');
    elseif strcmp(mouseclick,'open')% restore the original image
        xLimNew = dbud.xLim;
        yLimNew = dbud.yLim;
        CurrentAxes = findobj(gcf, 'type', 'axes');
        set(CurrentAxes,'XLim',xLimNew,'YLim',yLimNew);    
    end
end


%%%
%%%  Sub-function - ButtonDownOnImage
%%%

function ButtonDownOnImage

global old_pt_zoom_x x0_pan_x;%temp for zoom

%imageHandle = gcbo;
currentHandle = gcbo;
if strcmp(get(currentHandle,'type'),'image')
    imageHandle = currentHandle;
else
    currentParentHandle = get(currentHandle,'Parent');
    currentChildrensHandles = get(currentParentHandle,'children');
    imageHandle = currentChildrensHandles(3);
end
figureHandle = get(get(imageHandle,'Parent'),'Parent');
displayBar = findobj(figureHandle, 'Tag', 'pixel value display bar');
dbud = get(displayBar, 'UserData');
axesHandle = get(imageHandle, 'Parent');

mouseclick = get(gcf,'SelectionType');
if strcmp(mouseclick,'normal')% case of distance measuring
	%
elseif strcmp(mouseclick,'alt') % pan mode
    setptr(figureHandle,'closedhand');
elseif strcmp(mouseclick,'extend') % zoom mode
    setptr(figureHandle,'glass');
end

%
% Turn on the PlotEdit options on X,Y slice images 
%
FigDataIn = get(figureHandle,'Userdata');
axesHandleZ = get(FigDataIn.ImaHandlerZ, 'Parent');

%delete the positioning line
ImVolume = get(FigDataIn.ImaHandlerX,'UserData');
if ishandle(ImVolume.Xxline)
    delete(ImVolume.Xxline);
    delete(ImVolume.Xyline);
    delete(ImVolume.Yxline);
    delete(ImVolume.Yyline);
    delete(ImVolume.Zxline);
    delete(ImVolume.Zyline);
end
set(FigDataIn.ImaHandlerX,'UserData',ImVolume);

% Set the initial point (x0,y0)

%pt = get(axesHandle, 'CurrentPoint');
%dbud.x0 = pt(1,1);
%dbud.y0 = pt(1,2);
%dbud.line = line('Parent', axesHandle, ...
%  'erasemode', 'xor', ...
%   'color', [1 0 0], ...
%   'Xdata', [dbud.x0 dbud.x0], ...
%   'Ydata', [dbud.y0 dbud.y0]);
dbud.displayMode = 'distance';
old_pt_zoom_x = get(0,'PointerLocation');% for zoom mode
x0_pan_x = get(figureHandle,'CurrentPoint');% for pan mood
dbud.buttonDownImage = imageHandle;
set(displayBar, 'UserData', dbud);
set(dbud.figureHandle, 'WindowButtonUpFcn', 'mia_Xpixval(''BackToNormalPixvalDisplay'')');
PixvalMotionFcn(displayBar);


%%%
%%%  Sub-function - BackToNormalPixvalDisplay
%%%

function BackToNormalPixvalDisplay

displayBar = findobj(gcbo, 'Tag', 'pixel value display bar');
dbud = get(displayBar, 'UserData');
imageHandle = dbud.buttonDownImage;
%
% Turn off the PlotEdit options on X,Y slice images and
% write the last X,Y,Z coordinates to the FigDataIn struct
%
[imageHandleTmp,imageType,img,x,y]= OverImage(dbud.figureHandle);
figureHandle = get(get(imageHandle,'Parent'),'Parent');
FigDataIn = get(figureHandle,'Userdata');
axesHandleX = get(FigDataIn.ImaHandlerX, 'Parent');
axesHandleY = get(FigDataIn.ImaHandlerY, 'Parent');
axesHandleZ = get(FigDataIn.ImaHandlerZ, 'Parent');

%draw the positioning line
%draw the positioning line
Xyrange = get(axesHandleX,'Ylim');
Xxrange = get(axesHandleX,'Xlim');
Yyrange = get(axesHandleY,'Ylim');
Yxrange = get(axesHandleY,'Xlim');
Zyrange = get(axesHandleZ,'Ylim');
Zxrange = get(axesHandleZ,'Xlim');

ImVolume = get(FigDataIn.ImaHandlerX,'UserData');
if ishandle(ImVolume.Xxline)
    delete(ImVolume.Xxline);
    delete(ImVolume.Xyline);
    delete(ImVolume.Yxline);
    delete(ImVolume.Yyline);
    delete(ImVolume.Zxline);
    delete(ImVolume.Zyline);
end

LineWidthCur = 2;
%lines in saggital slice
ImVolume.Xxline=line('Parent', axesHandleX,'color', [0 1 1],'EraseMode','xor', ....
    'LineWidth',LineWidthCur,'Xdata',[ImVolume.Y ImVolume.Y],'Ydata',[0 Xyrange(2)], ...
    'ButtonDownFcn','mia_Xpixval(''ButtonDownOnImage'')');
ImVolume.Xyline=line('Parent', axesHandleX,'color', [0 1 1],'EraseMode','xor', ...
'LineWidth',LineWidthCur,'Xdata',[0 Xxrange(2)],'Ydata', [ImVolume.Z ImVolume.Z], ...
    'ButtonDownFcn','mia_Xpixval(''ButtonDownOnImage'')');

%lines in axial slice
ImVolume.Zxline=line('Parent', axesHandleZ,'color', [0 1 1],'EraseMode','xor', ....
    'LineWidth',LineWidthCur,'Xdata',[ImVolume.X ImVolume.X],'Ydata',[0 Zyrange(2)], ...
    'ButtonDownFcn','mia_Zpixval(''ButtonDownOnImage'')');
ImVolume.Zyline=line('Parent', axesHandleZ,'color', [0 1 1],'EraseMode','xor', ...
    'LineWidth',LineWidthCur,'Xdata',[0 Zxrange(2)],'Ydata', [ImVolume.Y ImVolume.Y], ...
    'ButtonDownFcn','mia_Zpixval(''ButtonDownOnImage'')');

% set(FigDataIn.ImaHandlerX,'UserData',ImVolume);
%lines in coronal slice
ImVolume.Yxline=line('Parent', axesHandleY,'color', [0 1 1],'EraseMode','xor', ....
    'LineWidth',LineWidthCur,'Xdata',[ImVolume.X ImVolume.X],'Ydata',[0 Xyrange(2)], ...
    'ButtonDownFcn','mia_Ypixval(''ButtonDownOnImage'')');
ImVolume.Yyline=line('Parent', axesHandleY,'color', [0 1 1],'EraseMode','xor', ...
    'LineWidth',LineWidthCur,'Xdata',[0 Yxrange(2)],'Ydata', [ImVolume.Z ImVolume.Z], ...
    'ButtonDownFcn','mia_Ypixval(''ButtonDownOnImage'')');

set(FigDataIn.ImaHandlerX,'UserData',ImVolume);


%delete(dbud.line);
%dbud.line = [];
%dbud.x0 = []; dbud.y0 = [];
set(dbud.figureHandle, 'WindowButtonUpFcn', '');
dbud.displayMode = 'normal';
dbud.buttonDownImage = 0;
set(displayBar, 'UserData', dbud);
PixvalMotionFcn( displayBar);



%%% 
%%%  Sub-function - MoveDisplayBar
%%%

function MoveDisplayBar

displayBar = gcbo;
dbud = get(displayBar, 'UserData');
oldWindowMotionFcn = get(dbud.figureHandle, 'WindowButtonMotionFcn');
set(dbud.figureHandle, 'WindowButtonMotionFcn', '');
oldPointer = get(dbud.figureHandle, 'Pointer');
oldPointerShapeCData = get(dbud.figureHandle, 'PointerShapeCData');
oldPointerShapeHotSpot = get(dbud.figureHandle, 'PointerShapeHotSpot');
setptr(dbud.figureHandle,'closedhand'); 

txtpos = get(displayBar, 'Position');
frmPos = get(dbud.DisplayFrame, 'Position');
position = txtpos + [0 0 frmPos(3) 0];
position2 = dragrect(position);
dx = position2(1)-position(1);
dy = position2(2)-position(2);

txtpos = txtpos + [dx dy 0 0];
set(displayBar, 'Position', txtpos);

frmPos = frmPos + [dx dy 0 0];
set(dbud.DisplayFrame, 'Position', frmPos);

btnPos = get(dbud.CloseButton, 'Position');
btnPos = btnPos + [dx dy 0 0];
set(dbud.CloseButton, 'Position', btnPos);

set(dbud.figureHandle, 'Pointer', oldPointer, ...
   'PointerShapeCData', oldPointerShapeCData, ...
   'PointerShapeHotSpot', oldPointerShapeHotSpot)
set(dbud.figureHandle, 'WindowButtonMotionFcn', oldWindowMotionFcn);




%%%
%%%  Sub-function - DeleteDisplayBar
%%%

function DeleteDisplayBar(displayBar)
%  Take apart the pixel value display - get rid of the text
%  uicontrol and clean up the image objects (remove their 
%  UserData's and get rid of their ButtonDown & Delete Fcn's)

if nargin<1
   displayBar = findobj(gcbf, 'Tag', 'pixel value display bar');
end

if ~isempty(displayBar) % if it's empty, there's no work to do.
   dbud = get(displayBar, 'UserData');
   set(displayBar, 'DeleteFcn', '');  % Make sure there's no recursion
   if ishandle(displayBar)
      delete(displayBar); 
   end
   if ishandle(dbud.CloseButton)
      delete(dbud.CloseButton);
   end
   if ishandle(dbud.DisplayFrame)
      delete(dbud.DisplayFrame);
   end
   
   % We are once again restoring the figure state, since
   % UIRESTORE also will reactivate the SCRIBE toolbar.
   uirestore(dbud.oldFigureUIState);

   % This is what we did for IPT 2.1/ML 5.2 :
   %   uisuspend(dbud.figureHandle); 
end



%%% 
%%%  Sub-function - CreatePointer
%%% 

function [pointerShape, pointerHotSpot] = CreatePointer

pointerHotSpot = [8 8];
pointerShape = [ ...
      NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
   NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
   NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
   NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
   NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
   1   1   1   1   1   1   2 NaN   2   1   1   1   1   1   1   1
   2   2   2   2   2   2   2 NaN   2   2   2   2   2   2   2   2
   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
   2   2   2   2   2   2   2 NaN   2   2   2   2   2   2   2   2
   1   1   1   1   1   1   2 NaN   2   1   1   1   1   1   1   1
   NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
   NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
   NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
   NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
   NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
