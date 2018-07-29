function hFig = JTattooDemo()
% JTattooDemo - demonstrates effects of Look-and-Feel changes (including JTattoo L&F)
%
% JTattooDemo displays a figure with Matlab uicontrols and Java components, 
% and allows the user to modify the figure's look-and-feel (L&F) to any of
% the standard L&Fs installed on the system, as well to the JTattoo L&Fs.
%
% Syntax:
%    hFig = JTattooDemo()
%
% Input Parameters:
%    None.
%
% Output parameters:
%    hFig - handle of the created figure
%
% Technical description:
%    http://UndocumentedMatlab.com/blog/jtattoo-look-and-feel-demo/
%    http://www.jtattoo.net
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Release history:
%    1.1 2013-03-19: Fixed JTattoo's name; restored original L&F for other GUI; removed slider Java control; added current L&F title
%    1.0 2013-03-19: First version posted on <a href="http://www.mathworks.com/matlabcentral/fileexchange/authors/27420">MathWorks File Exchange</a>

% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.0 $  $Date: 2013/03/19 23:22:38 $

    % Add the JTatto java library
    folder = fileparts(mfilename('fullpath'));
    javaclasspath( {folder, [folder '\JTattoo.jar']} );

    % The main figure can't be moved or resized with setting the default Windows L&F
    %originalLnF = javax.swing.UIManager.getLookAndFeel;
    %javax.swing.UIManager.setLookAndFeel(originalLnF); %'com.sun.java.swing.plaf.windows.WindowsLookAndFeel');

    % Create MATLAB figure
    hFig = figure( 'Name', 'JTattoo Look-and-Feel Demo', ...
                   'NumberTitle', 'off', ...
                   'MenuBar', 'none', ...
                   'Toolbar', 'none', ...
                   'CloseRequestFcn',@onExit);

    % Get the MATLAB figure's underlying Java frame
    javaWindow = getJavaFrame( hFig );
    setappdata( hFig, 'javaWindow', javaWindow );

    % Add the figure's main menus
    addMainMenus( hFig );

    % Add the figure's controls
    addControls( hFig );

end  % JTattooDemo

% Add the main menus to the figure
function addMainMenus( hFig )
    % File main menu
    FileMenu = uimenu( hFig, 'Label', 'File' );
    uimenu( FileMenu, 'Label', 'Exit', 'Callback', @onExit );

    % System main menu
    SystemMenu = uimenu( hFig, 'Label', 'System' );
    lnfs = javax.swing.UIManager.getInstalledLookAndFeels();
    for idx = 1 : length( lnfs )
        uimenu( SystemMenu, 'Label',char(lnfs(idx).getName), 'Callback',@(h,e)updateInterface(char(lnfs(idx).getClassName)));
    end

    % JTattoo look and feel object names
    jt_lnf =   {
        'Default'     ''
        'Smart'       'com.jtattoo.plaf.smart.SmartLookAndFeel'
        'Aluminium'   'com.jtattoo.plaf.aluminium.AluminiumLookAndFeel'
        'Acryl'       'com.jtattoo.plaf.acryl.AcrylLookAndFeel'
        'Aero'        'com.jtattoo.plaf.aero.AeroLookAndFeel'
        'Bernstein'   'com.jtattoo.plaf.bernstein.BernsteinLookAndFeel'
        'Graphite'    'com.jtattoo.plaf.graphite.GraphiteLookAndFeel'
        'Fast'        'com.jtattoo.plaf.fast.FastLookAndFeel'
        'Hifi'        'com.jtattoo.plaf.hifi.HiFiLookAndFeel'
        'Luna'        'com.jtattoo.plaf.luna.LunaLookAndFeel'
        'McWin'       'com.jtattoo.plaf.mcwin.McWinLookAndFeel'
        'Mint'        'com.jtattoo.plaf.mint.MintLookAndFeel'
        'Noire'       'com.jtattoo.plaf.noire.NoireLookAndFeel'
        };
    
    % JTattoo main menu
    JTattooMenu = uimenu( hFig, 'Label', 'JTattoo' );
    for idx = 1 : length( jt_lnf )
        uimenu( JTattooMenu, 'Label',jt_lnf{idx,1}, 'Callback',@(h,e)updateInterface(jt_lnf{idx,2})) ;
    end
