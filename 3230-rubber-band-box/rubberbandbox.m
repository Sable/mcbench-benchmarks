function [p1,p2]=rubberbandbox(varargin)
% Function to draw a rubberband box and return the start and end points
% Usage: [p1,p2]=rubberbox;     uses current axes
%        [p1,p2]=rubberbox(h);  uses axes refered to by handle, h
% Based on an idea of Sandra Martinka's Rubberline
% Written/Edited by Bob Hamans (B.C.Hamans@student.tue.nl) 
% 02-04-2003

%Check for optional argument
switch nargin
case 0
  h=gca;
case 1
  h=varargin{1};
  axes(h);
otherwise
  disp('Too many input arguments.');
end

% Get current user data
cudata=get(gcf,'UserData'); 
hold on;
% Wait for left mouse button to be pressed
k=waitforbuttonpress;
p1=get(h,'CurrentPoint');       %get starting point
p1=p1(1,1:2);                   %extract x and y
lh=plot(p1(1),p1(2),'-r');      %plot starting point
% Save current point (p1) data in a structure to be passed
udata.p1=p1;
udata.h=h;
udata.lh=lh;
% Set gcf object properties 'UserData' and call function 'wbmf' on mouse motion. 
set(gcf,'UserData',udata,'WindowButtonMotionFcn','wbmf','DoubleBuffer','on');
k=waitforbuttonpress;

% Get data for the end point
p2=get(h,'Currentpoint');       %get end point
p2=p2(1,1:2);                   %extract x and y
set(gcf,'UserData',cudata,'WindowButtonMotionFcn','','DoubleBuffer','off'); %reset UserData, etc..
delete(lh);

function wbmf %window motion callback function
utemp=get(gcf,'UserData');
ptemp=get(utemp.h,'CurrentPoint');
ptemp=ptemp(1,1:2);
% Use 5 point to draw a rectangular rubberband box
set(utemp.lh,'XData',[ptemp(1),ptemp(1),utemp.p1(1),utemp.p1(1),ptemp(1)],'YData',[ptemp(2),utemp.p1(2),utemp.p1(2),ptemp(2),ptemp(2)]);
