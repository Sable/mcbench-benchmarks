function z = generateSimulatedBouncingPath(iterationNum, roundTimes)
% This function generates the Z-coordinate path for the center of heart.

% by Xin Zhao
% Feb 14, 2008

% define the z path of the center of ball for rountTimes of bouncing along z-axis
if nargin < 2
    roundTimes = 3;
end

if nargin < 1
    iterationNum = 40;
end

radius = 1;
deltaH = 1.5; % the highest point comapred with radius
deltaL = -0.3;% the lowest point comapred with radius

rangeY = [-2, 1];

% gravity accelerator constant
% Note: this is smaller to the real 9.8 value, but this makes the bouncing slower
g = 5;

% define the accelerator for the z < 0
% k is similar to spring coefficient, but it's more complicated than that.
% k just needs to satisfy one condition here, i.e. it will stop at location defined by
% deltaL*radius
k = g * deltaH/(-deltaL);

% start point
startZ = deltaH*radius;

% speed when z =0
V0 = sqrt(2*startZ*g);

% calcualte the total time for rountTimes of bouncing
% time for z > 0
plusZtime = sqrt(2*deltaH*radius/g);
% time for z < 0
minusZtime = sqrt(-2*deltaL*radius/k);

% half period
qPeriod = plusZtime + minusZtime;

% define totalTime
qPeriodTime = linspace(0, qPeriod, iterationNum);

% z path when z > 0
zPlus = startZ - 0.5 * g * qPeriodTime(qPeriodTime<plusZtime).^2;

% z path when z < 0
zMinus = -V0 * (qPeriodTime(qPeriodTime >=plusZtime)-plusZtime) + 0.5 * k* (qPeriodTime(qPeriodTime >=plusZtime)-plusZtime).^2;

z = [zPlus, zMinus, fliplr(zMinus), fliplr(zPlus)];
% the last zPlus is for the stop action
z = [repmat(z, 1, roundTimes), zPlus];
y = linspace(rangeY(1), rangeY(2), numel(z));
