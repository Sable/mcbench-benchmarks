function fdonut(fig_size,sound_factor,n_incr)

% FDONUT Forbidden Donut: favorite pastime of Homer Simpson
%   FDONUT starts with default parameters
%
%   FDONUT(FIG_SIZE,SOUND_FACTOR,ANIM_SPEED) requires 
%   3 arguments as follow:
%       FIG_SIZE: height (or width) in pixels (scalar) of the 
%          figure window 
%       SOUND_FACTOR: sound level setting (scalar)
%          min:0 -> no sound ; max:1 -> full sound
%       ANIM_SPEED: donut animation speed (scalar) after the 
%          "Hummmmm forbidden do........nut !" sound
%          min:1 -> fastest ; max:some hundreds -> slower
%
%   FDONUT only accepts no-agument OR 3 arguments.
%

%   Author: Jérôme Briot
%   Contact: dutmatlab@yahoo.fr
%   Version: 1.0 - Aug 2006
%   Comments:
%

% Check number of input arguments (should be 0 or 3)
if nargin~=0 & nargin~=3
    
    error('Number of input arguments must be 0 or 3')
    
end

% Set default values if no input arguments
if nargin==0
    
    sound_factor=.75; % You can change this (0.0 no sound to 1.0 full sound) 
    fig_size=350; % You can change this (200px to smaller than the screen size)
    n_incr=300; % Increase -> slower donut animation ; decrease -> faster donut animation
    
end

% Check FIGURE size 
if fig_size<200 % 200px is a good min size
    error('Figure size too small (min: 200px)')
end

% Get the screen size in pixels. But first store current units and switch it back next.
units_0=get(0,'units');
set(0,'units','pixels')
scr=get(0,'screensize');
set(0,'units',units_0);

clear units_0

% Check FIGURE height
if fig_size>scr(3)
    error('Figure width too large')
end

% Check FIGURE width
if fig_size>scr(4)
    error('Figure height too large')
end

% Check soud factor (0.0 to 1.0)
if sound_factor<0 | sound_factor>1
    error('Sound factor must be between 0.0 and 1.0')
end

% Check speed effect (>1)
if n_incr<1
    error('Speed must be greater than 1')
end

% Fig_size must be a multiple of the donut IMAGE size (32px)
% If it is not, add the remainder.
fig_size=fig_size+32-mod(fig_size,32);

% Close the "Forbiden Donut" FIGURE if exists
% This prevent multiple figures to be created
close(findobj('type','figure','tag','fdonut_fig'));

% Create the "Forbiden Donut" FIGURE
fdonut_fig=figure(...
    'units', 'pixels', ... % Specify the size of the FIGURE in pixels
    'position', [(scr(3)-fig_size)/2 (scr(4)-fig_size)/2 fig_size fig_size], ... % Centers in the middle of the screen
    'numbertitle', 'off',... % Removes "Figure No. #"
    'name', 'Forbidden Donut - dutmatlab@yahoo.fr - Dist: 0',... % Adds name 
    'menubar', 'none', ... % Removes the menus (File, Edit, Tools ...)
    'toolbar', 'none', ... % Removes the toolbar with icons 
    'doublebuffer', 'on', ... % Produces flash-free rendering for simple animations
    'pointer', 'custom', ... % During the first Homer's quote, the pointer is hidden (see next comment)
    'pointershapecdata', repmat(nan,16,16), ... % This is easily done by setting the 16x16 matrix to NaN
    'closerequestfcn', [], ... % The FIGURE can't be closed (for the moment)
    'tag', 'fdonut_fig'); % Adds a tag to the FIGURE to get/set its properties later

% Set the resize property of the FIGURE to off.
% This line is separeted from the others above because of a bug in Matlab R12.1
set(fdonut_fig,'resize','off')

