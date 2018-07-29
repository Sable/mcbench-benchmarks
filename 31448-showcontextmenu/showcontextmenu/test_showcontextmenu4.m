function test_showcontextmenu4(  )
%in this example, in contrast to test_showcontextmenu, right-click menu is
%shown below the button (not on click position)

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

    

    function rmb_cb(hObject)
        hcmenu2 = uicontextmenu('Parent',getParentFigure(hObject));
                uimenu(hcmenu2, 'Label','say 1','Callback',@(varargin) some_action('one'));
                uimenu(hcmenu2, 'Label','say 2','Callback',@(varargin) some_action('two'));
                showcontextmenu(hObject,hcmenu2);
    end

uicontrol(...
            'Parent',hF,...
            'Style', 'pushbutton',...
            'String', 'Right click or Left click me',...
            'Position', [20 20 200 100],...
            'Callback', @button_cb,...
            'ButtonDownFcn',@(hObj,varargin) feval_onButtonDownExact(@rmb_cb,hObj) ...
         );





end

