function h= testmotion
h = [];
h.plotData = @plotData;
h.setRotation = @setRotation;
h.setStepSize = @setStepSize;
h.onerot = @onerot;
h.ccrot = @ccrot;
h.cwrot = @cwrot;
h.readcell = @readcell;
% ---
rotationdirection = 1;
%1 for clockwise
%-1 for counter clockwise
%--
stepsize = 1; % in degrees

hMotor = makeMotor(stepsize,h);

    function onerot()
        hMotor.moveHand(rotationdirection);
    end
     
    function ccrot()
       rotationdirection = 1; 
    end

    function cwrot()
       rotationdirection = -1; 
    end

    function result = readcell(lednumber)
        result = hMotor.readcell(lednumber);
    end
end

function hMotor = makeMotor(setstepsize,hmotion)
hMotor = [];

stepsize = setstepsize;
hMotor.moveHand = @moveHand;
hMotor.plotData = @plotData;
hMotor.readcell = @readcell;
currentTheta = 0;
% Initiliaze the clock face
clockface = figure('name','Stepper Motor Simulator');% Figure clockface named "scotts clock"
set(clockface,'NumberTitle','off');                 %
set(clockface,'MenuBar','none');                    % Disable the menu bar
set(clockface,'color','w');                         % Set the backround color to white
set(clockface,'visible','on');                      % Set the clock to visible
set(clockface,'closerequestfcn',@closeRequestFcn);   % Specify closefunc at the bottom of the screen
set(clockface,'Resize','off');
set(clockface,'DoubleBuffer','on');
%set(clockface,'Renderer','OpenGL');
set(clockface,'UserData',hmotion);

%Draw the perimeter of the clock and position the figure
R=linspace(0,2*pi,1000);
x1=9*cos(R);
y1=9*sin(R);
plot(x1,y1,'b','linewidth',8,'color','k') %Draws a thick black circle
hold on
axis off
axis([-10 10 -10 10]) %Draws the figure with +/-10 for [Xmin Xmin Ymin Ymax]
axis equal
%== Tic Marks ==
% Define the Length of the Tic marks
TLenStart = 8.1;    % Start of the Tick mark (distance from origin)
TLenStop = 8.5;     % End of the Tick mark (distance from origin)
[STX,STY,TTX,TTY] = ticMark(TLenStart,TLenStop);
% Plot Skinny and Thick Tick marks on the clock face
plot(STX,STY, 'linewidth',1,'color','k');
%plot(TTX,TTY, 'linewidth',5,'color','k');
[HpDx,HpDy] = GetPolyData(0);

hourhand = fill(HpDx,HpDy,'k');

% Plot the numbers 1-12 on the screen
% --Declare variables to be used in the plotting the clock numbers
Clk_fSize = 12;                                  % controls the font size of the numbers of the clock
Clk_fTheta = (0:pi/4:((2*pi)-(pi/4)))';           % sets the Theta for each number position
Clk_fRad = 7;                                 % sets the Raduis for each number position
Clk_numbas = (0:45:315)';
Clk_nData = [Clk_fRad*cos(Clk_fTheta) Clk_fRad*sin(Clk_fTheta) Clk_numbas];
text(Clk_nData(:,1),Clk_nData(:,2),num2str(Clk_nData(:,3)),...
    'horizontalAlignment','center','verticalAlignment','middle','FontSize',Clk_fSize);

led1 = makeLED(5,0,0);
led2 = makeLED(0,-5,270);
led1.cursorPosition(0);
led2.cursorPosition(0);

hFace = makeFace(stepsize,hMotor,led1,led2);
firststep = hFace.getFirstStep();
currentstep = firststep;

    function result = readcell(cellnumber)
        result = 0;
        if cellnumber ==1
           result =  led1.getState();
        elseif cellnumber ==2
            result = led2.getState();
        end
        
    end

    function moveHand(direction)
        if direction>0
            currentstep = currentstep.getNext();
            currentstep.landedon();
        else
            currentstep = currentstep.getPrev();
            currentstep.landedon();
        end
    end

    function setRotation(rotdir)
        rotationdirection = rotdir;
    end

    function setStepSize(stepsizedeg)
        stepsize = stepsizedeg;
    end

    function onerot()
        plotData(currentTheta+stepsize*rotationdirection);
        currentTheta = currentTheta+stepsize*rotationdirection;
    end

    function plotData(angleOfArm)
        angleOfArm = angleOfArm*(pi/180);
[HpDx,HpDy] = GetPolyData(angleOfArm);
set(hourhand,'xdata',HpDx,'ydata',HpDy);
        