end  % addMainMenus

% Add the figure's controls
function addControls( hFig )
    % Example MATLAB controls
    matlabPanel = uipanel(hFig, 'units','norm', 'pos',[0.05,0.05,0.4,0.9], 'title','Matlab controls');
    controlLayout = uiflowcontainer( 'v0', matlabPanel );
    uicontrol(controlLayout, 'Style','list', 'BackgroundColor', 'w', 'String',{'Listbox item #1','Listbox item #2','Listbox item #3'}, 'Parent', controlLayout);
    uicontrol(controlLayout, 'Style','Pushbutton',  'String', 'Button ');
    uicontrol(controlLayout, 'Style','edit',        'String', 'Edit Box');
    uicontrol(controlLayout, 'Style','text',        'String', 'Static Text');
    uicontrol(controlLayout, 'Style','slider',      'String', 'Slider');
    uicontrol(controlLayout, 'Style','radiobutton', 'String', 'Radio Button');
    uicontrol(controlLayout, 'Style','checkbox',    'String', 'Check Box');
    uicontrol(controlLayout, 'Style','popupmenu',   'String', {'Option 1','Option 2', 'Option 3'});

    % Example Java components
    javaPanel = uipanel(hFig, 'units','norm', 'pos',[0.5,0.05,0.4,0.9], 'title','Java controls');
    jspinner     = javax.swing.JSpinner();
    jspinner.setValue(25);
    jbutton      = javax.swing.JButton('Java Button');
    jtextfield   = javax.swing.JTextField('Java TextField');
    jprogressbar = javax.swing.JProgressBar(0,100);
    jprogressbar.setStringPainted(true);
    jprogressbar.setValue(65);
    jslider      = javax.swing.JSlider(0,100,35);
    jslider.setPaintLabels(true);
    jslider.setMajorTickSpacing(20);
    jscrollbar = javax.swing.JScrollBar();
    jscrollbar.setValue(40);
    jscrollbar.setOrientation(jscrollbar.HORIZONTAL);
    jradiobutton = javax.swing.JRadioButton('Java RadioButton');
    jcheckbox    = javax.swing.JCheckBox('Java CheckBox');
    jcombobox    = javax.swing.JComboBox({'Option #1','Option #2','Option #3'});
    placeJavaComponent(jspinner,     [0.1 0.9  0.8 0.07], javaPanel);
    placeJavaComponent(jbutton,      [0.1 0.8  0.8 0.07], javaPanel);
    placeJavaComponent(jtextfield,   [0.1 0.7  0.8 0.07], javaPanel);
    placeJavaComponent(jprogressbar, [0.1 0.60 0.8 0.07], javaPanel);
   %placeJavaComponent(jslider,      [0.1 0.45 0.8 0.10], javaPanel);  % buggy in JTattoo, so leave out
    placeJavaComponent(jscrollbar,   [0.1 0.35 0.8 0.07], javaPanel);
    placeJavaComponent(jradiobutton, [0.1 0.25 0.8 0.07], javaPanel);
    placeJavaComponent(jcheckbox,    [0.1 0.15 0.8 0.07], javaPanel);
    placeJavaComponent(jcombobox,    [0.1 0.05 0.8 0.07], javaPanel);
    
    % Display the current L&F name
    bgcolor = get(hFig,'color');
    lnfName = char(javax.swing.UIManager.getLookAndFeel.getName);
    uicontrol(hFig, 'Style','text', 'FontWeight','bold', 'units','norm', 'pos',[0.02,0.95,0.9,0.04], 'string',lnfName, 'Background',bgcolor, 'tag','L&F title');
