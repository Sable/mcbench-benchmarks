function scottsclock
%SCOTTSCLOCK Displays an old school analog clock using timer and callacks


% Initiliaze the clock face
clockface = figure('name','Scotts Clock');          % Figure clockface named "scotts clock"
set(clockface,'NumberTitle','off');                 % 
set(clockface,'MenuBar','none');                    % Disable the menu bar
set(clockface,'color','w');                         % Set the backround color to white
set(clockface,'visible','on');                      % Set the clock to visible
set(clockface,'closerequestfcn',@closeRequestFcn);   % Specify closefunc at the bottom of the screen
set(clockface,'Resize','off');
set(clockface,'DoubleBuffer','on');
%set(clockface,'Renderer','OpenGL');
  

%PreAllocate arrays for faster startup
HourHandData = zeros(1,4);
MinuteHandData = zeros(1,4);
SecondHandData = zeros(1,4);
pDx = zeros(1,5);
pDy = zeros(1,5);

%Draw the perimeter of the clock and position the figure
R=linspace(0,2*pi,1000);
x1=9*cos(R);
y1=9*sin(R);
plot(x1,y1,'b','linewidth',8,'color','k') %Draws a thick black circle
hold on
axis off
axis([-10 10 -10 10]) %Draws the figure with +/-10 for [Xmin Xmin Ymin Ymax]
axis equal
%set(clockface,'position',[0.13 0.05 0.7 0.8]) %Position the figure [Left Bottom Width Height ] 

% Plot the numbers 1-12 on the screen
% --Declare variables to be used in the plotting the clock numbers
Clk_fSize = 26;                                  % controls the font size of the numbers of the clock
Clk_fTheta = (pi/3:-2*pi/12:-3*pi/2)';           % sets the Theta for each number position
Clk_fRad = 7;                                 % sets the Raduis for each number position
Clk_numbas = (1:1:12)';
Clk_nData = [Clk_fRad*cos(Clk_fTheta) Clk_fRad*sin(Clk_fTheta) Clk_numbas];
text(Clk_nData(:,1),Clk_nData(:,2),num2str(Clk_nData(:,3)),...
    'horizontalAlignment','center','verticalAlignment','middle','FontSize',Clk_fSize);

%== Tic Marks ==
% Define the Length of the Tic marks
TLenStart = 8.1;    % Start of the Tick mark (distance from origin)
TLenStop = 8.5;     % End of the Tick mark (distance from origin)
[STX,STY,TTX,TTY] = ticMark(TLenStart,TLenStop);
% Plot Skinny and Thick Tick marks on the clock face
plot(STX,STY, 'linewidth',1,'color','k');
plot(TTX,TTY, 'linewidth',5,'color','k');
%set initial Theta of h/m/s to current time
time = clock;
[HpDx,HpDy,MpDx,MpDy,SpDx,SpDy] = GetPolyData(time);
%Plot/Fill the 3 polygon hands for initial view
hourhand = fill(HpDx,HpDy,'k');
minhand = fill(MpDx,MpDy,'k');
sechand = fill(SpDx,SpDy,'r');
hold off
set(clockface,'HandleVisibility','off'); 
%== The Timer ==
datimer = timer('timerfcn',@local_timerFcn,'period',.1,'executionmode','fixedrate');
%start the timer
start(datimer)
%TO DO: figure out what is the error talking about too many inputs

%== The Timer Function ==
function local_timerFcn(varargin)
    
    time = clock;
    [HpDx,HpDy,MpDx,MpDy,SpDx,SpDy] = GetPolyData(time);
    set(hourhand,'xdata',HpDx,'ydata',HpDy);
    set(minhand,'xdata',MpDx,'ydata',MpDy);
    set(sechand,'xdata',SpDx,'ydata',SpDy);
    %drawnow
    
end%end of the timerFcn

