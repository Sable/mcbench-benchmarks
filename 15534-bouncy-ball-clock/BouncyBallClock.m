function BouncyBallClock
% BouncyBallClock
%
% A clock featuring four chambers of bouncing balls.  There is one chamber
% each for seconds, minutes, hours, and AM/PM.  The number of balls in each
% chamber represents the time count for that chamber.  For instance, if
% there are five balls in the hours chamber, then it is sometime during the
% 5:00 hour.
%
% Copyright 2005-2011 The MathWorks, Inc.

% NOTE: The bouncy ball clock makes a set of assumptions in order to
% improve perf:
% - Each ball can only make one collision with another ball per round
% - The one collision will happen with the first ball with which it
%   collides in data order
% - Balls will not be collision tested against the wall: they will simply
%   be prohibited from advancing past it

% Set up figure
hFigure = figure;
hAxes   = axes('xlim', [-0.1 2.1], 'ylim', [-0.1 2.1], 'dataaspectratio', [1 1 1], 'visible', 'off');
rectangle('position', [0 0 2 2], 'edgecolor', 'k', 'facecolor', 'w', 'linewidth', 2);
line([0 2], [1 1], 'color', 'k', 'linewidth', 2);
line([1 1], [0 2], 'color', 'k', 'linewidth', 2);

% Set up ball data
global data
data = struct;
data.axes = hAxes;
data.nChambers = 4;

% Seconds chamber
data.chambers(1).radius = .01;
data.chambers(1).nBalls = 0;
data.chambers(1).maxBalls = 60;
data.chambers(1).speed = .01;
data.chambers(1).currentTick = 0;
data.chambers(1).clearTick = 0;
data.chambers(1).cleared = 0;
data.chambers(1).color = [.01666 0 0];
data.chambers(1).location = hgtransform('parent', hAxes);

% Minutes chamber
data.chambers(2).radius = .02;
data.chambers(2).nBalls = 0;
data.chambers(2).maxBalls = 60;
data.chambers(2).speed = .01;
data.chambers(2).currentTick = 0;
data.chambers(2).clearTick = 0;
data.chambers(2).cleared = 0;
data.chambers(2).color = [0 .01666 0];
data.chambers(2).location = hgtransform('parent', hAxes);

% Hours chamber
data.chambers(3).radius = .03;
data.chambers(3).nBalls = 0;
data.chambers(3).maxBalls = 12;
data.chambers(3).speed = .01;
data.chambers(3).currentTick = 0;
data.chambers(3).clearTick = 1;
data.chambers(3).cleared = 0;
data.chambers(3).color = [0 0 .08333];
data.chambers(3).location = hgtransform('parent', hAxes);

% AM/PM chamber
data.chambers(4).radius = .04;
data.chambers(4).nBalls = 0;
data.chambers(4).maxBalls = 2;
data.chambers(4).speed = .01;
data.chambers(4).currentTick = 0;
data.chambers(4).clearTick = 1;
data.chambers(4).cleared = 0;
data.chambers(4).color = [0 0 0];
data.chambers(4).location = hgtransform('parent', hAxes);

% Translate the minutes, hours, and AM/PM balls to their chambers
location = makehgtform('translate', [1 1 0]);
set(data.chambers(2).location, 'matrix', location);
location = makehgtform('translate', [0 1 0]);
set(data.chambers(3).location, 'matrix', location);
location = makehgtform('translate', [1 0 0]);
set(data.chambers(4).location, 'matrix', location);

% Create the individual balls for each chamber
for k = 1:data.nChambers
    for i = 1:data.chambers(k).maxBalls
        data.chambers(k).balls(i).position = [rand rand];
        velocity = [rand rand];
        velocity = data.chambers(k).speed * (velocity / norm(velocity));
        data.chambers(k).balls(i).velocity = velocity;
        diameter = 2 * data.chambers(k).radius;
        color = i * data.chambers(k).color;
        data.chambers(k).balls(i).circle = rectangle('position', [0 0 diameter diameter], 'curvature', [1,1], 'facecolor', color, 'edgecolor', color);
        data.chambers(k).balls(i).transform = hgtransform('parent', data.chambers(k).location);
        data.chambers(k).balls(i).moved = 0;
        set(data.chambers(k).balls(i).circle, 'parent', data.chambers(k).balls(i).transform); 
        set(data.chambers(k).balls(i).transform, 'visible', 'off');
    end
