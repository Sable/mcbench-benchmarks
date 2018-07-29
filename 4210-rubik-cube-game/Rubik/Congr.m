function Congr(hAxes,Color,NumColor)
% Congratulation
for k1=1:6, % check any side
  onesq = Color(k1,:,NumColor(k1,1)); % one square of side
  for k2=2:9, % check other squares
    othsq = Color(k1,:,NumColor(k1,k2)); % other square of side
    if ~all(onesq==othsq),
      return
    end
  end
end
hFig = get(hAxes,'Parent'); % main figure handle
Pos = get(hFig,'Position');
dPos = [20,200,-40,-380];
Pos1 = Pos+dPos; % new position
hFCongr = figure('Position',Pos1,...
  'Color',get(0,'DefaultUicontrolBackgroundColor'),...
  'Resize','off','MenuBar','none',...
  'NumberTitle','off','Name','Rubik Cube Game');
hTCongr = uicontrol(hFCongr,'Style','text',...
  'Position',[10 10 Pos1(3:4)-20],...
  'FontName','Comic Sans MS','FontSize',28,...
  'ForegroundColor',[0 0 1],...
  'String','Congratulations!');
return
