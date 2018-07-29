% This code requires the installation of Arduino® Support Package:
% http://www.mathworks.com/matlabcentral/fileexchange/32374-matlab-support-package-for-arduino-aka-arduinoio-package

% The "blink_challenge" is described in the last part of the Ladyada Arduino 
% tutorial, http://www.ladyada.net/learn/arduino/ and it consists in designing 
% a circuit (and programming the board) so that the resulting device has 5 
% LEDs  and 4 modes (the user can switch among them using a button connected
% to digital input #2):
% 
% Mode 1: All LEDs Off
% Mode 2: All LEDs On
% Mode 3: LEDs blinking simultaneously with variable frequency regulated 
%         by a potentiometer
% Mode 4: LEDs blinking one after the other (wave like) with variable speed 
%         regulated by a potentiometer
% 
% Also note that if the variable delay is set (with the potentiometer) to
% high values, it might be necessary to keep the button pressed longer to
% change mode. 

% Tinkerkit Configuration
% 5 Leds connected to O0 to O4 
% Pushbutton connected to O5
% Linear Potentiometer connected to I0
% Please note this is the same configuration as the blink model with
% Tinkerkit

    %   Copyright 2011-2012 The MathWorks, Inc.

% create arduino object and connect to board
if exist('a','var') && isa(a,'arduino') && isvalid(a),
    % nothing to do    
else
    a=arduino('COM7');
end

% initialize pins
disp('Initializing Pins ...');

% sets digital input pins
a.pinMode(3, 'INPUT'); 

% sets digital and analog (pwm) output pins   
a.pinMode(5, 'OUTPUT'); % pwm available here
a.pinMode(6, 'OUTPUT'); % pwm available here
a.pinMode(9, 'OUTPUT'); % pwm available here
a.pinMode(10,'OUTPUT'); % pwm available here
a.pinMode(11,'OUTPUT'); % pwm available here
led = [5 6 9 10 11];

% button pin and analog pin
bPin=3;aPin=0;

% initialize state
state=0;
% get previous state
prev=a.digitalRead(bPin);

% start loop
disp('Starting main loop (it will last 60 secs)');
disp('push button to change state ...');

% loop for 1 minute
tic
while toc/60 < 1
    
    % read analog input
    ain=a.analogRead(aPin);
    v=100*ain/1024;
    
    % read current button value
    % note that button has to be kept pressed a few seconds to make sure
    % the program reaches this point and changes the current button value 
    curr=a.digitalRead(bPin);
    
    % button is being released, change state
    % delay corresponds to the "on" time of each led in state 3 (wave)
    if (curr==1 && prev==0)
        state=mod(state+1,4);
        disp(['state = ' num2str(state) ', delay = ' num2str(v/200)]);
    end
    
    % toggle state all on or off
    if (state<2)
        for i=1:5
            a.digitalWrite(led(i),state);
        end
    end
    
    % blink all leds with variable delay
    if (state==2)
        for j=0:1
            % analog output pins
            for i=1:5
                a.digitalWrite(led(i),j);
            end

            pause((15*v*(1-j)+4*v*j)/1000);
        end
    end
    
    % wave
    if (state==3)
        for i=1:5
            a.digitalWrite(led(i),0);
            if i == 5
                a.digitalWrite(led(1),1);
            else
                a.digitalWrite(led(i+1),1);
            end
            pause(v/200);
        end
    end
    
    % update state
    prev=curr;
    
end

% turn everything off
for i=1:5, a.digitalWrite(led(i),0); end
delete(instrfind({'Port'},{'COM7'}))