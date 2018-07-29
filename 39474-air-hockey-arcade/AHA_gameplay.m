%%%%%%%%%%Programmed by: Chi-Hang Kwan%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Completion Date: December 13, 2012%%%%%%%%%%%%%%%%%%%
function AHA_gameplay(window,score)
tb = get(window,'UserData');

%setting the scores and get AI difficulty level
user = 0;
comp = 0;
timedelay = 0;
difficulty = get(tb.disp.ai,'userdata');

%Defining the framerate[Hz] and deceleration rate[m/s^2]
decel = 1.1;
fps = 120;
tstep = 1/fps;

%Initialize the positions and velocity of objects
[pos,posu,posc]=initialize(window,0);
vel=[0 0];

counter=1;
tic
while (1)
    %get the position of the user's mallet   
    posu_new = get(tb.obj.maluser,'userdata');
    %get the position of the computer's mallet  
    if difficulty==0
        posc_new = AI(window,pos,vel,posc,tstep);
    else
        posc_new = AI_advanced(window,pos,vel,posc,tstep);
    end
    %update computer's position on screen
    set(tb.obj.malcomp,'XData', tb.geom.malletx + posc_new(1), 'YData', tb.geom.mallety + posc_new(2));
    velu = (posu_new - posu)/tstep;
    velc = (posc_new - posc)/tstep;
    
    %Update the puck position
    pos = pos + vel*tstep;
    set(tb.obj.puck,'XData', tb.geom.puckx + pos(1), 'YData', tb.geom.pucky + pos(2));
    
    %Check hitting the side rails
    if abs(pos(1))>=tb.fieldw/2-tb.r_puck
        pos(1)= sign(pos(1))*(tb.fieldw/2-tb.r_puck);
        set(tb.obj.puck,'XData', tb.geom.puckx + pos(1));
        vel(1)= -vel(1);
    end
    
    %Check when the puck approaches the top and side rails
    if abs(pos(2)) >= (tb.fieldh/2-tb.r_puck)
        if abs(pos(1))> tb.goalw/2 %for when the puck is not between the two goal posts
            pos(2)= sign(pos(2))*(tb.fieldh/2-tb.r_puck);
            set(tb.obj.puck,'YData',tb.geom.pucky + pos(2));
            vel(2)= -vel(2);
        else
            %Check to see if the puck hits the goal posts
            count=1;
            for x_post=-1:2:1
                for y_post=-1:2:1
                    e(count,:)= [x_post*tb.goalw/2 y_post*tb.fieldh/2];
                    d(count)= sqrt((e(count,1)-pos(1))^2+(e(count,2)-pos(2))^2);                                       
                    count=count+1;
                end
            end 
            [dmin,ind] = min(d);
            if dmin <= tb.r_puck
                vel = bounce(vel,[0 0],pos,e(ind,:));%calculate direction after bounce
            end
        end
    end

    %limit the speed to a certain value to make the gameplay more manageable
    speed = min(3.2, sqrt(vel(1)^2 + vel(2)^2)); 
    
    %Check if the puck hits the user's mallet
    dpu = posu_new-pos;
    dpum = sqrt(dpu(1)^2 + dpu(2)^2);    
    if dpum <=(tb.r_puck+tb.r_mallet)
        posu_new = pos + (tb.r_puck + tb.r_mallet+5e-3)/dpum*dpu;
        set(tb.obj.maluser,'Xdata',tb.geom.malletx+posu_new(1),'Ydata',tb.geom.mallety+posu_new(2)); %move the mallet position
        set(0,'pointerlocation', (posu_new-tb.disp.corner)./tb.disp.ratio + tb.disp.totaloffset); %move the cursor position         
        vel = bounce(vel,velu,pos,posu_new);%calculate direction after bounce
        speed = sqrt(vel(1)^2 + vel(2)^2);
    end
    
    %Check if the puck hits the computer's mallet
    dpc = posc_new-pos;
    dpcm = sqrt(dpc(1)^2 + dpc(2)^2);    
    if dpcm <=(tb.r_puck+tb.r_mallet)
        posc_new = pos + (tb.r_puck + tb.r_mallet+5e-3)/dpcm*dpc;
        set(tb.obj.malcomp,'Xdata',tb.geom.malletx+posc_new(1),'Ydata',tb.geom.mallety+posc_new(2)); %move the mallet position
        vel = bounce(vel,velc,pos,posc_new);%calculate direction after bounce
        speed = sqrt(vel(1)^2 + vel(2)^2);
    end
    
    %apply deceleration and copy the current position to the "old" positions 
    theta = atan2(vel(2),vel(1));
    speed = speed-min(speed,decel*tstep);
    vel = speed*[cos(theta) sin(theta)];
    posu = posu_new;
    posc = posc_new;
    
    %check to see if one has scored a goal
    if pos(2)> tb.fieldh/2 + tb.r_puck
        user = user + 1;
        set(tb.disp.end,'enable','off');
        t1=toc;
        set(tb.disp.user,'string',num2str(user));
        goal(window); %do scoring animation
        if user==score
            break;
        end
        [pos,posu,posc] = initialize(window,1);
        vel=[0 0];
        t2= toc - t1;
        timedelay = timedelay + t2;
    elseif pos(2)< -tb.fieldh/2 - tb.r_puck
        comp = comp + 1;
        set(tb.disp.end,'enable','off');
        t1=toc;
        set(tb.disp.comp,'string',num2str(comp));
        goal(window); %do scoring animation
        if comp==score
            break;
        end
        [pos,posu,posc] = initialize(window,2);
        vel=[0 0];
        t2= toc - t1;
        timedelay = timedelay + t2;
    end 
    
    %update the game clock
    time = toc-timedelay;
    set(tb.disp.min,'string',num2str(floor(time/60)));
    set(tb.disp.sec,'string',num2str(floor(rem(time,60))));
    pause(counter*tstep-time); %to sync game time with physical time
    counter = counter+1;
    
    if get(tb.disp.end,'userdata')==1 %check if user wishes to end game
        break;
    end
