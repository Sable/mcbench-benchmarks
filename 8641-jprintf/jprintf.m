% JPRINTF general print utility.
% function h = JPRINTF(dev,fmt,p1,p2,...) is a general replacement
% for the built-in fprintf function.  In addition to printing to a
% file or the command window, JPRINTF can print formatted output to
% one or more text windows.  The text windows resemble the command
% window and can be independantly positioned, editted, and printed.
%
% Parameter dev is a device specifier which controls the destination
% of the output:
%    dev = 1      -- standard output (i.e. the command window)
%    dev = 2      -- standard error (i.e. the command window)
%    dev = fid    -- open file with handle = fid
%    dev = -n     -- text window n (note the minus sign!)
% If dev is not supplied, it defaults to dev=1 (command window output).
% The parameter dev can also be set to the handle of the current Java
% TextArea to perform simple API functions from the command line (as 
% explained below).
%
% The optional return argument h contains different information depending
% on the usage:
%     When dev = 1, 2, or fid, then h = number of characters written.
%     When dev = -n, then h = a handle to the Java TextArea object.
%
% You can use get(h), set(h), inspect(h), or methods(h) to access its
% properties and methods.  To retrive the complete text string, use
% h.getText or get(h,'Text').  The first method return a java.lang.String,
% while the second method returns a Matlab char string.  Furthermore, 
% getappdata(0) will return a structure with fields JavaBox<n> that contain
% the Java TextArea objects for all open JPRINTF windows.
%
% Example 1 - Printing to different windows:
%   >> jprintf(-1,'pi is approximately = %6.4f\n',pi)
%   >> jprintf(-7,'HELLO WORLD\n')
%   >> jprintf(-1,'Added Text')
% creates two text windows.  The first window, named "Java Box 1", contains
% the string "pi is approximately = 3.1416" on the first line and "Added Text"
% on the second line. The second window, named "Java Box 7", contains the
% string "HELLO WORLD".
%
% Example 2 - Normal printing to the command window:
%    >> jprintf(1,'Hello World. ')
%    >> jprintf('This is a good day.\n')
% prints "Hello World. This is a good day." to the command window.
%
% Example 3 - Normal printing to a file:
%    >> fid = fopen('Junk.txt','w');
%    >> nchar = jprintf(fid,'This is junk\n');
%    >> fclose(fid);
% writes "This is junk" to a text file and returns the number of characters
% written (13).
%
% Use the pull-down menus to perform these functions:
%     File: open, save, save as, print, close
%     Edit: cut, copy, paste, find, find next, select all, clear all
%     Format: font, foreground color, background color, wrap (on/off)
%     Help:  JPRINTF Help, About JPRINTF
%
% You can programmatically perform most of these functions by calling jprintf
% using the handle of the java object for the device specifier, and supplying 
% the required property/value pairs as described below.
%
% The following functions require property/value pairs:
%     'openfile',   <filename>
%     'savefile',   <filename>
%     'find',       <search string>
%     'fontname',   <fontname>
%     'fontsize',   <size>
%     'fontstyle',  <'bold','italic','plain'>
%     'foreground', <rgb color spec>
%     'background', <rgb color spec>
%     'wordwrap',   <'on','off'>
%     'size',       <[width, height]>
%     'position',   <[X,Y]>
%
% The following functions do not take a value argument:
%     'selectall'
%     'copy'
%     'cut'
%     'paste'
%     'findnext'
%     'clear'
%     'close'
%
% Example 4 - Using the API to perform various functions:
%   >> h = jprintf(-1,'HELLO WORLD\n')  % create window and return handle
%   >> jprintf(h,'fontname','Arial')
%   >> jprintf(h,'foreground',[0 0 1])
%   >> jprintf(h,'background','red')
%   >> jprintf(h,'size',[300,400])
%   >> index = jprintf(h,'find','world')  % find string and its location
%   >> jprintf(h,'cut')
%   >> jprintf(h,'savefile','Test.txt')
%   >> jprintf(h,'clear')
%   >> jprintf(h,'close')
%
% At this time, you can only supply one property/value pair for each call
% to jprintf, as illustrated in the examples above.
%
% NOTE:  When performing find or findnext functions, the optional
% return argument h provides the offset into the text where the string
% was found, or [] if the string was not found.
%
% See MYDISPLAY.M for an S-function wrapper for use in Simulink.
% JPRINTF supercedes GPRINTF which will no longer be maintained.
% Help FPRINTF for more information.
%
% Version 3.0
% June 2011
% Mark W. Brown
% mwbrown@ieee.org