function [HpDx,HpDy,MpDx,MpDy,SpDx,SpDy] = GetPolyData(time)
        %GetPolyData is given the time in a vector and returns
        % the points that make up the polygons relative to the
        % time(in a vector) given to it. This angle of each 
        % polygon is calculated by the Initial angle of each hand
        % then the dimensions are specified through the _HandData
        % shown below. Finally the function PolyEngine is
        % called where it will return the data points that make up
        % the polygon. This is done to allow the polygons to be 
        % updated later without having to redifine there 
        % specifications here in GetPolyData.  
        %Initial Angle of Each Hand
        hoursTheta = (((time(4)*30)+(time(5)/2))-90)*(-pi/180);
        minsTheta = (((time(5)*6)-90)+time(6)/10)*(-pi/180);
        secsTheta= ((time(6)*6)-90)*(-pi/180);
        %Data Set for each hand
        %HandData = 'Front Length' 'Back Length' 'Front Width' 'Back Width'
        HourHandData = [5 5/3 .1 .3];
        % X     Y data for this polygon
        [HpDx,HpDy] = PolyEngine(hoursTheta,HourHandData);
        MinuteHandData  = [7 7/3 .1 .3];
        [MpDx,MpDy] = PolyEngine(minsTheta,MinuteHandData);
        SecondHandData = [7 7/3 .05 .15];
        [SpDx,SpDy] = PolyEngine(secsTheta,SecondHandData);
end %end GetPolyData

function [STX,STY,TTX,TTY] = ticMark(TLenStart,TLenStop)
            %ticMark is given the distance from center to start the tick
            % marks (TLenStart) and the distance from origin to stop the
            % tick marks (TLenStop).
            %STTTheta 60 point array going clockwise skinny ticmarks
            STTheta = pi/2:-2*pi/60:-3*pi/2;
            %Calculates X Y coordinates for all 60 skinny tick marks
            STX = [TLenStart*cos(STTheta') TLenStop*cos(STTheta')]'; 
            STY = [TLenStart*sin(STTheta') TLenStop*sin(STTheta')]';
            %TTTheta 12 point array going around clockwise thick tic marks
            TTTheta = pi/2:-2*pi/12:-3*pi/2;
            %Calculates X Y coordinates for all 12 thick tic marks
            TTX = [TLenStart*cos(TTTheta') TLenStop*cos(TTTheta')]'; 
            TTY = [TLenStart*sin(TTTheta') TLenStop*sin(TTTheta')]';
end %end ticmark function
   
function [pDx,pDy] = PolyEngine(Theta,HanData)
        %PolyEngine is given the initial angle and specifications for each
        % polygon it is to generate. It then calculates the data points
        % that will makeup the polygon and passes it back in two variables
        % making up a set of X and Y coordinates that corelate to the
        % current angle. This makes it easy to plot the points as well as
        % easy to change the polygons shape. At this time it is specified
        % with 4 data points but a 5th could be added easily with only
        % changing the data in this PolyEngine function.
    
        %-Hand Polygon Equations
        %==================================================================
        %-Calculate the length from origin to points A and B.
        oA = sqrt(HanData(1)^2+HanData(3)^2);
        %-Calculate the length from origin to points C and D.
        oB = sqrt(HanData(2)^2+HanData(4)^2);
        %-Calculate X Y coordinates of points A B C and D.
        %-Prepare the X Y data points to be easily passed back and plotted.
        pDx = [oA*cos(Theta+atan(HanData(3)/HanData(1))), ...
              (HanData(1)+HanData(3)*5)*cos(Theta),...
              oA*cos(Theta-atan(HanData(3)/HanData(1))),...
              oB*cos(Theta+atan(HanData(4)/HanData(2))+pi),...
              oB*cos(Theta-atan(HanData(4)/HanData(2))+pi)];
        pDy = [oA*sin(Theta+atan(HanData(3)/HanData(1))) (HanData(1)+HanData(3)*5)*sin(Theta) oA*sin(Theta-atan(HanData(3)/HanData(1))) oB*sin(Theta+atan(HanData(4)/HanData(2))+pi) oB*sin(Theta-atan(HanData(4)/HanData(2))+pi)];
end%end PolyEngine function

function closeRequestFcn(varargin)
        %closeRequestFcn shuts down the timer and closes the figure when
        % the figure is closed. The try/catch has been added in case the
        % timer has never started it will just end without causing errors.
        try
        stop(datimer)
        delete(datimer)
        catch
        end
        closereq
end%end closerequestfcn

end%end of the mytestclock2 function








