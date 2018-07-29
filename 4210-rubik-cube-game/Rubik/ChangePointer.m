function ChangePointer(hFig,Cube)
% to change the mouse pointer
p = get(hFig,'CurrentPoint'); % pointer coordinates
pinpol = 0; % =1, if Pointer is in any polygon
for k=1:size(Cube.PgRotCubeX,2),
  if inpolygon(p(1),p(2),Cube.PgRotCubeX(:,k),Cube.PgRotCubeY(:,k))==1,
    pinpol = 1;
    break;
  end
end
if pinpol==0,
  for k=1:size(Cube.PgRotLayX,2),
    if inpolygon(p(1),p(2),Cube.PgRotLayX(:,k),Cube.PgRotLayY(:,k))==1,
      pinpol = 1;
      break;
    end
  end
end
if pinpol,
  set(hFig,'Pointer','custom','PointerShapeCData',Cube.hand,...
    'PointerShapeHotSpot',[1 8]);
else
  set(hFig,'Pointer','arrow');
end
return  