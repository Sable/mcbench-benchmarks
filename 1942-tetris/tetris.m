function tetris(action)

% TETRIS for MATLAB
%	
%	To begin, simply type: tetris
%
%	Only one game can be run at a time.
%	UN-PAUSE (I know that's not a word) the game by hitting RETURN
%	in the Matlab command window. 
%
%	Please feel free to modify, improve, rewrite, cleanup the code etc.
%	Written and tested on a SUN running Matlab 4.2c, but should work with
%	Matlab 4.0, if not you can debug/modify it.
%	This is FREEWARE, enjoy!   -  Peace & Love

%
%	Author: Maurice Smith, 1/19/95 (msmith@bme.jhu.edu) 

global CENTER_X CENTER_Y POS STUCK USED_SPACE H;
global WIDTH1 HEIGHT1 LEVEL TIME_DELAY SQ_X SQ_Y;
global H_SLIDER_LEVEL H_SLIDER_WIDTH H_SLIDER_HEIGHT;
global H_TEXT_LEVEL H_TEXT_WIDTH H_TEXT_HEIGHT H_TEXT_SCORE;
global START_HANDLE STOP_HANDLE STOP_GAME EXIT_HANDLE;
global H_A H_B BOX H_LINE MIN_DELAY MAX_DELAY;
 
if nargin < 1, action = 'initialize'; end;

if strcmp(action,'initialize'),

default_width = 10;		% default width of tetris play-field
default_height = 25;		% default hieght of tetris play-field
default_level = 5;		% default skill level
default_box = 1;		% default play field outline (on=1, off=0)

WIDTH1 = default_width;
HEIGHT1 = default_height;
LEVEL = default_level;
BOX = default_box;

MIN_DELAY = 0.1;		% delay corresponding to skill level 9
MAX_DELAY = 1;			% delay corresponding to skill level 0
TIME_DELAY = MAX_DELAY*exp((LEVEL/9)*log(MIN_DELAY/MAX_DELAY));
fig=figure( ...
        'Name','Tetris for Matlab', 'NumberTitle','off', ...
        'Visible','off', 'BackingStore','off');

SQ_X = [0 -1 -1 0]';	% vertex coordinates of unit square (for "patch" command) 
SQ_Y = [0 0 -1 -1]';

on = 'set(go_handle,''back'',''cyan''), ';
off = 'set(go_handle,''back'',''default''), ';

figure(fig);
H_A = axes( ...
        'Units','normalized', 'Position', [.1 .18 .4 .8], ...
        'Visible','off', 'DrawMode','fast', ...
        'NextPlot','replace', 'XLim',[1 WIDTH1+1],'YLim',[0 HEIGHT1]);
H_B = axes( ...
        'Units','normalized', 'Position', [.1 .18 .4 .8],...
        'Visible','off', 'DrawMode','fast', ...
        'NextPlot','replace', 'XLim',[1 WIDTH1+1],'YLim',[0 HEIGHT1]);

if BOX == 1,			% draw outline box initially 
	BOX = ~BOX;
	tetris('box');
end

pause_handle = uicontrol('units','normalized',...
	'position', [.7 .04 .1 .05],'string','pause', ...
	'callback','disp(''press RETURN to continue''); pause;', ...
	'interruptible','no');

box_handle = uicontrol('units','normalized',...
	'position', [.7 .15 .1 .05],'string','box', ...
	'callback','tetris(''box'');', ...
	'interruptible','yes');

STOP_HANDLE = uicontrol('units','normalized',...
	'position', [.55 .04 .1 .05],'string','stop', ...
	'callback','tetris(''stop'')', ...
	'interruptible','yes','visible','off');

EXIT_HANDLE = uicontrol('units','normalized',...
	'position', [.85 .04 .1 .05],'string','exit', ...
	'callback','delete(gcf)', ...
	'interruptible','no');

START_HANDLE = uicontrol('units','normalized',...
	'position', [.55 .04 .1 .05],'string','start', ...
	'callback','tetris(''start'')', ...
	'interruptible','yes','visible','on');

left_handle = uicontrol('units','normalized',...
	'position', [.18 .07 .1 .05 ],'string','<---', ...
	'callback','tetris(''left'')', ...
	'interruptible','yes');

right_handle = uicontrol('units','normalized',...
	'position', [.32 .07 .1  .05 ],'string','--->', ...
	'callback','tetris(''right'')', ...
	'interruptible','yes');

drop_handle = uicontrol('units','normalized',...
	'position',[.25 .01 .1 .05 ],'string','drop', ...
	'callback','tetris(''drop'')');

rotate_handle = uicontrol('units','normalized',...
	'position',[.25 .13 .1 .05],'string','rotate', ...
	'callback','tetris(''rotate'')');


H_TEXT_SCORE = uicontrol(... 
		'ForegroundColor',[ 1 1 1 ],... 
		'Position',[ 0.65 0.85 0.2 0.07 ],... 
		'String','Score: xxxxx',... 
		'Units','normalized'); 


v = version; 
if str2num(v(1:3)) >= 4.2,	% if Matlab 4.2 or later, create slider controls 

H_SLIDER_LEVEL = uicontrol(... 
		'CallBack', 'tetris(''level''); ', 'Max',[ 9 ], 'Min',[ 0 ],...
		'val', LEVEL, 'Position', [ 0.6 0.3 0.04 0.4 ],...
		'Style', 'slider', 'Units', 'normalized'); 

H_SLIDER_HEIGHT = uicontrol(... 
		'CallBack', 'tetris(''height''); ', 'Max', [ 50 ], 'Min', [ 10 ],...
		'val', HEIGHT1, 'Position', [ 0.78 0.3 0.04 0.4 ],... 
		'Style', 'slider', 'Units', 'normalized'); 

H_SLIDER_WIDTH = uicontrol(... 
		'CallBack','tetris(''width''); ','Max',[ 20 ],'Min',[ 6 ],...
		'val',WIDTH1,'Position',[ 0.9 0.3 0.04 0.4 ],... 
		'Style','slider','Units','normalized'); 

H_label_width = uicontrol(... 
		'ForegroundColor',[ 0 1 1 ], 'Position',[0.87 .72 .1 .06],... 
		'String','Width', 'Style','text', 'Units','normalized'); 

H_label_Height = uicontrol(... 
		'ForegroundColor',[ 1 1 0 ], 'Position',[ 0.75 0.72 0.1 0.06 ],... 
		'String','Height', 'Style','text', 'Units','normalized'); 

H_label_level = uicontrol(... 
		'ForegroundColor',[ 1 0 0 ], 'Position',[ 0.57 0.72 0.1 0.06 ],... 
		'String','Level', 'Style','text', 'Units','normalized'); 

H_TEXT_WIDTH = uicontrol(... 
		'ForegroundColor',[ 0 1 1 ], 'Position',[0.87 .22 .1 .06],... 
		'String',num2str(WIDTH1), 'Style','text', 'Units','normalized'); 

H_TEXT_HEIGHT = uicontrol(... 
		'ForegroundColor',[ 1 1 0 ], 'Position',[ 0.75 0.22 0.1 0.06 ],... 
		'String',num2str(HEIGHT1), 'Style','text', 'Units','normalized'); 

H_TEXT_LEVEL = uicontrol(... 
		'ForegroundColor',[ 1 0 0 ], 'Position',[ 0.57 0.22 0.1 0.06 ],... 
		'String',num2str(LEVEL), 'Style','text', 'Units','normalized'); 

end;    % end version 4.2 extras (slider controls & labels)

end; 	% end initialization routine 




if strcmp(action,'level'),				% set skill level
	LEVEL = round(get(H_SLIDER_LEVEL,'val')); 
	set(H_TEXT_LEVEL,'string',LEVEL);
	TIME_DELAY = MAX_DELAY*exp((LEVEL/9)*log(MIN_DELAY/MAX_DELAY)); 
end;	


if strcmp(action,'height'),			% set play-field height
	HEIGHT1 = round(get(H_SLIDER_HEIGHT,'val')); 
	set(H_TEXT_HEIGHT,'string',HEIGHT1); 
end;	


if strcmp(action,'width'),			% set play-field width
	WIDTH1 = round(get(H_SLIDER_WIDTH,'val')); 
	set(H_TEXT_WIDTH,'string',WIDTH1); 
end;	


if strcmp(action,'box'),		% toggle display of play-field outline 
	BOX = ~BOX;
	if BOX == 1, 
		H_LINE = line ([1 WIDTH1+1 WIDTH1+1 1 1], [1 1 HEIGHT1 HEIGHT1 1]);
	else, delete(H_LINE); 
	end
end;	


if strcmp(action,'left'),		% Move Left
	stopped = 0;
	for i=1:4, if USED_SPACE(POS(i,1)-1,POS(i,2)) == 1, stopped=1; end; end;
	if stopped == 0,
		POS(:,1) = POS(:,1) - 1; 
		CENTER_X = CENTER_X - 1;
		for i=1:4, set(H(i),'XData',SQ_X+POS(i,1),'YData',SQ_Y+POS(i,2)); end; 
		drawnow; 
	end;
end;


if strcmp(action,'right'),		% Move Right
	stopped = 0;
	for i=1:4, if USED_SPACE(POS(i,1)+1,POS(i,2)) == 1, stopped=1; end; end;
		
	if stopped == 0, 
		POS(:,1) = POS(:,1) + 1;
		CENTER_X = CENTER_X + 1;
		for i=1:4, set(H(i),'XData',SQ_X+POS(i,1),'YData',SQ_Y+POS(i,2)); end; 
		drawnow; 
	end;
end;


if strcmp(action,'drop'),		% Drop Piece Down
	while STUCK==0, 
		for i=1:4, if USED_SPACE(POS(i,1),POS(i,2)-1) == 1, STUCK=1; end; end;
		if STUCK == 0, POS(:,2) = POS(:,2) -1; end;	 
	end; 
	for i=1:4, set(H(i),'XData',SQ_X+POS(i,1),'YData',SQ_Y+POS(i,2)); end; 
	drawnow;

end;


if strcmp(action,'rotate'),			% Rotate
	new_x = -(POS(:,2) - CENTER_Y) + CENTER_X;
	new_y = (POS(:,1) - CENTER_X) + CENTER_Y;
	stopped = 0;
	for i=1:4, 
		if ((new_x>1) & (new_x<(WIDTH1+2)) & (new_y>1)), 
			if USED_SPACE(new_x(i), new_y(i)) == 1, stopped=1; end;
		else, stopped=1;
		end;
	end;
	if stopped == 0,			% space not occupied
		POS = [new_x new_y];
		for i=1:4, set(H(i),'XData',SQ_X+POS(i,1),'YData',SQ_Y+POS(i,2)); end; 
		drawnow;
	end; 
end;


if strcmp(action,'stop'),             % stop game
	STOP_GAME = 1;
end;	



% start tetris game

if strcmp(action,'start'),             % start game

STOP_GAME = 0;	
score = 0;
set(START_HANDLE, 'visible', 'off');
set(STOP_HANDLE, 'visible', 'on');
set(EXIT_HANDLE, 'visible', 'off');
set(H_TEXT_SCORE, 'string', ['Score: ' num2str(score)]);

h_matb = zeros(WIDTH1+2,HEIGHT1); 
USED_SPACE = zeros(WIDTH1+2,HEIGHT1);
USED_SPACE(:,1) = ones(WIDTH1+2,1);
USED_SPACE ([1 WIDTH1+2],:) = ones(2,HEIGHT1);
%USED_SPACE
drawnow;
axes(H_A); 

% shape definitions 

a_shape = [-1 0 1 2; 0 0 0 0]';		% rectangle 1x4
b_shape = [-1 0 0 1; 0 0 1 0]';		% Z mirror
c_shape = [-1 0 0 1; 0 0 1 1]';		% Z normal
d_shape = [-1 0 0 1; 1 1 0 0]';		% truncated T
e_shape = [0 0 1 1; 0 1 0 1]';		% square 2x2
f_shape = [-1 0 1 1; 0 0 0 1]';		% L normal
g_shape = [-1 -1 0 1; 1 0 0 0]';	% L mirror

shape_matrix = [a_shape b_shape c_shape d_shape e_shape f_shape g_shape]; 
s = size(shape_matrix);
num_shapes = s(2) / 2;

color_matrix = [ 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
home_pos = ones(4,1) * [(WIDTH1/2) (HEIGHT1-2)]; 
POS = a_shape + home_pos;
for i=1:4, H(i) = patch(SQ_X+POS(i,1),SQ_Y+POS(i,2),'r'); end;
	
while ((sum(USED_SPACE(2:WIDTH1+1,HEIGHT1-4)) == 0) & (STOP_GAME == 0)),

	shape_index = ceil(num_shapes*rand(1)); 	% choose random shape
	current_color = color_matrix(shape_index,:);	% associated color
	POS = shape_matrix(:,(2*shape_index - 1):(2*shape_index)) + home_pos;	% set initial postion of shape
	CENTER_X = home_pos(1,1);			% set origin of rotation
	CENTER_Y = home_pos(1,2);
	for i = 1:4, 
		set(H(i),'XData',SQ_X+POS(i,1), 'YData',SQ_Y+POS(i,2), ...
			'FaceColor', current_color, 'Visible', 'on'); 
	end;
	drawnow;
	STUCK = 0;
	t0 = clock;
	while ((STUCK == 0) & (STOP_GAME == 0)),
		drawnow;
		if etime(clock,t0) > TIME_DELAY,	% move piece down one unit
			%etime(clock,t0)		
			for i=1:4,  
				if USED_SPACE(POS(i,1),POS(i,2)-1) == 1, STUCK=1; end; 
			end;
			
			if STUCK == 0,
				t0 = clock;
				POS(:,2) = POS(:,2) - 1;
				CENTER_Y = CENTER_Y - 1;
				for i = 1:4, 
					set(H(i),'YData',SQ_Y+POS(i,2)); 
				end;
				drawnow;
				%etime(clock,t0) 

			end
		end;
		drawnow;
	end
	for i=1:4, USED_SPACE(POS(i,1),POS(i,2)) = 1; end;	% retire piece
	for i = 1:4, set(H(i),'Visible', 'off'); end;		% hide active piece
	axes(H_B);
	for i=1:4, h_matb(POS(i,1),POS(i,2)) = patch(SQ_X+POS(i,1),SQ_Y+POS(i,2),current_color); end;

	i=2;
	while i < HEIGHT1,  				% check if any lines are complete 
		if sum(USED_SPACE(2:WIDTH1+1,i)) == WIDTH1,
			score = score + 10*(LEVEL+1);	% add score for completing line
			set(H_TEXT_SCORE, 'string', ['Score: ' num2str(score)]);
			for k1=2:WIDTH1+1, delete(h_matb(k1,i)); end;
			for k2=(i+1):HEIGHT1,
				for k1=2:WIDTH1+1, 
					if h_matb(k1,k2) ~= 0, 
						%disp([k1 k2 h_matb(k1,k2)]);					
						set(h_matb(k1,k2),'YData',k2-1+SQ_Y); 
					end;
				end;
			end;
			h_matb(2:WIDTH1+1,i:(HEIGHT1-1)) = h_matb(2:WIDTH1+1,(i+1):HEIGHT1);
			h_matb(2:WIDTH1+1,HEIGHT1) = zeros(WIDTH1,1);
			USED_SPACE(2:WIDTH1+1,i:(HEIGHT1-1)) = USED_SPACE(2:WIDTH1+1,(i+1):HEIGHT1);
			USED_SPACE(2:WIDTH1+1,HEIGHT1) = zeros(WIDTH1,1);
		else i = i+1;
		end
		
	end
	axes(H_A);

end  % end while loop


for k2=2:HEIGHT1,		% delete objects and clear play-field
	for k1=2:WIDTH1+1, 
		if h_matb(k1,k2) ~= 0, 
			delete(h_matb(k1,k2)); 
		end;
	end;
end;
set(START_HANDLE, 'visible', 'on');
set(STOP_HANDLE, 'visible', 'off');
set(EXIT_HANDLE, 'visible', 'on');

end  	% end 'start' command (end game)
