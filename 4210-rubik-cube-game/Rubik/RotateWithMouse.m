function Cube = RotateWithMouse(hAxes,Cube)
% to rotate cube or layer with mouse
hFig = get(hAxes,'Parent');
p = get(hFig,'CurrentPoint'); % pointer coordinates
pinpol = 0; % <>0, if Pointer is in any polygon
for k=1:size(Cube.PgRotCubeX,2), % for cube rotation
  if inpolygon(p(1),p(2),Cube.PgRotCubeX(:,k),Cube.PgRotCubeY(:,k))==1,
    pinpol = -k;
    break;
  end
end
if pinpol==0, % for layer rotation
  for k=1:size(Cube.PgRotLayX,2),
    if inpolygon(p(1),p(2),Cube.PgRotLayX(:,k),Cube.PgRotLayY(:,k))==1,
      pinpol = k;
      break;
    end
  end
end
if pinpol<0, % to rotate cube
  Axe = fix((-pinpol-1)/4)+1;
  Direction = 1-mod(fix((-pinpol-1)/2),2)*2;
  Cube = RotateCube(hAxes,Cube,Axe,Direction);
elseif pinpol>0, % to rotate layer
  Axe = fix((pinpol-1)/8)+1;
  Side = 1-mod(fix((pinpol-1)/4),2)*2;
  Direction = 1-mod(fix((pinpol-1)/2),2)*2;
  Cube = RotateLayer(hAxes,Cube,Axe,Side,Direction,1);
end
return