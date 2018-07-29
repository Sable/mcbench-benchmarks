function importfig(figfilename,SubplotAxes)
% IMPORTFIG(Figfilename,Axes) opens a fig file and places the
% contents into another axes such as on a subplot.
% 
% Example
% h=subplot(3,2,1); 
% importfig('plot1.fig',h); 

% Import fig info
ImportFig=hgload(figfilename,struct('visible','off')); % Open fig file and get handle
ImportFigAxes=get(ImportFig,'Children');          % Get handle to axes

% Get subplot axes info
NewFig=get(SubplotAxes,'Parent');           % Get new (subplot) figure handle
SubplotPos=get(SubplotAxes,'Position');     % Get position of subplot axes
delete(SubplotAxes);                        % Delete blank subplot axes

% Copy axes over to subplot
NewSubplotAxes=copyobj(ImportFigAxes,NewFig); % Copy import fig axes to subplot
set(NewSubplotAxes,'Position',SubplotPos)     % Set position to orginal subplot axes

%  Delete figure
delete(ImportFig);                             % Delete imported figure