end

%reset object positions
set(window,'WindowButtonMotionFcn','');
posu = [0 -tb.fieldh/2+tb.goalh];
posc = -posu;
pos = [0 0];
set(tb.obj.maluser,'Xdata',tb.geom.malletx + posu(1),'Ydata',tb.geom.mallety + posu(2));
set(tb.obj.malcomp,'Xdata',tb.geom.malletx + posc(1),'Ydata',tb.geom.mallety + posc(2));
set(tb.obj.puck,'Xdata',tb.geom.puckx + pos(1),'Ydata',tb.geom.pucky + pos(2));

%show final message and disable/enable buttons
if get(tb.disp.end,'userdata')==1
    message = sprintf('Game Over');
else
    if user > comp
        message = sprintf('Congratulations!\nYou won!');
    else
        message = sprintf('Better luck\nnext game.');
    end
end
set(tb.textbox,'string',message);
pause(1.5);
set(tb.textbox,'string','');
set(tb.disp.start,'enable','on');
set(tb.disp.end,'enable','off');
set(tb.disp.radio1,'enable','on');
set(tb.disp.radio2,'enable','on');
set(tb.disp.radio3,'enable','on');
set(tb.disp.radio4,'enable','on');
set(tb.disp.radio5,'enable','on');
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Function for calculating the bouncing of the puck%%%%%%%%%%%%
function Vp = bounce(Vp,Ve,p,e)

d=e-p;

Vnp = dot(Vp,d)/(d(1)^2+d(2)^2)*d;
Vne = dot(Ve,d)/(d(1)^2+d(2)^2)*d;

Vtp = Vp-Vnp;
Vnp=-Vnp+Vne;
Vp=Vnp+Vtp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%Function for creating the scoring animation%%%%%%%%%%%%%%%
function goal(window)

