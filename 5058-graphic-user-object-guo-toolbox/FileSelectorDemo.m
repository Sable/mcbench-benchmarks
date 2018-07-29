function FileSelectorDemo(Action);

persistent FS FileText;

% function FileSelectorDemo(Action);
% 
% Demonstrates the FileSelector class.
% The Action argument selects the callback code
% and should not be supplied from the command line.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if nargin == 0
   % No Action parameter supplied:  create figure, GUO and other controls
   
   figure;
   FS = FileSelector('Units', 'pixels', ...
                     'Position', [100 100 200 20]);
   setchild(FS, 'Select', 'Callback', 'FileSelectorDemo(''Select'')');
   FileText = uicontrol('Style', 'text', ...
                        'Position', [100 125 200 20]);
   uicontrol('Style', 'pushbutton', ...
             'String', 'SetDir  c:\*.sys', ...
             'Position', [100 150 100 20], ...
             'Callback', 'FileSelectorDemo(''SetDir'')');
   uicontrol('Style', 'pushbutton', ...
             'String', 'SetDir  *.*', ...
             'Position', [200 150 100 20], ...
             'Callback', 'FileSelectorDemo(''*.*'')');
          
else
   % Action argument supplied (selects callback function for control).
   % Other callbacks are handled automatically in the FileSelector class directory.
   
   switch Action
   case 'Select'  % Callback for popupmenu "Select" within FS (displays full file name)
      set(FileText, 'String', GetFileName(FS));
   case 'SetDir'  % "SetDir  c:\*.sys" button sets directory to C:\ and mask to *.sys
      SetDir(FS, 'C:\', '*.sys');
   case '*.*'     % "SetDir  *.*" button sets mask to *.*
      SetDir(FS, '', '*.*');
   otherwise      % This should never happen...
      msgbox(['Unknown Action: ' Action], 'FileSelectorDemo', 'error');
   end
end
