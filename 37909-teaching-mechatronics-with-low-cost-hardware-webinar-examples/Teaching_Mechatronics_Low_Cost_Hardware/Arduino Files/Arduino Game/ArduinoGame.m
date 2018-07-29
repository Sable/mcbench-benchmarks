function ArduinoGame
% Arkanoid like game implemented with Arduino® Board.
% Copyright 2012 The MathWorks, Inc.

% Arduino Init

% Create connection with Arduino
conn = arduino('COM7');

%Input

conn.pinMode(11,'output')

%GUI
fh = figure('Name','Arduino Game');
ah = axes('Units','normalized','Position',[0.1 0.3 0.8 0.6]);


uicontrol('Style','pushbutton','Units','normalized',...
    'Position',[0.1 0.1 0.2 0.1],'String','Start','Callback',@start_game)
uicontrol('Style','pushbutton','Units','normalized',...
    'Position',[0.7 0.1 0.2 0.1],'String','Close','Callback',@close_game)

% Initial Bar
central_point = 5;
width = 1;
c_bar = plot([central_point-width,central_point+width],[1,1],'linewidth',3);
axis([0 10 0 10])
set(ah,'xTick',[],'yTick',[])
hold on

%Initial Ball
persistent xpos ypos dir first_hit
if isempty(xpos)
    xpos = 5;
end
if isempty(ypos)
    ypos = 8;
end
if isempty(dir)
    alpha = -pi/6;
    dir = [cos(alpha) sin(alpha)];
end
if isempty(first_hit)
    first_hit = 0;
end

ball = plot(xpos,ypos,'o','MarkerSize',6,'MarkerFaceColor','k');


%Create Timer
period = 0.02;
t1 = timer('TimerFcn',@game, 'Period', period,'ExecutionMode', 'fixedRate');
status = 0;

    function game(~,~)
        %Read Potentiometer
        value = conn.analogRead(0);
        scaled_value = value/(902-8);
        if scaled_value > 1
            scaled_value = 1;
        elseif scaled_value <0
            scaled_value = 0;
        end
        central_point = scaled_value * (10-2*width) + width;
        set(c_bar,'xData',[central_point-width,central_point+width])
        
        
        %Move the ball
        
        %Set the speed
        v_input = 10*(conn.analogRead(1)-2)/1016; %Speed of the ball
        if v_input < 0
            v_input = 0;
        end
        v = v_input;
        
        [xpos,ypos] = compute_position(xpos,ypos,v,dir,period);

        
        set(ball,'xData',xpos,'yData',ypos)
        drawnow
        
        %Check to exit
        if status == 1
            return
        end
        
        %Bar bounce
        if ypos < 1
            first_hit = first_hit + 1; % Save the ball (test contact up to 5 times)
        end
        if ypos <=1 && dir(2) < 0 && (xpos >= central_point-width) && (xpos <= central_point+width) && first_hit <= 5
            dist = (xpos - central_point)/width;
            alpha = pi/2-dist*75*pi/180;
            dir = [cos(alpha) abs(sin(alpha))];
            first_hit = 0;
      
        end
        %Boundary bounce
        if xpos<= 0 || xpos >=10
            dir(1) = -dir(1);
        elseif ypos>=10
            dir(2) = -dir(2);
        end
        
        
        %Set ball light
        light = floor(ypos/10 * 255);
        if light > 255 %Saturation
            light = 255;
        elseif light < 0
            light = 0;
        end
        conn.analogWrite(11,light)
        
        %Lose game
        if ypos < 0
            warndlg('You Lose','Game end')
            close_game
        end
        
    end

    function start_game(~,~)
        start(t1)
    end

    function close_game(~,~)
        stop(t1)
        delete(instrfind({'Port'},{'COM7'}))
        delete(fh)
        clear functions
        status = 1; % Exit Flag
        
    end



end

function [new_posx,new_posy] = compute_position(xpos,ypos,v,dir,period)
% Compute new Ball Position
vx = v*dir(1);
vy = v*dir(2);
new_posx = xpos + vx*period;
new_posy = ypos + vy*period;
end

