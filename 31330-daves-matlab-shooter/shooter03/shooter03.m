%+-------------------------------------------------------+%
%|              DAVE'S MATLAB SHOOTER v0.3               |%
%|                 by David Buckingham                   |%
%|                                                       |%
%|         a vertical-scrolling shoot-em-up game         |%
%+-------------------------------------------------------+%

%+-------------------------------------------------------+%
%|                         TIPS                          |%
%|                                                       |%
%| -kill cruisers as quickly as possible.                |%
%| -game lagging too much? set NO_FILL to true.          |%
%| -program needs access to "hitTest.m"                  |%
%| -questions? email xorvox@hotmail.com                  |%
%+-------------------------------------------------------+%

%v0.3
%-bullets, fireballs, explosions, pause messages are all cleared from the
% secreen when game is reset instead of remaining behind the intro message.
%-fixed image layering order. bots now appear behind messages like game
% over and pause, behind health bars, and above stars. fireballs appear
% behind hud bars.
%-duration of superShoot upgrade is now set in seconds according to
% SUPER_SHOOT_DURATION which is 14. Previously, it was set to 1 and
% decremented each frame by SUPER_SHOOT_DRAIN, which was set to .002.
%-no points are scored if INVINCIBLE
%-the problem with bot plots changin slightly when bullets are on screen
% mysteriously fixed itself :)
%-bots can exit bounds to left or right if less than BOT_END above bottom
% instead of always moving out through the bottom of the screen.
%-function name now matches filename (oops).
%-added tips section at top of code
 
%v0.2
%-decrease fireball speed from 3 to 2.5
%-increase hero speed from 7 to 7.5
%-increase shield restore rate from .0001 to .00015 per frame
%-enemy models 1 and 2 drop fewer upgrades
%-waves last longer
%-instead of at top of plot, bots are generated at top of plot plus some
% distance BOT_START. this delays return of bots after using bomb.
%-shorten break between waves to compensate for addition of BOT_START.
%-explosion when fireball hits hero, so you know when your hit.
%-minor updates to comments and code, e.g. comment correct fps.
%-killHero calles makeExplosion instead of creating its own explosion.

%known problems with v0.1:
%-can lag  a bit. when there are many ships on the screen there's alot going
% on each frame. I'm sure the code could use alot of optimization to make
% things run faster. for a quick fix, setting NO_FILL to true should make a
% big difference.
%-bot plots change slightly when bullets are on screen. this drives me nuts.
% if anybody can figure out why this is happening PLEASE let me know.
%-game has not been extensively tested. will want to tweak stuff to
% get the difficulty, excitement, etc. just right for next release
%-imprecision in matlab's 'pause' function means that in-game seconds aren't
%guaranteed to be real-time seconds. on my machine, game seconds are about
%1.5 real seconds.


function [] = shooter03()

close all
clear all
clc

%+-----------------------------------------------------------------------+
%|                              CONSTANTS                                |
%+-----------------------------------------------------------------------+
%here's some values that you might want to mess around with. It is safe
%to modify these to values within the specified ranges.
%-NO_FILL:     true/false
%-INVINCIBLE:  true/false
%-START_WAVE:  1 <= START_WAVE <= 10
NO_FILL = false; %set to true if game lags. ships are just outlines.
INVINCIBLE = false; %hero doesn't die if shield goes below 0
START_WAVE = 1; %wave at game start

FRAME_DELAY = .025; %don't modify this. delay between animation frames.
%to avoid distortion: FIGURE_WIDTH/FIGURE_HEIGHT = PLOT_W/PLOT_H
%we'll use the golden rectangle because its supposed to look nice
%although i doubt it will actually be displayed at the right dimensions.
FIGURE_WIDTH = 464; %pixels
FIGURE_HEIGHT = 750;
PLOT_W = 200; %width in plot units. this will be main units for program
PLOT_H = 324; %height
%number frames between periodic tasks like bot generation and bot firing
%this should be 10.
WAIT_FRAMES = 10; %DONT CHANGE THIS. KEEP IT AT 10.
%these "secons" assume precise frame delays, which matlab doesn't
%guarantee. these "seconds" are about 1.5 real seconds on my machine. let
%me know what you come up with. although there coule be something i'm
%missing in my code thats causing this effect and the frame delays
%could be accurate.
WAVE_BREAK = 3; %number of seconds between waves
ENCORE_DELAY = 1; %number of seconds between death and 'game over' message

%colors
GREEN = [.1, .7, .1];
BLUE = [.3, .3, .9];
WHITE = [1, 1, 1];
RED = [.9, .3, .3];
BULLET_FACE_COLOR = GREEN;
BULLET_EDGE_COLOR = GREEN;
FIRE_FACE_COLOR = [1, 0, 0];
FIRE_EDGE_COLOR = [1, 0, 0];
HERO_COLOR = BLUE;
BOT_COLORS = [.9, .4, .0; ... %bot1 color
  .6, .6, .7; ... %bot2 color
  .8,  0, .4];     %bot3 color
PUP_FACE_COLORS = [GREEN; ... %supershoot
  BLUE; ... %superspeed
  RED];     %nuke
PUP_EDGE_COLOR = [.8, .8, .4];
FIGURE_COLOR = [.15, .15, .15]; %program background
AXIS_COLOR = [0, 0, 0]; %the sky
STAR_COLOR = [.4, .4, .4];
INTRO_COLOR = GREEN; %name of program on intro screen
OVER_COLOR = GREEN; %game over
PAUSE_COLOR = GREEN;
TITLE_COLOR = GREEN;
%color for top bar outline, bottom outline, top fill, bottom fill.
HUD_COLORS = [BLUE; BLUE * .8; GREEN; GREEN * .8];
FILL_DARKEN = 0.3; %multiplied by ship color to make ship fill color

%speeds
BULLET_SPEED = 5;
BOT_SPEEDS = [2, 1.5, .5]; %[bot1, bot2, bot3]
MAX_STAR_SPEED = 5;
MIN_STAR_SPEED = 1;
STILL_SPEED = 1; %how fast 'still' things like explosions should move.
FIRE_SPEED = 2.5; %speed of enemry fireballs
HERO_SPEED = 7.5;

%displaying powerups
d = sqrt(3)/2;
PUP_SHAPE = [-1, -.5, .5, 1, .5, -.5, -1; %hexagon
  0,   d,  d, 0, -d,  -d,  0];
PUP_SIZE = 4;
PUP = PUP_SHAPE .* PUP_SIZE;
PUP_LINE_WIDTH = 2;
theta = pi/64; %how fast pups spin
ROTATION_MATRIX = [cos(theta), sin(theta); ...
  -sin(theta), cos(theta)];
SUPER_LAG = 4; %distance side bullets lag front bullet if superShoot
SUPER_SPACE = 6; %distance of extra bullets from centerline of hero

%powerup effects
HEALTH_BOOST = .3; %health restored by health pup
SUPER_SHOOT_DURATION = 14; %how long superShoot upgrade lasts in 'seconds'

%bullets shot by hero
BULLET_DELAY = 4; %number of frames between bullets
BULLET_SHAPE = 'd';
BULLET_SIZE = 5;
ENERGY_DRAIN = .02; %per shot while shooting
ENERGY_RESTORE = .02; %per frame if not shooting and after delay
ENERGY_DELAY = 30; %how long after stop shooting until energy restore

%fire shot by bots
FIRE_SHAPE = 'o';
FIRE_SIZE = 5;
FIRE_VAR = .5; %alters fire vector so enemies miss sometimes
FIRE_DAMAGE = .5; %damage done to hero by fire

