function [x,y,button] = ginput_zoom(n, style)
%  GINPUT_ZOOM Graphical input from mouse with Zoom In/Out function.
%     [X,Y] = GINPUT_ZOOM(N, STYLE) gets N points from the current axes and returns 
%     the X- and Y-coordinates in length N vectors X and Y.  The cursor
%     can be positioned using a mouse (or by using the Arrow Keys on some 
%     systems).  Data points are entered by pressing a mouse button
%     or any key on the keyboard except carriage return, which terminates
%     the input before N points are entered. The style of cursor can be
%     change by setting STYLE (please reference to "Specifying the Figure
%     Pointer" in the help, default: 'fullcross').
%
%     User can click and drag to Zoom In / Out
%     - Left-Top to Right-Down means Zoom In
%     - Right-Down to left-Top means Zoom Out
%  
%     [X,Y] = GINPUT_ZOOM gathers an unlimited number (less then 100000) 
%     of points until the return key is pressed.
%   
%     [X,Y,BUTTON] = GINPUT_ZOOM(N) returns a third result, BUTTON, that 
%     contains a vector of integers specifying which mouse button was
%     used (1,2,3 from left) or ASCII numbers if a key on the keyboard
%     was used.
%
%     Chang Yi-Chung 20091002

ox = xlim;     % get original x limit
oy = ylim;     % get original y limit
xlim('auto');  % zoom out to x max
ylim('auto');  % zoom out to y max
xmax = xlim;   % get max x 
ymax = ylim;   % get max y
xlim(ox);      % restore x limit
ylim(oy);      % restore y limit

if exist('style') == 0
    style = 'fullcross';
end

set(gcf,'pointer', style);  % use fullcross, user can change this

if exist('n') == 0
    n = 100000;
end

for i = 1:n
    while 1
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);                
        if sum(point1 == point2) == 2        % same points
            if  k == 1                       % detects a key press
                x(i) = point1(1);
                y(i) = point1(2);
                button(i) = double(get(gcf,'CurrentCharacter'));   % get keyboad ascii number
                if n == 100000 & button(i) == 13                   % n is not assigned and press Enter(13) -> exit
                    i = n;          
                    % compatible with ginput
                    x = x(1:end-1);
                    y = y(1:end-1);
                    button = button(1:end-1);
                end                
            else                             % detects a mouse button press
                x(i) = point1(1);
                y(i) = point1(2);
                switch get(gcf,'SelectionType')
                    case 'normal'            % left button
                        button(i) = 1;
                    case 'extend'            % middle button
                        button(i) = 2;
                    case 'alt'               % right button
                        button(i) = 3;
                end
            end
            break;
        end
        offset = (point2-point1);           
        if offset(1) > 0 & offset(2) < 0     % drag left-top to right-down -> zoom in
            xlim([point1(1) point2(1)]);
            ylim([point2(2) point1(2)]);
        end         
        if offset(1) < 0 & offset(2) > 0     % drag right-down to left-top -> zoom out
            xlim(xmax);
            ylim(ymax);
        end
    end
    if i == n        
        break;
    end
end

% compatible with ginput
x = x';
y = y';
button = button';