tb = get(window,'UserData');
set(window,'WindowButtonMotionFcn',''); %disable mallet movement
set(tb.textbox,'fontsize',40);
set(tb.textbox,'string','Goal!');

n=3;
for count=1:n
    pause(0.5);

    set(tb.obj.edge,'facecolor',[1 1 0.1]);
    set(tb.obj.centercircle,'color',[1 1 0.1]);
    set(tb.obj.centerline,'color',[1 1 0.1]);
    set(tb.obj.creaseb,'color',[1  1 0.1]);
    set(tb.obj.creaset,'color',[1  1 0.1]);

    if count==n
        pause(1.5);
    else
        pause(0.5);
    end

    set(tb.obj.edge,'facecolor',[1 0.55 0.15]);
    set(tb.obj.centercircle,'color',[1 0.55 0.15]);
    set(tb.obj.centerline,'color',[1 0.55 0.15]);
    set(tb.obj.creaseb,'color',[1 0.55 0.15]);
    set(tb.obj.creaset,'color',[1 0.55 0.15]);
end

set(tb.textbox,'string','');
set(tb.textbox,'fontsize',30);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$
%%%%%%%%Function to initialize puck and mallet positions%%%%%%%%%%%%%%%%%%
function [pos,posu,posc]=initialize(window,code)
tb = get(window,'UserData');

if code==0
    pos = [0 0];
elseif code==1
    range = tb.fieldw-2*tb.r_puck;
    pos = [range*rand-range/2 tb.fieldh/8];
else
    range = tb.fieldw-2*tb.r_puck;
    pos = [range*rand-range/2 -tb.fieldh/8];
end
posu = [0 -tb.fieldh/2+tb.goalh];
posc = -posu;

%Change the locations on screen
set(tb.obj.puck,'XData', tb.geom.puckx + pos(1), 'YData', tb.geom.pucky + pos(2));
set(tb.obj.maluser,'Xdata',tb.geom.malletx + posu(1),'Ydata',tb.geom.mallety + posu(2));
set(tb.obj.malcomp,'Xdata',tb.geom.malletx + posc(1),'Ydata',tb.geom.mallety + posc(2));

set(tb.obj.maluser,'userdata',posu);%saves the current location of the player's mallet
set(0,'pointerlocation', (posu-tb.disp.corner)./tb.disp.ratio + tb.disp.totaloffset); %move the cursor position         

%Starting animation
set(tb.textbox,'string','Get Ready');
pause(1);
set(tb.textbox,'string','');

%enable mouse control of user's mallet
set(window,'WindowButtonMotionFcn',{@callback_malletcontrol,window});
set(tb.disp.end,'enable','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%Function to control user's mallet%%%%%%%%%%%%%%%%%%
function callback_malletcontrol(src, event, window)

tb = get(window,'UserData');

%Get the current cursor position
mousepos = get(0,'pointerlocation');

%Calculate the position w.r.t the playing field
posuser = (mousepos-tb.disp.totaloffset)*tb.disp.ratio + tb.disp.corner;

%%%%%%%%Ensure the mallet stays within the user's own half%%%%%%%%%%%%%%%
if abs(posuser(1))>tb.fieldw/2-tb.r_mallet    
    posuser(1)= sign(posuser(1))*(tb.fieldw/2-tb.r_mallet);
end
if posuser(2) > -tb.r_mallet
    posuser(2)= -tb.r_mallet;
elseif posuser(2) < -tb.fieldh/2 + tb.r_mallet
    posuser(2) = -tb.fieldh/2 + tb.r_mallet;
end

%%%%%%%%Move the user's mallet to the cursor's position
set(tb.obj.maluser,'Xdata',tb.geom.malletx + posuser(1),'Ydata',tb.geom.mallety + posuser(2));
set(tb.obj.maluser,'UserData',posuser); %saves the current location of the player's mallet

