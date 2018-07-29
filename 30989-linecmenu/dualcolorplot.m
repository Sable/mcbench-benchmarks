function [] = dualcolorplot(x,y,F,OPT)
%DUALCOLORPLOT linear plot with dividing line.
% DUALCOLORPLOT(X,Y,F) plots vector Y versus vector X, and places a
% horizontal line on the plot at y-value F.  The line divides the plot into 
% red (top) and blue (bottom).  The user is able to click on the dividing
% line then drag it up and down to change the proportion of red to blue.
%
% DUALCOLORPLOT(X,Y,F,'interp') forces linear interpolation between top and
% bottom colors so that they meet at the horizontal line.  This is slightly 
% slower than the default for very large vectors.
%
% A context menu is provided for each of the lines in order to alter their
% appearance.  Simply right-click on any of the lines to see the
% options.  A context menu is also provided for the axes to turn on or off
% automatic scaling.  This can be useful if in zoom mode.
%
% NOTE:  
% Calling DUALCOLORPLOT will set the following properties of the current 
%         figure:  windowbuttondownfcn
%                  windowbuttonupfcn,
%                  windowbuttonmotionfcn
%
% and the uicontextmenu for the current axes.
%
% THIS FUNCTION REQUIRES LINECMENU BE ON THE PATH.
%
%
% EXAMPLES:  
%           x = -2*pi:.01:2*pi;
%           f = @(x) sin(x).*exp(x/5);
%           dualcolorplot(x,f(x),0)  % Right click on lines and axes!
%
%          
%           % Show the difference interpolation makes by exaggeration...
%           x = 0:.25:8*pi;  % A thinly populated plot
%           y = sin(x);
%           subplot(1,2,1)
%           dualcolorplot(x,y,0)
%           title('No Interpolation.')
%           subplot(1,2,2)
%           dualcolorplot(x,y,0,'interp')
%           title('With Interpolation')
%
% 
% See also plot 
%
% Author:  Matt Fig
% Data:  3/30/2011

NARG = nargin;

if NARG==3
    flg = 0;
elseif NARG == 4  
   if ~ischar(OPT) || ~strncmpi(OPT,'interp',6)
      error('Unknown Fourth option.  See help.') 
   end
   flg = 1;  % User wants to interpolate.
else 
    error('dualcolorplot requires 3 or 4 input arguments.  See help.')
end

fh = get(0,'currentfigure');

if isempty(fh)
    fh = figure('windowbuttondownfcn',{@fh_wndbtnfcn},...
                'windowbuttonupfcn',{@fh_wndbtnfcn},...
                'windowbuttonmotionfcn',{@fh_wndmtnfcn});
    AX = axes;
else
    set(fh,'windowbuttondownfcn',{@fh_wndbtnfcn},...
           'windowbuttonupfcn',{@fh_wndbtnfcn},...
           'windowbuttonmotionfcn',{@fh_wndmtnfcn});
    AX = get(fh,'currentaxes');
    
    if isempty(AX)
        AX = axes;
    end
end
        
L = [];  % This hold the handles to the lines.
V = 1:length(x);  % For indexing... avoid FIND.
mxx = max(x(:));  mnx = min(x(:));  % For the axis limits.
mxy = max(y(:));  mny = min(y(:));
D = (mxy-mny)/10;  % Resize buffer.
fbd = false;  % figure button up/down.
axzm =  true;  % On and off resize axes...  for zoom state.
LUICM = linecmenu;  % Call the LINECMENU function.
AUICM = uicontextmenu('userdata',axzm);
AUIM = uimenu(AUICM,'label','Set Resize OFF');
set(AUIM,'callback',{@ax_cntxtcb});  % Callback for uimenu.
set_colors();  % This is the function which does the work.

    function [] = set_colors(varargin)
    % Sets the appropriate colors, and divides x and y.
        idxlt = y<=F;  % Find the lower portion of the data.
        idxgt = V(~idxlt);
        idxlt = V(idxlt);
        y1 = y;  x1 = x;  % The lower portion of the plot.
        y2 = y;  x2 = x;  % The upper portion of the plot.
        y1(idxgt) = nan;  % NAN won't get plotted.
        y2(idxlt) = nan;
        
        if flg % User wants interpolated values.
            NN = isnan(y1);
            A = strfind(NN,[1 0]);  % Where interpolations will go.
            B = strfind(NN,[0 1]);
            y1(A) = F;
            y1(B+1) = F;  % At interpolation point, y is the horiz line.
            y2(B) = F;
            y2(A+1) = F;
            % Interpolations for the x variables.
            idx1 = (x(A+1)-x(A))./(y(A+1)-y(A)).*(F-y(A))+x(A); 
            idx2 = (x(B+1)-x(B))./(y(B+1)-y(B)).*(F-y(B))+x(B);
            x1(A) = idx1;
            x1(B+1) = idx2;
            x2(B) = idx2;
            x2(A+1) = idx1;
        end


        if isempty(L)  % First time through
            L(1) = line(x2,y2,'color','r');
            L(2) = line(x1,y1,'color','b');
            L(3) = line([mnx mxx],[F F],'color','g',...
                        'tag','HorizLine');
                    % Store data in Horz line userdata.
            set(L(3),'userdata',{L,flg,x,y,D,mnx,mxx,mny,mxy}) 
            set(AX,'uicontextmenu',AUICM);
            axis([mnx mxx min(mny,F)-D max(mxy,F)+D]) % Adjust axis
            set(L,'uicontextmenu',LUICM)
        else  % Called from callback.
            UD = get(varargin{1},'userdata');
            set(UD{1}(1),'xdata',x2,'ydata',y2);
            set(UD{1}(2),'xdata',x1,'ydata',y1);
            UD{3} = x;
            UD{4} = y;
            set(varargin{1},'userdata',UD)
        end
    end


    function [] = fh_wndbtnfcn(varargin)
    % Windowbutton-up/down-function for figure.
        fbd = ~fbd; % Button up or down?
    end


    function [] = fh_wndmtnfcn(varargin)
    % Windowbuttonmotionfcn for figure.
        CL = get(fh,'currentobject'); 
        CO = findobj(fh,'tag','HorizLine');  % The horizontal line(s).
        if ~isempty(CL) && any(CL==CO)  % Is current one of the horiz?
            UD = get(CL,'userdata') ; 
            flg = UD{2};  % Retrieve the flag for interpolation.

            if fbd  % Button is held down.      
                AXD = get(gca,{'currentpo','uicontextm'});% AXES DATA
                set(CL,'ydata',AXD{1}(:,2));
               
                if get(AXD{2},'userdata')
                    axis([UD{6} UD{7} min(UD{8},AXD{1}(1,2))-...
                         UD{5} max(UD{9},AXD{1}(1,2))+UD{5}])
                end
                
                F = AXD{1}(1,2);
                x = UD{3};
                y = UD{4};
                set_colors(CL);  % Call the drawing function.
            end

        end
    end


    function [] = ax_cntxtcb(varargin)
    % Callback for the contextmenus to the axes.
        P = get(varargin{1},'parent');
        axzm = ~get(P,'userdata');  % The on/off state is stored here.
        
        if axzm  % Change the label for the next call.
            set(AUIM,'label','Set Resize OFF')
        else
            set(AUIM,'label','Set Resize ON')
        end
        
        set(P,'userdata',axzm)  % Set the new value.
    end
end