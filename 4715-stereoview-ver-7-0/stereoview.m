function stereoview
% STEREOVIEW  Stereoscopic plotting function
% 
%   stereoview grabs the current 3D figure and plots it in two
%   stereoscopical images.
% 
%   Once launched, you can:
%   1) Choose the interocular distance coefficient (idc)
%   that is defined as the ratio between the distance from the Camera
%   Target and the interocular distance; a value of 30 works fine.
% 
%   2) Choose the viewing mode: 'parallel' or 'crossed'.
% 
% 	3) Rotate the view. In the Free Rotation mode, use:
%   a, s, d, w to rotate,
%   x to stop.
% 
%   4) Start a continuous rotation of the view; x to stop.
% 
%   5) Print the two stereoscopical views in separate images. You
%   may change the options for the saved images directly in the .m file.
% 
%   6) choose 'perspective' or 'orthographic' view.
% 
%   Version 4.0 NEWS
%   - stop of the continuous rotation with "x"
%   - can print the two images
% 
%   Version 5.0 NEWS
%   - can change the distance between the two
%     views to allow easier visualization
%   - can change zoom
%   - vertical axis bending bug fixed
% 
%   Version 6.0 NEWS
%   - allows chosing perspective or orthographic
%   - unused commands deleted
% 
%   Version 7.0 NEWS
%   - bug about viewing along z fixed
%   - bug about horizontal positioning of plots fixed
%   - bug about projection mode fixed
%   - figure color preserved
%   - renderer: zbuffer
%   - figure(2) bug fixed (thanks to Andrew Murray)
% 
% ----------------------------------------------------------
% 2010      Iari-Gabriel Marino
%           <infoAToptotesys.it>
%           <iari-gabriel.marinoATfis.unipr.it>
%           http://www.fis.unipr.it/home/marino/    
% ----------------------------------------------------------
%   Example 0
% 
%   knot
%   stereoview
% 
%   ------------------------
%   Example 1
% 
%   [X,Y,Z] = peaks(30);
%   surfc(X,Y,Z)
%   stereoview
% 
%   ------------------------
%   Example 2
% 
% 	daspect([1,1,1])
% 	load wind
% 	xmin = min(x(:));
% 	xmax = max(x(:));
% 	ymin = min(y(:));
% 	ymax = max(y(:));
% 	zmin = min(z(:));
% 	daspect([2,2,1])
% 	xrange = linspace(xmin,xmax,8);
% 	yrange = linspace(ymin,ymax,8);
% 	zrange = 3:4:15;
% 	[cx cy cz] = meshgrid(xrange,yrange,zrange);
% 	hcones = coneplot(x,y,z,u,v,w,cx,cy,cz,5);
% 	set(hcones,'FaceColor','red','EdgeColor','none')
% 	hold on
% 	wind_speed = sqrt(u.^2 + v.^2 + w.^2);
% 	hsurfaces = slice(x,y,z,wind_speed,[xmin,xmax],ymax,zmin);
% 	set(hsurfaces,'FaceColor','interp','EdgeColor','none')
% 	hold off
% 	axis tight; view(30,40); axis off
% 	camproj perspective; camzoom(1.5)
% 	camlight right; lighting phong
% 	set(hsurfaces,'AmbientStrength',.6)
% 	set(hcones,'DiffuseStrength',.8)
%   stereoview
% 
%   ------------------------
%   Example 3
% 
% 	[x y z v] = flow;
% 	h = contourslice(x,y,z,v,[1:9],[],[0],linspace(-8,2,10));
% 	axis([0,10,-3,3,-3,3]); daspect([1,1,1])
% 	camva(24); camproj perspective;
% 	campos([-3,-15,5])
% 	set(gcf,'Color',[.5,.5,.5],'Renderer','zbuffer')
% 	set(gca,'Color','black','XColor','white', ...
%         'YColor','white','ZColor','white')
% 	box on
%   stereoview

St.title = 'Stereoview by I.-G. Marino';

