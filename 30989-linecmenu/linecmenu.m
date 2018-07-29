function [LCM] = linecmenu(varargin)
%LINECMENU Creates a uicontextmenu or submenu for a line object.
% U = LINECMENU; creates a uicontext menu for a line object.  U can then be
% put in the 'uicontextmenu' property of any (or several) line object(s). 
%
% LINECMENU(H) appends a line menu to uicontextmenu or submenu in handle H.
%
%  EXAMPLES:
%
%      % Create several line objects and set two of their uicontextmenus.
%      x = 0:.5:10;
%      L = plot(x,x.^2,x,x.^2.5,x,x.^3);
%      % Next call the LINECMENU at assignment to L's uicontextmenu.
%      set(L(2:3),'uicontextmenu',linecmenu); % Now right-click on a line.
%
%
%      % Create a uicontextmenu then append the LINECMENU to it.
%      x = 0:.5:10;  L = plot(x,x.^2,x,x.^2.5,x,x.^3);
%      R = uicontextmenu;  % Create a uicontextmenu for the line object.
%      t = uimenu(R,'label','Help');  % And some menus.
%      t(2) = uimenu(t(1),'label','Me');
%      s = uimenu(R,'label','2B');
%      s(2) = uimenu(s(1),'label','~2B'); 
%      linecmenu(R); % Here we want to append to uicontextmenu.
%      set(L(3),'uicontextmenu',R);  % Note that we use R.  Only one line.
%
%
%      % Create a uicontextmenu then append the LINECMENU to a submenu.
%      x = 0:.5:10;  L = plot(x,x.^2,x,x.^2.5,x,x.^3);
%      R = uicontextmenu;  % Create a uicontextmenu for the line object.
%      t = uimenu(R,'label','Help');  % And some menus.
%      t(2) = uimenu(t(1),'label','Me');
%      s = uimenu(R,'label','2B');
%      s(2) = uimenu(s(1),'label','~2B'); 
%      linecmenu(t(1)); % Here we want to append to uicontextmenu.
%      set(L(3),'uicontextmenu',R);  % Note that we use R.  Only one line.
%
%      % Use FINDOBJ to get the job done.
%      plot(1:10)
%      set(findobj(gca,'type','line'),'uicontextmenu',linecmenu)      
%
%
% The code should be easy enough to follow that it is extensible.  For
% example, one could add more sizes to the MarkerSize menu by following the
% pattern laid out in the code.  
%
% I put this function in a file on my path so that it is available 
% everywhere.
%
% See also uicontextmenu, uimenu, get, set
% 
% Date: 3/30/2011
% Author: Matt Fig

if nargin  % Check input argument.
    if ~ishandle(varargin{1}) 
        % User passed a non-handle...
        error('Input must be the handle to a uicontextmenu or menu.')
    end
    
    T = get(varargin{1},'type');  % Input is a handle. But correct kind?
    
    if ~strcmpi(T,'uicontextmenu') && ~strcmpi(T,'uimenu')
        % User passed a handle to some other object....
        error('Input must be the handle to a uicontextmenu or menu.')
    end
    
    LCM = varargin{1}; % User wants the linecmenu appended.
else
    LCM = uicontextmenu;  % User wants only the linecmenu returned.
