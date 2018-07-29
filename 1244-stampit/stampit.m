function [fh,dh] = stampit(fd_flag)

% The Stampit function places a file and/or date stamp on the bottom
% of all open figures windows.  It must be called at the end of an m-file
% (otherwise the m-file name is []). If f_flag is 'f' then only the filename
% is placed on the figures, if d_flag = 'd' then only the date is stamped in
% the figure windows.  
%
% fh and dh are the corresponding handles of the filename and date text
% within each of the figure windows.  
%
% Call: [fh,dh]=stampit('f');
%
% Written by T. Burke, 8/21/01
%
% Revision List:
%  - addition of hidn_axis was added to properly locate the 
%    filename and date at the bottom of the overall figure window (DMP/TAB)
%  - addition of cur_ax in order to set the current axes handle back to its
%    original state (before Stampit is called) (DEK/TAB)
%  - addition of cur_fig in order to reset the current figure back to its 
%    original state (before Stampit was called) (TAB 11/7/01)
%  - place the handle for the hidden stampit axis to the bottom of the 
%    figure's Children handle list -- this should solve problems with the zoom
%    function and other functions after stampit has been called (TAB 11/13/01)
%  - used st(length(st)).name instead of st(2,1).name so that the original m-file
%    that is run is the one printed on the plots (ie. NOT a function's name in
%    case the figures are generated within a function call) (TAB 12/17/01)


%check for proper input to function
if nargin>1, error('Too Many Arguments for Stampit Function'); end
if nargin==0, flag=2; end
if nargin==1
    if fd_flag=='f'
        flag=1;
    else
        flag=0;
    end
end
 
%obtain location of calling m-file
[st,i] = dbstack;

if max(size(st))==1,error('Stampit must be called at the end of an m-file');end

h = findobj('Type','figure');
cur_fig = get(0,'CurrentFigure');

warning off
for i = 1:length(h)
    set(0,'CurrentFigure',h(i));
    cur_ax = get(h(i),'CurrentAxes'); % gets current axis handle for given figure
    
    hidn_axis=axes('Position',[0 0 1 1], 'Visible','off','Units','normalized','Tag','Stampit');
    % Make a hidden axis the size of the entire figure window
    
    if flag>0
        fh(i,1) = text(0.13,0.01,st(length(st)).name); % st(length(st)).name identifies the "parent" m-file called (TAB 12/17/01)
        set(fh(i,1),'FontSize',[7]);
    end    
    if flag==0|flag==2
        dh(i,1) = text(.905,0.01,date);
        set(dh(i,1),'FontSize',[7],'HorizontalAlignment','Right');
    end
    
    set(h(i),'CurrentAxes',cur_ax); % Sets current axis back to its previous state
    
    chld = get(h(i),'Children');                              % These lines place the hidden "Stampit" axis
    if length(chld)>1                                         % to the bottom of the figure's Children handle list
        set(h(i),'Children',[chld(2:length(chld)); chld(1)])  % This alieveates problems with zoom and other functions
    end                                                       % after stampit has been called. (TAB 11/13/01)   
                                                          
end

set(0,'CurrentFigure',cur_fig);

pause(.001)
warning on
