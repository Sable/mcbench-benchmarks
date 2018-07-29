function jmouseemu(varargin)
%JMOUSEEMU   Java-Based Mouse Emulator
%   JMOUSEEMU(POS) moves mouse cursor to POS = [X,Y] (in pixels) on the
%   current figure. If there is no figure open, POS specifies the position
%   with respect to the bottom-left corner of the screen.
%
%   JMOUSEEMU(POS,CLICK) defines the button click option. CLICK is a string
%   argument with five possible values [ {'none'} | 'normal' | 'extend' |
%   'alternate' | 'open']. The click option follows the Figure's
%   SelectionType property:
%
%      'none'      - No mouse click (default)
%      'normal'    - Click left mouse button
%      'extend'    - Shift-click left mouse button
%      'alternate' - Control-click left mouse button
%      'open'      - Double click any mouse button
%
%   If only mouse click without cursor movement is desired, leave POS
%   empty.
%
%   JMOUSEEMU(H,...) explicitly specifies the graphics object handle to
%   which (X,Y) coordinate is specified. Supported types of graphics
%   object are figure, axes, uibuttongroup, uicontrol, uipanel, and
%   uitable. If POS is empty with H defined (non-zero), POS is
%   automatically set to the upper left hand corner of the specified
%   object.
%
%   JMOUSEEMU(CMDS,T) can be used to perform multiple commands defined in
%   CMDS cell array with command interval T seconds (default: 0). CMDS
%   is an N-by-3 cell array where the k-th row {H_k,POS_k,CLICK_k} defines
%   the k-th mouse position/clicking command. If H_1 (i.e., CMDS{1,1}) is
%   empty, the position is defined w.r.t. current figure or w.r.t. screen
%   if no figure is open. Other empty H_k's (i.e., CMD{2:end,1}) defaults
%   to H_(k-1).
%
%   In addition to the 5 CLICK options for the single-command mode, 2
%   additional click options are available to enable mouse dragging:
%
%      'drag_on'	 - Click left mouse button and hold
%      'drag_off'  - Release held left mouse button
%
%   Every 'drag_on' must be paired with subsequent 'drag_off', and no other
%   mouse click commands is allowed during dragging.
%
%   To insert a one-time pause, CLICK option can also be set to 'delay'
%   with duration in seconds specified in POS as a single scalar. The value
%   for H is ignored.
%
%   JMOUSEEMU(CMDS,DeltaT) specifies the intervals between commands with
%   length-N DeltaT vector. DeltaT(1) indicates the initial delay.
%
%   IMPORTANT NOTE: 
%
%   If JMOUSEEMU is used to trigger a sequence of HG callbacks, call
%   JMOUSEEMU multiple times, so that only the last command in each
%   JMOUSEEMU call triggers a callback.
%
%   It appears that HG callbacks are only queued and not actually
%   triggered during JMOUSEEMU execution. All callbacks occur only after
%   JMOUSEEMU exits. Therefore, if a mouse button callback utilizes
%   figure's SelectionType property, it may result in behaving erroneously.
%   

% Version 2.2 (Aug. 27, 2010)
% Written by: Takeshi Ikuma
% Created: Aug. 2, 2010
% Revision History:
%  - (Aug. 2, 2010) : initial release
%  v2.0 (Aug. 11, 2010)
%     * more click options
%     * added multiple-command support
%     * timer-based mouse motion
%  v2.1 (Aug. 14, 2010)
%     * Fixed figure auto focus bug
%     * Allowing T = 0
%     * Allowing no input argument (equivalent to move mouse to the top
%       left corner of the figure window)
%  v2.2 (Aug. 27, 2010)
%     * Changed from using MATLAB timer to using java.Robot.delay() and
%       java.Robot.waitForIdle() functions
%     * Added 'delay' "click" option for momentary pause
%     * Added support for DeltaT vector instead of constant T interval
%  v2.3 (Aug. 05, 2013)
%     * Fixed an error that occurs when called with a single input argument

% parse input arguments
[cmds,DeltaT,msg] = parseInput(nargin,varargin);
if ~isempty(msg), error(msg); end

Ncmds = size(cmds,1); % number of commands

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize handle if not given
if isempty(cmds{1,1})
	cmds{1,1} = get(0,'CurrentFigure');
	if isempty(cmds{1,1}) % no figure currently open
		cmds{1,1} = 0;
	end
