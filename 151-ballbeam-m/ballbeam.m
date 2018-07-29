function ballbeam(action)

% BALLBEAM demonsrates Proportional-Derivative (PD) control as applied to a
% ball and beam demonstration experiment. Execute by calling with no
% arguments.
%
% P and PD controllers are implemented which manipulates the beam angle in
% response to the position of the ball on the beam. The setpoint is
% indicated by the red marker, and is adjusted using the slider at the
% bottom of the figure. The control gain, Kp, and the Derivative Time
% constant, Td, are adjusted by a sliders located in the right hand control
% panel.
%
% This demo has been tested on Matlab 5.3 and Matlab 6.0. Some of the user
% interface code was shamelessly ripped out of the standard Matlab demos.

% Jeffrey Kantor
% Version 1.0
% March 24, 2001
%
%
% Updated for Matlab 2010b and README.m
% January 20, 2011

    if nargin < 1
        action = 'initialize';
    end

    persistent ballradius beamlength beamwidth
    persistent xmin xmax umin umax g dt 
    persistent t x v u done
    persistent Kp Td N xsp xlast dterm Ad Bd
    persistent ballHndl xball yball 
    persistent beamHndl xbeam ybeam
    persistent markerHndl xmarker ymarker
    persistent setpointHndl
    persistent runHndl resetHndl stopHndl closeHndl infoHndl
    persistent gainHndl gaintxtHndl gainlblHndl
    persistent dervHndl dervtxtHndl dervlblHndl
    persistent manualHndl modeHndl mode
    persistent bbAxes plotAxes plotHndl legHndl tdata udata xdata xspdata

    switch lower(action)
    case {'initialize'}

        % Basic dimensions.

        ballradius = 1;
        beamlength = 20;
        beamwidth = 0.3;

        % System parameters

        xmin = 0;                   % Left limit
        xmax = beamlength;          % Right limit
        umin = -0.25;               % Minimum beam angle
        umax = 0.25;                % Maximum beam angle
        g = 0.05;                   % Gravitational Constant
        dt = 0.2;                   % Time Step

        % Set initial conditions for ball and beam position

        t = 0;                      % Initial time
        x = beamlength/2;           % Initial Ball position
        v = 0;                      % Initial Velocity
        u = 0;                      % Initial beam angle
        done = 0;                   % Done Flag

        % Setup controller with initial parameters

        mode = 1;                   % Flag, start in manual mode
                                    %   Mode == 1 => Manual
                                    %   Mode == 2 => Proportional
                                    %   Mode == 3 => PD
        Kp = 0.1;                   % Proportional Gain
        Td = 20;                    % Derivative time constant
        N = 10;                     % Maximum derivative gain
        xsp = x;                    % Initial setpoint
        xlast = x;                  % Last measured value
        dterm = 0;                  % Derivative term
        Ad = Td/(Td+N*dt);          % Derivative filter constant
        Bd = Kp*Td*N/(Td+N*dt);     % Derivative gain

        % Create figure

        figure( ...
            'Name','Ball & Beam Demo', ...
            'NumberTitle','off', ...
            'BackingStore','off');

        % Create axes to hold ball & beam animation

        bbAxes = axes(...
            'Units','normalized', ...
            'Position',[0.02 0.02 0.75 0.70],...
            'Visible','off',...
            'NextPlot','add');

        % Create plotting axes near the top of the window

        plotAxes = axes(...
            'Units','normalized',...
            'Position',[0.05 0.65 0.75 0.30],...
            'Visible','off');

        % Information for all buttons
        xPos=0.85;
        btnWid=0.12;
        btnHt=0.08;
        % Spacing between the button and the next command's label
        spacing=0.025;

        %====================================
        % CONSOLE frame container for buttons
        frmBorder=0.02;
        yPos=0.05-frmBorder;
        frmPos=[xPos-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
        uicontrol( ...
            'Style','frame', ...
            'Units','normalized', ...
            'Position',frmPos, ...
            'BackgroundColor',[0.5 0.5 0.7]);

        %====================================
        % RUN button
        btnNumber=1;
        yPos=0.90-(btnNumber-1)*(btnHt+spacing);

        runHndl=uicontrol( ...
          'Style','pushbutton', ...
          'Units','normalized', ...
          'Position',[xPos yPos-spacing btnWid btnHt], ...
          'String','Run', ...
          'Interruptible','on', ...
          'Callback','ballbeam(''run'');');

        %====================================
        % RESET button
        btnNumber=2;
        yPos=0.90-(btnNumber-1)*(btnHt+spacing);

        resetHndl=uicontrol( ...
          'Style','pushbutton', ...
          'Units','normalized', ...
          'Position',[xPos yPos-spacing btnWid btnHt], ...
          'String','Reset', ...
          'Interruptible','on', ...
          'Callback','ballbeam(''reset'');');

        %====================================
        % The STOP button
        btnNumber=3;
        yPos=0.90-(btnNumber-1)*(btnHt+spacing);

        stopHndl=uicontrol( ...
            'Style','pushbutton', ...
            'Units','normalized', ...
            'Position',[xPos yPos-spacing btnWid btnHt], ...
            'Enable','off', ...
            'String','Stop', ...
            'Callback','ballbeam(''stop'');');

        %====================================
        % The MODE popup button
        btnNumber=4;
        yPos=0.90-(btnNumber-1)*(btnHt+spacing);
        textStr='Mode';
        popupStr=['Manual';' P    ';' PD   '];

        % Generic button information
        btnPos1=[xPos yPos-spacing+btnHt/2 btnWid btnHt/2];
        btnPos2=[xPos yPos-spacing btnWid btnHt/2];
        uicontrol( ...
           'Style','text', ...
           'Units','normalized', ...
           'Position',btnPos1, ...
           'String',textStr, ...
           'BackgroundColor',[0.5 0.5 0.7]);
        modeHndl=uicontrol( ...
           'Style','popup', ...
           'Units','normalized', ...
           'Position',btnPos2, ...
           'String',popupStr,...
           'Value',mode,...
           'Callback','ballbeam(''mode'')');

        %====================================
        % The first slider -- Kp, proportional control gain
        btnNumber=5;
        yPos=0.90-(btnNumber-1)*(btnHt+spacing);

        gainHndl = uicontrol( ...
            'Style','slider', ...
            'Units','normalized', ...
            'Position',[xPos yPos-btnHt btnWid btnHt/2], ...
            'Min',0, ...
            'Max', 0.5, ...
            'Value', Kp, ...
            'Visible','off',...
            'Callback','ballbeam(''control'');');
        gainlblHndl = uicontrol( ...
            'Style','text', ...
            'String','Kp', ...
            'Units','normalized', ...
            'Visible','off',...
            'Position',[xPos yPos btnWid btnHt/2]);
        gaintxtHndl = uicontrol( ...
            'Style','text', ...
            'String',num2str(Kp), ...
            'Units','normalized', ...
            'Visible','off',...
            'Position',[xPos yPos-btnHt/2 btnWid btnHt/2]);
        if mode >= 2,
            set(gainlblHndl,'Visible','on');
            set(gaintxtHndl,'Visible','on');
        end

        %====================================
        % The second slider -- Td, the Derivative Time Constant
        btnNumber=6;
        yPos=0.90-(btnNumber-1)*(btnHt+spacing);

        dervHndl = uicontrol( ...
            'Style','slider', ...
            'Units','normalized', ...
            'Position',[xPos yPos-1.5*btnHt btnWid btnHt/2], ...
            'Min',0, ...
            'Max',50, ...
            'Value',Td,...
            'Visible','off',...
            'Callback','ballbeam(''control'')');
        dervlblHndl = uicontrol( ...
            'Style','text', ...
            'String','Td', ...
            'Units','normalized', ...
            'Visible','off',...
            'Position',[xPos yPos-btnHt/2 btnWid btnHt/2]);
        dervtxtHndl = uicontrol( ...
            'Style','text', ...
            'String',num2str(Td), ...
            'Units','normalized', ...
            'Visible','off',...
            'Position',[xPos yPos-btnHt btnWid btnHt/2]);
        if mode == 3,
            set(dervlblHndl,'Visible','on');
            set(dervtxtHndl,'Visible','on');
        end

       %====================================
       % The INFO button

        infoHndl=uicontrol( ...
            'Style','push', ...
            'Units','normalized', ...
            'Position',[xPos 0.16 btnWid btnHt], ...
            'String','Info', ...
            'Callback','ballbeam(''info'')');

        %====================================
        % The CLOSE button

        closeHndl=uicontrol( ...
            'Style','push', ...
            'Units','normalized', ...
            'Position',[xPos 0.05 btnWid btnHt], ...
            'String','Close', ...
            'Callback','close(gcf)');

        axes(bbAxes);

        % Create Ball, keep handle

        a = 2*pi*(0:.05:.95)';
        xball = ballradius*sin(a);
        yball = ballradius*(1+cos(a));
        ballHndl = patch(xball+x,yball,1);
        set(ballHndl,'EraseMode','xor');

        % Create Beam

        xbeam = beamlength*[0 1 1 0]';
        ybeam = beamwidth*[0 0 -1 -1]';
        beamHndl = patch(xbeam,ybeam,2);
        set(beamHndl,'EraseMode','xor');

        % Create Fulcrum

        xpivot = [0 1 -1]';
        ypivot = [0 -5 -5]' - beamwidth;
        patch(xpivot,ypivot,3);

        % Create Setpoint Marker
        xmarker = 3*beamwidth*[0 1 -1]';
        ymarker = 3*beamwidth*[0 -1 -1]'-beamwidth;
        markerHndl = patch(xmarker + xsp,ymarker,'r');

        % Draw

        axis equal
        axis([-2, beamlength+ballradius+1, -5, 5 + ballradius]);

        % Create setpoint slider

        setpointHndl = uicontrol(gcf, ...
            'Units','normalized',...
            'Position',[0.05 0.05 0.75 0.04],...
            'Style','slider', ...
            'Min',0, ...
            'Max', beamlength, ...
            'Value', beamlength/2,...
            'Callback','ballbeam(''setpoint'')');

        % Create manual control slider

        manualHndl = uicontrol(gcf, ...
            'Units','normalized',...
            'Position',[0.78 0.12 0.03 0.50],...
            'Style','slider',...
            'Min',umin,...
            'Max',umax,...
            'Visible','off',...
            'Value',0,...
            'Callback','ballbeam(''manual'')');
        if mode == 1,
            set(manualHndl,'Visible','on');
        end

        drawnow;

    case {'run'}
        done = 0;
        set([runHndl,resetHndl,closeHndl,infoHndl],'Enable','off');
        set(stopHndl,'Enable','on');
        set(plotAxes,'Visible','off');
        if ishandle(plotHndl)
            set(plotHndl,'Visible','off');
        end
        if ishandle(legHndl)
            set(legHndl,'Visible','off');
        end
        while (x > xmin) && (x < xmax) && (~done),

            % Update controller using current ball position
            % Last value of the control is in u
            % Current value of the state is in x

            if mode == 1,
                u = get(manualHndl,'Value');
            elseif mode == 2,
                pterm = Kp*(x-xsp);             % Position mode
                dp = Kp*(x-xlast);              % Velocity mode
                u = 0.02*pterm + 0.98*(u + dp);   % Blended
            elseif mode == 3
                pterm = Kp*(x-xsp);
                dterm = Ad*dterm + Bd*(x-xlast);
                u = pterm + dterm;
            end
            xlast = x;
            u = max(min(u,umax),umin);

            % Compute next ball position

            v = v - g*u*dt;
            x = x + v*dt;
            t = t + dt;

            % Store Data

            tdata = [tdata,t];
            udata = [udata,u];
            xdata = [xdata,x];
            xspdata = [xspdata,xsp];

            % Update Ball and Beam Animation

            set(beamHndl, ...
                'Xdata',cos(u)*xbeam - sin(u)*ybeam, ...
                'Ydata',sin(u)*xbeam + cos(u)*ybeam);
            set(ballHndl, ...
                'Xdata',cos(u)*(x + xball) - sin(u)*yball, ...
                'Ydata',sin(u)*(x + xball) + cos(u)*yball);
            set(markerHndl, ...
                'Xdata',cos(u)*(xsp + xmarker) - sin(u)*ymarker, ...
                'Ydata',sin(u)*(xsp + xmarker) + cos(u)*ymarker);
            drawnow;

        end
        
        if x < xmin
            x = xmin - 1 - ballradius;
            set(ballHndl,'Xdata',x + xball,'Ydata',yball-5);
        end
        if x > xmax
            x = xmax + ballradius;
            set(ballHndl,'Xdata',x + xball,'Ydata',yball-5);
        end
        
        % Save data to .mat file for subsequent analysis
        
        save ballbeam tdata udata xdata xspdata

        % Update Plot

        axes(plotAxes);
        plotHndl = plot(tdata,xdata,'b',tdata,xspdata,'r');
        axis([min(tdata),max(tdata),xmin,xmax]);
        xlabel('Time');
        ylabel('Beam Position');
        legHndl = legend(['Ball Position';...
                'Setpoint     '],0);
        set(plotAxes,'Visible','on');

        set([runHndl,resetHndl,closeHndl,infoHndl],'Enable','on');
        set(stopHndl,'Enable','off');
        axes(bbAxes);   

    case{'manual'}

        % Set the beam angle manually

        u = get(manualHndl,'Value');
        set(beamHndl, ...
            'Xdata',cos(u)*xbeam - sin(u)*ybeam, ...
            'Ydata',sin(u)*xbeam + cos(u)*ybeam);
        set(ballHndl, ...
            'Xdata',cos(u)*(x + xball) - sin(u)*yball, ...
            'Ydata',sin(u)*(x + xball) + cos(u)*yball);
        set(markerHndl, ...
            'Xdata',cos(u)*(xsp + xmarker) - sin(u)*ymarker, ...
            'Ydata',sin(u)*(xsp + xmarker) + cos(u)*ymarker);

    case('setpoint')

        % Get the setpoint from the setpoint slider, then
        % adjust the setpoint marker

        xsp = get(setpointHndl,'Value');
        set(markerHndl, ...
            'Xdata',cos(u)*(xsp + xmarker) - sin(u)*ymarker, ...
            'Ydata',sin(u)*(xsp + xmarker) + cos(u)*ymarker);

    case{'reset'}

        % Reset the ball to the middle of the beam, and level the
        % beam.

        x = beamlength/2;
        v = 0;
        u = 0;
        t = 0;
        xsp = x;
        xlast = x;
        dterm = 0;
        xdata = x;
        tdata = t;
        udata = u;
        xspdata = xsp;
        set(setpointHndl,'Value',beamlength/2);
        set(beamHndl,'Xdata',xbeam,'Ydata',ybeam);
        set(ballHndl,'Xdata',x + xball, 'Ydata',yball);
        set(markerHndl,'Xdata',xsp + xmarker,'Ydata',ymarker);

    case{'mode'}

        mode = get(modeHndl,'Value');

        if mode == 1,

            % Manual Mode
            set(manualHndl,'Visible','on');
            set(gainlblHndl,'Visible','off');
            set(gaintxtHndl,'Visible','off');
            set(gainHndl,'Visible','off');
            set(dervlblHndl,'Visible','off');
            set(dervtxtHndl,'Visible','off');
            set(dervHndl,'Visible','off');

            set(manualHndl,'Value',u);

        elseif mode == 2,

            % Proportional Mode
            set(manualHndl,'Visible','off');
            set(gainlblHndl,'Visible','on');
            set(gaintxtHndl,'Visible','on');
            set(gainHndl,'Visible','on');
            set(dervlblHndl,'Visible','off');
            set(dervtxtHndl,'Visible','off');
            set(dervHndl,'Visible','off');

        elseif mode == 3,

            % PD Mode
            set(manualHndl,'Visible','off');
            set(gainlblHndl,'Visible','on');
            set(gaintxtHndl,'Visible','on');
            set(gainHndl,'Visible','on');
            set(dervlblHndl,'Visible','on');
            set(dervtxtHndl,'Visible','on');
            set(dervHndl,'Visible','on');
            dterm = 0;

        end

    case{'control'}

        % Get the control parameters from the sliders, do them
        % both with the same call because I'm too lazy to write
        % separate cases.

        Kp = get(gainHndl,'Value');
        Td = get(dervHndl,'Value');
        set(gaintxtHndl,'String',num2str(Kp));
        set(dervtxtHndl,'String',num2str(Td));
        Ad = Td/(Td+N*dt);
        Bd = Kp*Td*N/(Td+N*dt);

    case{'info'}

        % Display help file

        helpwin(mfilename);

    case{'stop'}

        % Set stop flag. This is caught in run, and the 
        % button status's reset there on exit from the main
        % loop

        done = 1;

    otherwise

        % Should never get here

        disp('Unknown action');
    end

end