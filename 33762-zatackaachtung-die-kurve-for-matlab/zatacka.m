function winner = zatacka(N)
global x
global alive
global increment
global controls
global snakeSize
global lastPos
global holeCountDown
global F

if nargin==0
    N = 1;
end

map = [0   0 0; ...  %black
       255 0 0; ...  %red
       0 255 0; ...  %green
       0 0 255; ...  %blue
       255 255 0]/255; %yellow
% GAME SETTINGS
% if the game runs too slow or too fast, try adjusting
% the speed v in combination with the wait-time
% v should not exceed 1
res = [640, 480];
snakeSize = 5;
controls = ['qw';'cv';'ui';',.'];
v = 0.5 * snakeSize;        %speed in pixels/iteration
r = 7 * snakeSize;          %radius in pixels
minHoleTime = 120;
maxHoleTime = 160;
minHoleSize = round(2 * snakeSize / v);
maxHoleSize = round(4 * snakeSize / v);
wait = 2e-2;


% INITIATE GAME
F = sparse(res(2), res(1));
alive = 1:N;
increment = zeros(N,1);
dphi = v / r;
lastPos = zeros(snakeSize^2, 2*N);
x = rand(N, 3);
buffer = 150;
R = [res(1) - buffer, buffer ; buffer, res(2) - buffer];

x(:,1:2) = x(:,1:2) * R; 
x(:,3)   = x(:,3) * 2 * pi;   %position coordinates and angle
for i=1:N
    lastPos(:,2*i-1:2*i) = getpixels(x(i,:), snakeSize);
end
holeCountDown = rand(N, 2);
holeCountDown(:,1) = round(holeCountDown(:,1) * (maxHoleTime - minHoleTime)) + minHoleTime;
holeCountDown(:,2) = round(holeCountDown(:,2) * (maxHoleSize - minHoleSize)) + minHoleSize;
updategrid(x);

deskres = get(0, 'ScreenSize');
close(findobj('Name','Zatacka!'))
fig = figure('Name', 'Zatacka!',...
                 'WindowKeypressFcn', @getkey,...
                 'WindowKeyReleaseFcn', @losekey,...
                 'Colormap', map,...
                 'Position', deskres);
ax  =   axes('Parent', fig,...
             'XLim', [0 res(1)],...
             'YLim', [0 res(2)],...
             'XTickLabel', [],...
             'YTickLabel', [],...
             'PlotBoxAspectRatio', [res(1), res(2), 1],...
             'Color', [0 0 0]);
zatack = image('Parent', ax, 'CData', F + 1);
ready = text(res(1)/2, res(2)/2, 'GET READY', 'Color','White');
% RUN GAME!
pause(1)
delete(ready)
while numel(alive) > 1 - (N==1)
    x(:,3) = mod(x(:,3) + dphi * increment, 2 * pi); %increment angles
    x(:,1) = x(:,1) + v * cos(x(:,3));               %update positions
    x(:,2) = x(:,2) - v * sin(x(:,3));
    
    holeCountDown(:,1) = holeCountDown(:,1) - 1;
    updategrid(x, minHoleTime, minHoleSize, maxHoleTime, maxHoleSize);
    set(zatack, 'CData', F + 1);
    pause(wait)
end
if isempty(alive)
    winner = 1;
else
    winner = alive;
end
colors = {'Red', 'Green', 'Blue', 'Yellow'};
questdlg(sprintf('KONEC HRY!\n%s won!', colors{winner}),'Game Over','OK', 'OK');
close(fig);