% The donut IMAGE
M=[ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0 0 0 0 0 5 5 5 5 5 5 5 5 0 0 0 0 0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0 0 5 5 5 1 1 1 1 1 1 2 4 4 5 5 0 0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 5 2 2 1 1 4 4 4 4 4 4 4 1 1 1 2 5 5 0 0 0 0 0 0 0
	0 0 0 0 0 5 2 2 1 4 4 4 5 5 5 5 6 5 5 5 4 4 1 1 1 4 5 0 0 0 0 0
	0 0 0 0 5 1 1 4 4 5 6 6 6 6 6 6 6 6 6 6 6 7 6 4 4 1 4 5 0 0 0 0
	0 0 0 9 4 1 4 5 6 6 3 3 3 6 3 3 3 3 3 6 3 6 6 6 7 4 1 5 5 0 0 0
	0 0 0 5 4 4 6 6 3 3 1 3 3 3 3 1 3 3 1 3 3 3 3 6 6 6 5 4 5 9 0 0
	0 0 5 4 6 5 3 3 3 1 3 1 1 1 3 1 1 1 1 3 3 1 3 3 6 7 6 7 4 5 0 0
	0 9 4 5 6 3 3 3 1 0 1 0 1 1 1 3 1 3 1 0 1 3 1 3 3 6 6 7 7 4 9 0
	0 9 4 6 3 3 1 1 1 1 1 1 3 3 3 1 3 3 1 3 1 0 1 1 3 3 6 6 6 4 9 0
	0 6 5 6 3 1 1 1 0 1 1 3 3 3 3 3 3 3 3 1 3 1 1 3 1 3 3 6 7 7 5 0
	9 7 6 3 1 3 1 3 1 1 3 3 6 6 6 0 0 6 6 3 3 3 1 0 1 3 3 6 6 7 6 9
	9 6 6 3 1 0 3 1 1 3 3 6 6 7 0 0 0 0 6 6 3 3 3 0 1 1 3 3 7 6 7 9
	9 6 3 3 1 1 1 1 3 3 3 6 7 9 0 0 0 0 9 7 6 3 3 1 0 1 3 3 6 7 7 9
	9 6 3 1 0 1 1 3 3 3 6 7 8 9 0 0 0 0 9 8 7 6 3 3 1 3 1 3 7 6 7 9
	9 6 3 1 1 1 0 1 3 6 6 7 8 9 9 9 9 9 9 8 7 6 3 3 0 1 3 3 6 7 7 9
	9 6 3 1 0 1 1 3 3 6 6 7 8 8 9 9 9 9 8 8 7 6 6 3 1 3 1 3 6 6 7 9
	9 9 3 1 0 3 1 1 3 6 6 7 7 8 8 9 9 8 8 7 7 6 6 3 0 1 3 3 6 7 9 9
	0 9 6 3 1 1 0 1 3 6 6 7 7 7 8 8 8 8 7 7 7 6 3 3 0 1 1 3 7 6 9 0
	0 9 7 3 0 1 1 3 1 3 6 6 7 7 7 7 7 7 7 7 6 6 3 1 1 0 3 3 6 7 9 0
	0 9 9 3 1 0 0 0 3 3 6 6 6 7 7 7 7 7 6 6 6 3 1 3 1 1 3 3 6 9 9 0
	0 0 9 9 3 1 0 1 1 0 3 1 6 6 6 6 6 6 6 3 3 1 3 1 1 3 3 6 7 9 0 0
	0 0 0 9 7 3 1 0 1 0 1 3 3 3 3 3 3 3 3 3 1 3 0 3 3 3 6 7 9 9 0 0
	0 0 0 9 9 7 3 1 0 1 0 0 1 1 3 1 3 1 3 1 3 0 3 1 3 6 7 9 9 0 0 0
	0 0 0 0 9 9 9 3 1 0 1 3 1 0 1 3 1 1 1 0 1 1 3 3 3 9 9 9 0 0 0 0
	0 0 0 0 0 9 9 9 9 3 0 0 1 1 0 1 0 0 3 1 3 3 6 9 9 9 9 0 0 0 0 0
	0 0 0 0 0 0 0 9 9 9 9 9 1 1 1 1 1 1 3 3 9 9 9 9 9 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0 0 9 9 9 9 9 9 9 9 9 9 9 9 9 9 0 0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0 0 0 0 0 9 9 9 9 9 9 9 9 0 0 0 0 0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]+1;

% Get the size of the IMAGE for later use
size_M=size(M);

% The associated colormap
map=[1.0 1.0 1.0
	 1.0 0.8 0.6
	 1.0 0.8 0.4
	 1.0 0.6 0.4
	 1.0 0.6 0.0
	 1.0 0.4 0.0
	 0.8 0.4 0.2
	 0.6 0.2 0.0
	 0.4 0.2 0.0
	 0.0 0.0 0.0];

% Set the FIGURE colormap to the one found in the bmp file
colormap(map)

% Create the AXES that handle the IMAGE
fdonut_ax=axes(...
    'units', 'normalized', ... % Full size AXES
    'position', [0 0 1 1], ... % Full size AXES
    'color', 'w', ... % Sets color to white    
    'xcolor', 'w', ... % Sets the color of x-axis to white ( -> invisible)
    'ycolor', 'w', ... % Sets the color of y-axis to white ( -> invisible)
    'dataaspectratio', [1 1 1], ...% Equivalent to AXIS EQUAL
    'xtick', [], ... % Removes all ticks along x-axis
    'ytick', [], ... % Removes all ticks along y-axis
    'nextplot', 'add', ... % Uses the current axes to draw all graphics objects.
    'xlim', [.5*(fig_size-size_M(2)) .5*(fig_size+size_M(2))], ... % Controls placement of IMAGE along x-axis
    'ylim', [.5*(fig_size-size_M(1)) .5*(fig_size+size_M(1))]); % Controls placement of IMAGE along y-axis 