% Tested under:
%    MATLAB Version 7.10.0.499 (R2010a)
%    Operating System: Microsoft Windows XP x64 Version 5.2 (Build 3790: Service Pack 2)
%    Java VM Version: Java 1.6.0_12-b04 with Sun Microsystems Inc. Java HotSpot(TM) 64-Bit Server VM mixed mode

% Changes since last version:
%    Eliminated JPrinterWorks.  Using native Java print method on JTextArea.
%    Eliminated separate PageSetup dialog.  Now integrated into Print dialog.
%    Window now scrolls to the bottom of the window.
%    Added default font (Courier New 12pt).
%    Added rudimentary API.
%    Fixed bug which did not return the count of chars written by normal fprintf.
%    Fixed bug with caused a Java Exception when attempting to cut text
%    from an empty window.
%    Added find and findnext functions.
%    Added standard Windows keyboard shortcuts for most menu items.

function hrtn = jprintf(varargin)

persistent JavaBoxPos

% User has to input something:
if isempty(varargin);
  error('Not enough input arguments.')
end

% Get device (dev) and format (fmt) specifiers
% and create a properly formatted string:
if isnumeric(varargin{1}) 
  % the first argument is a device
  if length(varargin) < 2
    error('No format string.');
  end
  dev = varargin{1};
  str = sprintf(varargin{2:end});
elseif ischar(varargin{1}) 
  % the first argument is a format string
  dev = 1;
  str = sprintf(varargin{:});
