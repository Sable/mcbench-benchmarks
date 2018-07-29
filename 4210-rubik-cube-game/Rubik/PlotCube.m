function Res = PlotCube(hAxes,Cube)
% plot the cube Cube in axes hAxes
axes(hAxes); % current axes for draw
cla
hold on
for k=1:27,
  CurrNodes = Cube.Nodes(:,:,k);
  CurrColor = Cube.Color(:,:,k);
  patch('Vertices',CurrNodes,'Faces',Cube.Order,...
    'FaceVertexCData',CurrColor,'FaceColor','flat',...
    'ButtonDownFcn','Cube=RotateWithMouse(hAxes,Cube);');
end
hold off
return