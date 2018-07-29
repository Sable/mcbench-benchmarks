function browseFigure(figHandle, varargin)
% Function to display several instances of data sets in a single figure, 
% with a slider enabling switching between the data sets. Requires the
% function collectObjects to work.
%
% First, create the figure and sequentially all objects that belong to one 
% display. Everytime you finish one set of displayed objects, call the 
% function collectObjects with the figure handle as input argument (see 
% example below). When all graphic objects are created, call browseFigure 
% the figure handle as input.
% The function then creates a slider in the lower left corner of the
% figure which will allow you to switch the display between the data sets.
% Thanks to Sina Tootoonian for some suggestions to make the function more 
% user friendly!
%__________________________________________________________________________
% Example:
% 
% fig = figure;
% for i=1:5
%     % Plot commands
%     subplot(211);
%     plot((0.1:0.1:10).^i);
%     title(['f(x) = x^',num2str(i)]);
%     subplot(212);
%     plot((0.1:0.1:10).^(1/i));
%     title(['f(x) = x^{1/',num2str(i) '}']);
%     % Call collectObjects to collect and hide newly created objects
%     collectObjects(fig);
% end
% browseFigure(fig);
%__________________________________________________________________________
%               (c) Stephan Junek 2010

objHandles = get(figHandle, 'UserData');
if length(objHandles) > 1
    uicontrol(figHandle,'Style','slider','Value',1,'Min',1,'Max',length(objHandles),...
        'units','normalized','Position',[.01 .01 .15 .02], 'Callback','objHandles = get(gcf,''UserData'');v = round(get(gco,''Value''));set(gcf,''Name'',[''Data Set '' num2str(v) '' / '' num2str(length(objHandles))]);set(cell2mat(objHandles(:)),''Visible'',''off'');set(objHandles{v},''Visible'',''on'');',...%@updateFigure,...
        'SliderStep',[1/(length(objHandles)-1) 10/(length(objHandles)-1)]);
end
set(cell2mat(objHandles(:)), 'Visible','off');
set(objHandles{1},'Visible','on');
set(figHandle,'Name',['Data Set ' num2str(1) ' / ' num2str(length(objHandles))]);
set(figHandle, 'UserData', objHandles, 'toolbar','figure');

end