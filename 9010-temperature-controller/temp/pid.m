% khobe ama ba hplot mishkel dare c_type kar nemikone Ti Td , Kc ro ehtemalan baid global bedam 
function pid
    global C_controller    
    hfigure = findall(0,'tag','pid');
    if hfigure 
        figure(hfigure)
    else
        h_pid = figure('unit','pixel','pos',[172  412  450  102],'ToolBar','none',...
            'menubar','none','resize','off','CloseRequestFcn','','tag','pid','name','controler',...
            'NumberTitle','off');
        h_panel = uipanel('parent',h_pid,'unit','pixel','pos',[9    14   432    76]);
        h_Ti = uicontrol('parent',h_panel,'unit','pixel','pos',[250.0000   53.0000   77.0000   16.0000],...
            'style','text','string','1/Ti','tag','text2');
        h_Td = uicontrol('parent',h_panel,'unit','pixel','pos',[350.0000   53.0000   77.0000   16.0000],...
            'style','text','string','Td','tag','text3');
        h_P = uicontrol('parent',h_panel,'unit','pixel','pos',[150.0000   53.0000   77.0000   16.0000],...
            'style','text','string','P','tag','text1');
        h_Ti_edit = uicontrol('parent',h_panel,'unit','pixel','pos',[250.0000   32.0000   76.0000   21.0000],...
            'style','edit','string','1','tag','edit2');
        h_Td_edit = uicontrol('parent',h_panel,'unit','pixel','pos',[350.0000   32.0000   76.0000   21.0000],...
            'style','edit','string','1','tag','edit3');
        h_P_edit = uicontrol('parent',h_panel,'unit','pixel','pos',[150.0000   32.0000   76.0000   21.0000],...
            'style','edit','string','1','tag','edit1');
        h_popupmenu = uicontrol('parent',h_panel,'unit','pixel','pos',[13    30    88    21],...
            'style','popupmenu','string', {'P' 'P.I' 'P.I.D'},'BackgroundColor',[1 1 1],...
            'callback',@value_callback,'tag','popup');
        txths = findall(0,'style','text','-not','tag','text1');
        set(txths,'vis','off')
        txthe = findall(0,'style','edit','-not','tag','edit1');
        set(txthe,'vis','off')
        C_controller=1;
    end
    function value_callback(hObject, eventdata, handles)
        global C_controller
        h_popupmenu = findall(0,'tag','popup');
        hpid= get(h_popupmenu,'value');
        switch hpid
            case 1
                txths = findall(0,'style','text','-not','tag','text1');
                set(txths,'vis','off')
                txthe = findall(0,'style','edit','-not','tag','edit1');
                set(txthe,'vis','off')
                C_controller=1;
            case 2
                txths = findall(0,'style','text');
                set(txths,'vis','on')
                txthe = findall(0,'style','edit');
                set(txthe,'vis','on')
                txths = findall(0,'tag','text3');
                set(txths,'vis','off')
                txthe = findall(0,'tag','edit3');
                set(txthe,'vis','off')
                C_controller=2;
            case 3
                txths = findall(0,'style','text');
                set(txths,'vis','on')
                txthe = findall(0,'style','edit');
                set(txthe,'vis','on')
                C_controller=3;
        end