%hero
COLLISION_DAMAGE = .9; %damage done to hero by collision with bot
HEALTH_RESTORE = .00015; %health restored each frame
HERO_START_Y = 20; %hero start position
HERO_W = 15; %hero width
HERO_H = 20; %hero height
HERO_SHAPE = [1 0 1 2 3 4 3 1; ... %x values
  0 1 2 4 2 1 0 0];    %y values
xScale = HERO_W / max(HERO_SHAPE(1,:));
yScale = HERO_H / max(HERO_SHAPE(2,:));
%coordinats for drawing hero at 0,0.
HERO = [HERO_SHAPE(1,:) .* xScale; HERO_SHAPE(2,:) .* yScale];

%bots
%each constant is a list of values, one for each bot model: [m1, m2, m3]
FIRE_PROB = [.02, .04, .1]; %probability of firing each WAIT_FRAMES
BOT_POINTS = [10, 100, 500]; %points awarded for killing
PUP_PROB = [.0033, .0333, .3333]; %probabiliity of droping a powerup
FIRE_BURST = [1, 2, 4]; %how many fireballs shot at a time by a bot
BOT_HEALTH = [1, 3, 12]; %number of hits to kill bot
BOT_W = [9, 13, 18]; %widths
BOT_H = [9, 12, 22]; %heights
%BOT_START distance above top of screen where bots are generaged. This mainly
%determines how long after using bomb powerup until more bots come. this
%also affects bot vectors a bit.
BOT_START = 40;
%BOT_END maximum distance above bottom of screen where bots MIGHT go out
%of bounds according to its vector.
BOT_END = 100;

%bot1
MIN_FORMATION = 3; %minimum number of bots in a formation
MAX_FORMATION = 10; %maximum
BOT1_SHAPE = [1 0 0 1 2 3 3 2 2 1 1; ...
              0 1 2 3 3 2 1 0 1 1 0];
xScale = BOT_W(1) / max(BOT1_SHAPE(1,:));
yScale = BOT_H(1) / max(BOT1_SHAPE(2,:));
%BOT1 is scaled BOT1_SHAPE, it is the coordinates for drawing bot at 0,0.
BOT1 = [BOT1_SHAPE(1,:) .* xScale; BOT1_SHAPE(2,:) .* yScale];

%bot2
BOT2_SHAPE = [0 0 1 3 4 4 3 2 1 0; ...
              1 4 3 3 4 1 2 0 2 1];
xScale = BOT_W(2) / max(BOT2_SHAPE(1,:));
yScale = BOT_H(2) / max(BOT2_SHAPE(2,:));
%scaled BOT2_SHAPE
BOT2 = [BOT2_SHAPE(1,:) .* xScale; BOT2_SHAPE(2,:) .* yScale];
BOT2_TACK_PROB = .15; %chance of bot tacking each WAIT_FRAMES

%bot3
BOT3_SHAPE = [1 2 0 3 6 4 5 3 1; ...
              1 2 4 5 4 2 1 0 1];
xScale = BOT_W(3) / max(BOT3_SHAPE(1,:));
yScale = BOT_H(3) / max(BOT3_SHAPE(2,:));
%scaled BOT3_SHAPE
BOT3 = [BOT3_SHAPE(1,:) .* xScale; BOT3_SHAPE(2,:) .* yScale];

%appearance
SHIP_LINE_WIDTH = 2;
STAR_SHAPE = '*';
BIG_STAR_SIZE = 3;
SMALL_STAR_SIZE = 2;
NUM_STARS = 50; %number of stars

%explosions
EXPLOSION_MIN = 4; %explosion marker start size
EXPLOSION_INCREASE = 5; %increse in explosion marker size each frame
EXPLOSION_DURATION = 5; %how long explosions take in frames

%text and messages
MESSAGE_Y = 190; %placement of pause and gameover messages
FONT = 'Courier'; %used for all text in program
MESSAGE_SPACE = 15; %spacing between message lines
LARGE_TEXT = 18; %text sizes
SMALL_TEXT = 14;
TINY_TEXT = 13;

%hud
HUD_H = 6; %height of one of the hud bars
HUD_W = 85; %width
HUD_MARGIN = 2; %margin around hud bars
HUD_LINE_WIDTH = 9; %width of lines filling hud bars
HUD_BAR  = [0, 0, HUD_W, HUD_W, 0; ...
            0, HUD_H, HUD_H, 0, 0];

%strings
STR_CONTINUE = 'hit any key to continue';
STR_PAUSED = 'GAME PAUSED';
STR_OVER = 'GAME OVER';
STR_CONTROLS = 'reset:(r) quit:(q) pause:any';

%waves
%each row represents a wave of fighters in format: [D, Pb, P1, P2]
%D = duration of wave in seconds
%Pb = probability of generating a bot each WAIT_FRAMES
%P1 = probability that a generated bot is model 1
%P2 = probability that a generated bot is NOT model 3. P2 >= P1
%e.g. if P1=.2 and P2=.7 then:
%probability of generating model1 = .2
%probability of generating model2 = .5
%probability of generating model3 = .3
%if P1 = P2 there are no model 2s
%if p2 = 1, there are no model 3s
%        [D, Pb, P1, P2]
WAVES = [15, .4,  1,  1; ... %wave 1
         30, .4, .6,  1; ... %2
         45, .6, .7,  1; ... %3
         60, .3, .5, .9; ... %4
         75, .4, .4, .9; ... %5
         90, .4, .8, .7; ... %6
         105, .2,  0, .8; ... %7
         120, .3, .1, .8; ... %8
         135, .5, .4, .8; ... %9
         99, .5, .1, .7;];   %10, continues indefinitely


%+-----------------------------------------------------------------------+
%|                        DECLARE VARIABLES                              |
%+-----------------------------------------------------------------------+

fig = []; %main program figure

%boolean flags
quitGame = false; %guard for main loop. when true, program ends
paused = []; %true if game is paused
mouseDown = []; %is the mouse button down
gameOver = []; %bool, hero has died but game not reset yet
intro = []; %bool, are we in the intro screen?
onBreak = []; %bool, are we in a break between waves. no bots are alive
levelOver = []; %bool. level over but not on break yet. bots still alive.

%counters
counter = []; %main counter number of frames since reset
energyCounter = []; %keep track of time until begin to restore energy
encoreCounter = []; %track time after gameover until display message
bulletCounter = []; %time since last bullet fired.
waveCounter = []; %counter at start of current wave or break

%pairs of units and associated plots
%units depicted by markers have a single plot for all units
%units depicted by draswings have a plot for each unit
heroPos = []; %position of hero
heroPlot = []; %plot for hero
smallStars = []; %list of small star locations
smallStarPlot = [];
bigStars = []; %list of big star locations
bigStarPlot = [];
bullets = []; %2xN array of bullet's x and y positions.
bulletPlot = [];
fire = []; %4xN matrix of enemy fireballs in form [x;y;dx;dy]
firePlot = []; %plot of enemy fire
pups = []; %3xN matrix of powerups [x;y;type]
pupPlots = []; %list of powerup plots
explosions = []; %3xN matrix of explosion [x;y;age]
explosionPlots = []; %list of plots of explosions
bots = []; %list of current bots
botPlots = []; %list of current bot plots

