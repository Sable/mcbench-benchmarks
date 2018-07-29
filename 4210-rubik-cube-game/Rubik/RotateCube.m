function Cube = RotateCube(hAxes,Cube,Axe,Direction)
% to rotate all cube
MyCube = Cube; % copy object
a1 = Axe; % 1st axe
a2 = Axe+1;
if a2>3,
  a2 = 1;
end % 2nd axe
a3 = 6-a1-a2; % 3rd axe
cosa = cos(Direction*pi/36); % cos(+-1 degree)
sina = sin(Direction*pi/36); % sin(+-1 degree)
T = zeros(3);
T(a1,a1) = 1;
T(a2,a2) = cosa;
T(a2,a3) = -sina;
T(a3,a2) = sina;
T(a3,a3) = cosa;
for k1=1:18, % algle loop
  for k2=1:27, % small cube loop
    MyCube.Nodes(:,:,k2) = MyCube.Nodes(:,:,k2)*T';
  end
  PlotCube(hAxes,MyCube);
  drawnow;
end
ind = 2*Axe-1+(1-Direction)/2; % index number
MyColor = zeros(size(Cube.Color));
for k1=1:27, % small cube loop
  for k2=1:6, % flat loop
    MyColor(Cube.RotCubeFlat(ind,k2),:,Cube.RotCubeCube(ind,k1)) = ...
      Cube.Color(k2,:,k1);
  end
end
Cube.Color = MyColor; % change colors
PlotCube(hAxes,Cube);
return  