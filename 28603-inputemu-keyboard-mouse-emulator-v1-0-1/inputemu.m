function inputemu(varargin)
%INPUTEMU   Java-Based Mouse/Keyboard Emulator
%   INPUTEMU(ACTION,PARAM) emulates the human input via mouse and
%   keyboard. This utility uses Java java.awt.Robot class.
%
%   INPUTEMU(MOUSE_ACTION,[X Y WHEEL]) performs mouse emulation with 5
%   action types:
%
%      'move'|'none'|'wheel' - No mouse click (default)
%      'normal'              - Click left mouse button
%      'extend'              - Shift-click left mouse button
%      'alternate'           - Control-click left mouse button
%      'open'                - Double click any mouse button
%
%   The mouse cursor is first moved to the coordinate [X Y] (with respect
%   to the lower-left corner of the primary screen), followed by button
%   click action (if specified), then it turns the mouse wheel by WHEEL
%   notches. The number of "notches" to move the mouse wheel negative
%   values indicate movement up/away from the user, positive values
%   indicate movement down/towards the user. If PARAM (or any of its
%   elements) is missing, the default position is the current cursor
%   position and WHEEL = 0.
%
%   INPUTEMU('wheel',WHEEL) may be used to turn wheel without moving mouse
%   cursor.
%
%   INPUTEMU(KEYBOARD_ACTION,'text') performs keyboard emulation with
%   4 action types:
%
%      'key_normal'  - Normal keypress (shift-key pressed as needed)
%      'key_ctrl'    - CONTROL-key keypress
%      'key_alt'     - ALT-key keypress
%      'key_win'     - WIN-key keypress
%
%   The 'text' to be typed may contain special keys as escape characters
%   with '\' prefix:
% 
%      '\BACKSPACE'   '\TAB'         '\ENTER'       '\SHIFT'
%      '\CTRL'        '\ALT'         '\PAUSE'       '\CAPSLOCK'
%      '\ESC'         '\PAGEUP'      '\PAGEDOWN'    '\END'
%      '\HOME'        '\LEFT'        '\UP'          '\RIGHT'
%      '\DOWN'        '\PRINTSCREEN' '\INSERT'      '\DELETE'
%      '\WINDOWS'     '\NUMLOCK'     '\SCROLLLOCK'  
%
%   These escape characters are NOT case sensitive while regular characters
%   are. For regular backslash, use '\\' unless it is the only character
%   then '\' may be used. 
%
%   In addition to above action types, there are 8 low-level actions to
%   specify button or key to be down (pressed) or up (released).
%
%      'left_down'/'left_up' | 'drag_on'/'drag_off' - Left mouse button
%      'right_down'/'right_up'                      - Right mouse button
%      'middle_down'/'middle_up'                    - Middle mouse button
%      'key_down'/'key_up'                          - Keyboard key
%
%   INPUTEMU(CMDS) can be used to perform multiple commands. CMDS is an
%   2-by-N cell array where the n-th column {ACTION_n;PARAM_n} defines the
%   n-th input action. CMDS may be given in an N-by-2 array (if N~=2)
%
%   INPUTEMU(CMDS,T) performs the CMDS action sequence with T second
%   update period.
%
%   INPUTEMU(CMDS,Tints) where time is a N-element vector, specifies
%   update interval (in s) for individual action. time(1) specifies the lag
%   before performing the first action.
%
%   See also jmouseemu and inputlog.

% Version 1.0 (Aug. 31, 2010)
% Written by: Takeshi Ikuma
% Created: Aug. 31, 2010
% Revision History:
%  - (Aug. 31, 2010) : initial release

% To Do List
% * Support for pause action
% * Allow a choice between block/non-block modes
% * Internationalization
%   - support for user specified locale / OemChars def
%   - support for special keys not on the US keyboard
%   - support for non-European alphabet support (possible?)

% Java environment check
error(javachk('jvm'));
error(javachk('awt'));