elseif isjava(varargin{1}); 
  % the first argument is a java object
  htext = varargin{1};
  cmd = varargin{2};
  % process the user command
  switch lower(cmd)
      case 'openfile'
          % open a file and import the text
          filespec = varargin{3};
          fid = fopen(filespec,'r');
          ftext = fscanf(fid,'%c');
          fclose(fid);
          set(htext,'Text',ftext);
          htext.setCaretPosition(htext.getDocument.getLength);
      case 'savefile'
          % save the text to a file
          fspec = varargin{3};
          ttext = get(htext,'Text');
          fid = fopen(fspec,'w');
          fprintf(fid,'%s',ttext);
          fclose(fid);
      case 'close'
          % close the java window
          frame = get(htext,'TopLevelAncestor');
          frame.dispose;
      case 'cut'
          % cut the selected text
          htext.cut;
          pos = htext.getSelectionStart;
          htext.setCaretPosition(pos);
          htext.setSelectionEnd(pos);
          %htext.updateUI
      case 'copy'
          % copy the selected text
          htext.copy;
      case 'paste'
          % paste whatever is in the clipboard
          htext.paste;
      case 'selectall'
          % select all of the text
          htext.selectAll;
      case 'clear'
          % clear the text window
          set(htext,'Text','');
      case 'fontname'
          % specifiy the font
          fontname = varargin{3};
          hf = get(htext,'Font');
          style = get(hf,'Style');
          size = get(hf,'Size');
          f = java.awt.Font(fontname, style, size);
          htext.setFont(f);
      case 'fontsize'
          % specify the font size
          size = varargin{3};
          hf = get(htext,'Font');
          fontname = get(hf,'Name');
          style = get(hf,'Style');
          f = java.awt.Font(fontname, style, size);
          htext.setFont(f);
      case 'fontstyle'
          % specify the style of font
          newstyle = lower(varargin{3});
          hf = get(htext,'Font');
          fontname = get(hf,'Name');
          size = get(hf,'Size');
          if strcmp(newstyle,'bold')
            style = java.awt.Font.BOLD;
          elseif strcmp(newstyle,'italic')
            style = java.awt.Font.ITALIC;
          else
            style = java.awt.Font.PLAIN;
          end
          f = java.awt.Font(fontname, style, size);
          htext.setFont(f);
      case 'foreground'
          % set the foreground (font) color
          rgb = varargin{3};
          set(htext,'Foreground',rgb);
      case 'background'
          % set the background color
          rgb = varargin{3};
          set(htext,'Background',rgb);
      case 'wordwrap'
          % turn on/off wordwrap (the pulldown
          % menu may not reflect the proper state
          % after doing this)
          state = varargin{3};
          if strcmp(state,'off')
              set(htext,'LineWrap','off');
          else
              set(htext,'LineWrap','on');
              set(htext,'WrapStyleWord','on');
          end
      case 'size'
          % set the size of the window (frame)
          dim = varargin{3};
          frame = get(htext,'TopLevelAncestor');
          frame.setSize(dim(1),dim(2))
      case 'position'
          % set the position of the window (frame)
          pos = varargin{3};
          frame = get(htext,'TopLevelAncestor');
          frame.setLocation(pos(1),pos(2));
      case 'find'
          % find a string
          str = varargin{3};
          t = get(htext,'Text');
          htext.setCaretPosition(0);
          if ~isempty(str)
               pos = htext.getCaretPosition + 1;
               k = strfind(lower(t(pos:end)),lower(str));
               if isempty(k)
                   if nargout
                      hrtn = [];
                   end
               else
                   htext.setSelectionStart(k(1)-1);
                   htext.setSelectionEnd(k(1)+length(str)-1);
                   setappdata(htext,'SearchString',str);
                   if nargout
                      hrtn = k(1)-1;
                   end
               end
          end
      case 'findnext'
          % get the next occurence of the search string
          t = get(htext,'Text');
          pos = htext.getCaretPosition + 1;
          str = getappdata(htext,'SearchString');
          k = strfind(lower(t(pos:end)),lower(str));
          if isempty(k)
             if nargout
                hrtn = [];
             end
          else
             htext.setSelectionStart(pos+k(1)-2);
             htext.setSelectionEnd(pos+k(1)+length(str)-2);
             if nargout
                hrtn = pos+k(1)-2;
             end
          end
      otherwise
  end
  return
end

% If device specifier is positive number,
% then do a regular built-in fprintf:
if dev > 0
  count = fprintf(dev,str);

  % Return an optional count of characters.
  if nargout
    hrtn = count;
  end