end

% convert DeltaT and 'delay' duration from s to ms
DeltaT(:) = DeltaT*1e3;
idx = cellfun(@(click)click(9),cmds(:,3));
cmds(idx,2) = cellfun(@(T)T*1e3,cmds(idx,2),'UniformOutput',false);

% if position not defined by non-zero handle defined, set to the top
% corner of the handle object
if cmds{1,1}~=0 && isempty(cmds{1,2})
	units = get(cmds{1,1},'units');
	set(cmds{1,1},'units','pixels');
	pos = get(cmds{1,1},'position');
	set(cmds{1,1},'units',units);
	cmds{1,2} = [0 pos(4)-3];
end

% set commands handle
for n = 1:Ncmds
	% if handle not given, use the previously defined handle
	if isempty(cmds{n,1}), cmds{n,1} = cmds{n-1,1}; end
end

% find unique handles & their location (its lower left hand corner)
[H,~,I] = unique(cell2mat(cmds(:,1)));
Nh = numel(H);
pos0 = zeros(Nh,2);
focusFig = false;
for n = 1:Nh
	while H(n)~=0
		% put the figure on focus
		if ~focusFig && strcmp(get(H(n),'type'),'figure')
			figure(H(n)); drawnow;
			focusFig = true;
		end
		
		% position conversion (preserve the object's Units property)
		units = get(H(n),'units');
		set(H(n),'units','pixels');
		p = get(H(n),'position');
		set(H(n),'units',units);
		pos0(n,:) = pos0(n,:) + p(1:2);
		
		H(n) = get(H(n),'Parent'); % go up in the graphics object hierchy
	end
end

% convert pos0's reference to upper left corner
scrn = get(0,'ScreenSize');
pos0(:,2) = scrn(4)-pos0(:,2);

% get absolute mouse positions
for n = 1:Ncmds
	if numel(cmds{n,2})~=2, continue; end % do nothign if position not given
	ref = pos0(I(n),:);
	cmds{n,2}(1) = ref(1) + cmds{n,2}(1);
	cmds{n,2}(2) = ref(2) - cmds{n,2}(2); % w.r.t. upper left corner reference
end

% make sure the figure has the focus
drawnow;
% pause(0.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

import java.awt.Robot
import java.awt.event.InputEvent
import java.awt.event.KeyEvent

% initialize the java.robot
robot = Robot();

% queue the mouse commands
for n = 1:Ncmds
	robot.delay(DeltaT(n));
	
	% delay or wheel options
	if numel(cmds{n,2})==1
		switch true
			case cmds{n,3}(8)
				robot.mouseWheel(cmds{n,2}(1));
			case cmds{n,3}(9)
				robot.delay(cmds{n,2}(1));
		end
		continue;
	end
	
	% move mouse cursor
	if ~isempty(cmds{n,2})
		robot.mouseMove(cmds{n,2}(1),cmds{n,2}(2));
	end
	
	% if appropriate, press modifier key
	switch (true)
		case cmds{n,3}(3) % 'extend'
			robot.keyPress(KeyEvent.VK_SHIFT);
		case cmds{n,3}(4) % 'alternate'
			robot.keyPress(KeyEvent.VK_CONTROL);
	end
	
	% click (or enable/disable dragging)
	if ~any(cmds{n,3}([1 7])) % neither 'drag_off' nor 'none'
		robot.mousePress(InputEvent.BUTTON1_MASK);
	end
	if ~any(cmds{n,3}([1 6])) % neither 'drag_on' nor 'none'
		robot.mouseRelease(InputEvent.BUTTON1_MASK);
	end
	
	% if appropriate, release modifer key or click again
	switch (true)
		case cmds{n,3}(3) % 'extend'
			robot.keyRelease(KeyEvent.VK_SHIFT);
		case cmds{n,3}(4) % 'alternate'
			robot.keyRelease(KeyEvent.VK_CONTROL);
		case cmds{n,3}(5) % 'open'
			robot.mousePress(InputEvent.BUTTON1_MASK);
			robot.mouseRelease(InputEvent.BUTTON1_MASK);
	end
	
end

robot.waitForIdle(); % blocks until last action is dequeued (not actually performed)
pause(0.05); % extra pause to let all mouse actions to complete

end % jmouseemu()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parse Input Arguments
function [cmds,DeltaT,msg] = parseInput(n,argin)

cmds = {};
DeltaT = [];

msg = nargchk(0,3,n); %#ok
if ~isempty(msg), return; end

if n<1 || ~iscell(argin{1}) % single-command mode
	cmds = cell(1,3);
	switch n
		case 1
			cmds(2) = argin(1);
		case 2
			if ischar(argin{2})
				cmds(2:3) = argin(1:2);
			else
				cmds(1:2) = argin(1:2);
			end
		case 3
			cmds = argin(1:3);
	end
else % multiple command mode
	msg = nargchk(1,2,n); %#ok
	if ~isempty(msg), return; end
	
	cmds = argin{1};
	if n>1
		DeltaT = argin{2};
	end
end

% check cmds
if ~iscell(cmds) || size(cmds,2)~=3
	msg = 'CMDS must be a 2-D cell array with 3 columns.';
	return;
end
if any(cellfun(@(h)~isempty(h) && (~ishandle(h)  || numel(h)~=1 || ~ismember({get(h,'type')},{'root','figure','axes','uicontrol','uipanel','uitable'})),cmds(:,1)))
	msg = 'Specified graphics object handle is invalid or not supported.';
	return;
end
if any(cellfun(@(x)~isempty(x) && (~isnumeric(x) || any(isinf(x)) || any(isnan(x))),cmds(:,2)))
	msg = 'Position must be finite numeric values';
	return;
end
click_types = {'none','normal','extend','alternate','open','drag_on','drag_off','wheel','delay'};
if any(cellfun(@(click)~isempty(click) && (~ischar(click) || ~ismember({lower(click)},click_types)),cmds(:,3)))
	msg = 'Mouse click option must be one of ''none'',''normal'',''extend'',''alternate'',''open'',''drag_on'',''drag_off'',''wheel'',''delay.''';
	return;
end

% replace click options to logical vector
cmds(:,3) = cellfun(...
	@(click)strcmpi(click,click_types),...
	cmds(:,3),'UniformOutput',false);
cmds(cellfun(@(x)~any(x(2:9)),cmds(:,3)),3) = {[true false(1,8)]};

% check position vector size
if any(cellfun(@(pos,click)all(numel(pos)~=[0 2])&&any(click(1:7)),cmds(:,2),cmds(:,3)))
	msg = 'Mouse position must be a 2-element vector.';
	return;
end
if any(cellfun(@(pos,click)click(8)&&numel(pos)~=1,cmds(:,2),cmds(:,3)))
	msg = 'Mouse wheel travel must be a scalar value.';
	return;
end
if any(cellfun(@(pos,click)click(9)&&(numel(pos)~=1&&pos(1)<0),cmds(:,2),cmds(:,3)))
	msg = 'Pause duration must be a positive scalar value.';
	return;
end

% check button click conflict with drag option
n_drag_on = find(cellfun(@(x)x(6),cmds(:,3)));
n_drag_off = find(cellfun(@(x)x(7),cmds(:,3)));
n_click = find(cellfun(@(x)any(x(2:5)),cmds(:,3)));
if numel(n_drag_on)~=numel(n_drag_off) || any(n_drag_on>n_drag_off)
	msg = '''drag_on'' must be followed by ''drag_off''.';
	return;
end
for n = 1:numel(n_drag_on)
	if any(n_click>n_drag_on(n) & n_click<n_drag_off(n))
		msg = 'Mouse button cannot be clicked during dragging.';
		return;
	end
end

% check T
if isempty(DeltaT)
	DeltaT = 0.01*ones(size(cmds,1),1);
elseif ~isnumeric(DeltaT) || any(DeltaT<0 | isnan(DeltaT) | isinf(DeltaT))
	msg = 'DeltaT must be a strictly positive scalar.';
	return;
elseif numel(DeltaT)==1
	DeltaT = DeltaT*ones(size(cmds,1),1);
elseif numel(DeltaT)~=size(cmds,1)
	msg = 'DeltaT must be either a scalar or a vector with matching size to CMDS';
end

end % parseinput()

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
