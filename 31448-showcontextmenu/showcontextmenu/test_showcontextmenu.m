function test_showcontextmenu(  )
%TEST_SHOWCONTEXTMENU is a simple test of a showcontextmenu function

hF=figure();

    function some_action(str)
        msgbox(str);
    end


    function button_cb(hObj,varargin)
        hcmenu1 = uicontextmenu; %this menu is generated dynamicaly, on-click
        uimenu(hcmenu1, 'Label','say hi','Callback',@(varargin) some_action('hi'));
        uimenu(hcmenu1, 'Label','Destroy Galaxy','Callback',@(varargin) some_action('boom'));
        showcontextmenu(hObj,hcmenu1);
    end

hcmenu2 = uicontextmenu; %this menu is static
uimenu(hcmenu2, 'Label','say 1','Callback',@(varargin) some_action('one'));
uimenu(hcmenu2, 'Label','say 2','Callback',@(varargin) some_action('two'));

 uicontrol('Parent',hF,...
           'Style', 'pushbutton',...
           'String', 'Right click or Left click me',...
           'Position', [20 20 200 100],...
           'Callback', @button_cb,...
           'UIContextMenu',hcmenu2);
end