% Create the donut IMAGE in the middle of the FIGURE
% The low-level routine is used here to avoid the creation of a new axes
image( ...
    'cdata', M, ... % IMAGE data
    'xdata', [.5*(fig_size-size_M(2)) .5*(fig_size+size_M(2))], ... % Controls placement of IMAGE along x-axis
    'ydata', [.5*(fig_size-size_M(1)) .5*(fig_size+size_M(1))], ... % Controls placement of IMAGE along y-axis  
    'hittest', 'off', ... % Necessary to let the ButtonDownFcn of the AXES works properly
    'tag', 'donut_im') % Adds a tag to the IMAGE to get/set its properties later

clear M alph map

% Load and play the "Hummmmm fobidden do........nut !" sound
[Y,FS,NBITS]=wavread('fdonut2.wav');
sound(Y*sound_factor,FS);

% Load the "Doh!" sound an store it to avoid multiple call to WAVREAD later.
[Y,FS,NBITS]=wavread('doh1.wav');
doh.Y=Y*sound_factor;
doh.FS=FS;
setappdata(gcf,'doh',doh)

clear Y FS NBITS

% Ensure that the sound is over
pause(4)

% Donut animation after the "Hummmmm fobidden do........nut !" sound
% Decrease/increase AXES xlim/ylim range.
incr=[linspace(.5*(fig_size-size_M(2)),1,n_incr); 
      linspace(.5*(fig_size+size_M(2)),fig_size,n_incr)];

for n=1:size(incr,2)    
    
    set(fdonut_ax, ...
        'xlim', [incr(1,n) incr(2,n)], ... 
        'ylim', [incr(1,n) incr(2,n)]) % Update the AXES limits
    
    drawnow % Forces the scene to render
    
end

% Add the interactive property now.
% It is safer to avoid mouse-click during wav playing
set(fdonut_fig, ...
    'windowbuttonmotionfcn', @wbmfcn, ... % Executes when the pointer moves in the figure
    'pointer', 'crosshair', ... % Sets the pointer of the FIGURE
    'closerequestfcn', 'closereq') % Restores the possibility to close the FIGURE

set(fdonut_ax, 'buttondownfcn', @bdfcn) % Executes when the mouse button is press down in the figure

function wbmfcn(obj,event)

% WBMFCN WindowButtonMotionFcn of the FIGURE
%   WBMFCN keeps the donut away from the pointer.
%

    % Get the handle of the donut IMAGE
    h_donut=findobj('type','image','tag','donut_im');
    
    % Get the coordinates of the 4 vertices of the IMAGE
    m_pos=get(h_donut,{'xdata' 'ydata'});
    
    % Get the coordinates of the current point
	cp=get(gca,'currentpoint');
	
	% Get the FIGURE size 
    % OBJ is the current FIGURE handle.
	fig_size=get(obj,'position');
	
    % Compute x and y distance
	delt=[cp(1)-.5*(m_pos{1}(2)+m_pos{1}(1)) cp(1,2)-.5*(m_pos{2}(2)+m_pos{2}(1))];
    
    % Compute resultant distance
	d=sqrt(delt(1)^2+delt(2)^2);
	
	if d<23 % The pointer is coming too near
       
		m_pos{1}=m_pos{1}-delt(1);
        m_pos{2}=m_pos{2}-delt(2);
        
        % Check if the donut IMAGE break the y-axis
        if m_pos{1}(2)<16 | m_pos{1}(1)>(fig_size(3)-16)
            
            m_pos{1}=m_pos{1}+3*delt(1);
            
        end
        
        % Check if the donut IMAGE break the x-axis
        if m_pos{2}(2)<16 | m_pos{2}(1)>(fig_size(3)-16)
            
            m_pos{2}=m_pos{2}+3*delt(2);
            
        end
        
	end
	
    % Update the donut IMAGE position
	set(h_donut,{'xdata' 'ydata'},m_pos);
	
    % Update the FIGURE window title
    % OBJ is the current FIGURE handle.
	set(obj, ...
        'name', sprintf('Forbidden Donut - dutmatlab@yahoo.fr - Dist: %.1f ',d));
	
    % Fix the xlim/ylim of the AXES
	set(gca, ...
        'xlim', [1 fig_size(3)], ...
        'ylim', [1 fig_size(3)])

function bdfcn(obj,event)

% BDFCN ButtonDownFcn of the AXES
%   BDFCN plays the famous "Doh!" when the user try to get the donut
%

    % Temporary remove the buttondownfcn property to avoid multiple clicks during wav play
    % OBJ is the current AXES handle
	set(obj,'buttondownfcn',[])
	
    % Get the "Doh!" sound parameters
	doh=getappdata(gcf,'doh');
    % Play the sound
	sound(doh.Y,doh.FS);

    % Ensure that the sound is over
	pause(.3)
	
    % Restore the buttondownfcn
    % OBJ is the current AXES handle
 	set(obj,'buttondownfcn',@bdfcn)