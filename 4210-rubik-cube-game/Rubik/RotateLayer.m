function Cube = RotateLayer(hAxes,Cube,Axe,Side,Direction,Anime)
% to rotate layer
ind1 = 2*Axe-1+(Side+1)/2;
if Anime, % to show animation
  MyCube = Cube; % copy object
  a1 = Axe; % 1st axe
  a2 = Axe+1;
  if a2>3,
    a2 = 1;
  end % 2nd axe
  a3 = 6-a1-a2; % 3rd axe
  cosa = cos(-Direction*Side*pi/36); % cos(+-1 degree)
  sina = sin(-Direction*Side*pi/36); % sin(+-1 degree)
  T = zeros(3);
  T(a1,a1) = 1;
  T(a2,a2) = cosa;
  T(a2,a3) = -sina;
  T(a3,a2) = sina;
  T(a3,a3) = cosa;
  for k1=1:18, % algle loop
    for k2=1:9, % small cube loop
      MyCube.Nodes(:,:,Cube.RotLayerCube(ind1,k2)) = ...
        MyCube.Nodes(:,:,Cube.RotLayerCube(ind1,k2))*T';
    end
    PlotCube(hAxes,MyCube);
    drawnow;
  end
end
ind = 2*Axe-1+(1+Side*Direction)/2; % index number
MyColor = Cube.Color;
for k1=1:9, % small cube loop
  for k2=1:6, % flat loop
    MyColor(Cube.RotCubeFlat(ind,k2),:,Cube.RotCubeCube(ind,Cube.RotLayerCube(ind1,k1))) = ...
      Cube.Color(k2,:,Cube.RotLayerCube(ind1,k1));
  end
end
Cube.Color = MyColor; % change colors
if Anime, % to show animation
  PlotCube(hAxes,Cube);
  Congr(hAxes,Cube.Color,Cube.NumColor); % Congratulation
end
return  