end  % addControls

% Place a Java component within a panel in a specified normalized position
function placeJavaComponent ( jcomponent, position, parent )
    jcomponent = javaObjectEDT( jcomponent );  % ensure component is auto-delegated to EDT
    jcomponent.setOpaque(false);  % useful to demonstrate L&F backgrounds
    [jc,hContainer] = javacomponent( jcomponent, [], parent ); %#ok<ASGLU>
    set(hContainer, 'Units','Normalized', 'Position',position);
end  % placeJavaComponent

% User wants to exit the application
function onExit( h, e ) %#ok<INUSD>
    hFig = gcbf;
    try
        javaWindow = getappdata( hFig, 'javaWindow' );
        SetDefaultLookAndFeel( javaWindow );
    catch
        % ignore...
    end
    delete( hFig );
    drawnow;
end % onExit

% User requested to change the L&F
function updateInterface( lookandfeel )
    originalLnF = javax.swing.UIManager.getLookAndFeel;
    javaWindow = getappdata( gcbf, 'javaWindow' );
    if isempty( lookandfeel )
        javax.swing.UIManager.setLookAndFeel(...
            'com.sun.java.swing.plaf.windows.WindowsLookAndFeel');
    else
        jTattoo = javaObjectEDT( 'UpdateJTattooInterface' );
        javaMethodEDT('setLookAndFeel', jTattoo, lookandfeel, 'Default', javaWindow);
    end
    container = javaMethodEDT('getContentPane', javaWindow);
    javaMethodEDT('updateComponentTreeUI', 'javax.swing.SwingUtilities', container);
    
    % Update the title
    hTitle = findall(gcbf, 'tag','L&F title');
    lnfName = char(javax.swing.UIManager.getLookAndFeel.getName);
    set(hTitle, 'String',lnfName);
    drawnow;
    
    % Restore original L&F for other GUI
    javax.swing.UIManager.setLookAndFeel(originalLnF)
end % updateInterface

% Get a Matlab figure's underlying Java Frame (RootPane) reference handle
function JavaFrame = getJavaFrame( hFig )
    try
        %  contentSize = [0,0];  % initialize
        JavaFrame = hFig;
        figName = get(hFig,'name');
        if strcmpi(get(hFig,'number'),'on')
            figName = regexprep(['Figure ' num2str(hFig) ': ' figName],': $','');
        end
        mde = com.mathworks.mde.desk.MLDesktop.getInstance;
        jFigPanel = mde.getClient(figName);
        JavaFrame = jFigPanel;
        JavaFrame = jFigPanel.getRootPane;
    catch
        try
            jFrame = get(handle(hFig),'JavaFrame');
            jFigPanel = get(jFrame,'FigurePanelContainer');
            JavaFrame = jFigPanel;
            JavaFrame = jFigPanel.getComponent(0).getRootPane;
        catch
            % Never mind
        end

    end
    try
        % If invalid RootPane, retry up to N times
        tries = 10;
        while isempty(JavaFrame) && tries>0  % might happen if figure is still undergoing rendering...
            drawnow; pause(0.001);
            tries = tries - 1;
            JavaFrame = jFigPanel.getComponent(0).getRootPane;
        end

        % If still invalid, use FigurePanelContainer which is good enough in 99% of cases... (menu/tool bars won't be accessible, though)
        if isempty(JavaFrame)
            JavaFrame = jFigPanel;
        end
        % contentSize = [JavaFrame.getWidth, JavaFrame.getHeight];

        % Try to get the ancestor FigureFrame
        JavaFrame = JavaFrame.getTopLevelAncestor;
    catch
        % Never mind - FigurePanelContainer is good enough in 99% of cases... (menu/tool bars won't be accessible, though)
    end
end  % getJavaFrame
