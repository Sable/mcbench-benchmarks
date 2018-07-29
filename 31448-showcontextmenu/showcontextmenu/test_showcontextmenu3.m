function test_showcontextmenu3(  )
%TEST_SHOWCONTEXTMENU is a simple test of a showcontextmenu function


fh = figure();
set(fh,'Toolbar','figure');  % Display the standard toolbar
%set(fh,'Toolbar','none');    % Hide the standard toolbar

tbh = findall(fh,'Type','uitoolbar');

% to test without separators:
%ch=getAllChildren(tbh);
%set(ch,'Separator','off');




N=6;
for i=1:N
    pth = uipushtool('Parent',tbh,'Cdata',rand(20,20,3),'ClickedCallback',@button_cb);
    %pth = uitoggletool('Parent',tbh,'Cdata',rand(20,20,3),'ClickedCallback',@button_cb);
    
    %to test with many separators:
    %set(pth,'Separator','on');
end
  
             
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

set(pth,'UIContextMenu',hcmenu2); 
end