end
Initialize;

set(hFigure,'Renderer','opengl')
%drawnow

% Set up and run timer
hTimer = timer('TimerFcn', @ClockCallback, 'Period', .25, 'ExecutionMode', 'fixedRate');
start(hTimer);
set(hFigure, 'DeleteFcn', {@CirclesDeleteFcn, hTimer});
set(hFigure, 'Name', 'Bouncy Ball Clock by Brian Cody');
set(hFigure, 'MenuBar', 'none');

% Pause to keep profiler attached
%pause(120);

%--------------------------------------------------------------------------
% ClockCallback
function ClockCallback(obj, event)

global data
hClock   = clock;
ticks(1) = round(hClock(6));    % Seconds
ticks(2) = hClock(5);           % Minutes
ticks(3) = mod(hClock(4), 12);  % Hours (12-hour form)
if (ticks(3) == 0)
    ticks(3) = 12;
end
ticks(4) = 1;                   % AM/PM
if (hClock(4) > 11)
    ticks(4) = 2;
end

for k = 1:data.nChambers
    % Clear out chamber when necessary / Add new balls
    if (ticks(k) == data.chambers(k).clearTick && data.chambers(k).cleared == 0)
        % Clear out the chamber
        ClearBalls(k);
        
        % Make sure the chamber has the correct number of balls after clear
        for i = 1:ticks(k)
            AddBall(k);
        end
        data.chambers(k).currentTick = ticks(k);        
    end
    if (ticks(k) > data.chambers(k).currentTick)
        % Add a new ball to the chamber
        data.chambers(k).currentTick = ticks(k);
        data.chambers(k).cleared = 0;
        AddBall(k);
    end
    
    % Move balls and check for collisions
    for i = 1:data.chambers(k).nBalls
        if (data.chambers(k).balls(i).moved == 0)
            collisionTime = -1;
            for j = i+1:data.chambers(k).nBalls
                collisionTime = GetCollisionTime(k, i,j);
                if (collisionTime >= 0)
                    Collide(k, i, j, collisionTime);
                    break   % Assume only one collision per round for perf: take the first one found
                end
            end
            if (collisionTime == -1)
                data.chambers(k).balls(i).position = data.chambers(k).balls(i).position + data.chambers(k).balls(i).velocity;          
                move = makehgtform('translate', [data.chambers(k).balls(i).position(1) data.chambers(k).balls(i).position(2) 0]);
                set(data.chambers(k).balls(i).transform, 'matrix', move);
            end
        else
            % This ball has already moved this round, do nothing more
            % (for perf reasons, algorithm assumes only one collision per
            % ball per round)
            data.chambers(k).balls(i).moved = 0;
        end
        
        % Handle boundary conditions in a very simplistic way:
        % Don't do collision testing against the wall, simply make sure
        % that the balls stay within bounds and that the velocity changes
        % when balls approach the walls.
        if (data.chambers(k).balls(i).position(1) <= 0)
            data.chambers(k).balls(i).position(1) = 0;
            data.chambers(k).balls(i).velocity(1) = abs(data.chambers(k).balls(i).velocity(1));
        end
        if (data.chambers(k).balls(i).position(1) >= 1 - 2*data.chambers(k).radius)
            data.chambers(k).balls(i).position(1) = 1 - 2*data.chambers(k).radius;
            data.chambers(k).balls(i).velocity(1) = -1 * abs(data.chambers(k).balls(i).velocity(1));
        end
        if (data.chambers(k).balls(i).position(2) <= 0)
            data.chambers(k).balls(i).position(2) = 0;
            data.chambers(k).balls(i).velocity(2) = abs(data.chambers(k).balls(i).velocity(2));
        end
        if (data.chambers(k).balls(i).position(2) >= 1 - 2*data.chambers(k).radius)
            data.chambers(k).balls(i).position(2) = 1 - 2*data.chambers(k).radius;
            data.chambers(k).balls(i).velocity(2) = -1 * abs(data.chambers(k).balls(i).velocity(2));
        end
    end
end

%--------------------------------------------------------------------------
% Initialize
% When the clock is first run, this function ensures that each chamber has
% the appropriate number of balls for the user to be able to tell time
function Initialize
global data
hClock   = clock;
ticks(1) = round(hClock(6));    % Seconds
ticks(2) = hClock(5);           % Minutes
ticks(3) = mod(hClock(4), 12);  % Hours (12-hour form)
if (ticks(3) == 0)
    ticks(3) = 12;
