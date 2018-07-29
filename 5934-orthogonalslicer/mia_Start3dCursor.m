function FigDataIn = mia_Start3dCursor(imaVOLin, pixsize, colormaptype, minpix, maxpix)
% function FigDataIn = mia_Start3dCursor(imaVOLin,pixsize,colormaptype,minpix, maxpix)
%
% Setup 3 figures showing the 3 orthogonal slices
%
% Matlab library function for mia_gui utility. 
% University of Debrecen, PET Center/LB 2003

scrsz = get(0,'ScreenSize');
X0 = round(size(imaVOLin,1)/2);Y0 = round(size(imaVOLin,2)/2);Z0 = round(size(imaVOLin,3)/2);
if (isempty(findobj('tag','mia_figure1')) && isempty(findobj('tag','PetAnalSimulatorFigure')))
    xyplane_name = 'X-Y plane';
    yzplane_name = 'Y-Z plane';
    xzplane_name = 'X-Z plane';
else
    xyplane_name = 'Axial slice';
    yzplane_name = 'Coronal slice';
    xzplane_name = 'Sagital slice';
end

%FigHandlerZ = figure('position',[100 200 imzoom*size(imaVOLin,1)*pixsize(1) imzoom*size(imaVOLin,2)*pixsize(2)]);
PlotLeft =  scrsz(3)/32; PlotBottom =  scrsz(4)/3;
PlotHeight = scrsz(4)/2;
PlotBAspectRatio = [size(imaVOLin,2)*pixsize(2) size(imaVOLin,1)*pixsize(1) 1];
PlotWidth = PlotHeight*PlotBAspectRatio(1)/PlotBAspectRatio(2); 
FigHandlerZ = figure('position',[PlotLeft PlotBottom PlotWidth PlotHeight], ...
    'menubar','none','NumberTitle','off','name',xyplane_name,...
    'DeleteFcn','mia_Stop3dCursor','doubleBuffer','on');

map = colormap(colormaptype);
ImaHandlerZ = imagesc(imaVOLin(:,:,Z0),[minpix maxpix]);
axesHandleZ = get(ImaHandlerZ, 'Parent');
set(axesHandleZ,'PlotBoxAspectRatio',PlotBAspectRatio);
axis off;
%pause;


PlotBAspectRatioY = [size(imaVOLin,2)*pixsize(2) size(imaVOLin,3)*pixsize(3) 1];
PlotLeftY =  PlotLeft + 1.8*PlotWidth; PlotBottomY =  scrsz(4)/4;
PlotWidthY = PlotWidth; 
PlotHeightY = PlotWidthY*PlotBAspectRatioY(2)/PlotBAspectRatioY(1);

% if the imaVOL contains WB investigation the Coronal and Saggital figures size
% need to reduce
if PlotBottomY + PlotHeightY > scrsz(4)
    SizeFactor = 0.6;
else
    SizeFactor = 1;
end
FigHandlerY = figure('position',[PlotLeftY PlotBottomY PlotWidthY*SizeFactor PlotHeightY*SizeFactor] , ...
    'menubar','none','NumberTitle','off','name',yzplane_name, ...
    'DeleteFcn','mia_Stop3dCursor','doubleBuffer','on');

map = colormap(colormaptype);
%ImaHandlerY = imagesc(rot90(squeeze(imaVOLin(:,Y0,:))));
ImaHandlerY = imagesc(rot90(squeeze(imaVOLin(X0,:,:))),[minpix maxpix]);
axesHandleY = get(ImaHandlerY, 'Parent');
set(axesHandleY,'PlotBoxAspectRatio',PlotBAspectRatioY);
axis off;

PlotBAspectRatioX = [size(imaVOLin,1)*pixsize(1) size(imaVOLin,3)*pixsize(3) 1];
%PlotLeft =  scrsz(3)/2; PlotBottom =  scrsz(4)/2;
PlotLeftX = PlotLeft + PlotWidth; PlotBottomX =  scrsz(4)/8;
PlotWidthX = PlotWidth; 
PlotHeightX = PlotWidthX*PlotBAspectRatioX(2)/PlotBAspectRatioX(1);


