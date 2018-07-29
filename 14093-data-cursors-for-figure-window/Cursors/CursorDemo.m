function CursorDemo()
% demo function for cursors
%
% Example:
% type CursorDemo at the command line

h=figure('Name','Hold the left button down over the cursors to move them around the screen');
x=0:0.1:10;
y=sin(x);

for k=1:9
    subplot(3,3,k)
    plot(x,y);
end

n1=CreateCursor(h);
SetCursorLocation(n1, 2.5);
n2=CreateCursor(h);
SetCursorLocation(n2, 7.5);
end