% Else if its a negative number, then
% we must create or update a java window:
elseif dev < 0

  % Get the name of this java window:
  dev = abs(dev);
  namestr = ['JavaBox',num2str(dev)];
  
  % See if the java window already exists:
  text = getappdata(0,namestr);
  if isempty(text)
  
    % The window doesn't exist, so we need to create it:
    import java.awt.*
    import javax.swing.*
		
	% Create frame object:
	frame = javax.swing.JFrame(['Java Box ',num2str(dev)]);
	frame.setSize(600,600)

    % Stagger position so frames don't overlap.  Restart
    % if the new frame will be off the screen.
    ScreenDim = get(0,'ScreenSize');
    if isempty(JavaBoxPos)
      JavaBoxPos = [0 0];
    else
      JavaBoxPos = JavaBoxPos + [30 30];
      if any(JavaBoxPos+[600 600] > ScreenDim(3:4))
        JavaBoxPos = [0 0];
      end
    end
    frame.setLocation(JavaBoxPos(1),JavaBoxPos(2));
    
	% Create text object and set some default properties:
	text = javax.swing.JTextArea;
    f = java.awt.Font('DialogInput', 0, 12);
    text.setFont(f);
    set(text,'Background',[1.0000, 0.9686, 0.9216]);
    text.setCursor(java.awt.Cursor(2));  %text cursor

	% Create scroller object with text:
	scroller = javax.swing.JScrollPane(text);
		
	% Create menu bar:
	mymenu = javax.swing.JMenuBar;
		
	% Create FILE menu:
	menu1 = javax.swing.JMenu('File');
	mymenu.add(menu1);
		
	% Add items under FILE menu:
	menuitem1a = javax.swing.JMenuItem('Open...');
    menuitem1a.setAccelerator(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_O,java.awt.event.ActionEvent.CTRL_MASK));
	set(menuitem1a,'ActionPerformedCallback',{@DoOpenFile, text})
	menu1.add(menuitem1a);
	
	menuitem1b = javax.swing.JMenuItem('Save');
    menuitem1b.setAccelerator(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_S,java.awt.event.ActionEvent.CTRL_MASK));
	set(menuitem1b,'ActionPerformedCallback',{@DoSaveFile, text})
	menu1.add(menuitem1b);
		
	menuitem1c = javax.swing.JMenuItem('Save As...');
    menuitem1c.setAccelerator(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_F12,0));
	set(menuitem1c,'ActionPerformedCallback',{@DoSaveFileAs, text})
	menu1.add(menuitem1c);
		
    if version('-release') > 13
      menu1.addSeparator;
      menuitem1g = javax.swing.JMenuItem('Print...');
      menuitem1g.setAccelerator(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_P,java.awt.event.ActionEvent.CTRL_MASK));
      set(menuitem1g,'ActionPerformedCallback',{@DoPrint, text})
      menu1.add(menuitem1g);
    end
    
    menu1.addSeparator;
	menuitem1d = javax.swing.JMenuItem('Close');
	set(menuitem1d,'ActionPerformedCallback',{@DoClose, frame})
	menu1.add(menuitem1d);
		
	% Create EDIT menu:
	menu2 = javax.swing.JMenu('Edit');
	mymenu.add(menu2);
		
	% Add items under EDIT menu:
	menuitem2a = javax.swing.JMenuItem('Cut');
    menuitem2a.setAccelerator(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_X,java.awt.event.ActionEvent.CTRL_MASK));
	set(menuitem2a,'ActionPerformedCallback',{@DoCut, text})
	menu2.add(menuitem2a);
		
	menuitem2b = javax.swing.JMenuItem('Copy');
    menuitem2b.setAccelerator(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_C,java.awt.event.ActionEvent.CTRL_MASK));
	set(menuitem2b,'ActionPerformedCallback',{@DoCopy, text})
	menu2.add(menuitem2b);
		
	menuitem2c = javax.swing.JMenuItem('Paste');
    menuitem2c.setAccelerator(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_V,java.awt.event.ActionEvent.CTRL_MASK));
	set(menuitem2c,'ActionPerformedCallback',{@DoPaste, text})
	menu2.add(menuitem2c);
    
	menu2.addSeparator;
	menuitem2f = javax.swing.JMenuItem('Find...');
    menuitem2f.setAccelerator(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_F,java.awt.event.ActionEvent.CTRL_MASK));
	set(menuitem2f,'ActionPerformedCallback',{@DoFind, text})
	menu2.add(menuitem2f);

	menuitem2g = javax.swing.JMenuItem('Find Next');
    menuitem2g.setAccelerator(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_F3,0));
	set(menuitem2g,'ActionPerformedCallback',{@DoFindNext, text})
	menu2.add(menuitem2g);

    menu2.addSeparator;
    menuitem2e = javax.swing.JMenuItem('Select All');
    menuitem2e.setAccelerator(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_A,java.awt.event.ActionEvent.CTRL_MASK));
	set(menuitem2e,'ActionPerformedCallback',{@DoSelectAll, text})
	menu2.add(menuitem2e);
		
	menu2.addSeparator;
	menuitem2d = javax.swing.JMenuItem('Clear All');
	set(menuitem2d,'ActionPerformedCallback',{@DoClearAll, text})
	menu2.add(menuitem2d);
		
    % Create FORMAT menu:
	menu3 = javax.swing.JMenu('Format');
	mymenu.add(menu3);
		
	% Add items under FORMAT menu:
	menuitem3a = javax.swing.JMenuItem('Font...');
	set(menuitem3a,'ActionPerformedCallback',{@DoFont, text})
	menu3.add(menuitem3a);

	menu3.addSeparator;
	menuitem3b = javax.swing.JMenuItem('Foreground Color...');
	set(menuitem3b,'ActionPerformedCallback',{@DoForeColor, text})
	menu3.add(menuitem3b);
		
	menuitem3c = javax.swing.JMenuItem('Background Color...');
	set(menuitem3c,'ActionPerformedCallback',{@DoBackColor, text})
	menu3.add(menuitem3c);
		
	menu3.addSeparator;
	menuitem3g = javax.swing.JCheckBoxMenuItem('Word Wrap');
	set(menuitem3g,'ItemStateChangedCallback',{@DoWordWrap, text});
	menu3.add(menuitem3g);
		
	% Create HELP menu:
	menu4 = javax.swing.JMenu('Help');
	mymenu.add(menu4);
		
	% Add items under FORMAT menu:
	menuitem4a = javax.swing.JMenuItem('JPRINTF Help');
    menuitem4a.setAccelerator(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_F1,0));
	set(menuitem4a,'ActionPerformedCallback',@DoHelpUsing)
	menu4.add(menuitem4a);
    
	menu4.addSeparator;
	menuitem4b = javax.swing.JMenuItem('About JPRINTF');
	set(menuitem4b,'ActionPerformedCallback',@DoHelpAbout)
	menu4.add(menuitem4b);

    % Add the widgets to the frame and make visible:
	frame.getContentPane.add(BorderLayout.CENTER,scroller);
	frame.getContentPane.add(BorderLayout.NORTH,mymenu);
	frame.show
    
    % Add the input text to the java TextArea and position
    % the cursor (caret) at the bottom of the window::
    text.append(str);
    text.setCaretPosition(text.getDocument.getLength);

    % Enable some handy features:
    if version('-release') > 13
      set(text,'dragEnabled','on');
    end
    
    % Store the text object in appdata so we can find it later.
    % Also define a callback to remove appdata when the box is closed.
    set(text,'name',namestr);
    set(text,'AncestorRemovedCallback','rmappdata(0,get(gcbo,''name''))');
    setappdata(0,namestr,text);
    
  else
    
    % Add the input text to the java TextArea and position
    % the cursor (caret) at the bottom of the window:
    text.append(str);
    text.setCaretPosition(text.getDocument.getLength);

  end
  
  % Return an optional java TextArea object.
  if nargout
    hrtn = text;
  end

