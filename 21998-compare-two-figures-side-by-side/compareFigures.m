function compareFigures(fig1, fig2)
%COMPAREFIGURES - places the second figure next to the first one
%
% Syntax:
%   compareFigures(fig1, fig2) places the contents of fig2 next to the
%   contents of fig1, inside fig2

% Copyright 2008 The MathWorks, Inc. 

pos1 = get(fig1,'Position');
pos2 = get(fig2,'Position');


%set absolute units to prevent resizing
setChildrenToPixel(fig1);
setChildrenToPixel(fig2);

%move the item from the second figure to the first
moveChildren(fig2,fig1,pos1(2));
%get rid of the second figure
close(fig2); 

%resize the first figure to accodate the second
pos1(3) = pos1(3) + pos2(3);
pos1(4) = max(pos1(4),pos2(4));
set(fig1, 'Position', pos1);

%center on screen
set(fig1,'units','normalized');
pos1 = get(fig1,'Position');
pos1(1) = (1 - pos1(3)) / 2;
pos1(2) = (1 - pos1(4)) / 2;
set(fig1,'Position',pos1);
%bring to the front
figure(fig1);


function setChildrenToPixel(fig)
children = get(fig,'Children');
for i=1:length(children)
    set(children(i),'Units','pixels')
end
    
function moveChildren(from,to,x)
children = get(from,'Children');
for i=1:length(children)
    pos = get(children(i),'Position');
    pos(1) = x;
    set(children(i),'Parent',to,'Position', pos);
end