function typetime(varargin)
%{
Typing Timer
A program that measures how many words a user can type in one minute.
To run, type 'typetime' in the command window. Alternatively, you can choose
'Run' from this editor window, of press 'F5'.

To start the test, press the 'Start' button in the GUI. A three second countdown
will commence, giving you time to move the cursor to the right edit box, afterwhich
a randomly chosen piece of text will appear on the text box to the left. Try to type
as many correct words as you can before the one minute runs out, and after time is
out, a number representing the number of correctly typed words will appear.

   Examples:
      Example 1:
           %Run the game
           typetime

Important Notes:

1) The program compares the two texts word by word, meaning if you accidentally type
two words without a space in between, it will treat that as one word and compare it
to the original first one of these two words. Thus, every word that comes after that
will compared to the word before it.

Example:
Text 1: I ate ten brown cookies                 Text 2: I ateten brown cookies

Comparisons: [I, I]: correct
             [ate, ateten]: incorrect
             [ten, brown]: incorrect
             [brown, cookies]: incorrect

So in the end, you only get one correct word, all because you didn't put the space.

2) Continuing from 1, a space, comma, period and dash ('-') all account as word seperators.

3) Spaces, commas, periods and dashes are counted as part of the word before them, not after.

4) Speaking of which, a word will be counted only if paired with its following space/comma/period/dash.

5) Do not, under any circumstances, hit the Backspace key. Just don't. Instead, press space and continue with the next word.

6) If you want to take another test after finishing a previous one, be sure to choose your time before you do so.

7) A new paragraph doesn't necessitate a space, but a new line does.

8) The code can be edited very easily. 
    a) To change the time, edit the variable 'seconds'.
    b) To add a new text, add it as a case in the 'chz' function, and increment the variable 'number'.

Code written on MATLAB 7.4.

Husam Aldahiyat, Jordan, 2008.
%}

hh=figure('visible','on','Menubar','none','name','Typing Timer','Numbertitle','off',...
    'units','normalized','resize','off','position',[.05 .05 .8 .9*.9],'color','w');
uicontrol('style','text','units','normalized','fontsize',12,...
    'position',[.73 .85 .13 .08],'string','Place Cursor Here','backgroundcolor',[.7 .8 .9],'max',2,'horizontalalignment','left');
h2=uicontrol('style','edit','units','normalized','fontsize',12,...
    'position',[.66 .05 .3 .85],'string','','backgroundcolor',[.7 .8 .9],'max',2,'horizontalalignment','left');
h3=uicontrol('style','text','units','normalized','fontsize',12,...
    'position',[.06 .05 .3 .85],'string','','backgroundcolor',[.7 .8 .9],'horizontalalignment','left');
hpp=uicontrol('style','pushbutton','string','Start Test','callback',@goon3,'units','normalized','fontsize',12,...
    'position',[.45 .6 .1 .07],'backgroundcolor',[1 1 1],'max',2,'horizontalalignment','left');
uicontrol('style','pushbutton','string','Change Time','callback',@goon9,'units','normalized','fontsize',12,...
    'position',[.45 .8 .1 .07],'backgroundcolor',[1 1 1],'max',2,'horizontalalignment','left');
h5=uicontrol('style','text','units','normalized','fontsize',12,...
    'position',[.45 .7 .1 .07],'string','1:00','foregroundcolor','r','backgroundcolor','w');
h6=uicontrol('style','text','callback',@goon,'units','normalized','fontsize',12,...
    'position',[.45 .5 .1 .07],'string','','foregroundcolor','r','backgroundcolor','w','fontweight','bold');
h7=uicontrol('style','text','units','normalized','fontsize',12,'visible','off',...
    'position',[.4 .4 .2 .07],'string','Number of correct words:','foregroundcolor','g','backgroundcolor','w','fontweight','bold');
h8=uicontrol('style','text','units','normalized','fontsize',12,'visible','off',...
    'position',[.4 .35 .2 .07],'string','50','foregroundcolor',[.15 .5 .17],'backgroundcolor','w','fontweight','bold');
h12=uicontrol('style','text','units','normalized','fontsize',12,'visible','off',...
    'position',[.38 .25 .2 .07],'string','Words per Minute:','foregroundcolor','g','backgroundcolor','w','fontweight','bold');
