function plotgng(pos,edges,display_node_index)
%PLOTGNG Plot growing neural gas map.
%
%  Syntax
%
%    plotgng(pos,edges,display_node_index)
%
%  Description
%
%    PLOTGNG(pos,edges,display_node_index) takes three input arguments:
%
%    - pos - NxS matrix of S N-dimensional neural positions.
%    and plots the neuron positions with red dots, linking
%    the neurons which are connected (have a common edge).
%    
%   - edges is a symmetric binary matrix. If edges(i,j) = 1, then an edge (line segment) 
%      will be drawn to connect the i-th to the j-th nodes. Also, by
%      definition, edges(j,i) = 1 as well
%
%   - display_node_index is a dual valued flag that indicates wether we
%   also desire to draw the neural unit's number. It takes 2 string values:
%    'y' (yes) or 'n' (no).


% Arguments Check
if nargin<3
    error('Not enough arguments.');
end


% Check Dimensions
[R,S] = size(pos);
if R < 3
   pos = [pos; zeros(3-R,S)];
elseif R > 3
   disp('Warning - PLOTGNG only shows first three dimensions.');
   pos = pos(1:3,:);
end 

% Line coordinates
[I J] = meshgrid(1:S,1:S);
[i  j] = find(edges == 1); 

numLines = length(i);

x = [pos(1,i); pos(1,j); zeros(1,numLines)+NaN];
y = [pos(2,i); pos(2,j); zeros(1,numLines)+NaN];
z = [pos(3,i); pos(3,j); zeros(1,numLines)+NaN];
x = reshape(x,1,3*numLines);
y = reshape(y,1,3*numLines);
z = reshape(z,1,3*numLines);

% Draw Node Index as well:
% Prepare the node indices for drawing... 
if display_node_index == 'y'
    node_index = cell(size(pos,2),1);
    for i=1:size(pos,2)
         node_index(i) = num2cell(i);
    end
end

% Plot the edges and the nodes:
plot3(x,y,z,'b',pos(1,:),pos(2,:),pos(3,:),'.r','markersize',6)

% Draw the node indices if selected:
if display_node_index == 'y'
    text(pos(1,:)+.05,pos(2,:),pos(3,:),node_index,'HorizontalAlignment','left','FontSize',7, 'EraseMode','xor');
end

t = 'GNG Nodes (red dots) and Edges (blue line segments)';
var = ['x','y','z'];

set(gca,'box','off')
grid off
xlabel(var(1));
ylabel(var(2));
zlabel(var(3));
title(t)
view(2 + (R>=3));
