function Cube = CreateNewGame(hAxes,Cube)
% to create new game
n = 20; % number of random rotations
Axe = unidrnd(3,1,n); % axes
Side = unidrnd(2,1,n)*2-3; % sides
Direction = unidrnd(2,1,n)*2-3; % directions
for k=1:n, % random rotations
  Cube = RotateLayer(hAxes,Cube,Axe(k),Side(k),Direction(k),0);
end
PlotCube(hAxes,Cube);
return