end
ticks(4) = 1;                   % AM/PM
if (hClock(4) > 11)
    ticks(4) = 2;
end

% Add any balls that should be visible and place them at a random location
for k = 1:data.nChambers
    for i = 1:ticks(k)
        AddBall(k);
        data.chambers(k).balls(i).position = [rand rand];
    end
    data.chambers(k).currentTick = ticks(k);
end

%--------------------------------------------------------------------------
% AddBall
% Add the next ball to chamber k
function AddBall(k)
global data

% Reset data for this ball, return it to the starting position, and make it
% visible
nBalls = data.chambers(k).nBalls + 1;
data.chambers(k).nBalls = nBalls;
data.chambers(k).balls(nBalls).moved = 0;
data.chambers(k).balls(nBalls).position = [.025 .025];
move = makehgtform('translate', [data.chambers(k).balls(nBalls).position(1) data.chambers(k).balls(nBalls).position(2) 0]);
set(data.chambers(k).balls(nBalls).transform, 'matrix', move);
set(data.chambers(k).balls(nBalls).transform, 'visible', 'on');

%--------------------------------------------------------------------------
% ClearBalls
% Remove all the balls from chamber k
function ClearBalls(k)
global data

% Reset data for this chamber and make all balls in it invisible
data.chambers(k).nBalls = 0;
data.chambers(k).cleared = 1;
for i = 1:data.chambers(k).maxBalls
    set(data.chambers(k).balls(i).transform, 'visible', 'off');
end

%--------------------------------------------------------------------------
% GetCollisionTime
% If balls i and j in chamber k collide during this round, return the time
% into the round at which the collision happens, otherwise, return -1
function t = GetCollisionTime(k, i, j)
global data

% Cache data
pi = data.chambers(k).balls(i).position;
pj = data.chambers(k).balls(j).position;

% Collision detection algorithm taken and modified from www.gamasutra.com
v = data.chambers(k).balls(i).velocity - data.chambers(k).balls(j).velocity;
normV = norm(v);
dist = norm(pi - pj);
sumRadii = 2 * data.chambers(k).radius;
dist = dist - sumRadii;
t = -1;
if (normV >= dist)
    N = v / normV;
    C = pj - pi;
    D = dot(N,C);
    if (D > 0)
        lengthC = norm(C);
        F = lengthC^2 - D^2;
        sumRadiiSquared = sumRadii^2;
        if (F < sumRadiiSquared)
            T = sumRadiiSquared - F;
            if (T >= 0)
                distance = D - sqrt(T);
                mag = normV;
                if (mag >= distance)
                    moveV = N * distance;
                    t = norm(moveV)/normV;
                end
            end
        end
    end
end

%--------------------------------------------------------------------------
% Collide
% Apply the collision of balls i and j in chamber k at time t
function Collide(k, i, j, t)
global data

% Cache data
pi = data.chambers(k).balls(i).position;
pj = data.chambers(k).balls(j).position;
vi = data.chambers(k).balls(i).velocity;
vj = data.chambers(k).balls(j).velocity;

% Move positions to collision point
pi = pi + t*vi;
pj = pj + t*vj;

% Make the collision is viewable in the window
move = makehgtform('translate', [pi(1) pi(2) 0]);
set(data.chambers(k).balls(i).transform, 'matrix', move);
move = makehgtform('translate', [pj(1) pj(2) 0]);
set(data.chambers(k).balls(j).transform, 'matrix', move);

% Calculate new velocities
% Algorithm taken and modified from www.gamasutra.com
ni = (pi - pj)/norm(pi-pj);
mi = dot(vi, ni);
mj = dot(vj, ni);

vi = vi - (mi-mj)*ni;
vj = vj + (mi-mj)*ni;

% Set new positions and velocities
data.chambers(k).balls(i).position = pi + (1-t)*vi;
data.chambers(k).balls(j).position = pj + (1-t)*vj;
data.chambers(k).balls(i).velocity = vi;
data.chambers(k).balls(j).velocity = vj;

data.chambers(k).balls(j).moved = 1;

%--------------------------------------------------------------------------
% Delete function
function CirclesDeleteFcn(obj, event, hTimer)
% Stop and delete the timer
stop(hTimer);
delete(hTimer);