%other
superShoot = []; % 0<=x<=1 how much time left for supershot upgrade
energy = []; %amount of energy for shooting. 0 <= energy <= 1.
health = []; % player health
hudPlots = []; %plots for hud. top outline, fill. bottom outline, fill.
starSpeeds = []; %a speeds to move stars. reused for small and large stars
mousePos = []; %position of mouse [x, y]
mainAxis = []; %reference to the main axis
score = []; %current player score
axisTitle = []; %handle to axis title
currentWave = []; %int, the current wave
storedStartX = []; %to be passed to each bot1 in a formation
storedGoalX = []; %to be passed to each bot1 in a formation
formation = []; %int, number of ships left to make for currernt formation
encoreText = []; %used to display game over message. cleared by reset.



%+-----------------------------------------------------------------------+
%|                          CREATE FIGURE CBF                            |
%+-----------------------------------------------------------------------+
%set up the main figure and axis for the program
%run once at start of program
  function createFigure
    %ScreenSize is a four-element vector: [left, bottom, width, height]:
    scrsz = get(0,'ScreenSize');
    %put our figure in the middle of the screen
    fig = figure('Position',[(scrsz(3)-FIGURE_WIDTH)/2, ...
      (scrsz(4)-FIGURE_HEIGHT)/2, ...
      FIGURE_WIDTH, ...
      FIGURE_HEIGHT]);
    %custom close function.
    set(fig,'CloseRequestFcn',@my_closefcn);
    
    %set background color for figure
    set(fig, 'color', FIGURE_COLOR);
    
    %make custom mouse pointer
    pointer = NaN(16, 16);
    pointer(4, 1:7) = 2;
    pointer(1:7, 4) = 2;
    pointer(4, 4) = 1;
    set(fig, 'Pointer', 'Custom');
    set(fig, 'PointerShapeHotSpot', [4, 4]);
    set(fig, 'PointerShapeCData', pointer);
    
    %register keydown and keyup listeners
    set(fig,'KeyPressFcn',@keyDownListener)
    %set(fig, 'KeyReleaseFcn', @keyUpListener);
    set(fig,'WindowButtonDownFcn', @mouseDownListener);
    set(fig,'WindowButtonUpFcn', @mouseUpListener);
    set(fig,'WindowButtonMotionFcn', @mouseMoveListener);
    
    %figure can't be resized
    set(fig, 'Resize', 'off');
    
    mainAxis = axes(); %handle for axis
    axis([0 PLOT_W 0 PLOT_H]);
    axis manual; %axis wont be resized
    
    %set color for the court, hide axis ticks.
    set(mainAxis, 'color', AXIS_COLOR, 'YTick', [], 'XTick', []);
    %handles to title for displaying wave, score
    axisTitle = title('');
    set(axisTitle, 'FontName', FONT,'FontSize', LARGE_TEXT);
    set(axisTitle, 'Color', TITLE_COLOR);
    
    hold on;
  end


%+-----------------------------------------------------------------------+
%|                          CREATE PLOTS CBF                             |
%+-----------------------------------------------------------------------+
%make all permanent plots.
%plot coords all set to NaN for blank plots, data provided later
%run once at start of program
  function createPlots
    
    %plot hud
    for n = 1:4
      hudPlots(n) = plot(NaN, NaN, '-');
      set(hudPlots(n), 'Color', HUD_COLORS(n,:));
    end
    set(hudPlots(2), 'LineWidth', HUD_LINE_WIDTH);
    set(hudPlots(4), 'LineWidth', HUD_LINE_WIDTH);
    
    %plot stars
    smallStarPlot = plot(NaN,NaN);
    bigStarPlot = plot(NaN,NaN);
    set(smallStarPlot, 'Marker', STAR_SHAPE);
    set(smallStarPlot, 'MarkerEdgeColor', STAR_COLOR);
    set(smallStarPlot, 'MarkerSize', SMALL_STAR_SIZE);
    set(smallStarPlot, 'LineStyle', 'none');
    set(bigStarPlot, 'Marker', STAR_SHAPE);
    set(bigStarPlot, 'MarkerEdgeColor', STAR_COLOR);
    set(bigStarPlot, 'MarkerSize', BIG_STAR_SIZE);
    set(bigStarPlot, 'LineStyle', 'none');
    %move stars to the bottom of the display stack
    uistack(smallStarPlot, 'bottom');
    uistack(bigStarPlot, 'bottom');
    
    %plot hero
    if NO_FILL
      heroPlot = plot(NaN,NaN, '-');
      set(heroPlot, 'LineWidth', SHIP_LINE_WIDTH);
      set(heroPlot, 'Color', HERO_COLOR);
    else
      heroPlot = patch(NaN,NaN, 'b');
      set(heroPlot, 'LineWidth', SHIP_LINE_WIDTH);
      set(heroPlot, 'EdgeColor', HERO_COLOR);
      set(heroPlot, 'FaceColor', HERO_COLOR * FILL_DARKEN);
    end
    
    
    %plot bullets
    bulletPlot = plot(NaN,NaN);
    set(bulletPlot, 'Marker', BULLET_SHAPE);
    set(bulletPlot, 'MarkerFaceColor', BULLET_FACE_COLOR);
    set(bulletPlot, 'MarkerEdgeColor', BULLET_EDGE_COLOR);
    set(bulletPlot, 'MarkerSize', BULLET_SIZE);
    set(bulletPlot, 'LineStyle', 'None');
    
    %plot fire
    firePlot = plot(NaN,NaN);
    set(firePlot, 'Marker', FIRE_SHAPE);
    set(firePlot, 'MarkerFaceColor', FIRE_FACE_COLOR);
    set(firePlot, 'MarkerEdgeColor', FIRE_EDGE_COLOR);
    set(firePlot, 'MarkerSize', FIRE_SIZE);
    set(firePlot, 'LineStyle', 'None');
    %move fireballs bellow everything except stars in visual stack
    uistack(firePlot, 'bottom');
    uistack(firePlot, 'up', 3)
  end


%+-----------------------------------------------------------------------+
%|                             RESET CBF                                 |
%+-----------------------------------------------------------------------+
%run at start of program and at game reset
%set all variables to starting values
  function reset
    energyCounter = 0;
    encoreCounter = 0;
    counter = 0;
    waveCounter = 0;
    energy = 0;
    health = 0;
    intro = true;
    bulletCounter = 0;
    
    %just because it looks wierd for stars to stay the same when you
    %restart the game.
    for k = 1:(NUM_STARS / 2)
      starSpeeds(k) = ...
        (rand * (MAX_STAR_SPEED - MIN_STAR_SPEED) + MIN_STAR_SPEED);
    end
    for k = 1:(NUM_STARS / 2)
      smallStars(1,k) = randi(PLOT_W);
      smallStars(2,k) = randi(PLOT_H);
      bigStars(1,k) = randi(PLOT_W);
      bigStars(2,k) = randi(PLOT_H);
    end
    
    for n = 1:4
      set(hudPlots(n), 'XData', NaN, 'YData', NaN);
    end
    
    delete(encoreText(:)); %in case of game over message
    encoreText = [];
    
    
    delete(botPlots(:));
    botPlots = [];
    
    pups = [];
    delete(pupPlots(:));
    pupPlots = [];
    
    explosions = [];
    delete(explosionPlots(:));
    explosionPlots = [];
    
    set(bulletPlot, 'XData', NaN, 'YData', NaN);
    bullets = [];

    set(firePlot, 'XData', NaN, 'YData', NaN);
    fire = [];
    set(heroPlot, 'XData', NaN, 'YData', NaN);
    bots = [];
    paused = false;
    if START_WAVE > size(WAVES, 1)
      currentWave = size(WAVES, 1);
    elseif START_WAVE < 1
      currentWave = 1;
    else
      currentWave = START_WAVE;
    end
    onBreak = true;
    levelOver = false;
    heroPos = [(PLOT_W - HERO_W)/2, HERO_START_Y];
    mousePos = heroPos;

    score = 0;
    formation = 0;
    gameOver = false;
    
    showIntro;
    
  end


