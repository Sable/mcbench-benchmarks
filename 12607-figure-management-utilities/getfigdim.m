function [figsize,figborders]=getfigdim(figh)
% [figsize,figborders]=getfigdim(figh)  GET FIGure DIMensions.
%   Function creates a figure and then measures the appropriate values to
%   obtain border widths and heights of the menu and tool bars and other 
%   parameters. This can then be used to size and place figures more exactly.
%   "figh" is the handle of the figure whose dimensions are measured.
%       If "figh" is not specified or empty then a figure will be created.
%   "figsize" is a four element row vector which specifies the figure. 
%       The vector is as follows:  [left bottom width height]
%       These are the same values returned by "OuterPosition" property.
%   "figborders" is a 6 element row vector which is defined as:
%       [figureborder titlebarheight menubarheight ...
%                           toolbarheight minfigwidth minfigheight]
%       The figureborder is defined for all four sides of the figure.
%       The minfigwidth, minfigheight are the minimum size of figures that
%       Matlab produces without menu and tool bars.
%       
%   Example: 
%       [fsize,fborder]=getfigdim; 
%       fsize = [227   241   570   504]
%       fborder = [5    26    21    27   125    37]

%   Copyright 2006 Mirtech, Inc.
%   created 08/20/2006  by Mirko Hrovat on Matlab Ver. 7.2
%   Mirtech, Inc.       email: mhrovat@email.com

%Create a figure if it doesn't exist
if nargin==0 || isempty(figh),
    figh=figure;
    clrflg=1;
else
    figure(figh);
    clrflg=0;
end
menbarstate=get(figh,'MenuBar');
toolbarstate=get(figh,'ToolBar');
unitsstate=get(figh,'Units');
set(figh,'Units','pixels');
drawnow
figsize=get(figh,'OuterPosition');
figpos=get(figh,'Position');
if nargout==2,
    set(figh,'MenuBar','none');
    set(figh,'ToolBar','none');
    drawnow
    p1=get(figh,'OuterPosition');
    p =get(figh,'Position');

    set(figh,'MenuBar','figure');
    set(figh,'ToolBar','none');
    drawnow
    p2=get(figh,'OuterPosition');

    set(figh,'MenuBar','none');
    set(figh,'ToolBar','figure');
    drawnow
    p3=get(figh,'OuterPosition');

    set(figh,'MenuBar','none');
    set(figh,'ToolBar','none');
    set(figh,'OuterPosition',[figsize(1),figsize(2),10,10]);
    drawnow
    p4=get(figh,'OuterPosition');

    figborders=zeros(1,6);
    figborders(4)= p3(4)-p1(4);             % calculate height of Toolbar
    figborders(3)= p2(4)-p1(4);             % calculate height of Menubar
    figborders(1)= (p1(3)-p(3))/2;          % calculate width of figure border
    figborders(2)= p1(4)-p(4)-2*figborders(1); % calculate height of title bar
    figborders(5:6)=p4(3:4);                % get minimium figure sizes
end %if nargout==2
% close the figure if created, otherwise return to original state
if clrflg,
    close(figh);
else
    set(figh,'MenuBar',menbarstate);
    set(figh,'ToolBar',toolbarstate);
    set(figh,'Units',unitsstate);
    set(figh,'Position',figpos);
    drawnow
end
% ---------- END ----------
