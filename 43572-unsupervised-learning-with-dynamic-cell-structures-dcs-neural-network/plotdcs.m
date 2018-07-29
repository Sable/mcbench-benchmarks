function plotdcs(pos,C,display_node_index)

%PLOTDCS Plot Dynamic Cell Structure neural net.
%
%  Syntax
%
%    plotdcs(pos,C,display_node_index)
%
%    Description
%
%    PLOTDCS takes three input arguments,
%    POS - NxS matrix of S N-dimension neural positions.
%    and plots the neuron positions with red dots, linking
%    the neurons which are connected. 

% Arguments
if nargin<3, error('Not enough arguments.'),end

% Check Dimensions
[R,S] = size(pos);
if R < 3
  pos = [pos; zeros(3-R,S)];
elseif R > 3
  disp('Warning - PLOTDCS only shows first three dimensions.');
  pos = pos(1:3,:);
end 

% Line coordinates
[I  J] = meshgrid(1:S,1:S);
[i   j] = find(C~=0); 

numLines = length(i);

x = [pos(1,i); pos(1,j); zeros(1,numLines)+NaN];
y = [pos(2,i); pos(2,j); zeros(1,numLines)+NaN];
z = [pos(3,i); pos(3,j); zeros(1,numLines)+NaN];
x = reshape(x,1,3*numLines);
y = reshape(y,1,3*numLines);
z = reshape(z,1,3*numLines);

if display_node_index == 'y'  
    node_index = cell(size(pos,2),1);
    for i=1:size(pos,2)
        node_index(i) = num2cell(i);
    end
end

% Plot
plot3(x,y,z,'b',pos(1,:),pos(2,:),pos(3,:),'.r','MarkerSize',6)
set(gca,'box','on')
if display_node_index == 'y'
    text(pos(1,:)+.05,pos(2,:),pos(3,:),node_index,'HorizontalAlignment','left','FontSize',7, 'EraseMode','xor');
end
grid off

t = 'DCS Nodes (red dots) and Connections (blue line segments)';
var = ['x','y','z'];

set(gca,'box','off')
grid off
xlabel(var(1));
ylabel(var(2));
zlabel(var(3));
title(t)
view(2 + (R>=3));
