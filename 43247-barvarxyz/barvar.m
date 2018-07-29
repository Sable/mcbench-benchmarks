% barvar(X,Y,W)
%
% using patches to re-implement the bar-plot function, allowing different
% width for each bar.
%
% columns in Y are regarded as a data series (same color). rows are grouped 
% into adjacent bars having different colors.
% 
% to set the width for each data series input a row vector:
% W = [w1,w2,w3...]. to a set a different width for each bars group input a
% column vector: W = [w1;w2;w3...].

function hBar = barvar( X, Y, W)

if nargin < 3
    fprintf( 'this is a demo of barvar(X,Y,Z). \nnext time give me all the required inputs.\n');
    W = randi(3,1,5);
    X = (1:5)' * sum(W) * 1.5;
    Y = 10*(rand(5,5) - 0.5);
end

% rectify input, if possible
for dim = 1:2
    Repeat = ones(1,2);
    if size(X,dim) ~= size(Y,dim)
        if size(X,dim) == 1
            Repeat(dim) = size( Y,dim);
            X = repmat( X, Repeat);
        elseif size(Y,dim) == 1
            Repeat(dim) = size( X,dim);
            Y = repmat( Y, Repeat);
        else
            error( 'each input dimension should be either 1 or equal to other inputs.');
        end
    end
    if size(W,dim) ~= size(Y,dim)
        if size(W,dim) == 1
            Repeat(dim) = size( Y,dim);
            W = repmat( W, Repeat);
        else
            error( 'each input dimension should be either 1 or equal to other inputs.');
        end
    end
end

%% draw bars

nSets = size( Y,2);
nBars = size( Y,1);
hBar = zeros( 1, nSets);
SetWidth = sum( W,2); % width of combined sets per bar
cdata = (1:nSets)';

for s = 1:nSets
    
    % 4 vertices for each bar
    Xdata = zeros(4,nBars);
    Ydata = zeros(4,nBars);
    for b = 1:nBars
        % X-left
        Xdata(1,b) = X(b,s); % ref data point
        Xdata(1,b) = Xdata(1,b) - SetWidth(b) / 2; % begining of set (centered on Xdata)
        Xdata(1,b) = Xdata(1,b) + sum( W(b,1:s-1)); % current set position
        Xdata(2,b) = Xdata(1,b);
        % X-right = Xl + W
        Xdata(3,b) = Xdata(1,b) + W(b,s);
        Xdata(4,b) = Xdata(3,b);
        % Y-down
        Ydata(1,b) = 0;
        Ydata(4,b) = 0;
        % Y-up
        Ydata(2,b) = Y(b,s);
        Ydata(3,b) = Y(b,s);
    end
    
    hBar(s) = patch( Xdata, Ydata, s);
%     set(gca,'CLim',[0 40])
%     set( hBar(s), 'FaceColor', 'flat', 'FaceVertexCData', cdata(b), 'CDataMapping', 'direct');
    hold on
end

% x-axis
line( [ min(X(:)) - 100, max(X(:)) + 100], [0,0], 'Color', 'k');
hold off
AxisMargin = max( sum(W,2));
set( gca, 'Box', 'on', 'Xlim', [ min(X(:)) - AxisMargin, max(X(:)) + AxisMargin]);
figure(gcf)

