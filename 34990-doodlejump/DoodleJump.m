function DoodleJump

%--------------------------------------------------------------------------
%DoodleJump
%Version 1.00
%Created by Stepen
%Created 2 February 2012
%Last modified 9 February 2012
%--------------------------------------------------------------------------
%Snake starts GUI game of iOS' Doodle Jump.
%--------------------------------------------------------------------------
%How to play DoodleJump:
%Player collects score by controlling doodle's movement by using a-d button
%or directional arrow button to reach higher altitude using given stepping
%pad while avoiding black holes.
%--------------------------------------------------------------------------

%CodeStart-----------------------------------------------------------------
%Reseting MATLAB environment
    close all
    clear all
%Declaring global variable
    global x_doodle y_doodle u_doodle v_doodle udot_doodle height
    global paddle
    doodlejump=25;
    doodleaccel=30;
    doodledecel=40;
    gravity=40;
    timestep=0.01;
    maxdoddlespeed=10;
    nopaddlelimit=5;
    paddlechance=0.75;
    paddlewidth=1;
    paddlecache=10;
    trapchance=0.01;
    trapradius=1;
    trapmindistance=50;
    trap=[0,-trapmindistance];
    fieldwidth=5;
    fieldheight=10;
    difficultymultiplier=1;
    difficultyupdateinterval=500;
    quitstat=0;
    playstat=0;
    decelstat=0;
    height=0;
%Generating GUI
    ScreenSize=get(0,'ScreenSize');
    mainwindow=figure('Name','DoodleJump',...
                      'NumberTitle','Off',...
                      'Menubar','none',...
                      'Resize','off',...
                      'Units','pixels',...
                      'Position',[0.5*(ScreenSize(3)-384),...
                                  0.5*(ScreenSize(4)-400),...
                                  384,400],...
                      'WindowKeyPressFcn',@pressfcn,...
                      'WindowKeyReleaseFcn',@releasefcn,...
                      'DeleteFcn',@closegamefcn);
    axes('Parent',mainwindow,...
         'Units','pixel',...
         'Position',[52,100,280,280]);
    heighttext=uicontrol('Parent',mainwindow,...
                         'Style','text',...
                         'String','0',...
                         'FontSize',12,...
                         'HorizontalAlignment','center',...
                         'Units','normalized',...
                         'Position',[0.4,0.15,0.2,0.05],...
                         'Callback',@startgamefcn);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','Start Game',...
              'Units','normalized',...
              'Position',[0.15,0.15,0.2,0.05],...
              'Callback',@startgamefcn);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','Close Game',...
              'Units','normalized',...
              'Position',[0.65,0.15,0.2,0.05],...
              'Callback',@closegamefcn);
    instructionbox=uicontrol('Parent',mainwindow,...
                             'Style','text',...
                             'String',['Click Start Game button to',...
                                       ' begin the game...'],...
                             'Units','normalized',...
                             'Position',[0.1,0.05,0.8,0.04]);
%Initiating graphics
    drawgame
%Listing CallbackFunction
    function pressfcn(~,event)
        switch event.Key
            case 'leftarrow'
                decelstat=0;
                if u_doodle>-maxdoddlespeed
                    udot_doodle=-doodleaccel;
                else
                    udot_doodle=0;
                end
            case 'rightarrow'
                decelstat=0;
                if u_doodle<maxdoddlespeed
                    udot_doodle=doodleaccel;
                else
                    udot_doodle=0;
                end
        end
    end
    function releasefcn(~,event)
        switch event.Key
            case 'leftarrow'
                decelstat=1;
            case 'rightarrow'
                decelstat=1;
        end
    end
    function startgamefcn(~,~)
        %Initiating doodle position and speed
        height=0;
        x_doodle=0;
        y_doodle=0;
        u_doodle=0;
        v_doodle=doodlejump;
        udot_doodle=0;
        difficultymultiplier=1;
        %Generating paddle and trap
        paddle=generatepaddle;
        trap=[(rand*(fieldwidth-trapradius))-...
              (0.5*(fieldwidth-trapradius)),...
              height+(2*trapmindistance*rand)];
        %Looping gameplay until game over
        set(instructionbox,'String','')
        playstat=1;
        while playstat
            %Decaying doodle's horizontal speed
            if decelstat
                if u_doodle>0
                    udot_doodle=-doodledecel;
                elseif u_doodle<0
                    udot_doodle=doodledecel;
                end
            end
            %Calculating doodle's position
            u_doodle=u_doodle+(udot_doodle*timestep);
            v_doodle=v_doodle-(gravity*timestep);
            x_doodle=x_doodle+(u_doodle*timestep);
            y_doodle=y_doodle+(v_doodle*timestep);
            %Anticipating screen cross
            if x_doodle<-0.5*fieldwidth
                x_doodle=x_doodle+fieldwidth;
            elseif x_doodle>0.5*fieldwidth
                x_doodle=x_doodle-fieldwidth;
            end
            %Sliding the view upwards
            if y_doodle>height+(0.5*fieldheight)
                height=y_doodle-(0.5*fieldheight);
                set(heighttext,'String',num2str(height))
            end
            %Determining if doodle steps on a paddle
            if (v_doodle<0)&&...
               (isdoodleatpaddle(x_doodle,y_doodle,v_doodle,paddle))
                v_doodle=doodlejump;
            end
            %Updating paddle (generating paddle at higher height)
            paddle=updatepaddle(paddle,height);
            %Updating trap (generating trap at higher height)
            trap=updatetrap(trap,height);
            %Updating game difficulty
            difficultymultiplier=exp(-height/difficultyupdateinterval);
            %Checking if doodle touches trap
            if norm([x_doodle-trap(1),y_doodle-trap(2)])<=trapradius
                playstat=0;
            end
            %Checking if doodle falls down to the bottom line
            if y_doodle<height-1
                playstat=0;
            end
            %Displaying animation
            drawgame
            %Delaying animation
            pause(timestep)
        end
        %Anticipating game termination
        if quitstat==1
            return
        end
        %Displaying game over scene
        set(instructionbox,...
            'String','Game over! Press Start Game to play again!')
    end
    function closegamefcn(~,~)
        %Stopping game loop
        quitstat=1;
        playstat=0;
        pause(1)
        %Closing main window
        delete(mainwindow)
    end
