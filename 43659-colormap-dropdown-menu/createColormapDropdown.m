function createColormapDropdown
    % Create colormap popupmenu
    hFig = figure('Name','Colormap Dropdown Menu','NumberTitle','off');
    cmapList = {'Jet', 'HSV', 'Hot', 'Cool', 'Spring', 'Summer', 'Autumn', ...
                 'Winter', 'Gray', 'Bone', 'Copper', 'Pink', 'Lines'}';
    hMenu = uicontrol('Style','popup','Parent',hFig,'String',cmapList);
    hAxes = axes('Units','pixels');

    % Reposition  Menu
    figPos = get(hFig,'Position');
    menuPos = get(hMenu,'Position');
    axesPos = get(hAxes,'Position');
    set(hAxes,'Position',[axesPos(1) axesPos(2) ...
                          axesPos(3) figPos(4)-menuPos(2)*2-axesPos(2)*2]);
    set(hMenu,'Position',[menuPos(1) figPos(4)-menuPos(2)*2 ...
                          menuPos(3) menuPos(4)]);
    

    % Use courier font for spacing and resize menu to fit colorbar
    set(hMenu,'FontName','Courier','BackgroundColor',[1 1 1]);
    set(hMenu,'Units','characters');
    menuPos = get(hMenu,'Position');
    set(hMenu,'Position',[menuPos(1) menuPos(2) 60 menuPos(4)]);
    set(hMenu,'Units','pixels');

    allLength = cellfun(@numel,cmapList);
    maxLength = max(allLength);
    cmapHTML = [];
    for i = 1:numel(cmapList)
        arrow = [repmat('-',1,maxLength-allLength(i)+1) '>'];
        cmapFun = str2func(['@(x) ' lower(cmapList{i}) '(x)']);
        cData = cmapFun(16);
        curHTML = ['<HTML>' cmapList{i} '<FONT color="#FFFFFF">' arrow '<>'];
        for j = 1:16
            HEX = rgbconv(cData(j,1),cData(j,2),cData(j,3));
            curHTML = [curHTML '<FONT bgcolor="#' HEX '" color="#' HEX '">__'];
        end
        curHTML = curHTML(1:end-2);
        curHTML = [curHTML '</FONT></HTML>'];
        cmapHTML = [cmapHTML; {curHTML}];
    end
    set(hMenu,'Value',1,'String',cmapHTML,'Callback',@getColormap);

    function getColormap(hMenu,~)
        %extraction of colormap name from popupmenu
        htmlList = get(hMenu,'String');
        listIdx = get(hMenu,'Value');
        removedHTML = regexprep(htmlList{listIdx},'<[^>]*>','');
        cmapName = strrep(strrep(strrep(removedHTML,'_',''),'>',''),'-','');
        cmapFun = str2func(['@(x) ' lower(cmapName) '(x)']);
        colormap(cmapFun(16));
        surf(peaks(40));
        colorbar;
    end
end