end

return

% Read a text file into the window.  The filename
% is NOT remembered, so if you try to save later,
% you will have to supply a filename.
function DoOpenFile(~,~,htext)
  [fname, fpath] = uigetfile('*.*');
  if fpath == 0; return; end
  filespec = fullfile(fpath,fname);
  fid = fopen(filespec,'r');
  ftext = fscanf(fid,'%c');
  fclose(fid);
  set(htext,'Text',ftext);
return

% Write the text to a file.  If a previous
% SAVEAS function was executed, the same
% filename will be used.
function DoSaveFile(~,~,htext)
  fspec = getappdata(htext,'Filename');
  if isempty(fspec);
    DoSaveFileAs([],[],htext);
  else
    ttext = get(htext,'Text');
    fid = fopen(fspec,'w');
    fprintf(fid,'%s',ttext);
    fclose(fid);
  end
return

% Write the text to a file.  The supplied filename
% is remembered for all subsequent SAVE operations.
function DoSaveFileAs(~,~,htext)
  ttext = get(htext,'Text');
  [fname, fpath] = uiputfile('*.txt','Saving text to...');
  if ischar(fname)
    fspec = fullfile(fpath,fname);
    setappdata(htext,'Filename',fspec);
    fid = fopen(fspec,'w');
    fprintf(fid,'%s',ttext);
    fclose(fid);
  end
return

% Print hardcopy to a printer:
function DoPrint(~,~,htext)
  htext.print;
return