%Listing LocalFunction
    function paddle=generatepaddle()
        paddle=zeros(paddlecache,2);
        paddle(:,1)=1:paddlecache;
        for count=1:size(paddle,1)
            decision=rand;
            if decision<0.8
                paddle(count,2)=(rand*(fieldwidth-paddlewidth))-...
                                (0.5*(fieldwidth-paddlewidth));
            else
                paddle(count,2)=NaN;
            end
        end
    end
    function paddle=updatepaddle(paddle,height)
        %Randomly generating paddle at the next height
        if height+paddlecache>paddle(paddlecache)+1
            paddle(1:paddlecache-1,:)=paddle(2:paddlecache,:);
            paddle(paddlecache,1)=paddle(paddlecache-1,1)+1;
            decision=rand;
            if decision<(paddlechance*difficultymultiplier)
                paddle(paddlecache,2)=(rand*(fieldwidth-paddlewidth))-...
                                      (0.5*(fieldwidth-paddlewidth));
            else
                paddle(paddlecache,2)=NaN;
            end
        end
        %Forcing paddle generation after n height unit
        if sum(isnan(paddle(...
                     paddlecache-nopaddlelimit+1:paddlecache,2)))==...
           nopaddlelimit
            paddle(paddlecache,2)=(rand*(fieldwidth-paddlewidth))-...
                                  (0.5*(fieldwidth-paddlewidth));
        end
    end
    function trap=updatetrap(trap,height)
        if trap(2)<height-fieldheight
            decision=rand;
            if decision<trapchance
                trap=[(rand*(fieldwidth-trapradius))-...
                      (0.5*(fieldwidth-trapradius)),...
                      height+fieldheight+(0.5*trapmindistance*rand)];
            end
        end
    end
    function stat=isdoodleatpaddle(x_doodle,y_doodle,v_doodle,paddle)
        stat=false;
        %Finding the closest paddle from doodle
        y_=floor(y_doodle);
        %Determining if doodle will land on the paddle
        if y_doodle+(v_doodle*timestep)<=y_
            x_=paddle(paddle(:,1)==y_,2);
            if abs(x_doodle-x_)<0.5*paddlewidth
                stat=true;
            end
        end
    end
    function drawgame
        %Drawing doodle
        scatter(x_doodle,y_doodle,'r')
        %Drawing paddle
        for count=1:size(paddle,1)
            if ~isnan(paddle(count,2))
                line([paddle(count,2)-(0.5*paddlewidth),...
                      paddle(count,2)+(0.5*paddlewidth)],...
                     [paddle(count,1),paddle(count,1)])
            end
        end
        %Drawing trap
        rectangle('Position',[trap(1)-trapradius,trap(2)-trapradius,...
                              2*trapradius,2*trapradius],...
                  'Curvature',[1,1],...
                  'FaceColor','k')
        axis equal
        axis([-0.5*fieldwidth,0.5*fieldwidth,height,height+fieldheight])
    end
%CodeEnd-------------------------------------------------------------------

end