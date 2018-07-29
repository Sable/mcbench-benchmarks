function TabObjectDemo(Action);

persistent T;

% function GUOdemo(Action);
% 
% Demonstrates the tabobject class.
% The Action argument selects the button callback code
% and should not be supplied from the command line.
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if nargin == 0
   % No Action parameter supplied:  create GUOs.
   % The PlaybackButtons and FileSelector GUOs would never normally be used in this way;
   % they are only used here to avoid having to invent further GUOs for TabObjectDemo.
   % In contrast, using a tabobject directly within another tabobject may be appropriate
   % under certain circumstances, providing that this is not confusing for the users.
   
   % Create inner tabobject containing PlaybackButtons & FileSelector
   P2 = PlaybackButtons('Tag', 'PBB2');
   F2 = FileSelector('Tag', 'FS2');
   T2 = tabobject('Tag', 'TO2');
   T2 = addchildguo(T2, P2, 'String', 'Playback 2', ...
                            'Callback', 'TabObjectDemo(''Playback2'')');
   T2 = addchildguo(T2, F2, 'String', 'File Selector 2', ...
                            'Callback', 'TabObjectDemo(''FileSelector2'')');
                         
   % Create outer tabobject containing inner tabobject, PlaybackButtons & FileSelector
   P = PlaybackButtons('Tag', 'PBB');
   F = FileSelector('Tag', 'FS');
   T = tabobject;
   T = addchildguo(T, T2, 'String', 'Tab Object', ...
                          'Callback', 'TabObjectDemo(''TabObject2'')');
   T = addchildguo(T, P, 'String', 'Playback', ...
                         'Callback', 'TabObjectDemo(''Playback'')');
   T = addchildguo(T, F, 'String', 'File Selector', ...
                         'Callback', 'TabObjectDemo(''FileSelector'')');

else
   % Action argument supplied (selects callback function)
   
   switch Action
   case 'Playback'       % "Playback" tab on outer tabobject
      T = selectchildguo(T, 'PBB');
   case 'FileSelector'   % "File Selector" tab on outer tabobject
      T = selectchildguo(T, 'FS');
   case 'TabObject2'     % "Tab Object" tab on outer tabobject
      T = selectchildguo(T, 'TO2');
   case 'Playback2'      % "Playback 2" tab on inner tabobject
      T = guoeval(T, 'TO2', 'selectchildguo(''PBB2'')');
   case 'FileSelector2'  % "File Selector 2" tab on inner tabobject
      T = guoeval(T, 'TO2', 'selectchildguo(''FS2'')');
   otherwise             % This should never happen...
      msgbox(['Unknown Action: ' Action],  'TabObjectDemo',  'error');
   end
end
