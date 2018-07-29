function play2(varargin)
% MATLAB Tetris
% To launch, simply type 'play2' in your command window.
% Alternatively, you can choose run from this editor window, or press 'F5'.
% 
% To start the game, place the cursor in the 'Start' edit box, and press Enter
% on your keyboard. Controls are as follows:
% 
% [Q/q]: Left
% [E/e]: Right
% [S/s]: Down
% [W/w]: Flip
% [P/p]: Pause/Unpause
% 
% Setting the Gravity option to 'On' will make all blocks falls downwards when
% a line if formed (regardless of the line's location). Thus after each line
% formed all the blocks will become next to each other (i.e. no blocks
% floating in mid air). This allows you to get big combos and big scores.
% 
% The controls can be edited in the code, as can most variables
% and aesthetic properties.
% 
% Code written on MATLAB 7.4 (will not work on earlier versions).
% 
% Husam Aldahiyat, Jordan, 2008.
%

%main figure layout. the figure is currently not visible.
hfig=figure('visible','off','Menubar','none','name','Tetris','Numbertitle','off',...
    'color',[.5 .2 .8],'units','normalized','resize','off','position',[.3 .05 .3 .9*.9]);

%The start edit box.
%In order to maintain the figure as always active (as opposed to
%going to the command window whenever a button is pressed), we make this edit box.
%As soon as you press enter, we go to its commanding function where the box becomes so
%small it is invisible to the human eye. Now when you type, the letters are written
%in the edit box and not in the command window, thus you can move the pieces via
%keyboard, and everything you type is in this edit box (but you can't see it).
h2=uicontrol('style','edit','string','Start','callback',@goon,'units','normalized',...
    'position',[.5 .05 .2 .05],'backgroundcolor',[.7 .8 .9]);

%the main axes that covers most of the figure window. our workground.
%change the x and y colours and use 'grid on' to view it in detail.
axes('Units','normalized','Position', [.05 .06 .9 .93],'Visible','on',...   	
'DrawMode','fast','NextPlot','replace','XLim',[1,5],'YLim',[1,15*.9]...
,'color',[.5 .2 .8],'xcolor',[.5 .2 .8],'ycolor',[.5 .2 .8]);

%dump text box for later use, will determine whether or not to continue the game
%(game over). when you lose the game, this text's string will change, signaling
%the end of creating additional pieces. it will always be invisibe.
h3=uicontrol('style','text','visible','off');

%the gravity radio buttons
hr=uibuttongroup('Units','normalized',...
'Position',[.1 .05 .25 .025],'SelectionChangeFcn',@grv);
hb1=uicontrol('Style','Radiobutton','String','On','Units','normalized',...
'Position',[0 0 .5 1],'Parent',hr,'backgroundcolor',[.7 .8 .9],'foregroundcolor',[0 0 0]);
hb2=uicontrol('Style','Radiobutton','String','Off','Units','normalized',...
'Position',[0.5 0 .5 1],'Parent',hr,'backgroundcolor',[.7 .8 .9],'foregroundcolor',[0 0 0]);
set(hr,'SelectedObject',hb1)

    function agvv=grv(varargin)     %function that checks which radio button is ticked.
        rbr=get(hr,'SelectedObject');
        switch rbr        
            case hb1            
                agvv='On';		
            case hb2				
                agvv='Off';
        end
    end

%initialization function. it clears the axes and draws the rightside texts
    function init(varargin)    
        cla
        text('position',[4.35 12.8],'string','NEXT','color','w');
        set(line([4.1,4.1,4.9,4.9],[7.3,9,9,7.3]+4),'Color',[0,0,0]);    
        set(line([4.1,4.9],[7.3,7.3]+4),'Color',[0,0,0]);    
        set(line([1,1,4,4],[2,13,13,2]),'Color',[0,0,0]);    
        set(line([1,4],[2,2]),'Color',[0,0,0]);   
        set(h2,'string','Start')    %the edit box retains its original string value          
        set(h3,'string','text')     %dummy text box is set to default value
        text('position',[4.1 10],'string','Complete Lines','color','w');
        text('position',[4.45 7.5],'string','Level','color','w');
        text('position',[4.4 2.5],'string','Combo','color','w');
        text('position',[4.45 5],'string','Score','color','w');
        text('position',[1.5 1.5],'string','Gravity','color','w');       
    end
init   
%more initialization
%these are the scoring values. they can be used in the nested functions and
%changed according to play
cls=text('position',[4.6 9.55],'string','0','color','w'); %completed lines
lvl=text('position',[4.6 7.05],'string',num2str(1),'color','w'); %level               
scr=text('position',[4.5 4.55],'string',num2str(0),'color','w'); %score
text('position',[4.6 1.95],'string',num2str(0),'color','w'); %combos
%menus
m1=uimenu('Label','Game');
m2=uimenu('Label','More');
uimenu(m1,'Label','Reset','Callback',@goon2);
mmm=uimenu(m1,'Label','Turn Off Sound','Callback',@goon4);
uimenu(m1,'Label','High Score','Callback',@goonh);
uimenu(m2,'Label','Controls','Callback',@goon5);
uimenu(m2,'Label','About','Callback',@goon3);

%after everything is set in place, make the figure appear.
set(hfig,'Visible','on');  

    function goon4(varargin)       %sound menu function, switches 'on'/'off' string,
        switch(get(mmm,'label'))   %for user interface and future reference.
            case 'Turn Off Sound'
                set(mmm,'label','Turn On Sound')
            case 'Turn On Sound'
                set(mmm,'label','Turn Off Sound')            
        end
    end

    function goon3(varargin)    %cheap plug function. just a new figure and some texts.
        gg11=figure('Menubar','none','Numbertitle','off','name','About','units','normalized','resize','off','position',[.3 .7 .25 .15]);
        text('position',[.002 .9],'string','MATLAB Tetris by Husam Aldahiyat,') 
        text('position',[-.01 .65],'string','Mechatronics Eng. student, University of Jordan.')
        text('position',[.05 .4],'string','numandina@gmail.com')
        text('position',[.002 .15],'string','Written on Matlab 7.4 (R2007a).')
        %set same colour for everything so you would not see any axes lines or numbers
        set(gca,'color',get(gg11,'color'),'xcolor',get(gg11,'color'),'ycolor',get(gg11,'color'))        
    end

    function goon5(varargin) %more texts and a new figure
        gg2=figure('Menubar','none','Numbertitle','off','name','Controls','units','normalized','resize','off','position',[.2 .6 .45 .25]);                
        text('position',[-.1 .9],'string','                Use the Keyboard to move the pieces','fontname','courier')
        text('position',[-.1 .65],'string','[Q/q]: Left      [E/e]: Right      [S/s]: Down      [W/w]: Flip','fontname','courier')
        text('position',[-.1 .15],'string','You can easily alter these controls in the code itself.','fontname','courier')
        text('position',[-.1 .4],'string','[P/p]: Pause the Game','fontname','courier')
        set(gca,'color',get(gg2,'color'),'xcolor',get(gg2,'color'),'ycolor',get(gg2,'color'))
    end

    function goon2(varargin) %the reset function     
        init                            
        cls=text('position',[4.6 9.55],'string','0','color','w');                        
        scr=text('position',[4.5 4.55],'string',num2str(0),'color','w');
        lvl=text('position',[4.6 7.05],'string',num2str(1),'color','w');
        text('position',[4.6 1.95],'string',num2str(0),'color','w');                                
        set(h2,'position',[.5 .05 .2 .05]) %give the edit function its original size
        set(hr,'visible','on')             %make the radio buttons reappear
        set(hr,'SelectedObject',hb1)
    end

    function goonh(varargin) %the high score function                    
        gg2=figure('Menubar','none','Numbertitle','off','name','High Score','units','normalized','resize','off','position',[.2 .6 .45 .25]);                
        text('position',[-.1 .85],'string','High Score:','fontname','courier','fontweight','bold','fontsize',44)       
        if ~exist('hsc.mat','file') %if this is the first time and there is no high score file   
            highs=0; %set high score to 0
            save hsc highs %and save it as zero for future reference 
        end        
        load hsc highs %load the high score highs from the file hsc
        text('position',[-.1 .25],'string',num2str(highs),'fontname','courier','fontweight','bold','fontsize',44)        
        set(gca,'color',get(gg2,'color'),'xcolor',get(gg2,'color'),'ycolor',get(gg2,'color'))
    end

    function goon(varargin)           %main function. starts the game.
        set(hr,'visible','off')       %sets radio buttons invisible.
        
        
        %this is our workground but in matrix form, consisting of ones and zeros.
        %the figure box in which the pieces are moving in spans x=1:4 and y=2:13.
        %given length ratios, each single square block will take 0.25 horizontally
        %and 0.5 vertically. this means that all in all, we have 21 by 12 possible
        %positions for each square block.
        %everything that changes in the matrix will see its equivalent change in the
        %figure window, and vice versa.
        map=zeros(21,12);             
              
        set(h2,'position',[.1 .1 .00000001 .0000001]) %make edit box too small to see
        j=0;                                          %counter to signal first time start
        xstopx=0;                     %mostly insignificant, used for next while loop
        text('position',[1.575 1.1],'string',grv,'color','w'); %gravity on/off text
              
        while ~xstopx                %main loop 1: continually creating new pieces to drop
            timm=.34/(str2double(get(lvl,'string'))); %time increment, depends on level reached
            
            %at the beginning of the loop, we check for any completed lines before
            %making a new piece
            [rn,yn]=chk(map);    %chk is the function that checks for complete lines
            %the yn variable returns 1 if a complete line exists, and 0 otherwise.
            %rn is the row number in which this happens. since the map matrix and the
            %figure window are mirrors to each other, a complete line in map equals
            %one in our figure window.
            
            if yn      %the proceeding occurs if indeed there is a complete line due
                       %to the previous piece landing.
                       %you can return here after reading the rest of the code first.
                pause(timm)    %extra pause so you could see the line before it disappears             
                
                for howz=1:6   %this loop makes the line flashes before disappearing  
                    %we flash by changing the line's colour from red to yellow and
                    %back, three times each.                    
                    switch mod(howz,2)    %alternates between 1 and 2, red and yellow
                        case 1                       
                            cr=[1 0 0];   %[r g b], [1 0 0] means red
                        case 0                       
                            cr='y';
                    end
                    %we color each of the 12 blocks in the row with the variable 'cr'
                    for k1=1:12                  %12 blocks in a row
                        for k2=rn                %same row, the complete line
                            %the following command fills the 'k1'th block of the row
                            %with the 'cr' colour.                            
                            patch([(k1-1)/4+1,(k1-1)/4+1,(k1-1)/4+1+.25,(k1-1)/4+1+.25],[(21-k2)/2+2,(21-k2)/2+2+.5,(21-k2)/2+2+.5,(21-k2)/2+2],cr)                          
                        end
                    end
                    pause(timm/2) %after twelve 'colouring in' operations, the whole line
                    %is coloured, so we pause for a while and display before using the next colour.
                end %end of flashing
                
                sound2(4) %make a disappearing line sound.
                
                %next comes updating of score values after the completion of a line
                %if this is not the very first line completed (i.e. cls~=0)
                if (str2double(get(cls,'string'))) 
                    prevlvl=newlvlno; %get previous value of level
                end
                newv=(num2str(str2double(get(cls,'string'))+1)); %add 1 to number of lines
                newlvlno=floor(str2double(newv)/10)+1; %update and get new value of level
                %if new level is different than old level, this means you've reached
                %a new level.
                if (str2double(get(cls,'string'))) && prevlvl~=newlvlno                         
                    musicc(2) %cue celebration music.      
                end
                %new score value, depends on previous score, level and combo.
                nrz=num2str(str2double(get(scr,'string'))+50*(floor((str2double(newv)-1)/10)+1)+3^(combo+1)*(combo));
                init %clear axes and update scores
                text('position',[1.575 1.1],'string',grv,'color','w');             
                lvl=text('position',[4.6 7.05],'string',num2str(newlvlno),'color','w');
                scr=text('position',[4.5 4.55],'string',(nrz),'color','w');                                                       
                cls=text('position',[4.6 9.55],'string',newv,'color','w');                
                h=drawshape1(chz(2),hic(2)); %draws the shape in the 'NEXT' box, depending
                %on chz and hic, introduced later.
                map(2:rn,1:12)=map(1:rn-1,1:12); %line disappears higher blocks take its place
                
                %since the axes got cleared, we need to redraw every block, based on
                %the variable map, where every 1 means there's a block in the
                %equivalent axes window.
                for k1=1:12
                    for k2=1:21
                        if map(k2,k1)
                            patch([(k1-1)/4+1,(k1-1)/4+1,(k1-1)/4+1+.25,(k1-1)/4+1+.25],[(21-k2)/2+2,(21-k2)/2+2+.5,(21-k2)/2+2+.5,(21-k2)/2+2],[1 1 1])
                        end
                    end
                end
                combo=combo+1;
                text('position',[4.6 1.95],'string',num2str(combo),'color','w');

                if strcmp(grv,'On') %if gravity is turned on, we still have some work to do
                    mapb=map;  %get map
                    map=hrav(map); %get new map, adjusted after gravity effect
                    
                    %if map before and after is the same, then gravity changed
                    %nothing, and we continue out of the loop (cha is almost 0).
                    cha=sum(sum(abs(map-mapb))); 
                    if cha>1 %else if gravity changed the map                        
                        jov=text('position',[1.25,7.5],'String','Gravity','color','w','fontsize',40) ;       
                        pause(.25) %these three commands make the quick 'Gravity' flash appear
                        delete(jov)
                        init                  %clear axes and redraw new blocks
                        text('position',[1.575 1.1],'string',grv,'color','w');                       
                        lvl=text('position',[4.6 7.05],'string',num2str(newlvlno),'color','w');
                        scr=text('position',[4.55 4.55],'string',(nrz),'color','w');                                                        
                        cls=text('position',[4.6 9.55],'string',newv,'color','w');
                        text('position',[4.6 1.95],'string',num2str(combo),'color','w');                
                        h=drawshape1(chz(2),hic(2));
                        for k1=1:12
                            for k2=1:21
                                if map(k2,k1)
                                    patch([(k1-1)/4+1,(k1-1)/4+1,(k1-1)/4+1+.25,(k1-1)/4+1+.25],[(21-k2)/2+2,(21-k2)/2+2+.5,(21-k2)/2+2+.5,(21-k2)/2+2],[1 1 1])
                                end
                            end
                        end
                        sound2(4)   %make another line falling sound                                     
                    end
                else
                end
                %this returns us to the start of the loop again to check for
                %additional lines before creating any new pieces.
                continue
            end
            combo=0;
            for bnm=5:8                
                if map(2,bnm) %if the top of map isn't free, it means game over.
                    %this is checked before creating new pieces.
                    set(h3,'string','nomore') %this signals the game over status
                end
            end
            if strcmp(get(h3,'string'),'nomore') %if game is indeed over
                %make text and end game music
                text('color',[1 0 0],'string','GAME OVER','position',[1.1 8.5],'fontsize',40)
                pause(.0001)
                musicc(1)                %cue sad music                  
                if ~exist('hsc.mat','file') %if this is the first time and there is no high score file   
                    highs=0; %set high score to 0
                    save hsc highs %and save it as zero for future reference 
                end                
                load hsc highs %loads high score from file hsc                
                if str2double(get(scr,'string')) > highs %if current score is higher than the high score,                    
                    highs=str2double(get(scr,'string'));
                    save hsc highs %save current score as high score
                end
                return %get out of the function
            end
            j=j+1;   %this variable's sole purpose is to show whether it's the first time
                     %a piece is created or not (if j==1). after the very first loop 
                     %it will have completed its purpose.       
                     
            %if it's not the very of the game, delete the piece's previous place.
            %you see the way this works is: a piece is plotted using the drawing
            %function, and each of its 4 blocks are given a handle. in the next loop
            %we draw the same piece again but one block lower, and delete the previous
            %handles. thus it looks like the piece dropped down.
            %for the very first time there is nothing previous to delete, and then
            %if a piece reaches the ground or something below it, we get
            %out of the loop and make a new piece (and nothing gets deleted fot another
            %loop). this will be seen later in the code.
            if j~=1 
                for kkk=1:4
                    delete(h(kkk)) %delete the 4 blocks in NEXT box
                end
            end
            
            %this is how we randomly choose pieces and their starting orientations.
            %chz is the piece, from 1 to 7, and hic is the flip side, from 1 to 4.
            if j==1  %for the very first time, we randomly create two values each
                     %one for the current piece, and one for the one after it (NEXT)
                chz=[floor(rand*7)+1;floor(rand*7)+1];               
                hic=[floor(rand*4)+1;floor(rand*4)+1];    
            else %after that, the first value is the second one, and new second value is made
                chz(1)=chz(2);                
                chz(2)=floor(rand*7)+1;                    
                hic(1)=hic(2);                
                hic(2)=floor(rand*4)+1;
            end
            h=drawshape1(chz(2),hic(2)); %this function draws the second values in the NEXT box
            d=1; %this variable shows how far down a piece has fallen.
            r=0; %this variable shows how much right or left a piece a piece moved.
            
            while 1 %main loop 2: each piece falling down until it settles.
                if d==1 %if this is the piece's first occurrence, there is no previous
                    prev=666; %place, so 'prev' is set to signal this.
                end               
                
                if d~=1 %if this isn't the piece's first occurrence,
                    %first we see which keyboard key is pressed (if any)
                    %if you press q/Q (left)
                    
                    if strcmp(get(hfig,'currentcharacter'),'q') || strcmp(get(hfig,'currentcharacter'),'Q')                       
                        
                        %condr1 and condr2 are the two conditions that prevent a piece
                        %from going left. the variable prev contains the coordinates
                        %of the piece's previous position. row 1 shows the y coordinates,
                        %and row 2 the x coordinates. prev is obtained from drawshape2.
                        condr1=0; %initially, left movement is allowed unless proven otherwise.
                        if prev(2,ghj2(1))==1 %ghj2 is the minimum x coordinate index. if the minimum
                            condr1=1;         %x coordinate is 1 (i.e. adjoined to the leftmost wall), we cannot
                        end                   %move the piece to the left. prev(2,ghj2(1))== min(prev(2,:)).
                        condr2=0;             %second condition                                           
                        %in the next loop we check if there is a block to the left of every minimum x coordinate.
                        %(map(prev(1,ghj2(klk)),prev(2,ghj2(klk))-1)==map(y(x_klk),x_klk-1),
                        %where x_klk is the 'klk'th minimum x coordinate, and x_klk-1 means the block to its left.
                        %map(prev(1,ghj2(klk))+1,prev(2,ghj2(klk))-1))==map(y(x_klk)+1,x_klk-1)
                        %checks one block to its left and one block below.
                        for klk=1:numel(ghj2)                                               
                            if ~condr1 && (map(prev(1,ghj2(klk)),prev(2,ghj2(klk))-1) || map(prev(1,ghj2(klk))+1,prev(2,ghj2(klk))-1))
                                condr2=1; %once instance is sufficient for setting this condition on.
                            end
                        end
                        vvv=find(yyy==max(yyy));
                        vvi=min(xxx(vvv));                     
                        %another condition. try to figure it out.
                        if ~condr1 && (map(max(yyy),(vvi)-1) || map((max(yyy))+1,vvi-1))                        
                            condr2=1;
                        end
                        %the following are special cases.
                        switch chz(1)
                            case 3 %inverted L block
                                switch hic(1)
                                    case 4   %inverted L orientation
                                        if map(min(prev(1,:))+1,min(prev(2,:))) || map(min(prev(1,:)),min(prev(2,:)))
                                            condr2=1;
                                        end
                                end
                            case 4 %L block
                                switch hic(1)
                                    case 4 %inverted upside down L orientation
                                        if map(max(prev(1,:)),min(prev(2,:))) || map(max(prev(1,:))+1,min(prev(2,:)))
                                            condr2=1;
                                        end
                                end
                        end
                        %if all prevention condition are 0 and you press q/Q
                        if ~condr1 && ~condr2
                            %we set r to its new value so we would move the piece's
                            %four blocks one place to the left later
                            r=r-1; 
                            sound2(2) %and make a movement sound
                        else
                            sound2(6) %else, make error sound
                        end
                        
                    elseif strcmp(get(hfig,'currentcharacter'),'e') || strcmp(get(hfig,'currentcharacter'),'E')
                        %next are the conditions for moving right
                        condl1=0;
                        if max(xxx)==12 %if the piece is next to the rightmost wall
                            condl1=1;
                        end
                        condl2=0;
                        ghjk=find(xxx==max(xxx));                                     
                        for klk=1:numel(ghjk) %just like before
                            if ~condl1 && (map(prev(1,ghjk(klk)),prev(2,ghjk(klk))+1) || map(prev(1,ghjk(klk))+1,prev(2,ghjk(klk))+1))                        
                                condl2=1;
                            end
                        end
                        vvv=find(yyy==max(yyy));
                        vvi=max(xxx(vvv));                     
                        if ~condl1 && (map(max(yyy),(vvi)+1) || map((max(yyy))+1,vvi+1))                        
                            condl2=1;
                        end
                        switch chz(1) %special cases
                            case 3    %inverted L block
                                switch hic(1)
                                    case 2 %upside down L orientation
                                        if map(max(prev(1,:)),max(prev(2,:))) || map(max(prev(1,:))+1,max(prev(2,:)))
                                            condl2=1;
                                        end
                                end
                            case 4    %L block
                                switch hic(1)
                                    case 2 %L orientation
                                        if map(min(prev(1,:)),max(prev(2,:))) || map(min(prev(1,:))+1,max(prev(2,:)))
                                            condl2=1;
                                        end
                                end
                        end
                        if ~condl1 && ~condl2
                            r=r+1;
                            sound2(1)
                        else
                            sound2(6)
                        end
                    elseif strcmp(get(hfig,'currentcharacter'),'s') || strcmp(get(hfig,'currentcharacter'),'S')
                        %if you press s (down), the time increment become very small and the block appears to
                        %be going to the ground very fast. you can set this number to 0 to see the block
                        %immediately reach the ground. this happens because the display only updates after a pause.  
                        timm=1e-10;               
                    elseif strcmp(get(hfig,'currentcharacter'),'p') || strcmp(get(hfig,'currentcharacter'),'P')   
                        %if you try to pause, the code changes the current letter input and puts you in an infinite
                        %loop. the only to get out of the loop is by pressing p again.
                        set(hfig,'currentcharacter','l')                                                 
                        sound2(1)   %pause sound, same as moving right sound
                        %a text box appears while paused
                        hhj=uicontrol('style','text','units','normalized','position',[.2 .74 .4 .05],'string','Game Paused','backgroundcolor',[0 0 0],'foregroundcolor','w','fontsize',16);                     
                        while ~(strcmp(get(hfig,'currentcharacter'),'p') || strcmp(get(hfig,'currentcharacter'),'P'))                                                                                
                            pause(.2) %infinite loop until you press p
                        end
                        delete(hhj) %when out of the loop, delete the text box
                        sound2(1) %and make another pause sound
                    elseif strcmp(get(hfig,'currentcharacter'),'w') || strcmp(get(hfig,'currentcharacter'),'W')                                          
                        %pressing w/W will make the piece 'flip'. unlike moving left/right, the conditions                        
                        %for allowing a piece to flip will only be checked after pressing the key.
                        pass=1;      %initially, you can flip unless proven otherwise               
                        %next, we take each individual case and test the allowability to flip it one time
                        switch chz(1)                        
                            case 1           %4 block line                                                
                                switch hic(1)                                
                                    case {1,3} %horizontal
                                        if yyy(1)>18 
                                            pass=0;  %if it's near the ground, you can't flip it
                                        end
                                        if pass &&(map(yyy(1)-1,max(xxx)-1) || map(yyy(1)+3,max(xxx)-1) || map(yyy(1)+1,max(xxx)-1) || map(yyy(1)+2,max(xxx)-1))
                                            pass=0; %if there are blocks below or above it, don't flip
                                        end
                                    case {2,4} %vertical
                                        if xxx(1)==12 || xxx(1)<3
                                            pass=0; %if it's stuck to the right wall, or near the left wall
                                        end
                                        if pass &&(map(max(yyy)-1,xxx(1)-2) || map(max(yyy)-1,xxx(1)-1) || map(max(yyy)-1,xxx(1)+1))
                                            pass=0; %if there are blocks to its left or right
                                        end
                                end
                                %case 2 is the square piece, and it can't be flipped!
                            case 3 %and so on...
                                switch hic(1) 
                                    case 1
                                        if (max(yyy))>19
                                            pass=0;
                                        end
                                        if pass && (map(min(yyy),min(xxx)+1) || (map(min(yyy),min(xxx)+2)) || (map(min(yyy)+2,min(xxx)+1)) || (map(min(yyy)+3,min(xxx)+1)) || (map(min(yyy),min(xxx)+2)))
                                            pass=0;
                                        end
                                    case 2
                                        if min(xxx)==1
                                            pass=0;
                                        end
                                        if pass && (map(min(yyy)+1,min(xxx)-1) || map(min(yyy)+2,min(xxx)-1) || map(min(yyy)+1,max(xxx)) || map(max(yyy),max(xxx)) || map(max(yyy)+1,max(xxx)))
                                            pass=0;
                                        end
                                    case 3
                                        if map(min(yyy)-1,min(xxx)+1) || map(min(yyy)+2,min(xxx)) || map(min(yyy)+2,min(xxx)+1)
                                            pass=0; 
                                        end
                                    case 4
                                        if max(xxx)==12
                                            pass=0; 
                                        end
                                        if pass && (map(min(yyy),min(xxx)) || map(min(yyy)+1,min(xxx)) || map(min(yyy)+1,max(xxx)+1) || map(max(yyy),max(xxx)+1))
                                            pass=0; 
                                        end
                                end
                            case 4                               
                                switch hic(1)                                    
                                    case 1                                                                 
                                        if max(yyy)>19                                            
                                            pass=0;                                    
                                        end
                                        if pass && (map(min(yyy),min(xxx)+1) || map(max(yyy)+1,max(xxx)) || map(max(yyy)+1,max(xxx)-1) || map(max(yyy)+2,max(xxx)) || map(max(yyy)+2,max(xxx)-1))
                                            pass=0;
                                        end
                                    case 2
                                        if min(xxx)==1
                                            pass=0;
                                        end
                                        if pass && (map(max(yyy)-1,max(xxx)) || map(min(yyy)+1,min(xxx)-1) || map(min(yyy)+2,min(xxx)-1) || map(min(yyy)+3,min(xxx)-1))
                                            pass=0;
                                        end
                                    case 3
                                        if map(min(yyy)-1,min(xxx)) || map(min(yyy)-1,min(xxx)+1) || map(min(yyy)+1,min(xxx)+1) || map(max(yyy)+1,min(xxx)+1)
                                            pass=0;
                                        end
                                    case 4
                                        if max(xxx)==12
                                            pass=0;
                                        end
                                        if pass && (map(min(yyy)+1,min(xxx)) || map(max(yyy),min(xxx)) || map(min(yyy)+1,max(xxx)+1) || map(min(yyy)+2,max(xxx)+1) || map(min(yyy),max(xxx)+1))
                                            pass=0;
                                        end
                                end
                            case 5
                                switch hic(1)
                                    case {1,3}
                                        if map(max(yyy)+1,min(xxx)+1) || map(min(yyy),max(xxx)) || map(min(yyy)-1,max(xxx))
                                            pass=0; 
                                        end
                                    case {2,4}
                                        if min(xxx)==1
                                            pass=0; 
                                        end
                                        if pass && (map(min(yyy)+1,min(xxx)-1) || map(max(yyy),min(xxx)-1) || map(max(yyy)+1,min(xxx)) || map(max(yyy)+1,max(xxx)) || map(max(yyy),max(xxx)))
                                            pass=0; 
                                        end
                                end
                            case 6
                                switch hic(1)
                                    case {1,3}                                                            
                                        if map(min(yyy)+2,min(xxx)+1) || map(min(yyy),min(xxx)) || map(min(yyy)-1,min(xxx))
                                            pass=0;
                                        end
                                    case {2,4}
                                        if max(xxx)==12
                                            pass=0;
                                        end
                                        if pass && (map(max(yyy),min(xxx)) || map(max(yyy)+1,min(xxx)) || map(max(yyy)+1,min(xxx)+1) || map(max(yyy),min(xxx)+2) || map(max(yyy)-1,min(xxx)+2) )
                                            pass=0;
                                        end
                                end
                            case 7
                                switch hic(1)
                                    case 1
                                        if max(yyy)>19
                                            pass=0;
                                        end
                                        if pass && (map(max(yyy)+1,max(xxx)-1) || map(max(yyy)+2,max(xxx)-1) || map(max(yyy)+1,max(xxx)))
                                            pass=0;
                                        end
                                    case 2
                                        if min(xxx)==1
                                            pass=0;
                                        end
                                        if pass && (map(min(yyy)+1,min(xxx)-1) || map(max(yyy),min(xxx)-1) || map(max(yyy)+1,min(xxx)) || map(max(yyy),min(xxx)+1))
                                            pass=0;
                                        end
                                    case 3
                                        if map(min(yyy)-1,min(xxx)+1) || map(max(yyy),min(xxx) || map(max(yyy)+1,min(xxx)+1))
                                            pass=0;
                                        end
                                    case 4
                                        if max(xxx)==12
                                            pass=0;
                                        end
                                        if pass && (map(min(yyy)+1,max(xxx)+1) || map(max(yyy),max(xxx)+1) || map(max(yyy),min(xxx)))
                                            pass=0; 
                                        end
                                end
                        end
                        if pass %finally, if the piece is allowed to flip
                            sound2(3)   %make flip sound
                            if hic(1)==4 %flip by changing hic(1) from 1-> 2-> 3-> 4-> 1-> 2...
                                hic(1)=1;
                            else
                                hic(1)=hic(1)+1;
                            end
                        else
                            sound2(6) %else make error sound
                        end
                    end
                    %after pressing any button we change the current active character to someting else
                    %otherwise the original character will be kept 'pressed' every time we get back to the loop
                    set(hfig,'currentcharacter','l') 
                end
                %after all is said and done, we draw the shape in the main box. the shape's position                
                %in the box depends on the shape, previous position, right/left changes and how
                %far it has fallen down. also in drawshape2 the map matrix gets updated with the new
                %values. map is the current matrix, map2 is the updated one.
                [hh,map2,prev]=drawshape2(chz(1),hic(1),r,d,map,prev);
%                 disp(map2) %this is just for fun
                kilo=map2-map; %kilo is the change of the map after the piece fell
                map=map2;
                if sum(abs(kilo(21,:))) %if there is a change in the final row, this                    
                    break %means the piece hit the ground, break and make another piece
                    %note that break gets out of the loop, so we won't see the piece
                    %blocks getting deleted, or the piece moving any more.
                end
                tt=0; %this is the condition to signal the piece should settle
                yyy=prev(1,:);
                xxx=prev(2,:);                
                ghj=find(yyy==max(yyy)); %this is the maximum y coordinate of the latest piece
                ghj2=find(xxx==min(xxx));
                %the following If statement(s) determine if there is a block below
                %any of the maximum y coordinate blocks of our piece
                if numel(ghj)==1
                    if map(prev(1,ghj)+1,prev(2,ghj));
                        break %if so, break
                    end
                else
                    for klop=1:numel(ghj)
                        if map(prev(1,ghj(klop))+1,prev(2,ghj(klop)))
                            tt=1; %or signal that the piece should settle
                        end
                    end
                end
                %for some pieces, if the sum of all the blocks contained in the rectangle formed by it exceeds 4, it should settle
                ggg=[min(yyy),max(yyy),min(xxx),max(xxx)];
                %for others, we take special cases. the following statements make sure a piece settles when it should,
                %through the care of special cases.
                hjp=1;
                if (chz(1)==3 && hic(1)==4) || (chz(1)==4 && hic(1)==2)           
                    hjp=0;                   
                end
                if ((chz(1)==3 && hic(1)==2) || chz(1)==4 && hic(1)==4)                    
                    if chz(1)==3
                        if map(yyy(4)+1,xxx(4))
                            tt=1;
                        end
                    else
                        if map(yyy(1)+1,xxx(1))
                            tt=1; 
                        end
                    end
                elseif hjp
                    if sum(sum(map(ggg(1):ggg(2),ggg(3):ggg(4))))~=4
                        tt=1;
                    end
                elseif chz(1)==3 && hic(1)==3
                    if map((max(yyy)),min(xxx)) || map(max(yyy),min(xxx)+1)
                        tt=1;
                    end
                elseif chz(1)==4 && hic(1)==3
                    if map((max(yyy)),max(xxx))
                        tt=1; 
                    end
                elseif chz(1)==3 && hic(1)==1
                    if map(max(yyy)+1,min(xxx)+1)
                        tt=1; 
                    end
                elseif chz(1)==4 && hic(1)==1
                    if map(max(yyy)+1,min(xxx)+1)
                       tt=1; 
                    end
                elseif chz(1)==4 && hic(1)==3
                    if map(max(yyy),min(xxx)+1)
                        tt=1; 
                    end                    
                elseif chz(1)==7 && hic(1)==4
                    if map(max(yyy),min(xxx))
                        tt=1;
                    end
                elseif chz(1)==6 && (hic(1)==2 || hic(1)==4)
                    if map(max(yyy),min(xxx))                        
                        tt=1; 
                    end
                elseif chz(1)==5 && (hic(1)==2 || hic(1)==4)
                    if map(max(yyy),max(xxx))                       
                        tt=1; 
                    end
                end
                if tt %finally, if a piece needs to settle, get out of the loop
                    break %note: we could put this break in the place of 'tt=1'
                end       %before.
                d=1+d; %if the piece shouldn't settle, then it will go down another block distance
                pause(timm) %pause so we would see the updated display after all the action                                                              
                
                for ll=1:4 %delete the four blocks of our piece in the main box window
                    delete(hh(ll))
                end
            end %end of main loop 2 (the piece has settled), make another
            sound2(5) %piece settling down sound
            scz=str2double(get(scr,'string'))+5*str2double(get(lvl,'string')); %score+5
            delete(scr) %deleted old score
            scr=text('position',[4.55 4.55],'string',scz,'color','w'); %put up new score
        end %end of main loop 1 (i.e. we're done)
        
        function sound2(a) %this function produces the different sounds, depending on 'a'
            if strcmp(get(mmm,'label'),'Turn On Sound')           
                return  %if we turned the sound off, we get out without producing anything
            end
            t=-4:.01:4; 
            switch a %else we make a sound based on 'a'
                case 1 %move right
                    %we use the MATLAB 'sound(y)' function to produce our sounds,
                    %where y is a vector consisting of numbers generally between -1
                    %and 1. the values of y should also generally be part of a
                    %periodic function, so I tested some different functions and
                    %obtained different sounds.
                    T0=1;
                    t=-4:.01:4;
                    w0=2*pi/T0;
                    s2=1/2;
                    for k=1:140        
                        s2=s2+2*(1-cos(20*k*w0*t-pi/2)+1*sin(20*k*w0*t-pi/2))*10/(1+k^2);
                    end
                    %you can plot(s2(1:50)) to see that it's the fourier series of a saw
                    %wave function, but with very low frequency (high pitch of the sound)
                    %the following is its 'sound'
                    sound(s2)                    
                case 2 %move left
                    T0=1;
                    t=-4:.01:4;
                    w0=2*pi/T0;
                    s2=1/2;
                    for k=1:140        
                        s2=s2+2*(1-cos(10*k*w0*t-pi/2)+1*sin(10*k*w0*t-pi/2))*10/(1+k^2);
                    end
                    %another periodic function with a cool sound
                    sound(s2)
                case 3 %flip piece
                    sound(10*sin(50*t)) %low frequency sine wave
                case 4 %complete line, gravity
                    sound(cos(50*t.^5)*10) %messed up function
                case 5 %settling down
                    sound(cos(50*t.^2)*10) %semi messed up function              
                case 6 %error
                    T0=1;
                    t=-4:.01:4;
                    w0=2*pi/T0;
                    s2=1/2;
                    for k=1:140        
                        s2=s2+2*(1-cos(1*k*w0*t-pi/2)+1*sin(1*k*w0*t-pi/2))*10/(1+k^2);
                    end
                    sound(s2) %plot and see
% 					equake(gcf,1,1,0)
            end
        end
    end

    function sound4(a)   %another sound function (used for the music)
        t=-4:.01:4;      
        %it makes a different sound based on the frequency you give it
        sound(cos(a*t)*10)
    end

    function h=drawshape1(a,b) %function that draws the pieces in the NEXT box
        %we draw the pieces using the patch function to draw four blocks for each piece.
        %using patch, you speciy  four points (tips of the square) in the x and
        %y coordinates, and patch fills the square meant by them. for example this command
        %patch([0 0 1 1],[0 1 1 0]) draws the square having a side 1 and starts
        %from the origin (the first argument is x, second is y).       
        xp=[0 0 .125 .125]; %this is how much the x argument increments when patching a square
        yp=[0 .25 .25 0]; %how much the y argument increments        
        xi=.125; %the x increment when moving to a square on the right (space between the starts of two squares)
        yi=.25; % space between the starts of two blocks on top of each other
        X=4.25; %starting position for x
        Y=12.2; %starting position for y
        %note: if you want to see how patch works more clearly, change the colours of the axes and use grid.
        switch a %a is the piece to be drawn, b is its orientation
            case 1 %4 block line
                switch b 
                    case {1,3} %horizontal
                        xshape=[0 xi xi*2 xi*3]; %this is how it looks like, 4 blocks next to each other
                        yshape=zeros(1,4);       %in the same y direction from the origin
                    case {2,4} %vertical
                        xshape=repmat(1.5*xi,1,4); %four blocks having the same x
                        yshape=[0 -yi -2*yi -3*yi]; %and consecutive y
                end
            case 2 %square
                xshape=repmat([xi 2*xi],1,2); %a square, like this: [xi xi 2*xi 2*xi]
                yshape=repmat([0 -yi],2,1);   %                     [0 -yi   0   -yi]
            case 3 %inverted L
                switch b 
                    case 1 %this shape: |__
                        xshape=[xi xi 2*xi 3*xi];
                        yshape=[0 -yi -yi -yi];
                    case 2 %upside down L, like this:.--
                        xshape=[xi xi xi 2*xi]; %    |
                        yshape=[-yi -2*yi 0 0]; %    |              
                    case 3 %case 1 turned 180 degrees
                        xshape=[xi xi*2 3*xi 3*xi];
                        yshape=[0 0 0 -yi];                  
                    case 4 %inverted L
                        xshape=[xi 2*xi 2*xi 2*xi];
                        yshape=[-2*yi -2*yi -yi 0];  
                end
            case 4 %L
                switch b
                    case 1
                        xshape=[xi xi*2 xi*3 xi*3];
                        yshape=[-yi -yi -yi 0];             
                    case 2
                        xshape=[xi*3 2*xi 2*xi 2*xi];
                        yshape=[-2*yi -2*yi -yi 0];             
                    case  3
                        xshape=[xi xi 2*xi 3*xi];
                        yshape=[-yi 0 0 0];             
                    case 4                        
                        xshape=[xi 2*xi 2*xi 2*xi];
                        yshape=[0 -yi 0 -2*yi]; 
                end
            case 5 %Z shape
                switch b
                    case {1,3}
                        xshape=[xi xi*2 xi*2 xi*3];
                        yshape=[0 0 -yi -yi];
                    case {2,4}
                        xshape=[xi*2 xi*2 xi*3 xi*3]-xi;
                        yshape=[-yi*2 -yi -yi 0];                            
                end
            case 6 %S shape
                switch b
                    case {1,3}                
                        xshape=fliplr([xi xi*2 xi*2 xi*3]);
                        yshape=[0 0 -yi -yi];
                    case {2,4}
                        xshape=fliplr([xi*2 xi*2 xi*3 xi*3])-xi;
                        yshape=([-yi*2 -yi -yi 0]);                  
                end
            case 7 %don't know the name of this one, but it's the 'fork' style shape
                switch b
                    case 1                
                        xshape=[xi xi*2 xi*2 xi*3];
                        yshape=[-yi -yi 0 -yi];
                    case 2
                        xshape=[xi xi xi xi*2];
                        yshape=[0 -yi -yi*2 -yi];
                    case 3
                        xshape=[xi xi*2 xi*2 xi*3];
                        yshape=[0 0 -yi 0];
                    case 4                        
                        xshape=[xi xi*2 xi*2 xi*2];
                        yshape=[-yi 0 -yi -yi*2];
                end
        end
        XX=zeros(1,4); %this is called prallocating. if you don't make these initialized
        YY=zeros(1,4); %matrices, the code runs somewhat slower, so make sure you reserve
        h=zeros(1,4);  %some memory beforehand using preallocation
        %after specifying the shape of our pieces, we specify the exact coordinates
        for j=1:4 %four block for each piece
            for i=1:4 %four values for each block
                XX(i)=X+xp(i)+xshape(j); %the x argument in the patch command. add starting position with
                                         %x increment and shape x increment.
                YY(i)=Y+yp(i)+yshape(j); %the y argument. since the pieces in NEXT never move, this is simpler
                                         %than the drawshape2 function
            end
            h(j)=patch(XX,YY,[1,1,1]); %patch each block with the colour white
        end
    end

    function musicc(a) %the music function
        if strcmp(get(mmm,'label'),'Turn On Sound') %if sound is turned off,
            return %come back from here empty handed
        end
        switch a
            case 1 %game over song        
                %the way I made this is as follows: the tab for this song on a bass guitar is
                %something like this: 3,3,3,3,6,5,5,3,3,2,3 on the A string.
                %so using the sound4 function and trying different frequencies, I got 'right'
                %sounds for 3 using sound4(10), and for 6 sound4(12). then, using ratios and more
                %experminenting, 5 becomes sound4(11.5) and 2 sound4(9.5). after the sounds were               
                %known, I used pause with different values to make the timing.
                sound4(10)
                pause(.5*.75)
                sound4(10)
                pause(.5*.5)
                sound4(10)
                pause(.5*.25)
                sound4(10)
                pause(.5*.75)
                sound4(12)
                pause(.5*.5) 
                sound4(11.5)
                pause(.5*.25)      
                sound4(11.5)               
                pause(.5*.5) 
                sound4(10)
                pause(.5*.25)
                sound4(10)
                pause(.5*.5) 
                sound4(9.5)
                pause(.5*.25)
                sound4(10)
            case 2 %end level song
                sound4(40) %just a nice mesh of sounds
                pause(.15)
                sound4(40)        
                pause(.15)
                sound4(40)        
                pause(.15)
                sound4(40)        
                pause(.15)
                sound4(40+9/2)  
        end
    end

    function [hh,map,prev]=drawshape2(a,b,r,d,map,dep) %the piece drawing function in the main box
        %if you haven't read the comments for drawshape1, I suggest you do now. drawshape2 is similar.
        xp=[0 0 .25 .25]; %the x increments are higher because the blocks are bigger.
        xi=.25;           %use grid and change axes colours to see this clearly.
        yi=.5;
        yp=[0 .5 .5 0];
        X=2;              %starting positions
        Y=12;
        switch a %same shape symbols as before
            case 1
                switch b
                    case {1,3}
                        xshape=[0 xi xi*2 xi*3];
                        yshape=zeros(1,4);
                    case {2,4}
                        xshape=repmat(2*xi,1,4); %notice here we couldn't use 1.5*xi, because that
                                                 %wouldn't be an integer multiple of the x increment
                        yshape=[0 -yi -2*yi yi];
                end
            case 2
                xshape=repmat([xi 2*xi],1,2);
                yshape=repmat([0 -yi],2,1);
            case 3
                switch b
                    case 1
                        xshape=[xi xi 2*xi 3*xi];
                        yshape=[0 -yi -yi -yi];
                    case 2
                        xshape=[xi xi xi 2*xi]+xi;
                        yshape=[-yi -2*yi 0 0];                
                    case 3
                        xshape=[xi xi*2 3*xi 3*xi];
                        yshape=[0 0 0 -yi]-yi;                  
                    case 4
                        xshape=[xi 2*xi 2*xi 2*xi];
                        yshape=[-2*yi -2*yi -yi 0];                 
                end               
            case 4       
                switch b
                    case 1
                        xshape=[xi xi*2 xi*3 xi*3];
                        yshape=[-yi -yi -yi 0];             
                    case 2
                        xshape=[xi*3 2*xi 2*xi 2*xi];
                        yshape=[-2*yi -2*yi -yi 0];             
                    case  3
                        xshape=[xi xi 2*xi 3*xi];
                        yshape=[-yi 0 0 0]-yi;             
                    case 4
                        xshape=[xi 2*xi 2*xi 2*xi];
                        yshape=[0 -yi 0 -2*yi]; 
                end
            case 5
                switch b
                    case {1,3}
                        xshape=[xi xi*2 xi*2 xi*3]-xi;
                        yshape=[0 0 -yi -yi]-yi;
                    case {2,4}
                        xshape=[xi*2 xi*2 xi*3 xi*3]-xi;
                        yshape=[-yi*2 -yi -yi 0];                            
                end
            case 6
                switch b
                    case {1,3}                
                        xshape=fliplr([xi xi*2 xi*2 xi*3]);
                        yshape=[0 0 -yi -yi]-yi;
                    case {2,4}
                        xshape=fliplr([xi*2 xi*2 xi*3 xi*3])-xi;
                        yshape=([-yi*2 -yi -yi 0]);                  
                end
            case 7
                switch b
                    case 1                
                        xshape=[xi xi*2 xi*2 xi*3];
                        yshape=[-yi -yi 0 -yi];
                    case 2
                        xshape=[xi xi xi xi*2]+xi;
                        yshape=[0 -yi -yi*2 -yi];
                    case 3
                        xshape=[xi xi*2 xi*2 xi*3];
                        yshape=[0 0 -yi 0]-yi;
                    case 4
                        xshape=[xi xi*2 xi*2 xi*2];
                        yshape=[-yi 0 -yi -yi*2];
                end
        end
        %due to the pieces being able to move, there are some new commands
        xshape=xshape+r*xi; %moves the x coordinates in multiples of the x increment (going right/left)
        yshape=yshape-d*yi; %moves the y coordinates in multiples of the y increment (going down)
        
        %next, some new commands are seen. these are to make the matrix and figure window equal
        for j=1:4 %this loop makes the map update by deleting the previously occupied 1 elements
            if dep~=666 %remember this? dep==666 means it's the first time and you need to skip this
                map(dep(1,(j)),dep(2,(j)))=0; %dep are the xy coordinates of the previous shape location
            end
        end
        %the drawing loop
        XX=zeros(1,4); %prelocating
        YY=zeros(1,4);
        hh=zeros(1,4);
        prev=zeros(2,4);
        for j=1:4 %four blocks
            for i=1:4 %four coordinates    
                XX(i)=X+xp(i)+xshape(j); %same as before
                YY(i)=Y+yp(i)+yshape(j);                
            end
            %the map puts a 1 in the location of every new block
            map(-round(yshape(j)/yi)+1,round(xshape(j)/xi)+5)=1;
            %we take the x and y coordinates of the newly shaped block and put them in prev
            prev(1,j)=-round(yshape(j)/yi)+1; %these become the variable dep the next time
            prev(2,j)=round(xshape(j)/xi)+5;  %we're here
            %and draw the block in the main figure window
            hh(j)=patch(XX,YY,[1,1,1]);            
        end
        %note: notice how we only see the 4 blocks together, and not individually drawn. this
        %is because display updates with the pause command, which appears after all the blocks
        %are drawn.
    end

    function [rn,yn]=chk(map) %checks for any completed line
        yn=0;       %initially, there are no completed lines
        for rn=21:-1:2        %scans all rows of the matrix
            if sum(map(rn,:))==12    %if any row adds to 12, it means it is full of ones
                yn=1;                
                break               
            end
        end
    end

    function map=hrav(map) %this function performs gravity
        for i=2:21 %all rows. you can change the numbers here for 'custom' gravity
            for j=1:12 %scan all columns
                if ~map(i,j) && map(i-1,j) %if there is a 0 with a 1 above it
                    map(2:i,j)=map(1:i-1,j); %make that entire column fall down
                end
            end
        end
    end
end