end
% First the colors
LM{1}(1) = uimenu(LCM,'Label','Color'); % A main menu
LM{1}(2) = uimenu(LM{1}(1),'Label','blue');  % Submenus
LM{1}(3) = uimenu(LM{1}(1),'Label','green');
LM{1}(4) = uimenu(LM{1}(1),'Label','red');
LM{1}(5) = uimenu(LM{1}(1),'Label','cyan');
LM{1}(6) = uimenu(LM{1}(1),'Label','magenta');
LM{1}(7) = uimenu(LM{1}(1),'Label','yellow');
LM{1}(8) = uimenu(LM{1}(1),'Label','black');
LM{1}(9) = uimenu(LM{1}(1),'Label','More...');
% Next the Linestyle
LM{2}(1) = uimenu(LCM,'Label','LineStyle'); % A main menu
LM{2}(2) = uimenu(LM{2}(1),'Label','-  solid'); % Submenus
LM{2}(3) = uimenu(LM{2}(1),'Label',':  dotted');
LM{2}(4) = uimenu(LM{2}(1),'Label','-.  dashdot');
LM{2}(5) = uimenu(LM{2}(1),'Label','--  dashed');
LM{2}(6) = uimenu(LM{2}(1),'Label','none');
% Next the widths
LM{3}(1) = uimenu(LCM,'Label','LineWidth'); % A main menu
LM{3}(2) = uimenu(LM{3}(1),'Label','1'); % Submenus
LM{3}(3) = uimenu(LM{3}(1),'Label','2');
LM{3}(4) = uimenu(LM{3}(1),'Label','3');
LM{3}(5) = uimenu(LM{3}(1),'Label','4');
LM{3}(6) = uimenu(LM{3}(1),'Label','More');
% Next the Marker
LM{4}(1) = uimenu(LCM,'Label','Marker'); % A main menu
LM{4}(2) = uimenu(LM{4}(1),'Label','.  point'); % Submenus
LM{4}(3) = uimenu(LM{4}(1),'Label','o  circle');
LM{4}(4) = uimenu(LM{4}(1),'Label','x  x-mark');
LM{4}(5) = uimenu(LM{4}(1),'Label','+  plus');
LM{4}(6) = uimenu(LM{4}(1),'Label','*  star');
LM{4}(7) = uimenu(LM{4}(1),'Label','s  square');
LM{4}(8) = uimenu(LM{4}(1),'Label','d  diamond');
LM{4}(9) = uimenu(LM{4}(1),'Label','v  triangle (down)');
LM{4}(10) = uimenu(LM{4}(1),'Label','^  triangle (up)');
LM{4}(11) = uimenu(LM{4}(1),'Label','<  triangle (left)');
LM{4}(12) = uimenu(LM{4}(1),'Label','>  triangle (right)');
LM{4}(13) = uimenu(LM{4}(1),'Label','p  pentagram');
LM{4}(14) = uimenu(LM{4}(1),'Label','h  hexagram');
LM{4}(15) = uimenu(LM{4}(1),'Label','none');
% Next the MarkerSize
LM{5}(1) = uimenu(LCM,'Label','MarkerSize'); % A main menu
LM{5}(2) = uimenu(LM{5}(1),'Label','4'); % Submenus
LM{5}(3) = uimenu(LM{5}(1),'Label','5');
LM{5}(4) = uimenu(LM{5}(1),'Label','6');
LM{5}(5) = uimenu(LM{5}(1),'Label','8');
LM{5}(6) = uimenu(LM{5}(1),'Label','9');
LM{5}(7) = uimenu(LM{5}(1),'Label','10');
LM{5}(8) = uimenu(LM{5}(1),'Label','12');
LM{5}(9) = uimenu(LM{5}(1),'Label','More');
% Next the MarkerFaceColor
LM{6}(1) = uimenu(LCM,'Label','MarkerFaceColor '); % A main menu
LM{6}(2) = uimenu(LM{6}(1),'Label','blue'); % Submenus
LM{6}(3) = uimenu(LM{6}(1),'Label','green');
LM{6}(4) = uimenu(LM{6}(1),'Label','red');
LM{6}(5) = uimenu(LM{6}(1),'Label','cyan');
LM{6}(6) = uimenu(LM{6}(1),'Label','magenta');
LM{6}(7) = uimenu(LM{6}(1),'Label','yellow');
LM{6}(8) = uimenu(LM{6}(1),'Label','black');
LM{6}(9) = uimenu(LM{6}(1),'Label','More...');
% Next the MarkerEdgeColor
LM{7}(1) = uimenu(LCM,'Label','MarkerEdgeColor '); % A main menu
LM{7}(2) = uimenu(LM{7}(1),'Label','blue'); % Submenus
LM{7}(3) = uimenu(LM{7}(1),'Label','green');
LM{7}(4) = uimenu(LM{7}(1),'Label','red');
LM{7}(5) = uimenu(LM{7}(1),'Label','cyan');
LM{7}(6) = uimenu(LM{7}(1),'Label','magenta');
LM{7}(7) = uimenu(LM{7}(1),'Label','yellow');
LM{7}(8) = uimenu(LM{7}(1),'Label','black');
LM{7}(9) = uimenu(LM{7}(1),'Label','More...'); 
% Set the callbacks.  The use of 'end' allows for easy extension above.
set(LM{1}(2:end),'callback',{@ln_colorcb});% Color
set(LM{2}(2:end),'callback',{@ln_stylecb});% LineStyle
set(LM{3}(2:end),'callback',{@ln_widthcb});% LineWidth
set(LM{4}(2:end),'callback',{@ln_stylecb});% Marker same as LineStyle
set(LM{5}(2:end),'callback',{@ln_widthcb});% MarkerSize same as LineWidth
set(LM{6}(2:end),'callback',{@ln_colorcb});% MarkerFaceColor same as Color
set(LM{7}(2:end),'callback',{@ln_colorcb});% MarkerEdgeColor same as Color
% Below are the callback functions for the various menu items.

    function [] = ln_colorcb(varargin)
    % Callback for the line 'Color', 'MarkerEdge/FaceColor' properties.
    % General handling.
        H = varargin{1};
        PS = strtrim(get(get(H,'parent'),'label'));  % The parent's string.
        S = get(H,'label');  % The menu's string.
        if strcmp(S,'More...')  % The More... option.
            C = uisetcolor;
            if ~isempty(C)  % User cancelled if empty.
                set(get(gcbf,'CurrentObj'),PS,C)
            end
        else
            set(get(gcbf,'CurrentObj'),PS,S)
        end
    end


    function [] = ln_stylecb(varargin)
    % Callback for the line 'LineStyle' and 'Marker' properties.
    % This callback handles the case where we have a symbol as the input
    % argument for the property SET.
        H = varargin{1};
        PS = strtrim(get(get(H,'parent'),'label'));  % The parent's string.
        S = get(H,'Label');
        set(get(gcbf,'CurrentObj'),PS,S(1:2)) % Need only the first two!
    end


    function [] = ln_widthcb(varargin)
    % Callback for the line 'LineWidth' and 'MarkerSize' properties.
    % This callback handles numbers.  Note STR2DOUBLE use.
        H = varargin{1};
        PS = strtrim(get(get(H,'parent'),'label'));  % The parent's string.
        STR = get(H,'Label');
        
        if strcmp(STR,'More')
            prompt = ['Enter desired ' PS];  % Going with a dialogbox here.
            dlg_title = PS;
            num_lines = 1;
            
            if strcmp(PS,'LineWidth')
                def = {'6'};
            else
                def = {'14'};
            end

            STR = inputdlg(prompt,dlg_title,num_lines,def);
        end
        
        N = str2double(STR);  % convert to number.
        
        if ~isnan(N)  % N will be a NaN if user enters nonsense. 
            set(get(gcbf,'CurrentObj'),PS,N)
        end
    end
end