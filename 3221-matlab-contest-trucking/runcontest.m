function [message,results,timeElapsed] = runcontest(drawboard)
%
%  Copyright 2003 The MathWorks, Inc.

if (nargin == 0)
    drawboard = 0;
end

% Load the testsuite
testsuite = load('testsuite');
testsuite = testsuite.testsuite;

% Run the submission for each problem in the suite.
responses = cell(size(testsuite));
time0 = cputime;
for k = 1:length(testsuite)
    responses{k} = solver(testsuite(k).v);
end
timeElapsed = cputime-time0;

% Check and score each answer.
for k = 1:length(testsuite),
    a = testsuite(k).v;
    c = responses{k};
    
    % Is it valid?
    if any(round(c) ~= c) | (any(~isreal(c)))
        error('Return vector must be integers')
    end
    if length(c)-1 ~= length(unique(c(2:end)))
        error('Cannot visit the same location more than once')
    end
    if (length(c)<2) | (c(1) ~= 1) | (c(end) ~= 1)
        error('Returned vector must start and end with 1')
    end
    if (any(c<1) | any(c> size(a,1)))
        error('Returned vector contains value out of range')
    end

    % Score it 
    x = a(c,1);
    y = a(c,2);
    d = cumsum(sqrt((x(2:end)-x(1:end-1)).^2 + (y(2:end)-y(1:end-1)).^2));
    g = cumsum(a(c(1:end-1),4));
    availableGas = sum(a(:,4));
    availableFreight = sum(a(:,3));
    collectedFreight = sum(a(c,3));
    if any((g-d)<0)
        % Ran out of gas.  No score.
        score = availableFreight + availableGas;
    else
        % Returned home with the cargo.
        score = availableFreight - sum(a(c(2:end),3)) + g(end);
    end
    
    results(k) = score;
    
    % plot
    if drawboard
        visualize(a,c)
        disp('Press "Enter" to continue.');
        pause
    end
end

% Report results.
message = sprintf('%.3fK raw score', sum(results)/1000);

%===============================================================================
function visualize(a,c)
cla
axis equal
box on
hold on
x = a(:,1);
y = a(:,2);
freight = a(:,3);
fuel = a(:,4);
availableFreight = sum(a(:,3));
collectedFreight = sum(a(c,3));
for i = 1:length(x)
    freightSize = (freight(i)/(max(freight)+1))*10+1;
    fuelSize = (fuel(i)/(max(fuel)+1))*10+1;
    line1 = plot(x(i),y(i),'s','markersize',freightSize,'markerfacecolor','none');
    line2 = plot(x(i),y(i),'*','markersize',fuelSize,'markeredgecolor','r','markerfacecolor','none');
end
plot(x(i),y(i),'s','markerfacecolor','b','visible','off');
plot(x(i),y(i),'*','markeredgecolor','r','markerfacecolor','r','visible','off');
plot(x(c),y(c),'k');
plot(x(1),y(1),'p','markeredgecolor','k','MarkerSize',14);
hold off

percentRemaining = (availableFreight-collectedFreight)/availableFreight*100;
disp(sprintf('%.2f%% remaining',max(percentRemaining,0)));
