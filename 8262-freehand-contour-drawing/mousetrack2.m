function outtrack = mousetrack()

% MOUSETRACK Track the motion of your mouse over an image
%   MOUSETRACK(X) retuns a Mx2 tensor, which containes the x and y position of the
%   mouse cursor during it's motion over the current axis, figure. Images can be real RGB image
%   data, or any MxN matrix. The recording phase is started and stopped by a
%   click on either mousebutton.
%
% Syntax:
%        outtrack = mousetrack()
% Example:
%       d = mousetrack(peaks)
%       hold on
%       plot(d(:,1),d(:,2),'r')
%
% Author: Leon Peshkin Harvard Medical School Cambridge MA 02115 
% Date: Mar 21st 2005

% global ratio shift
set(0, 'units', 'pixels'); set(gcf, 'units','pixels'); set(gca, 'units','pixels');
%x = get(gca, 'xlim');
%y = get(gca, 'ylim');
%axsize = get(gca, 'position');
%figsize = get(gcf, 'position'); 
%ratio = diag([diff(x)/axsize(3) diff(y)/axsize(4)]);
%shift = figsize(1:2) + axsize(1:2); 
set(gca, 'ydir', 'reverse');   % 'normal'  Y axis direction 
% set(gca, 'NextPlot', 'Add'); 
% set(gcf, 'NextPlot', 'Add'); 
set(gcf, 'windowbuttondownfcn', {@starttrack}); 
set(gcf, 'windowbuttonupfcn', {@stoptrack}, 'userdata', []); 
set(gcf, 'Interruptible', 'on'); set(gcf, 'BusyAction', 'queue')    %  queue not loose  actions ...
set(gca, 'Interruptible', 'on'); set(gca, 'BusyAction', 'cancel')
set(gca, 'DrawMode', 'fast') 
set(gca, 'XLimMode', 'manual','YLimMode','manual', 'ZLimMode', 'manual')
set(gcf, 'Renderer', 'painters'); set(gcf, 'DoubleBuffer','on')   % speeds up render, prevents blinking
set(gcf,'Menubar','none')

waitfor(0, 'userdata') 
outtrack = get(0, 'userdata'); 

function starttrack(imagefig, varargins) 
set(gcf, 'userdata', [] );   % disp('tracking started') 
set(gcf, 'Pointer', 'crosshair') 
%set(gcf, 'windowbuttondownfcn', {@stoptrack}, 'userdata', []);
set(gcf, 'windowbuttonmotionfcn', {@followtrack}); 

function followtrack(imagefig, varargins) 
% global shift ratio
% k = (get(0,'pointerlocation')-shift)*ratio; 
CurPnt = get(gca, 'CurrentPoint'); 
coords = CurPnt(2,1:2); 
pts = [get(gcf,'userdata'); coords]; 
set(gcf, 'userdata', pts); 
if mod(coords(1),.2) > .1
    plot(coords(1), coords(2), 'b.', 'MarkerSize', 10); 
else
    plot(coords(1), coords(2), 'y.', 'MarkerSize', 10); 
end
drawnow 

%--------------------------------------------------------------------------
function stoptrack(imagefig, varargins)
set(gcf, 'Pointer', 'arrow')
set(gcf, 'windowbuttonmotionfcn', []);
%set(gcf, 'windowbuttondownfcn', []);  % disp('tracking stopped')
% units0 = get(0, 'units'); unitsf = get(gcf, 'units'); unitsa = get(gca, 'units');                   
%set(0, 'units', units0); set(gcf, 'units', unitsf); set(gca, 'units', unitsa);
%mousetrail = (get(gcf,'userdata') - repmat(shift, size(get(gcf,'userdata'),1),1))*ratio;
pts = get(gcf, 'userdata');
if (length(pts) > 3)
    k = convhull(pts(:,1), pts(:,2)); 
    plot(pts(k,1), pts(k,2), '-r'); 
    set(0,'userdata', pts(k,:));
end
