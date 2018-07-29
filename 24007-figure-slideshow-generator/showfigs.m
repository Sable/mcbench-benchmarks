function showfigs()
%
% The function showfigs() generates a "slide show" of all open figures,
% bringing each open figure to the fore in turn and then pausing until the
% user issues a command by pressing a key.  Key commands are as follows:
%
% - Press Enter, down-arrow, or spacebar to advance to the next figure
% (next higher figure number).  If the current figure is the last (highest
% figure number), the slide show returns to figure 1.
%
% - Press the up-arrow key to return to the previous figure (next lower
% figure number).  If the current figure is figure 1, the slide show cycles
% back to the last figure (highest figure number).
%
% - Press a numeric key to display the figure whose handle has that value.
% If the user presses 0 (zero), the figure having a handle value of 10 is
% displayed.  If there is no figure corresponding to the key that was
% pressed, showfigs() writes an error message to the command window,
% generates a beep, and then continues running.
%
% - Press the Delete key to close the current figure window.  showfigs()
% decrements the figure handle number (wrapping around from 1 to the
% highest figure number if necessary) until a handle number corresponding
% to a figure that is still open is found, and will then display that
% figure.  (If all figures have been deleted, an error message is displayed
% and showfigs() terminates).
%
% - Press the End key to display the last figure (highest figure number,
% not counting any figures that have been deleted).
%
% - Press the Home key to display the first figure (lowest figure number,
% not counting any figures that have been deleted).
%
% - Press Escape or "q" to terminate the slide show.
%
% If the user presses a key that does not correspond to any showfigs()
% command, showfigs() writes an error message to the command window,
% generates a beep, and then terminates.
%
% Author: Dr. Phillip M. Feldman
%
% Note: I'd like to acknowledge many helpful suggestions from Jen Dobson of
% the MathWorks.
%
% Revision History
%
% Version 1.4, 18 Jun 2009: Modified so that pressing an invalid key does
% not eliminate the callback function (which had the effect of terminating
% the slideshow).  Added code to handle right and left arrows.
%
% Version 1.3, 7 May 2009: Streamlined code that handles numeric keys.
% Added support for "0" key (brings up figure having handle==10).  Added
% error messages.  Added sound feedback to alert user when an invalid key
% has been pressed.
%
% Version 1.2, 7 May 2009: Fixed bug (code that processes numeric keys was
% assuming that handle numbers start with 1 and are consecutive, which is
% not always true).
%
% Version 1.1, 6 May 2009: Modified code to check for deleted figures using
% ishandle() function.
%
% Version 1.0, 5 May 2009: Initial version.

global handles current;

% Find all objects of type axes:
handles= findobj(0, '-depth',1, 'type','figure');

if isempty(handles)
   fprintf(2,'There are no figures to display.\n');
   return
end

% Sort handles so that figures will be displayed in order:
handles= sort(handles);

% Place first figure on top:
figure(handles(1));
current= 1;

% Define callback function to process key presses:
set(handles(1), 'KeyPressFcn',@key_press_handler);

end % function showfigs()


function key_press_handler(source,event)
% keyPressFcn automatically takes in two inputs:
% - source is the object that was active when the keypress occurred
% - event stores the data for the key pressed

global handles current;

% Bring in the handles structure in to the function
handle= guidata(source);

% Remove callback for current figure:
set(handles(current), 'KeyPressFcn',[]);

k= event.Key; % k is the key that is pressed

% The user can press the Escape key or "q" to end the slide show.  Since we
% have already removed the callback, there is nothing more to be done:

if strcmp(k,'escape') | strcmp(k,'q'), return; end

if strcmp(k,'return') | strcmp(k,'downarrow') ...
   | strcmp(k,'rightarrow') | strcmp(k,'space')
   for i= 1 : length(handles)
      current= current + 1;
      if current > length(handles), current= 1; end
      if ishandle(handles(current)), break; end
   end

elseif strcmp(k,'uparrow') | strcmp(k,'leftarrow')
   for i= 1 : length(handles)
      current= current - 1;
      if current < 1, current= length(handles); end
      if ishandle(handles(current)), break; end
   end

elseif strcmp(k,'end')
   for current= length(handles) : -1 : 1
      if ishandle(handles(current)), break; end
   end

elseif strcmp(k,'home')
   for current= 1 : length(handles)
      if ishandle(handles(current)), break; end
   end

% If the user pressed a numeric key, try to activate the figure having the
% corresponding handle number:

elseif strfind('1234567890',k)
   i= str2num(k);
   if i == 0, i= 10; end
   if ishandle(i)
      current= find(handles==i);
   else
      fprintf(2,'There is no figure having handle==%d.\n', i);
      % Play a sound to alert user that an invalid key was pressed:
      play_sound(3);
   end

elseif strcmp(k,'delete')
   close(handles(current));
   for i= 1 : length(handles)
      current= current - 1;
      if current < 1, current= length(handles); end
      if ishandle(handles(current)), break; end
   end
   if ~ishandle(handles(current))
      fprintf(2,'All figures have been deleted.\n');
      return
   end

else
   fprintf('showfigs() does not know how to handle the "%s" key.\n', k);
   play_sound(3);
end

if current > length(handles)
   fprintf(2,'The is no figure number %d.\n', current);
   play_sound(3);
   return
end

% Allow time to update:
pause(0.01);

% Make specified figure visible and raise it above all other figures:
figure(handles(current));

% Define callback function to process key presses:
set(handles(current), 'KeyPressFcn',@key_press_handler);

end % function key_press_handler(source,event)