% Close the window:
function DoClose(~,~,frame)
  frame.dispose;
return

% Cut selected text.
function DoCut(~,~,htext)
  htext.cut;
  pos = htext.getSelectionStart;
  htext.setCaretPosition(pos);
  htext.setSelectionEnd(pos);
return

% Copy selected text to a buffer:
function DoCopy(~,~,htext) %DoCopy(obj,~) %DoCopy(a,b,obj)
  htext.copy;
return

% Paste the buffered text at cursor location:
function DoPaste(~,~,htext)
  htext.paste;
return

% Select all the text in the window:
function DoSelectAll(~,~,htext)
  htext.selectAll;
return

% Clear all text from the window:
function DoClearAll(~,~,htext)
  set(htext,'Text','');
return

% Search for text
function DoFind(~,~,htext)
   import javax.swing.*
   t = get(htext,'Text');
   s = JOptionPane.showInputDialog('Search String:');
   htext.setCaretPosition(0);
   if ~isempty(s)
       str = char(s);
       pos = htext.getCaretPosition + 1;
       k = strfind(lower(t(pos:end)),lower(str));
       if isempty(k)
           beep;
           JOptionPane.showMessageDialog([], 'String Not Found!');
       else
           htext.setSelectionStart(k(1)-1);
           htext.setSelectionEnd(k(1)+length(str)-1);
           setappdata(htext,'SearchString',str);
       end
   end
return

% Search for next occurance
function DoFindNext(~,~,htext)
    import javax.swing.*
    t = get(htext,'Text');
    pos = htext.getCaretPosition + 1;
    str = getappdata(htext,'SearchString');
    k = strfind(lower(t(pos:end)),lower(str));
    if isempty(k)
       beep;
       JOptionPane.showMessageDialog([], 'No More Occurences.');
    else
       htext.setSelectionStart(pos+k(1)-2);
       htext.setSelectionEnd(pos+k(1)+length(str)-2);
    end
return

% Change the font of the displayed text.  Note
% that Java cannot do simultaneous Bold and Italic.
% If you select both, you will only get Bold.
function DoFont(~,~,htext)
  hf = get(htext,'Font');
  cf.FontName = get(hf,'Name');  %cf is a struct of current font
  cf.FontUnits = 'points';
  cf.FontSize = get(hf,'Size');
  if strcmp(get(hf,'Bold'),'on')
    cf.FontWeight = 'bold';
  else
    cf.FontWeight = 'normal';
  end
  if strcmp(get(hf,'Italic'),'on')
    cf.FontAngle = 'italic';
  else
    cf.FontAngle = 'normal';
  end
  mf = uisetfont(cf);  %mf is a struct of modified font
  if isstruct(mf)
    style = java.awt.Font.PLAIN;
    if strcmp(mf.FontWeight,'bold')
      style = java.awt.Font.BOLD;
    elseif strcmp(mf.FontAngle,'italic')
      style = java.awt.Font.ITALIC;
    end
    f = java.awt.Font(mf.FontName, style, mf.FontSize);
    htext.setFont(f);
  end
return

% Change the font color:
function DoForeColor(~,~,htext)
  oldrgb = get(htext,'Foreground');
  newrgb = uisetcolor(oldrgb);
  set(htext,'Foreground',newrgb);
return

% Change the background color:
function DoBackColor(~,~,htext)
  oldrgb = get(htext,'Background');
  newrgb = uisetcolor(oldrgb);
  set(htext,'Background',newrgb);
return

% Toggle word wrap:
function DoWordWrap(obj,~,htext)
  state = get(obj,'State');
  if strcmp(state,'off')
    set(htext,'LineWrap','off');
  else
    set(htext,'LineWrap','on');
    set(htext,'WrapStyleWord','on');
  end
return

% Display help:
function DoHelpUsing(~,~)
  helpwin jprintf;
return

% Display about:
function DoHelpAbout(~,~)
  helpdlg({'Version 3.0','June 2011','Mark W. Brown','mwbrown@ieee.org'},'About JPRINTF');
return