St.idc = 30; %interocularDistanceCoefficient;
St.freeRotating = 0;
St.RotatingFlag = 0;
St.flying = 0;
% take the data of the original figure and set it invisible
origColormap = colormap;
origColor = get(gcf,'Color');
St.origcamup = camup;
St.origFig = gcf; set(St.origFig,'visible','off')
St.origAxis = gca;
origProj = camproj;
% create the stereo figure
St.stereoF = figure; set(St.stereoF,'name',St.title,'numbertitle','off','CloseRequestFcn',{@closeReqFcn,St});
pos = [120 271 780 420]; colormap(origColormap); set(gcf,'color',origColor);
set(St.stereoF,'Position',pos,'doublebuffer','on');
% create two axes (the two stereoscopical views) and paste on them the
% same original data; "axis vis3d" freezes aspect ratio properties to
% enable rotation of 3-D objects and overrides stretch-to-fill.
St.sxEye = copyobj(St.origAxis,St.origFig); set(St.sxEye,'pare',St.stereoF)
set(St.sxEye,'position',[0/10 3/10 5/10 6.5/10]);
axes(St.sxEye); axis vis3d;
St.dxEye = copyobj(St.origAxis,St.origFig); set(St.dxEye,'pare',St.stereoF)
set(St.dxEye,'position',[5/10 3/10 5/10 6.5/10]);
axes(St.dxEye); axis vis3d;
set(gcf,'Renderer','zbuffer');

% create buttons and controls
St.azLeftButton = uicontrol(gcf,'style','push','string','Left','position',[41 30 38 20]);
St.azRightButton = uicontrol(gcf,'style','push','string','Right','position',[81 30 38 20]);
St.azLeftRotButton = uicontrol(gcf,'style','push','string','<<','position',[41 10 38 20]);
St.azRightRotButton = uicontrol(gcf,'style','push','string','>>','position',[81 10 38 20]);
St.elUpButton = uicontrol(gcf,'style','push','string','Up','position',[121 30 38 20]);
St.elDownButton = uicontrol(gcf,'style','push','string','Down','position',[161 30 38 20]);
St.idcText = uicontrol(gcf,'style','text','string','IDC','position',[301 30 38 20]);
St.idcEdit = uicontrol(gcf,'style','edit','string','100','position',[291 10 58 20]);
St.changeModeList = uicontrol(gcf,'style','listbox','string',{'Parallel';'Crossed'},'position',[201 10 78 40]);
St.rotButton = uicontrol(gcf,'style','push','string','Free Rotation','position',[121 10 78 20]);
St.PrintViewsButton = uicontrol(gcf,'style','push','string','Print Views','position',[661 30 68 20]);
St.resetViewButton = uicontrol(gcf,'style','push','string','Reset View','position',[661 10 68 20]);
St.plotsMoreDistanceButton = uicontrol(gcf,'style','push','string','Plots <->','position',[581 30 68 20]);
St.plotsLessDistanceButton = uicontrol(gcf,'style','push','string','Plots >-<','position',[581 10 68 20]);
St.plotsMoreZoomButton = uicontrol(gcf,'style','push','string','Zoom +','position',[501 30 68 20]);
St.plotsLessZoomButton = uicontrol(gcf,'style','push','string','Zoom -','position',[501 10 68 20]);
St.projButton = uicontrol(gcf,'style','push','string','Ortho.','position',[360 10 68 20]);

switch origProj
    case 'perspective'
        set(St.projButton,'string','Ortho.');
    case 'orthographic'
        set(St.projButton,'string','Persp.');
end

set(St.azLeftButton,'callback',{@changeAz,{St,10}});
set(St.azRightButton,'callback',{@changeAz,{St,-10}});
set(St.azLeftRotButton,'callback',{@rotateAz,{St,10}});
set(St.azRightRotButton,'callback',{@rotateAz,{St,-10}});
set(St.elUpButton,'callback',{@changeEl,{St,-5}});
set(St.elDownButton,'callback',{@changeEl,{St,5}});
set(St.idcEdit,'callback',{@changeIdc,St});
set(St.changeModeList,'callback',{@changeMode,St});
set(St.rotButton,'callback',{@freeRot,St});
set(St.PrintViewsButton,'callback',{@printViews,St});
set(St.resetViewButton,'callback',{@resetView,St});
set(St.plotsMoreDistanceButton,'callback',{@plotsDistance,{St,5}});
set(St.plotsLessDistanceButton,'callback',{@plotsDistance,{St,-5}});
set(St.plotsMoreZoomButton,'callback',{@plotsZoom,{St,-.5}});
set(St.plotsLessZoomButton,'callback',{@plotsZoom,{St,.5}});
set(St.projButton,'callback',{@changeProj,St});

