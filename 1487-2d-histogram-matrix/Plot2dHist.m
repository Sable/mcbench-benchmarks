%function Plot2dHist(mHist2d, vEdgeX, vEdgeY, strLabelX, strLabelY, strTitle)
%Shows 2d histogram in p-color map
%Example
%     mYX = rand(10000,2);
%     vXEdge = linspace(0,1,100);
%     vYEdge = linspace(0,1,200);
%     mHist2d = hist2d(mYX,vYEdge,vXEdge);
%  
%     Plot2dHist(mHist2d, vXEdge, vYEdge, 'X', 'Y', 'Example'); colorbar
function Plot2dHist(mHist2D, vEdgeX, vEdgeY, strLabelX, strLabelY, strTitle)

nEdgeX = length(vEdgeX)-1;
nEdgeY = length(vEdgeY)-1;

rMinX = min(vEdgeX);
rMaxX = max(vEdgeX);

rMinY = min(vEdgeY);
rMaxY = max(vEdgeY);

rDeltaX = (vEdgeX(2)-vEdgeX(1));
rDeltaY = (vEdgeY(2)-vEdgeY(1));

vLabelX = (rMinX+0.5*rDeltaX):rDeltaX:(rMaxX-0.5*rDeltaX);
vLabelY = (rMinY+0.5*rDeltaY):rDeltaY:(rMaxY-0.5*rDeltaY);

pcolor (vLabelX, vLabelY, mHist2D);
shading interp; colorbar; 

grid on; 

xlabel(strLabelX); 
ylabel(strLabelY);

axis([rMinX, rMaxX, rMinY, rMaxY]);

title(strTitle)