h18=uicontrol('style','text','units','normalized','fontsize',12,'visible','off',...
    'position',[.55 .25025 .05 .07],'string','50','foregroundcolor',[.15 .5 .17],'backgroundcolor','w','fontweight','bold');

    function goon9(varargin)
        if strcmp(get(h5,'string'),'1:00')
            set(h5,'string','2:00')
        else
            set(h5,'string','1:00')
        end
    end

    function goon3(varargin)
        set(h7,'visible','off')
        set(h8,'visible','off')
        set(h12,'visible','off')
        set(h18,'visible','off')
        set(h3,'string','');        
        set(h2,'string','','style','edit');                
        set(h6,'string','3');      
        pause(1)
        set(h6,'string','2');      
        pause(1)
        set(h6,'string','1');
        pause(.9)
        number=3;
        a=floor(rand*number)+1;
        k=chz(a);
        pause(.1)      
        set(h6,'string','');       
        tic;
        G=[];
        if strcmp(get(h5,'string'),'1:00')        
            seconds=60;
        else
            seconds=120;
        end
        while toc<seconds
            set(h5,'string',num2str(seconds-toc,3)); 
            G=[G,get(hh,'currentcharacter')];            
            set(hh,'currentcharacter','0');
            pause(.000000001)
        end
        G((G=='0'))=[];
        G=[G,' ,.-'];
        k=[k,' ,.-'];
        set(h5,'string','Time Over');
        set(h2,'style','text','string',G(1:length(G)-4));
        stop=0;
        d=1;
        j1=1;
        j3=1;
        j2=1;        
        j4=1;     
        p1=find(k==' ');
        p2=find(k==',');
        p3=find(k=='.');
        p4=find(k=='-');
        dg=1;
        jg1=1;
        jg3=1;
        jg2=1;                        
        jg4=1;               
        pg1=find(G==' ');        
        pg2=find(G==',');        
        pg3=find(G=='.');        
        pg4=find(G=='-');                    
        s=0;
        while ~stop
            while strcmp(k(d),' ')                
                d=d+1;
                j1=j1+1;
            end       
            P=[p1(j1),p2(j2),p3(j3),p4(j4)];
            switch min(P)
                case P(1)
                    j1=j1+1;
                    if j1>length(p1)
                        p1(j1)=9999999;
                    end
                case P(2)
                    j2=j2+1;                    
                    if j2>length(p2)
                        p2(j2)=9999999;
                    end
                case P(3) 
                    j3=j3+1;                    
                    if j3>length(p3)
                        p3(j3)=9999999;
                    end  
                       case P(4) 
                    j4=j4+1;                    
                    if j4>length(p4)
                        p4(j4)=9999999;
                    end  
            end
            a1=k(d:min(P));
            d=min(P)+1;
            while strcmp(G(dg),' ')
                dg=dg+1;
                jg1=jg1+1;
            end
            Pg=[pg1(jg1),pg2(jg2),pg3(jg3),pg4(jg4)];
            
            switch min(Pg)
                case Pg(1)
                    jg1=jg1+1;
                    if jg1>length(pg1)
                        pg1(jg1)=9999999;
                    end
                case Pg(2)
                    jg2=jg2+1;                    
                    if jg2>length(pg2)
                        pg2(jg2)=9999999;
                    end
                case Pg(3) 
                    jg3=jg3+1;                    
                    if jg3>length(pg3)
                        pg3(jg3)=9999999;
                    end
                case Pg(4)
                    jg4=jg4+1;                    
                    if jg4>length(pg4)
                        pg4(jg4)=9999999;
                    end  
            end            
            ag1=G(dg:min(Pg));
            dg=min(Pg)+1;
            
            if strcmp(ag1,a1)
                s=s+1;
            end
            if d>length(k)-4 || dg>length(G)-4
                break
            end
        end
        set(h7,'visible','on')        
        set(h8,'visible','on','string',num2str(s))
        set(h12,'visible','on')
        set(h18,'visible','on','string',num2str(s*60/seconds))
        set(hpp,'visible','off')
        pause(1)
        set(hpp,'visible','on')
    end        

    function k=chz(a)       
        switch a
            case 1                
                k=['MATLAB is a high-performance language for technical computing. It integrates ',...
                'computation, visualization, and programming in an easy-to-use environment ',...
                'where problems and solutions are expressed in familiar mathematical notation.',...
                '                                                              ',...
                'MATLAB is an interactive system ',...
                'whose basic data element is an array that does not require dimensioning. This allows you to solve many technical ',...
                'computing problems, especially those with matrix and vector formulations, in a fraction of the time it would take ',...
                'to write a program in a scalar noninteractive language such as C or Fortran. ',...
                '                                                              ',...
                '                                                                              ',...
                'The name MATLAB stands for matrix laboratory. MATLAB ',...
                'was originally written to provide easy access to matrix software developed ',...
                'by the LINPACK and EISPACK projects. Today, MATLAB engines incorporate the ',...
                'LAPACK and BLAS libraries, embedding the state of the art in software for ',...
                'matrix computation.'];
            case 2
                k=['Et af SEGAs storste kampspil ser nu dagens lys i et eksplosivt cirkelspark pa Playstation 2. ',...
                'Med Virtua Fighter 4 er der lagt op til oretaever i bunkevis-bade for nybegynderen og den avacerede ',...
                'spiller. Hver figur i spillet har sin unikke kampform, og spillets i alt 13 unikkd stilarter muliggor ',...
                'tilsammen over 3000 forskellige manovrer, der med lethed gor spillet til den mest gennemforte ',...
                'kampsportssimulator pa markedet.',...
                '                                                                              ',...
                '                                                     ',...
                'Grafikken er superflot og rig pa laekre detajier, Fod-og kropsaftryk pa baner med sne og sand, samt stenog ',...
                'traevaegge, der smadres, nar din modstander slynges mod dem. Virtua Fighter 4 er et af arets mest action-intense',...
                'mader at afreagere pa, og har du en kammerat indenfor raekkevidde, er der ingen vej udenom. Spark til.'];                
            case 3             
                k=['Once upon a midnight dreary, while I pondered, weak and weary,',...
                '                              ',...
                'Over many a quaint and curious volume of forgotten lore.',...
                '                                                   ',...
                'While I nodded, nearly napping, suddenly there came a tapping,',...
                '                                    ',...
                'As of some one gently rapping, rapping at my chamber door.',...
                '                                              ',...
                'Tis some visiter, I muttered, tapping at my chamber door,',...
                '                                             ',...
                'Only this and nothing more.',...
                '                                                    ',...
                '                                                    ',...
                'Ah, distinctly I remember it was in the bleak December,',...
                '                                                         ',...
                'And each separate dying ember wrought its ghost upon the floor.',...
                '                                           ',...
                'Eagerly I wished the morrow-vainly I had sought to borrow',...
                '                                            ',...
                'From my books surcease of sorrow-sorrow for the lost Lenore.',...
                '                                          ',...
                'For the rare and radiant maiden whom the angels name Lenore,',...
                '                                     ',...
                'Nameless here for evermore.'];
        end
                set(h3,'string',k);        
    end

end