% plot the stereoscopical figures
St = PlotStereo(St);
shg

function St = PlotStereo(St)
% for camera position and target always consider as reference
% the original (invisible) figure
oriAspR = get(St.origAxis,'DataAspectRatio');
St.P0 = campos(St.origAxis)./oriAspR;    % normalization of X and Y by using DataAspectRatio values
St.T0 = camtarget(St.origAxis)./oriAspR; % normalization of X and Y by using DataAspectRatio values
d = sqrt(sum((St.P0-St.T0).^2)); % distance between camera and target: ||St.T0-St.P0||
% L is the real interocular distance; St.idc is a coefficient
L = d/St.idc;
%------------------------------
% Calculations for the position of the two cameras (eyes)
%------------------------------
if not(isequal((St.P0-St.T0)/norm(St.P0-St.T0),[0 0 1])) % The view direction is not the z axis
    P1 = St.P0 + L/2 * unitv(cross(St.P0-St.T0,[0 0 1]));
    P2 = St.P0 - L/2 * unitv(cross(St.P0-St.T0,[0 0 1]));
    %------------------------------
    campos(St.sxEye,P1.*oriAspR); % torno ai valori veri di X e Y moltiplicando per [oriAspR(1) oriAspR(2) 1]
    camtarget(St.sxEye,St.T0.*oriAspR);
    camup(St.sxEye,St.origcamup)
    campos(St.dxEye,P2.*oriAspR);
    camtarget(St.dxEye,St.T0.*oriAspR);
    camup(St.dxEye,St.origcamup)
else % if the view direction is along z
    P1 = St.P0 + L/2 * unitv(cross(St.P0-St.T0,[1 0 0]));
    P2 = St.P0 - L/2 * unitv(cross(St.P0-St.T0,[1 0 0]));
    %------------------------------
    campos(St.sxEye,P1.*oriAspR); % torno ai valori veri di X e Y moltiplicando per [oriAspR(1) oriAspR(2) 1]
    camtarget(St.sxEye,St.T0.*oriAspR);
    camup(St.sxEye,St.origcamup)
    campos(St.dxEye,P2.*oriAspR);
    camtarget(St.dxEye,St.T0.*oriAspR);
    camup(St.dxEye,St.origcamup)
end

function u = unitv(v)
u = v/(sqrt(sum(v.^2)));

function St = closeReqFcn(Handle,action,St)
if strcmp(get(St.stereoF,'Tag'),'flying'),
    disp('Press x before closing.');
    set(St.stereoF,'name','Press x before closing.');
else
    set(St.stereoF,'Tag','2close');
    delete(St.stereoF);
    set(St.origFig,'visible','on');
end

function St = changeProj(Handle,action,St)
axes(St.sxEye)
sxProj = camproj;
switch sxProj
    case 'perspective'
        axes(St.sxEye)
        camproj('orthographic')
        axes(St.dxEye)
        camproj('orthographic')
        set(St.projButton,'string','Persp.');
    case 'orthographic'
        axes(St.sxEye)
        camproj('perspective')
        axes(St.dxEye)
        camproj('perspective')
        set(St.projButton,'string','Ortho.');
end


function St = changeMode(ListH,action,St)
choice = get(ListH,'value');
sxPos = get(St.sxEye,'pos');
dxPos = get(St.dxEye,'pos');
switch choice
    case 1, % 'parallel'
        if sxPos(1)>dxPos(1),
            set(St.sxEye,'pos',[dxPos(1) sxPos(2) sxPos(3) sxPos(4)]);
            set(St.dxEye,'pos',[sxPos(1) dxPos(2) dxPos(3) dxPos(4)]);
        end
    case 2, % 'crossed'
        if sxPos(1)<dxPos(1),
            set(St.sxEye,'pos',[dxPos(1) sxPos(2) sxPos(3) sxPos(4)]);
            set(St.dxEye,'pos',[sxPos(1) dxPos(2) dxPos(3) dxPos(4)]);
        end
end
St = PlotStereo(St);