% default (i.e., US|us locale) OEM character map
import java.awt.event.KeyEvent
defaultOemChars = {... % {'ch w/o shift' 'ch w/shift' Java virtual keycode}
   '`' '~'   KeyEvent.VK_BACK_QUOTE
   '1' '!'   KeyEvent.VK_1
   '2' '@'   KeyEvent.VK_2
   '3' '#'   KeyEvent.VK_3
   '4' '$'   KeyEvent.VK_4
   '5' '%'   KeyEvent.VK_5
   '6' '^'   KeyEvent.VK_6
   '7' '&'   KeyEvent.VK_7
   '8' '*'   KeyEvent.VK_8
   '9' '('   KeyEvent.VK_9
   '0' ')'   KeyEvent.VK_0
   '-' '_'   KeyEvent.VK_MINUS
   '=' '+'   KeyEvent.VK_EQUALS
   '[' '{'   KeyEvent.VK_OPEN_BRACKET
   ']' '}'   KeyEvent.VK_CLOSE_BRACKET
   '\' '|'   KeyEvent.VK_BACK_SLASH
   ';' ':'   KeyEvent.VK_SEMICOLON
   '''' '"'  KeyEvent.VK_QUOTE
   ',' '<'   KeyEvent.VK_COMMA
   '.' '>'   KeyEvent.VK_PERIOD
   '/' '?'   KeyEvent.VK_SLASH
};

% parse input arguments
[cmds,deltaT,idx_mouse,oemChars,msg] = parseInput(defaultOemChars,nargin,varargin);
if ~isempty(msg), error(msg); end

% expand upper-level actions
[actions,params,dt,msg] = convertToLowLevelActions(cmds,deltaT,idx_mouse,oemChars);
if ~isempty(msg), error(msg); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

import java.awt.Robot
import java.awt.event.InputEvent

% initialize the java.robot
robot = Robot();

for n = 1:size(actions)
	% cue the action
	switch actions{n}
		case 'move'
			robot.mouseMove(params{n}(1),params{n}(2));
		case 'wheel'
			robot.mouseWheel(params{n});
		case 'left_down'
			robot.mousePress(InputEvent.BUTTON1_MASK);
		case 'left_up'
			robot.mouseRelease(InputEvent.BUTTON1_MASK);
		case 'right_down'
			robot.mousePress(InputEvent.BUTTON3_MASK);
		case 'right_up'
			robot.mouseRelease(InputEvent.BUTTON3_MASK);
		case 'middle_down'
			robot.mousePress(InputEvent.BUTTON2_MASK);
		case 'middle_up'
			robot.mouseRelease(InputEvent.BUTTON2_MASK);
		case 'key_down'
			robot.keyPress(params{n});
		case 'key_up'
			robot.keyRelease(params{n});
	end
	
	% delay
	robot.delay(dt(n));
end

% wait until robot's done
robot.waitForIdle();

end % jinputemu

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parse Input Arguments
function [cmds,deltaT,idx_mouse,oemChars,msg] = parseInput(defaultOemChars,n,argin)

cmds = {};
deltaT = [];
idx_mouse = [];
oemChars = defaultOemChars;

msg = nargchk(1,2,n); %#ok
if ~isempty(msg), return; end

if ~iscell(argin{1}) % single-command mode
	switch n
		case 1
			cmds = [argin(1);cell(1)];
		case 2
			cmds = argin;
		otherwise
			cmds = {}; % never gets here
	end
else % multiple-command mode
	cmds = argin{1};
	if n>1
		deltaT = argin{2};
	end
end

% get dimension
dim = size(cmds);

% use the first size-2 dimension as the command
idx = find(dim==2,1,'first');
if ~isempty(idx) && idx~=1
	idx = [idx 1:idx-1 idx+1:ndims(cmds)];
	cmds = permute(cmds,idx);
	dim(:) = dim(idx);
end

% check cmds
if dim(1)~=2
	msg = 'One of the sizes of the CMDS matrix must must be 2.';
	return;
end

mouse_actions = {'none','move','wheel','normal','extend','alternate',...
	'open','drag_on','drag_off','left_down','left_up','middle_down',...
	'middle_up','right_down','right_up'};
keyboard_actions = {'key_normal','key_alt','key_ctrl','key_win','key_up','key_down'};

if any(cellfun(@(action)~isempty(action) && ~ischar(action),cmds(1,:)))
	msg = 'Command actions (CMDS{1,:}) must be a string of characters.';
	return;
end

idx_mouse = cellfun(@(action)any(strcmpi(action,mouse_actions)),cmds(1,:));
idx_keyboard = cellfun(@(action)any(strcmpi(action,keyboard_actions)),cmds(1,:));

if any(~any(idx_mouse|idx_keyboard))
	msg = 'At least one command action is invalid.';
	return;
end

if any(cellfun(@(x)~isempty(x) && (~isnumeric(x) || ~any(numel(x)==[1 2 3]) || any(isinf(x)) || any(isnan(x))),cmds(2,idx_mouse)))
	msg = 'Position must be a 2- or 3-element vector with finite values';
	return;
end

if any(cellfun(@(x)~ischar(x),cmds(2,idx_keyboard)))
	msg = 'Text must be a character string';
	return;
end

% format mouse parameters
scrnsz = get(0,'ScreenSize');
ptrloc = get(0,'PointerLocation');
for n = find(idx_mouse)
	switch numel(cmds{2,n})
		case 0
			cmds{2,n} = [ptrloc 0];
		case 1
			if strcmpi(cmds{1,n},'wheel')
				cmds{2,n} = [ptrloc cmds{2,n}];
			else
				cmds{2,n} = [cmds{2,n} ptrloc(2) 0];
			end
		case 2
			cmds{2,n} = [cmds{2,n}(:)' 0];
	end
	if all(cmds{2,n}(1:2)==ptrloc)
		cmds{2,n}(1:2) = nan; % indicating no change
	else
      % move origin from lower-left corner to upper-left corner
      cmds{2,n}(2) = scrnsz(4)-cmds{2,n}(2);

      ptrloc = cmds{2,n}(2);  % update current mouse location
	end
	
end

% check time
if isempty(deltaT)
	deltaT = zeros([1 dim(2:end)]);
elseif any(numel(deltaT)~=1 || ~isnumeric(deltaT) || deltaT<0 || isnan(deltaT) || isinf(deltaT))
	msg = 'deltaT must be a non-negative scalar.';
elseif numel(deltaT)==1
	deltaT = repmat(round(deltaT*1000),[1 dim(2:end)]);
elseif numel(deltaT)~=numel(cmds)/2
	msg = 'deltaT must be a scalar or match the number of commands.';
else
   deltaT = round(deltaT*1000);
end

end % parseinput()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% expand all actions to include only 'XXX_down','XXX_up','move','wheel'
function [actions,params,dt,msg] = convertToLowLevelActions(cmds,deltaT,idx_mouse,oemChars)

import java.awt.event.KeyEvent

actions = {};
params = {};
dt = [];
msg = '';

Ncmds = numel(deltaT);

% determine total number of actions
Nactions = zeros(Ncmds,1);
for n = 1:Ncmds
	if idx_mouse(n) % mouse command
      % determine number of LL actions needed for each mouse command
		Nactions(n) = sum([...
			cmds{2,n}(1)>=0 || cmds{2,n}(2)>=0% move
			cmds{2,n}(3)~=0 % wheel
			~any(strcmpi(cmds{1,n},{'none','move','wheel'})) % click action
			strcmpi(cmds{1,n},'normal')   % both down & up
			3*any(strcmpi(cmds{1,n},{'open','extend','alternate'}))]); % down & up & modifier key down & up
		
		if strcmpi(cmds{1,n},'drag_on')
			cmds{1,n} = 'left_down';
		elseif strcmpi(cmds{1,n},'drag_off')
			cmds{1,n} = 'left_up';
		end
	else % keyboard command
		[cmds{1,n},cmds{2,n},msg] = parseKeyboardText(cmds{1,n},cmds{2,n},oemChars);
		if ~isempty(msg), return; end
		Nactions(n) = size(cmds{1,n},1);
	end
end

% create actions & params
Ntotal = sum(Nactions);
actions = cell(Ntotal,1);
params = cell(Ntotal,1);
dt = zeros(Ntotal,1);
I = 1;
for n = 1:Ncmds
	dt(I) = deltaT(n);
	if idx_mouse(n)
		if ~isnan(cmds{2,n}(1))
			actions{I} = 'move';
			params{I} = cmds{2,n}([1 2]);
			I = I + 1;
		end
		switch lower(cmds{1,n})
			case 'normal'
				actions{I} = 'left_down';
				I = I + 1;
				actions{I} = 'left_up';
				I = I + 1;
			case 'extend'
				actions{I} = 'key_down';
				params{I} = KeyEvent.VK_SHIFT;
				I = I+1;
				actions{I} = 'left_down';
				I = I + 1;
				actions{I} = 'left_up';
				I = I + 1;
				actions{I} = 'key_up';
				params{I} = KeyEvent.VK_SHIFT;
				I = I+1;
			case 'alternate'
				actions{I} = 'key_down';
				params{I} = KeyEvent.VK_CONTROL;
				I = I+1;
				actions{I} = 'left_down';
				I = I + 1;
				actions{I} = 'left_up';
				I = I + 1;
				actions{I} = 'key_up';
				params{I} = KeyEvent.VK_CONTROL;
				I = I+1;
			case 'open'
				actions{I} = 'left_down';
				I = I + 1;
				actions{I} = 'left_up';
				I = I + 1;
				actions{I} = 'left_down';
				I = I + 1;
				actions{I} = 'left_up';
				I = I + 1;
			case {'left_down','left_up',...
					'middle_down','middle_up',...
					'right_down','right_up'} % single button action
				actions{I} = lower(cmds{1,n});
				I = I + 1;
		end
		if cmds{2,n}(3)~=0
			actions{I} = 'wheel';
			params{I} = cmds{2,n}(3);
         I = I + 1;
		end
	else % keyboard action
		idx = I:(I+Nactions(n)-1);
		actions(idx) = cmds{1,n};
		params(idx) = cmds{2,n};
		I = I + Nactions(n);
	end
end

end % convertToLowLevelActions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% expand keyboard action to a sequence of 'key_down' and 'key_up'
function	[actions,params,msg] = parseKeyboardText(cmd,text,oemChars)

import java.awt.event.KeyEvent

actions = {};
params = {};
msg = '';

% virtual key codes for escape keys
spKeys = [{'\\'      KeyEvent.VK_BACK_SLASH
		'\BACKSPACE'   KeyEvent.VK_BACK_SPACE
		'\TAB'         KeyEvent.VK_TAB
		'\ENTER'       KeyEvent.VK_ENTER
		'\SHIFT'       KeyEvent.VK_SHIFT
		'\CTRL'        KeyEvent.VK_CONTROL
		'\ALT'         KeyEvent.VK_ALT
		'\PAUSE'       KeyEvent.VK_PAUSE
		'\CAPSLOCK'    KeyEvent.VK_CAPS_LOCK
		'\ESC'         KeyEvent.VK_ESCAPE
		'\PAGEUP'      KeyEvent.VK_PAGE_UP
		'\PAGEDOWN'    KeyEvent.VK_PAGE_DOWN
		'\END'         KeyEvent.VK_END
		'\HOME'        KeyEvent.VK_HOME
		'\LEFT'        KeyEvent.VK_LEFT
		'\UP'          KeyEvent.VK_UP
		'\RIGHT'       KeyEvent.VK_RIGHT
		'\DOWN'        KeyEvent.VK_DOWN
      '\PRINTSCREEN' KeyEvent.VK_PRINTSCREEN
		'\INSERT'      KeyEvent.VK_INSERT
		'\DELETE'      KeyEvent.VK_DELETE
		'\WINDOWS'     KeyEvent.VK_WINDOWS
		'\NUMLOCK'     KeyEvent.VK_NUM_LOCK
		'\SCROLLLOCK'  KeyEvent.VK_SCROLL_LOCK}
      [strcat({'\F'},num2str((1:12)','%02d')) num2cell(KeyEvent.VK_F1+(0:11)')
      strcat({'\F'},num2str((13:24)','%02d')) num2cell(KeyEvent.VK_F13+(0:11)')]];

% scan the text and determine regular vs. special key and total number of characters
chCodes = zeros(numel(text),1);
idx = 0;

% ID type of each character in text: 
%    regular char -> ASCII code
%    escape char -> negative of row index to spKeys followed by zeros
if numel(text)==1 % single character (to account for '\' case)
   chCodes = text;
else % string of characters
   while ~isempty(text)
      if text(1)=='\' % first character = special character
         tok = '';
         rest = text;
      else % first character = regular character
         [tok,rest] = strtok(text,'\');
      end
      chCodes(idx+(1:numel(tok))) = tok; % regular characters
      idx = idx+numel(tok);
      if isempty(rest), break; end

      I = find(cellfun(@(sch)strncmpi(rest,sch,numel(sch)),spKeys(:,1)));
      if isempty(I)
         msg = 'Invalid key.';
         return;
      end
      chCodes(idx+1) = -I;
      idx = idx + numel(spKeys{I});
      text = rest(numel(spKeys{I})+1:end);
   end
end

% remove the zero fillers for escape key string
chCodes = chCodes(chCodes~=0);

% total number of characters to type
Nchars = numel(chCodes);

% determine the virtual key codes for each key & need for shift key press
keycodes = zeros(Nchars,1);
shifts = false(Nchars,1);
I = chCodes>0;

%  - regular keys first
vkc = char(chCodes(I));
s = false(size(vkc));

%  * upper case
idx = vkc>='A' & vkc<='Z';
s(idx) = true;

%  * lower case
idx = vkc>='a' & vkc<='z';
vkc(idx) = vkc(idx)-'a'+'A';

%  * OEM keys
[idx1,J1] = ismember(vkc,oemChars(:,1)); % no shift
[idx2,J2] = ismember(vkc,oemChars(:,2)); % with shift
vkc(idx1) = cell2mat(oemChars(J1(idx1),3));
vkc(idx2) = cell2mat(oemChars(J2(idx2),3));
s(idx2) = true;

%  - update regular keys
keycodes(I) = vkc;
shifts(I) = s;

%  - then escape keys (no shift)
I = ~I;
keycodes(I) = cell2mat(spKeys(-chCodes(I),2));

%determine how to press keys
idx_type = strcmpi(cmd,{'key_normal','key_ctrl','key_alt','key_win'});
mod = any(idx_type(2:4)); % true to press modifier key during
press = ~strcmpi(cmd,'key_up'); % true to press key
release = ~strcmpi(cmd,'key_down'); % true to release key
shifts = [shifts(1);diff(shifts)]; % if 1, shift down, if -1 shift up (for each key)
release_shift = sum(shifts)>0; % if last character needs shift down, release it at the end

%determine total # of key down/up actions to perform
Nacts = 2*mod ... % if needs modiefier key, must press & release (2)
   + Nchars*(press+release) ... % for each character, needs 2 (if down&up) or 1 (if down or up)
   + sum(shifts~=0) ... % for each shift press/release actions
	+ release_shift; % to release the shift at the end

% define the keyboard action command cell
actions = cell(Nacts,1);
params = cell(Nacts,1);
I = 1; % action index
if mod % press the modifier key
	actions{I} = 'key_down';
	switch find(idx_type,1)
		case 2 %'key_ctrl'
			mod_param = KeyEvent.VK_CONTROL;
		case 3 %'key_alt'
			mod_param = KeyEvent.VK_ALT;
		case 4 %'key_win'
			mod_param = KeyEvent.VK_WINDOWS;
      otherwise % should never get here
			mod_param = [];
	end
	params{I} = mod_param;
	I = I + 1;
end
for n = 1:Nchars; % for each character
	if shifts(n)~=0 % shift key action needed
		if shifts(n)>0 % 1:press shift key
			actions{I} = 'key_down';
      else           % -1:release shift key
			actions{I} = 'key_up';
		end
		params{I} = KeyEvent.VK_SHIFT;
		I = I + 1;
	end
	if press
		actions{I} = 'key_down';
		params{I} = keycodes(n);
		I = I + 1;
	end
	if release
		actions{I} = 'key_up';
		params{I} = keycodes(n);
		I = I+1;
	end
end
if release_shift
	actions{I} = 'key_up';
	params{I} = KeyEvent.VK_SHIFT;
	I = I + 1;
end
if mod % release the modifier key
	actions{I} = 'key_up';
	params{I} = mod_param;
end

end % parseKeyboardText

% Copyright (c)2010, Takeshi Ikuma
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%   * Redistributions of source code must retain the above copyright
%   notice, this list of conditions and the following disclaimer. *
%   Redistributions in binary form must reproduce the above copyright
%   notice, this list of conditions and the following disclaimer in the
%   documentation and/or other materials provided with the distribution.
%   * Neither the names of its contributors may be used to endorse or
%   promote products derived from this software without specific prior
%   written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