%+-----------------------------------------------------------------------+
%|                         REFRESH STAR PLOT CBF                         |
%+-----------------------------------------------------------------------+
%this is separated from refreshPlots so it can run during intro
%runs every frame
  function refreshStarPlot
    set(smallStarPlot, 'XData', smallStars(1,:), 'YData', smallStars(2,:));
    set(bigStarPlot, 'XData', bigStars(1,:), 'YData', bigStars(2,:));
  end


%+-----------------------------------------------------------------------+
%|                         REFRESH PLOTS CBF                             |
%+-----------------------------------------------------------------------+
%this runs at the end of each frame and updates the data in each plot
%according to game data. entities represented by points, such as stars
%and fireballs, have one plot, e.g. the firePlot of fireballs. entities
%represented by drawn shapes, such as bots and powerups, have a plot
%for each entity. e.g. there is a list of powerup plots called pupPlots, a
%list of bot plots called botPlots.
  function refreshPlots
    
    refreshStarPlot;
    
    %stars
    set(smallStarPlot, 'XData', smallStars(1,:), 'YData', smallStars(2,:));
    set(bigStarPlot, 'XData', bigStars(1,:), 'YData', bigStars(2,:));
    
    %hero
    %current hero plot points given hero position
    if ~gameOver
      curHero = [HERO(1,:) + heroPos(1); HERO(2,:) + heroPos(2)];
      set(heroPlot, 'XData', curHero(1,:), 'YData', curHero(2,:));
    end
    
    %bots
    for k = 1:length(bots)
      bot = eval(['BOT', num2str(bots{k}.model)]);
      set(botPlots(k), ...
        'XData', bot(1,:) + bots{k}.pos(1), ...
        'YData', bot(2,:) + bots{k}.pos(2));
    end
    
    %bullets
    if size(bullets, 2) > 0
      set(bulletPlot, 'XData', bullets(1,:), 'YData', bullets(2,:));
    else
      set(bulletPlot, 'XData', NaN, 'YData', NaN);
    end
    
    %fire
    if size(fire, 2) > 0
      set(firePlot, 'XData', fire(1,:), 'YData', fire(2,:));
    else
      set(firePlot, 'XData', NaN, 'YData', NaN);
    end
    
    %explosions
    for k = 1:size(explosions, 2)
      set(explosionPlots(k), 'XData', explosions(1,k), ...
        'YData', explosions(2,k));
    end
    
    %pups
    %rotate pups and move them to new position
    for k = 1:size(pups,2)
      temp = [get(pupPlots(k), 'XData')' - pups(1,k); ...
        (get(pupPlots(k), 'YData')' - pups(2,k)) - STILL_SPEED];
      
      temp = ROTATION_MATRIX * temp;
      
      set(pupPlots(k), 'XData', temp(1,:) + pups(1,k), ...
        'YData', temp(2,:) + pups(2,k));
    end
    
    %hud
    bottomBarY = HUD_MARGIN + (.5 * HUD_H);
    topBarY = (2 * HUD_MARGIN) + (1.5 * HUD_H);
    set(hudPlots(2), 'XData', [HUD_MARGIN, HUD_MARGIN + ...
      (HUD_W * health)], ...
      'YData', [topBarY, topBarY]);
    set(hudPlots(4), 'XData', [HUD_MARGIN, HUD_MARGIN + ...
      (HUD_W * energy)], ...
      'YData', [bottomBarY, bottomBarY]);
    
    %score
    %we'll update the title displaying the curreent wave and score.
    waveString = sprintf('wave:%d', currentWave);
    scoreString = sprintf('score:%.6d', score);
    set(axisTitle, 'String', [waveString, '   ', scoreString]);
     
  end


%+-----------------------------------------------------------------------+
%|                           UPDATE BARS CBF                             |
%+-----------------------------------------------------------------------+
%update data in energy bar and health bar. this is probably not the best
%place to check if the hero is dead, but since we're checking the health
%level anyway and this runs each frame, its easy to do it here.
%runs every frame
  function updateBars
    if energyCounter == 0
      energy = energy + ENERGY_RESTORE;
      if energy > 1
        energy = 1;
      end
    else
      energyCounter = energyCounter - 1;
    end
    
    if superShoot > 0
      superShoot = superShoot - FRAME_DELAY;
    else
        superShoot = 0;
    end
    
    if ~gameOver
    health = health + HEALTH_RESTORE;
    if health > 1
      health = 1;
    elseif health < 0
      health = 0;
      killHero;
    end
    end
  end



%+-----------------------------------------------------------------------+
%|                             SHOW INTRO CBF                            |
%+-----------------------------------------------------------------------+
%displayes the intro screen in its own loop (so the main game loop isn't 
%running). this function is kind fo weird but i wanted to make it pretty
%independent of the rest of the program because it IS different. unlike
%most of the settings throughout the program that are declared as top-level
%constants, this function uses a lot of its own local variables. so if we
%want to change how intro looks, we should edit settings here. this layout
%is not every elegent, it's very "brute force"-ish, but it allows for
%easy and precise control over the placement of elements on the intro
%screen.
  function showIntro
    
    intro = true;
    t = []; %handles to text boxes
    b = []; %handles to bots
    p = []; %handles to pups
    h = []; %handles for hud bars
    
    %settings that controll element placement
    top = 290;
    padding0 = 10;
    padding1 = 20; %space between lines
    padding2 = 30;
    padding3 = 40;
    labelSpace1 = 10; %space between labels and bots, pups
    labelSpace2 = 5; %space between hud bars and labels
    spacer = 58; %horizontal spacing between bots and pups
    hudIndent = 45;
    
    %how full hud bars are
    shieldFull = .6;
    energyFull = .8;
    
    %locations of text
    welcomeY = top;
    titleY = welcomeY - padding1;
    useY = titleY - padding1;
    killY = useY - padding2;
    botsY = killY - padding3;
    pointsY = botsY - padding0;
    getY = pointsY - padding2;
    pupsY = getY - padding2;
    watchY = pupsY - padding2;
    barsY = watchY - padding1;
    controlsY = barsY - padding2;
    x = PLOT_W/2;
    
    %create text
    t(1) = text(x, welcomeY, 'welcome to');
    t(2) = text(x, titleY, 'DAVE''S MATLAB SHOOTER');
    t(3) = text(x, useY, 'use mouse to move and shoot');
    t(4) = text(x, killY, 'kill enemies:');
    t(5) = text(x, botsY, 'fighter    destroyer    cruiser');
    t(6) = text(x, pointsY, [num2str(BOT_POINTS(1)), ' pts     ', ...
                           num2str(BOT_POINTS(2)), ' pts     ', ...
                           num2str(BOT_POINTS(3)), ' pts']);
    t(7) = text(x, getY, 'get upgrades:');
    t(8) = text(x, pupsY, 'blaster     shield       bomb ');
    t(9) = text(x, watchY, 'watch bars:');
    t(10) = text(hudIndent + HUD_W + labelSpace2, barsY-1, ['shield', 10, 'energy']);
    t(11) = text(x, controlsY, STR_CONTROLS);
    t(12) = text(x, controlsY - MESSAGE_SPACE, STR_CONTINUE);
    
    %settings for text
    for k = 1:length(t)
      set(t(k), 'HorizontalAlignment', 'Center');
      set(t(k), 'FontName', FONT);
    end
    for k = [1, 3, 4, 7, 9, 11, 12]
      set(t(k), 'Color', WHITE);
      set(t(k), 'FontSize',SMALL_TEXT);
    end
    for k = [5, 6, 8, 10]
      set(t(k), 'Color', WHITE);
      set(t(k), 'FontSize',TINY_TEXT);
    end
    set(t(2), 'FontSize',LARGE_TEXT);
    set(t(2), 'Color', INTRO_COLOR);
    set(t(10), 'HorizontalAlignment', 'Left');
    
    %make bot images
    b(1) = patch(BOT1(1,:) + x - spacer - (BOT_W(1) / 2), ...
      BOT1(2,:) + botsY + labelSpace1, 'w');
    b(2) = patch(BOT2(1,:) + x - (BOT_W(2) / 2), ...
      BOT2(2,:) + botsY + labelSpace1, 'w');
    b(3) = patch(BOT3(1,:) + x + spacer - (BOT_W(3) / 2), ...
      BOT3(2,:) + botsY + labelSpace1, 'w');
    for k = 1:length(b)
      set(b(k), 'LineWidth', SHIP_LINE_WIDTH);
      set(b(k), 'FaceColor', BOT_COLORS(k,:) * FILL_DARKEN);
      set(b(k), 'EdgeColor', BOT_COLORS(k,:));
    end
    
    %make powerup images
    p(1) = patch(PUP(1,:) + x - spacer, ...
      PUP(2,:) + pupsY + labelSpace1 + (PUP_SIZE / 2), 'w');
    p(2) = patch(PUP(1,:) + x, ...
      PUP(2,:) + pupsY + labelSpace1 + (PUP_SIZE / 2), 'w');
    p(3) = patch(PUP(1,:) + x + spacer, ...
      PUP(2,:) + pupsY + labelSpace1 + (PUP_SIZE / 2), 'w');
    for k = 1:length(p)
      set(p(k), 'LineWidth', PUP_LINE_WIDTH);
      set(p(k), 'EdgeColor', PUP_EDGE_COLOR);
      set(p(k), 'FaceColor', PUP_FACE_COLORS(k,:));
    end
    
    %make hud images
    set(hudPlots(1), 'XData', HUD_BAR(1,:) + hudIndent, ...
      'YData', HUD_BAR(2,:) + barsY);
    
    set(hudPlots(3), 'XData', HUD_BAR(1,:) + hudIndent, ...
      'YData', HUD_BAR(2,:) + barsY - HUD_MARGIN - HUD_H);
    
    %y positions for bar fill
    topBarY = barsY + (.5 * HUD_H);
    bottomBarY = topBarY - HUD_MARGIN - HUD_H;
    
    set(hudPlots(2), 'XData', [hudIndent, hudIndent + (shieldFull * HUD_W)], ...
                     'YData', [topBarY, topBarY]);
    set(hudPlots(4), 'XData', [hudIndent, hudIndent + (energyFull * HUD_W)], ...
                     'YData', [bottomBarY, bottomBarY]);
    
    %loop for intro
    while intro && ~quitGame;
      moveStars;
      refreshStarPlot;
      pause(FRAME_DELAY);
    end
    delete(t(:));
    delete(h(:));
    delete(b(:));
    delete(p(:));
    endIntro;
  end


%+-----------------------------------------------------------------------+
%|                           END INTRO CBF                               |
%+-----------------------------------------------------------------------+
%all this does is redraw the hud bars after the intro
  function endIntro
    set(hudPlots(1), 'XData', HUD_BAR(1,:) + HUD_MARGIN, ...
      'YData', HUD_BAR(2,:) + (2 * HUD_MARGIN) + HUD_H);
    
    set(hudPlots(3), 'XData', HUD_BAR(1,:) + HUD_MARGIN, ...
      'YData', HUD_BAR(2,:) + HUD_MARGIN);
  end


%+-----------------------------------------------------------------------+
%|                            SET WAVE CBF                               |
%+-----------------------------------------------------------------------+
%controlls the flow of the game. there are essentially 6 game states.
%gameOver is after hero dies but before game is restarted.
%paused and intro run in their own loops and are not controleld by this
%function. onBreak, levelOver, and regular gameplay run in the main loop
%and are controlled by this function. 'counter' is a global coutner that
%keeps track of how many frames have elapsed since reset. 'waveCounter'
%is set and compared against 'counter' to control game flow. levelOver
%is after the time for a level has finished but before all bots are killed.
%onBreak is after levelOver and all bots are killed but before next attack
%has started (even thought the current wave increments as soot as onBreak
%begins. WAVE_BREAK and wave durations are in (quasi)seconds. run this
%functione very WAIT_FRAMES.
 function setWave
    count = counter - waveCounter;
    
    if levelOver && (size(bots, 2) == 0)
         levelOver = false;
         onBreak = true;
         waveCounter = counter;
         currentWave = currentWave + 1;
    elseif onBreak && (count > WAVE_BREAK / FRAME_DELAY)
        waveCounter = counter; %reset waveCounter

        onBreak = false; %break's over
    elseif (count > WAVES(currentWave,1) / FRAME_DELAY && ...
        size(WAVES, 1) > currentWave)
      %wave is over
      %take a break
      waveCounter = counter;
      levelOver = true;
      end
    end


%+-----------------------------------------------------------------------+
%|                           MOVE STARS CBF                              |
%+-----------------------------------------------------------------------+
%update star positions based on starSpeeds.
%run each frame.
  function moveStars
    smallStars(2,:) = smallStars(2,:) - starSpeeds;
    bigStars(2,:) = bigStars(2,:) - starSpeeds;
    for k = 1:(NUM_STARS / 2)
      if smallStars(2,k) < 0
        smallStars(1,k) = rand * PLOT_W;
        smallStars(2,k) = PLOT_H;
      end
      if bigStars(2,k) < 0
        bigStars(1,k) = rand * PLOT_W;
        bigStars(2,k) = PLOT_H;
      end
    end
  end


%+-----------------------------------------------------------------------+
%|                           MOVE BULLETS CBF                            |
%+-----------------------------------------------------------------------+
%update bullet positions based on bullet speed.
%run each frame.
  function moveBullets
        
    %use a while loop to make a reverse for loop
    %we need to count down so we dont try to access
    %items at higher index than exist after removal
    k = size(bullets,2);
    while k > 0
      if bullets(2,k) > PLOT_H
        %remove any bullets past top of plot from bullets list
        %miraculously this works even when k is 0 or end
        bullets = [bullets(:,1:k-1), bullets(:,k+1:end)];
      end
      k = k-1;
    end
    
    if size(bullets, 2) > 0
      bullets(2,:) = bullets(2,:) + BULLET_SPEED;
    end
    
  end


%+-----------------------------------------------------------------------+
%|                            MOVE FIRE CBF                              |
%+-----------------------------------------------------------------------+
%update fireball positions based on vector data of each fireball.
%run each frame.
  function moveFire
    
    %use a while loop to make a reverse for loop
    %we need to count down so we dont try to access
    %items at higher index than exist after removal
    k = size(fire,2);
    while k > 0
      if (fire(2,k) > PLOT_H || ...
          fire(2,k) < 0 || ...
          fire(1,k) > PLOT_W || ...
          fire(1,k) < 0)
        %remove out of bounds fire
        fire = [fire(:,1:k-1), fire(:,k+1:end)];
      end
      k = k-1;
    end
    
    if size(fire, 2) > 0
      fire(1:2,:) = fire(1:2,:) + fire(3:4,:);
    end
    
  end


%+-----------------------------------------------------------------------+
%|                            MOVE HERO CBF                              |
%+-----------------------------------------------------------------------+
%update hero position based on hero speed and mouse position.
%run each frame.
  function moveHero
    if ~gameOver
      
      heroSpeed = HERO_SPEED;
      
      %tempPos is a 2x3 matrix
      tempMousePos = get(mainAxis,'CurrentPoint');
      %hold mouse position in a 1x2 matrix
      mousePos = [tempMousePos(1), tempMousePos(3)];
      %get vector from ship to mouse
      heroCenter = [heroPos(1) + (HERO_W / 2), heroPos(2) + (HERO_H / 2)];
      tempV = mousePos - heroCenter;
      %magnitude of tempV
      magnitude = (sqrt(tempV(1)^2 + tempV(2)^2));
      if magnitude > heroSpeed
        %normalize the vector
        tempV = tempV ./ magnitude;
        %set new ship position
        heroPos = heroPos + (tempV * heroSpeed);
      else
        %set ship position to mouse position
        heroPos = [mousePos(1) - (HERO_W / 2), mousePos(2) - (HERO_H /2)];
      end
      
      %keep hero within bounds
      if (heroPos(1) < 0)
        heroPos(1) = 0;
      elseif (heroPos(1) > PLOT_W - HERO_W)
        heroPos(1) = PLOT_W - HERO_W;
      end
      if (heroPos(2) < 0)
        heroPos(2) = 0;
      elseif (heroPos(2) > PLOT_H - HERO_H)
        heroPos(2) = PLOT_H - HERO_H;
      end
    end
  end


%+-----------------------------------------------------------------------+
%|                            MOVE BOTS CBF                              |
%+-----------------------------------------------------------------------+
%update bot positions based on vector data for each bot.
%tack (switch direction of) bot2s if appropriate.
%kill out of bounds bots.
%run every frame.
  function moveBots
    k = length(bots);
    while k > 0
      bots{k}.pos = bots{k}.pos + bots{k}.vector;
      switch bots{k}.model
        case 1
          
        case 2
          if (bots{k}.pos(1) > PLOT_W - BOT_W(2))
            bots{k}.pos(1) = PLOT_W - BOT_W(2);
            bots{k}.vector(1) = abs(bots{k}.vector(1)) * -1;
          elseif (bots{k}.pos(1) < 0)
            bots{k}.pos(1) = 0;
            bots{k}.vector(1) = abs(bots{k}.vector(1));
            %use 5 so out of sync with calls to generateBots in main loop
            %for better efficiency
          elseif (mod(counter, WAIT_FRAMES) == 5)
            if (rand < BOT2_TACK_PROB)
              bots{k}.vector(1) = bots{k}.vector(1) * -1;
            end
          end
          
        case 3
      end
      
      %clean up dead bots
      if bots{k}.pos(2) < 0 - BOT_H(bots{k}.model) || ...
         bots{k}.pos(1) < 0 - BOT_W(bots{k}.model) || ...
         bots{k}.pos(1) > PLOT_W
        killBot(k);
      end
      k = k-1;
    end
  end


%+-----------------------------------------------------------------------+
%|                       MOVE EXPLOSIONS CBF                             |
%+-----------------------------------------------------------------------+
%move explosions according to STILL_SPEED.
%expand explosions.
%remove finished explosions.
%run every frame.
  function moveExplosions
    k = size(explosions, 2);
    while k > 0
      oldMarker = get(explosionPlots(k), 'MarkerSize');
      set(explosionPlots(k), 'MarkerSize', ...
        (oldMarker + EXPLOSION_INCREASE));
      explosions(2,k) = explosions(2,k) - STILL_SPEED;
      explosions(3,k) = explosions(3,k) + 1;
      if explosions(3,k) > EXPLOSION_DURATION;
        delete(explosionPlots(k));
        explosionPlots = [explosionPlots(:,1:k-1), ...
          explosionPlots(:,k+1:end)];
        explosions = [explosions(:,1:k-1), ...
          explosions(:,k+1:end)];
      end
      k = k - 1;
    end
  end


%+-----------------------------------------------------------------------+
%|                        MOVE PUPS CBF                                  |
%+-----------------------------------------------------------------------+
%move powerups according to STILL_SPEED.
%remove out of bounds powerups.
%run every frame.
  function movePups
    if size(pups, 2) > 0
      pups(2,:) = pups(2,:) - STILL_SPEED;
    end
    k = size(pups, 2);
    while k > 0
      if pups(2,k) < 0 - 10
        killPup(k);
      end
      k = k-1;
    end
  end


%+-----------------------------------------------------------------------+
%|                         KILL PUP CBF                                  |
%+-----------------------------------------------------------------------+
%remove a powerup.
%called when a pup goes out of bounds or is picked up by hero.
  function killPup (n)
    %remove it from list of pups
    pups = [pups(:,1:n-1), pups(:,n+1:end)];
    %cleare plot
    delete(pupPlots(n));
    %remove plot from list of pup plots.
    pupPlots = [pupPlots(:,1:n-1), pupPlots(:,n+1:end)];
  end


%+-----------------------------------------------------------------------+
%|                          KILL HERO  CBF                               |
%+-----------------------------------------------------------------------+
%make explosions, clear hero plot, set gameOver to true
%set encoreCounter to wait for game over message
%called if health < 0.
  function killHero
    
    if INVINCIBLE
      disp('you died!')
    else
      heroCenter = [heroPos + ([HERO_W, HERO_H] ./ 2)];
      makeExplosion(heroCenter, HERO_COLOR);
      set(heroPlot, 'XData', NaN, 'YData', NaN);
      gameOver = true;
      encoreCounter = floor(ENCORE_DELAY / FRAME_DELAY);
    end
  end


%+-----------------------------------------------------------------------+
%|                          KILL BOT CBF                                 |
%+-----------------------------------------------------------------------+
%make explosion, clear bot plot, maybe make pup, etc.
%called when a bot leaves bounds or bot health drops to 0.
  function killBot(k)
    %make a new explosion where ship was
    model = bots{k}.model;
    if bots{k}.pos(2) > 0 - BOT_H(model)
      botCenter = bots{k}.pos + ([BOT_W(model), BOT_H(model)] ./ 2);
      makeExplosion(botCenter, BOT_COLORS(model,:));
      if rand < PUP_PROB(model)
        makePup(botCenter, randi([1, 3]));
      end
    end
    %clean up
    %clear plot
    delete(botPlots(k));
    %remove plot from list of botPlots
    botPlots = [botPlots(:,1:k-1), botPlots(:,k+1:end)];
    %remove bot from list of bots
    bots = [bots(:,1:k-1), bots(:,k+1:end)];
    
  end


%+-----------------------------------------------------------------------+
%|                             SHOOT CBF                                 |
%+-----------------------------------------------------------------------+
%controls firing of hero's gun.
%called every frame.
  function shoot
    
    if ~gameOver %no shooting if your dead
      
      %this makes delay between bullets so they dont shoot every frame
      if bulletCounter > 0
        bulletCounter = mod(bulletCounter + 1, BULLET_DELAY);
      elseif mouseDown
        
        if energy - ENERGY_DRAIN >= 0 %only shoot if have enough energy
          bullets(1, end+1) = heroPos(1) + (HERO_W / 2);
          bullets(2, end) = heroPos(2) + HERO_H;
          if superShoot > 0 %make 2 extra bullets if we have powerup.
            bullets(1, end+1) = heroPos(1) + (HERO_W / 2) + SUPER_SPACE;
            bullets(2, end) = heroPos(2) + HERO_H - SUPER_LAG;
            bullets(1, end+1) = heroPos(1) + (HERO_W / 2) - SUPER_SPACE;
            bullets(2, end) = heroPos(2) + HERO_H - SUPER_LAG;
          end
          bulletCounter = bulletCounter + 1;
          energy = energy - ENERGY_DRAIN; %each shot drains energy
          energyCounter = ENERGY_DELAY; %reset delay until restore enrgy
          if energy < 0
            energy = 0;
          end
        end
        
      end
    end
    
  end


%+-----------------------------------------------------------------------+
%|                          BOTS FIRE CBF                                |
%+-----------------------------------------------------------------------+
%shoot fireballs from bots.
%for each bot, is the bot in the middle of a firing burst?
%if it is, fire again and decrement burst count.
%otherwise, decide if bot wants to fire. if so, set firing burst.
%called every WAIT_FRAMES
  function botsFire
    if ~gameOver
      for k = 1:length(bots)
        bot = bots{k};
        if bot.burst > 0;
            makeFire([bot.pos(1) + (BOT_W(bot.model) / 2), ...
            bot.pos(2) + (BOT_H(bot.model) / 2)]);
            bots{k}.burst = bot.burst - 1;
        
        elseif rand < FIRE_PROB(bot.model)
          bots{k}.burst = FIRE_BURST(bot.model);

        end
      end
    end
  end


%+-----------------------------------------------------------------------+
%|                         GENERATE BOTS CBF                             |
%+-----------------------------------------------------------------------+
%use WAVE information to create new bots.
%if were in the middle of a bot1 formation, make another bot1 and
%decrement formation count.
%otherwise decide wether to make a new bot and, if so, what model.
%runse every WAIT_FRAMES
  function generateBots
    
    if formation > 0
      makeBot(1, storedStartX, storedGoalX)
      formation = formation - 1;
      
    elseif ~levelOver && ~onBreak
      waveData = WAVES(currentWave,:);
      if rand < (waveData(2)); %we'll make a bot
        startX = rand * (PLOT_W - max(BOT_W)); %random starting x
        goalX = rand * (PLOT_W - max(BOT_W)); %directed toward random x
        modelSelect = rand;
        if modelSelect < waveData(3) %start a bot1 formation
          storedStartX = startX;
          storedGoalX = goalX;
          formation = randi([MIN_FORMATION, MAX_FORMATION]);
        elseif modelSelect < waveData(4) %make a bot2
          makeBot(2, startX, goalX);
        else %make a bot3
          makeBot(3, startX, goalX);
        end
      end
    end
  end


%+-----------------------------------------------------------------------+
%|                           MAKE BOT CBF                                |
%+-----------------------------------------------------------------------+
%create a new bot based on input model and position
%make appropriate settings to bot.
%make a corresponding plot in botPlots.
%called by generateBots.
  function makeBot(model, startX, goalX)
    %bot vector
   
    if model == 2
      if startX > PLOT_W / 2
        tempV = [-1, -1];
      else
        tempV = [1, -1];
      end
    else
      tempV = [goalX - startX, BOT_END - PLOT_H];
    end
    %normalize it
    normV = tempV ./ (sqrt(tempV(1)^2 + tempV(2)^2));
    %multiply by bot speed
    botV = normV .* BOT_SPEEDS(model);
    
    bots{end+1} = struct( ...
      'model', model, ...
      'pos', [startX, PLOT_H + BOT_START], ...
      'health', BOT_HEALTH(model), ...
      'vector', botV, ...
      'burst', 0);
    %goalX only affects bot1s and bot2s
    %dir only affects bot2s.
    %it determines which tack bot2 is on
    %if startx > middle of plot, set it to -1
    
    if NO_FILL
      tempPlot = plot(NaN, NaN, '-');
      set(tempPlot, 'LineWidth', SHIP_LINE_WIDTH);
      set(tempPlot, 'Color', BOT_COLORS(model,:));
    else
      tempPlot = patch(NaN, NaN, 'w');
      set(tempPlot, 'LineWidth', SHIP_LINE_WIDTH);
      set(tempPlot, 'EdgeColor', BOT_COLORS(model,:));
      set(tempPlot, 'FaceColor', BOT_COLORS(model,:) * FILL_DARKEN);
    end
    %move bot to bottom of visual stack but just above stars
    uistack(tempPlot, 'bottom');
    uistack(tempPlot, 'up', 2);
    botPlots(end+1) = tempPlot;
  end


%+-----------------------------------------------------------------------+
%|                           MAKE PUP CBF                                |
%+-----------------------------------------------------------------------+
%create a new pup based on input position and type
%make a coresponding plot in pupPlots.
%called by killBot.
  function makePup (pos, n)
    pups(:,end+1) = [pos, n];
    tempPlot = patch(PUP(1,:) + pos(1), PUP(2,:) + pos(2), ...
                     PUP_FACE_COLORS(n,:));
    set(tempPlot, 'EdgeColor', PUP_EDGE_COLOR);
    set(tempPlot, 'LineWidth', PUP_LINE_WIDTH);
    pupPlots(end+1) = tempPlot;
  end


%+-----------------------------------------------------------------------+
%|                          MAKE EXPLOSION CBF                           |
%+-----------------------------------------------------------------------+
%create a new explosion based on input position and color
%make a corresponding plot in explosionPlots.
%called by killBot and killHero.
  function makeExplosion (pos, color)
    explosions(:,end+1) = [pos, 0];
    tempPlot = plot(NaN, NaN);
    set(tempPlot, 'Marker', 'o');
    set(tempPlot, 'MarkerSize', EXPLOSION_MIN);
    set(tempPlot, 'MarkerEdgeColor', color);
    set(tempPlot, 'MarkerFaceColor', color * 0.1);
    
    explosionPlots(end+1) = tempPlot;
  end


%+-----------------------------------------------------------------------+
%|                          MAKE FIRE CBF                                |
%+-----------------------------------------------------------------------+
%make a new fireball based on input position.
%fireball vector set to hero position and altered by a small random value.
%called by botsFire.
  function makeFire(pos)
    tempV = [heroPos(1) + (HERO_W / 2), heroPos(2) + (HERO_H / 2)] - pos;
    tempV = [tempV(1) * (1 + (((rand * 2) - 1) * FIRE_VAR)), ...
      tempV(2) * (1 + (((rand * 2) - 1) * FIRE_VAR))];
    %normalize it
    normV = tempV ./ (sqrt(tempV(1)^2 + tempV(2)^2));
    %multiply by fire speed
    fireV = normV .* FIRE_SPEED;
    fire(:,end+1) = [pos(1); pos(2); fireV(1); fireV(2) - STILL_SPEED];
  end


%+-----------------------------------------------------------------------+
%|                         CHECK COLLISIONS CBF                          |
%+-----------------------------------------------------------------------+
%check for collisions between (bots, hero), (bots, bullets), (fire, hero),
%and (pups, hero).
%uses separate hitTest function. 
%carries out appropriate actions if collision detected.
%run every frame.
  function checkCollisions
    %cycle through bots
    bot = size(bots,2);
    while bot > 0
%------------------------ CHECK BOTS AGAINST HERO ------------------------
      %if bot collides with hero, kill both
      if hitTest(heroPos(1), heroPos(2), HERO_W, HERO_H, ...
          bots{bot}.pos(1), bots{bot}.pos(2), ...
          BOT_W(bots{bot}.model), BOT_H(bots{bot}.model))
        
        if ~gameOver
          killBot(bot);
          health = health - COLLISION_DAMAGE;

        end
      else
        %bot didnt colide with hero, check if it hit each bullet
        bul = size(bullets,2);
        while bul > 0
%----------------------- CHECK BOTS AGAINST BULLETS ----------------------
          if hitTest(bots{bot}.pos(1), bots{bot}.pos(2), ...
              BOT_W(bots{bot}.model), BOT_H(bots{bot}.model), ...
              bullets(1,bul), bullets(2,bul))
            
            bullets(2,bul) = PLOT_H + 1;
            bots{bot}.health = bots{bot}.health - 1;
            %if bot out of health, kill bot. break loop and go to next bot.
            if bots{bot}.health <= 0
              %update score
              if ~INVINCIBLE %no points for cheaters!
                score = score + BOT_POINTS(bots{bot}.model);
              end
              killBot(bot);
              bul = 0;
            end
          end
          %decrement bullet counter.
          bul = bul-1;
        end
      end
      %decrement bot counter.
      bot = bot - 1;
    end
%------------------------- CHECK FIRE AGAINST HERO -----------------------
    if ~gameOver
      f = size(fire, 2);
      while f > 0
        if hitTest(heroPos(1), heroPos(2), HERO_W, HERO_H, ...
            fire(1,f), fire(2,f))
          %decrement health due to collision with fireball
          health = health - FIRE_DAMAGE;
          makeExplosion([fire(1,f), fire(2,f)], FIRE_FACE_COLOR);
          fire(2,f) = 0 - 1;
        end
        f = f-1;
      end
    end
    
%------------------------- CHECK PUPS AGAINST HERO -----------------------
if ~gameOver
  p = size(pups, 2);
  while p > 0
    if hitTest(heroPos(1), heroPos(2), HERO_W, HERO_H, ...
        pups(1,p), pups(2,p))
      %hero picked up a powerup. no carry out appropriate action
      switch pups(3,p)
        case 1 %superShoot powerup
          superShoot = SUPER_SHOOT_DURATION;
        case 2 %shield boost
          health = health + HEALTH_BOOST;
          if health > 1
            health = 1;
          end
        case 3 %bomb. kill all bots
          k = size(bots,2);
          while k > 0
            killBot(k);
            k = k-1;
          end
          
      end          
          killPup(p); %remove the pup after collision with hero.

    end
    p = p-1;
  end
end

  end %end cbf



%+-----------------------------------------------------------------------+
%|                           PAUSE GAME CBF                              |
%+-----------------------------------------------------------------------+
%run a loop separate from the main game loop.
%display paused message.
%called when player hits a key.
%ends when player hits a key.
  function pauseGame()
    paused = true;
    
    encoreText(1) = text(0, 0, STR_PAUSED);
    set(encoreText(1), 'Position', [PLOT_W/2, MESSAGE_Y]);
    set(encoreText(1), 'Color', PAUSE_COLOR);
    set(encoreText(1), 'HorizontalAlignment', 'Center');
    set(encoreText(1), 'FontSize', LARGE_TEXT,'FontName', FONT);
    encoreText(2) = text(0, 0, [STR_CONTROLS 10 10 STR_CONTINUE]);
    set(encoreText(2), 'Position', [PLOT_W/2, MESSAGE_Y - MESSAGE_SPACE]);
    set(encoreText(2), 'Color', WHITE);
    set(encoreText(2), 'HorizontalAlignment', 'Center');
    set(encoreText(2), 'VerticalAlignment', 'Top');
    set(encoreText(2), 'FontSize',SMALL_TEXT,'FontName', FONT);
    while paused;
      pause(FRAME_DELAY);
    end
    delete(encoreText(:));

  end


%+-----------------------------------------------------------------------+
%|                            ENCORE CBF                                 |
%+-----------------------------------------------------------------------+
%display game over message
%encoreCounter was set on gameOver.
%If it gets down to 1, its time to display the game over message
%use global handles so message can be cleared by reset.
  function encore
    if encoreCounter > 0
      encoreCounter = encoreCounter - 1;
      if encoreCounter == 0
        encoreText(1) = text(0, 0, STR_OVER);
        set(encoreText(1), 'Position', [PLOT_W/2, MESSAGE_Y]);
        set(encoreText(1), 'Color', OVER_COLOR);
        set(encoreText(1), 'HorizontalAlignment', 'Center');
        set(encoreText(1), 'FontSize', LARGE_TEXT,'FontName', FONT);
        encoreText(2) = text(0, 0, STR_CONTINUE);
        set(encoreText(2), 'Position', [PLOT_W/2, MESSAGE_Y - MESSAGE_SPACE]);
        set(encoreText(2), 'Color', WHITE);
        set(encoreText(2), 'HorizontalAlignment', 'Center');
        set(encoreText(2), 'FontSize',SMALL_TEXT,'FontName', FONT);
      end

    end

  end


%+-----------------------------------------------------------------------+
%|                        USER INTERFACE LISTENERS                       |
%+-----------------------------------------------------------------------+
  function keyDownListener(src,event)    
    switch event.Key
      case 'r'
        reset;
      case 'q'
        paused = false;
        quitGame = true;
      otherwise
        if intro
          intro = false;
        elseif gameOver
          reset;
        elseif paused
          paused = false;
        else
          pauseGame;
        end
    end
  end

  function mouseDownListener(src,event);
    %     if intro
    %       intro = false;
    %     elseif gameOver
    %       reset;
    %     else
    mouseDown = true;
    %    end
  end

  function mouseUpListener(src,event);
    mouseDown = false;
  end

  function mouseMoveListener(src, event)
    %no body.
    %this handler must be registerd for axis 'CurrentPoint' to be
    %updated when mouse moves.
  end

%redefinition of CloseRequestFcn
%so don't get stuck in loop if close window while paused
%probably don't want to modify this.
  function my_closefcn(src, event)
    paused = false; %this is the only modification to the default definition
    if isempty(gcbf)
      if length(dbstack) == 1
        warning('MATLAB:closereq', ...
          'Calling closereq from the command line is now obsolete, use close instead');
      end
      close force
    else
      if (isa(gcbf,'ui.figure'))
        % Convert GBT1.5 figure to a double.
        delete(double(gcbf));
      else
        delete(gcbf);
      end
    end
  end


%+-----------------------------------------------------------------------+
%|                             MAIN SCRIPT                               |
%+-----------------------------------------------------------------------+
createFigure; %set up the figure
createPlots; %make all permanent plots
reset; %set variables to starting values. 
while ~quitGame
  moveStars;
  moveHero;
  moveBots;
  moveFire;
  moveBullets;
  moveExplosions;
  movePups;
  shoot;
  checkCollisions;
  updateBars; %set data for hud bars. kill hero if health < 0.
  encore;
  refreshPlots; %set data in all the plots
  counter = counter + 1; %increment main game counter.
  %here's things that can happen every WAIT_FRAMES staggered in execution
  f = (mod(counter, WAIT_FRAMES));
  if f == 0
    if ~gameOver
      if ~INVINCIBLE %no points for cheaters!
        score = score + 1;
      end
      setWave;
    end
  elseif f == 4
    generateBots;
  elseif f == 6
    botsFire
 end
  pause(FRAME_DELAY); %freeze program for each frame.
  
end
close(fig);

end