function St = plotsDistance(ButtonH,action,data)
St = data{1};
d = data{2};
set(St.sxEye,'units','pixel')
set(St.dxEye,'units','pixel')
sxPos = get(St.sxEye,'pos');
dxPos = get(St.dxEye,'pos');
set(St.sxEye,'pos',[sxPos(1)-d sxPos(2) sxPos(3) sxPos(4)]);
set(St.dxEye,'pos',[dxPos(1)+d dxPos(2) dxPos(3) dxPos(4)]);
set(St.sxEye,'units','normal')
set(St.dxEye,'units','normal')

function St = plotsZoom(ButtonH,action,data)
St = data{1};
z = data{2};
sxZoom = get(St.sxEye,'CameraViewAngle');
dxZoom = get(St.dxEye,'CameraViewAngle');
set(St.sxEye,'CameraViewAngle',sxZoom+z);
set(St.dxEye,'CameraViewAngle',dxZoom+z);

function St = changeIdc(EditH,action,St)
St.idc = str2num(get(EditH,'string'));
St = PlotStereo(St);

function St = resetView(ButtonH,action,St)
close(St.stereoF)
stereoview

function St = printViews(ButtonH,action,St)
fh_L = figure;
set(St.sxEye,'parent',fh_L,'units','normal')
set(gca,'pos',[0.13 0.11 0.775 0.8150])
print(gcf,'-dpng','stereoview_L')
set(St.sxEye,'parent',St.stereoF,'position',[0/10 3/10 5/10 6.5/10]);
close(fh_L)
fh_R = figure;
set(St.dxEye,'parent',fh_R,'units','normal')
set(gca,'pos',[0.13 0.11 0.775 0.8150])
print(gcf,'-dpng','stereoview_R')
set(St.dxEye,'parent',St.stereoF,'position',[5/10 3/10 5/10 6.5/10]);
close(fh_R)

function St = changeAz(ButtonH,action,data)
St = data{1};
moveAz = data{2};
axes(St.sxEye)
camorbit(moveAz,0);
axes(St.dxEye)
camorbit(moveAz,0);
drawnow

function St = rotateAz(ButtonH,action,data)
St = data{1};
moveAz = data{2};
set(St.stereoF,'WindowStyle','modal');
set(St.stereoF,'name','Rotating - Press x to exit.');
disp('Rotation Mode: Press x to exit')
St.RotatingFlag = 1;
while St.RotatingFlag == 1,
    figure(St.stereoF);
    if strcmp(get(St.stereoF,'CurrentCharacter'),'x')
            St.RotatingFlag = 0;
            set(St.stereoF,'CurrentCharacter','p')
    end
    axes(St.sxEye)
    camorbit(moveAz,0);
    axes(St.dxEye)
    camorbit(moveAz,0);
    drawnow
end
set(St.stereoF,'name',St.title);
set(St.stereoF,'WindowStyle','normal');

function St = changeEl(ButtonH,action,data)
St = data{1};
moveEl = data{2};
axes(St.sxEye)
camorbit(0,moveEl);
axes(St.dxEye)
camorbit(0,moveEl);
drawnow

function St = freeRot(ButtonH,action,St)
set(St.stereoF,'WindowStyle','modal');
set(ButtonH,'String','x to stop');
set(St.stereoF,'name','Flying - Use: a d w s - x to Exit.');
set(St.stereoF,'Tag','flying');
St.freeRotating = 1;
while St.freeRotating,
    if not(strcmp(get(St.stereoF,'Tag'),'2close')),
        figure(St.stereoF);
        switch get(St.stereoF,'CurrentCharacter')
        case 'a',
            changeAz([],[],{St ; 5});
            set(St.stereoF,'CurrentCharacter','p')
        case 'd',
            changeAz([],[],{St ; -5});
            set(St.stereoF,'CurrentCharacter','p')
        case 'w',
            changeEl([],[],{St ; 5});
            set(St.stereoF,'CurrentCharacter','p')
        case 's',
            changeEl([],[],{St ; -5});
            set(St.stereoF,'CurrentCharacter','p')
        case 'x',
            St.freeRotating = 0;
            set(St.stereoF,'CurrentCharacter','p')
        otherwise,
        end
        drawnow
    else
        St.freeRotating = 0;
        delete(St.stereoF);
    end
end
set(St.stereoF,'Tag','stopped');
set(ButtonH,'String','Free Rotation');
set(St.stereoF,'name',St.title);
set(St.stereoF,'WindowStyle','normal');