%         for idx = 1:.5:abs((angleOfArm*(180/pi))-stateTheta)
%             if currentTheta >=360
%                 currentTheta = 0;
%             elseif currentTheta<=0
%                 currentTheta = 360;
%             end
%             [HpDx,HpDy] = GetPolyData((pi/180)*(currentTheta+(rotationdirection*idx)));
%             set(hourhand,'xdata',HpDx,'ydata',HpDy);
%             led1.cursorPosition((currentTheta+(rotationdirection*idx)));
%             led2.cursorPosition((currentTheta+(rotationdirection*idx)));
%             pause(.01);
%         end
    end

    function [HpDx,HpDy] = GetPolyData(theta)

        HourHandData = [5 2/3 .2 .4];
        [HpDx,HpDy] = PolyEngine(theta,HourHandData);
    end

    function [STX,STY,TTX,TTY] = ticMark(TLenStart,TLenStop)
        %ticMark is given the distance from center to start the tick
        % marks (TLenStart) and the distance from origin to stop the
        % tick marks (TLenStop).
        %STTTheta 60 point array going clockwise skinny ticmarks
        STTheta = pi/2:-2*pi/180:-3*pi/2;
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
        closereq
    end%end closerequestfcn

end%end of motor


function hplace = makePlaceHolder(setposition,sethand)
hplace = [];
position = setposition;
hand = sethand;
hplace.setNext = @setNext;
hplace.getNext = @getNext;
hplace.setPrev = @setPrev;
hplace.getPrev = @getPrev;
hplace.addListener = @addListener;
hplace.landedon = @landedon;

theNextPlace = [];
thePrevPlace =[];
listeners = [];

    function landedon()
        
        hand.plotData(position);
        if ~isempty(listeners)
            listeners.turnOn()
        end
        pause(.1);
    end

    function addListener(listener)
        listeners = listener;
    end

    function setNext(nextplace)
        theNextPlace = nextplace;
    end

    function setPrev(prevplace)
        thePrevPlace = prevplace;
    end

    function result = getNext()
        
        result = theNextPlace;
        if ~isempty(listeners)
            listeners.turnOff()
        end
    end

    function result = getPrev()
       
        result = thePrevPlace;
        if ~isempty(listeners)
            listeners.turnOff()
        end
    end

end

function hface = makeFace(stepsize,hand,led1,led2)
hface = [];
hface.getFirstStep = @getFirstStep;

startstep = makePlaceHolder(0,hand);
endstep = makePlaceHolder((360-stepsize),hand);
startstep.setPrev(endstep);
startstep.addListener(led1);
endstep.setNext(startstep);
laststep = [];
beforebeforeendstep= [];
for step = (0+stepsize):stepsize:(360-(2*stepsize))
    newplace = makePlaceHolder(step,hand);
    if step==(0+stepsize)
        startstep.setPrev(endstep);
        startstep.setNext(newplace);
        newplace.setPrev(startstep);
    elseif step==(360-(2*stepsize))
        newplace.setNext(endstep);
        newplace.setPrev(laststep);
        endstep.setPrev(newplace);
        beforebeforeendstep.setNext(newplace);
    else
        laststep.setNext(newplace);
        newplace.setPrev(laststep);
    end
    
    if step==(360-(3*stepsize))
        beforebeforeendstep = newplace;
    end
    
    if step==270
       newplace.addListener(led2); 
    end
    laststep = newplace;
end

    function result = getFirstStep()
        result = startstep;
    end

end

function hled = makeLED(x,y,angleOfLED)
%sensors
plot(x,y,'*k') %270 degrees
plot(x*2,y*2,'O','color','black') %the circle around the light
led = plot(x*2,y*2,'*k','color',[.75 .75 .75]); %gray it out

hled = [];
hled.cursorPosition = @cursorPosition;
hled.led = led;
hled.turnOn = @turnOn;
hled.turnOff = @turnOff;
hled.getState = @getState;
fov = 4;

if (angleOfLED==0)
    angleofled = [360:-.01:(360-fov),0:.01:(0+fov)];
else
    angleofled = (angleOfLED-fov):(angleOfLED+fov);
end


    function cursorPosition(angleOfArm)
        if any(angleOfArm==angleofled)
            turnOn();
        else
            turnOff();
        end
    end

    function result = getState()
        result = [];
        currentcolor = get(hled.led,'Color');
        if sum(currentcolor)==1
           result = 5;
        else
            result = 0;
        end
    end

    function turnOn
        set(hled.led,'Color','r');
    end

    function turnOff
        set(hled.led,'Color',[.75 .75 .75]);
    end
end