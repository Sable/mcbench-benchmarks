function TableDemo(Action);

persistent Handles T;

% function TableDemo(Action);
% 
% Demonstrates the table class.
% The Action argument selects the button callback code
% and should not be supplied from the command line.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if nargin == 0
   % No Action parameter supplied:  create figure, table and other controls
   
   % Create figure and initialise data
   Handles.TableDemoFig = figure;
   set(Handles.TableDemoFig, 'Position', [50 50 800 420], ...
                             'Name', 'Table Test', ...
                             'ResizeFcn', 'TableDemo(''Resize'')');
   RowMax = 10;
   ColMax = 15;
   load PSE.mat;
   
   % Create table object with visible frame, create table controls and assign data
   T = table(Handles.TableDemoFig, 'Units', 'pixels', ...
                                   'Position', [10 40 780 370], ...
                                   'Visible', 'on');
   T = controls(T, RowMax, ColMax, 'ForegroundColor', 'red');
   T{:,:} = PSE;  % Assign data to table (can also be indexed specifically)
   
   % Create pushbuttons on figure
   Handles.SaveData    = uicontrol(Handles.TableDemoFig, ...
                                   'Style', 'pushbutton', ...
                                   'Position', [10 10 90 20], ...
                                   'String', 'Save Data', ...
                                   'Callback', 'TableDemo(''SaveData'')');
   Handles.RemoveTable = uicontrol(Handles.TableDemoFig, ...
                                   'Style', 'pushbutton', ...
                                   'Position', [100 10 90 20], ...
                                   'String', 'Remove Table', ...
                                   'Callback', 'TableDemo(''RemoveTable'')');                       
   Handles.Scroll      = uicontrol(Handles.TableDemoFig, ...
                                   'Style', 'pushbutton', ...
                                   'Position', [190 10 90 20], ...
                                   'String', 'Scroll to 3,4', ...
                                   'Callback', 'TableDemo(''Scroll'')');                       
   Handles.ScrollBack  = uicontrol(Handles.TableDemoFig, ...
                                   'Style', 'pushbutton', ...
                                   'Position', [280 10 90 20], ...
                                   'String', 'Scroll to 1,1', ...
                                   'Callback', 'TableDemo(''ScrollBack'')');                       
   Handles.SetMagic    = uicontrol(Handles.TableDemoFig, ...
                                   'Style', 'pushbutton', ...
                                   'Position', [370 10 90 20], ...
                                   'String', 'Set Magic Square', ...
                                   'Callback', 'TableDemo(''SetMagic'')');                       

else
   % Action argument supplied (selects callback function for figure or control).
   % Other callbacks are handled automatically in the table class directory.
   
   switch Action
   case 'Resize'       % ResizeFcn of Handles.TableDemoFig
      FigurePos = get(Handles.TableDemoFig, 'Position');
      TablePos = get(T, 'Position');
      TablePos(3) = FigurePos(3) - 20;
      TablePos(4) = FigurePos(4) - 50;
      T = set(T, 'Position', TablePos);
   case 'SaveData'     % Assign data from table (can also be indexed specifically)
      a = T{:,:};
      save save.mat a;
   case 'RemoveTable'  % Delete table
      T = delete(T);
      set(Handles.SaveData,    'Enable','off');
      set(Handles.RemoveTable, 'Enable','off');
      set(Handles.Scroll,      'Enable','off');
      set(Handles.ScrollBack,  'Enable','off');
      set(Handles.SetMagic,    'Enable','off');
   case 'Scroll'       % Set coordinates of upper left corner displayed within table
      T = scroll(T, 3, 4);
   case 'ScrollBack'   % Set coordinates of upper left corner displayed within table
      T = scroll(T, 1, 1);
   case 'SetMagic'     % Assign data to table (indexed specifically)
      T(1:5,3:7) = num2cell(magic(5));
   otherwise           % This should never happen...
      msgbox(['Unknown Action: ' Action], 'TableDemo', 'error');
   end
end