FigHandlerX = figure('position',[PlotLeftX PlotBottomX PlotWidthX*SizeFactor PlotHeightX*SizeFactor], ...
    'menubar','none','NumberTitle','off','name',xzplane_name, ...
    'DeleteFcn','mia_Stop3dCursor','doubleBuffer','on');
map = colormap(colormaptype);
%ImaHandlerX = imagesc(rot90(squeeze(imaVOLin(X0,:,:))));
ImaHandlerX = imagesc(rot90(squeeze(imaVOLin(:,Y0,:))),[minpix maxpix]);

axesHandleX = get(ImaHandlerX, 'Parent');
set(axesHandleX,'PlotBoxAspectRatio',PlotBAspectRatioX);
axis off;

set(ImaHandlerX,'EraseMode','none');
set(ImaHandlerY,'EraseMode','none');
set(ImaHandlerZ,'EraseMode','none');
FigDataIn.ImaHandlerX = ImaHandlerX;
FigDataIn.ImaHandlerY = ImaHandlerY;
FigDataIn.ImaHandlerZ = ImaHandlerZ;
FigDataIn.FigHandlerX = FigHandlerX;
FigDataIn.FigHandlerY = FigHandlerY;
FigDataIn.FigHandlerZ = FigHandlerZ;
FigDataIn.CData = imaVOLin;
ImVolume.X=X0;
ImVolume.Y=Y0;
ImVolume.Z=Z0;
ImVolume.Xxline='';
ImVolume.Xyline='';
ImVolume.Yxline='';
ImVolume.Yyline='';
ImVolume.Zxline='';
ImVolume.Zyline='';
ImVolume.PixInt=imaVOLin(X0,Y0,Z0);
set(FigHandlerZ,'userdata',FigDataIn);
set(FigHandlerY,'userdata',FigDataIn);
set(FigHandlerX,'userdata',FigDataIn);
set(ImaHandlerX,'userdata',ImVolume);
mia_Xpixval(FigHandlerX,'on');
mia_Ypixval(FigHandlerY,'on');
mia_Zpixval(FigHandlerZ,'on');
%
%draw the positioning line
%
axesHandleX = get(FigDataIn.ImaHandlerX, 'Parent');
axesHandleY = get(FigDataIn.ImaHandlerY, 'Parent');
axesHandleZ = get(FigDataIn.ImaHandlerZ, 'Parent');
Xyrange = get(axesHandleX,'Ylim');
Xxrange = get(axesHandleX,'Xlim');
Yyrange = get(axesHandleY,'Ylim');
Yxrange = get(axesHandleY,'Xlim');
Zyrange = get(axesHandleZ,'Ylim');
Zxrange = get(axesHandleZ,'Xlim');
LineWidthCur = 2;
%lines in saggital slice
ImVolume.Xxline=line('Parent', axesHandleX,'color', [0 1 1],'EraseMode','xor', ....
    'LineWidth',LineWidthCur,'Xdata',[ImVolume.Y ImVolume.Y],'Ydata',[0 Yxrange(2)], ...
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

%lines in coronal slice
ImVolume.Yxline=line('Parent', axesHandleY,'color', [0 1 1],'EraseMode','xor', ....
    'LineWidth',LineWidthCur,'Xdata',[ImVolume.X ImVolume.X],'Ydata',[0 Xxrange(2)], ...
    'ButtonDownFcn','mia_Ypixval(''ButtonDownOnImage'')');
ImVolume.Yyline=line('Parent', axesHandleY,'color', [0 1 1],'EraseMode','xor', ...
    'LineWidth',LineWidthCur,'Xdata',[0 Xxrange(2)],'Ydata', [ImVolume.Z ImVolume.Z], ...
    'ButtonDownFcn','mia_Ypixval(''ButtonDownOnImage'')');

set(FigDataIn.ImaHandlerX,'UserData',ImVolume);


 