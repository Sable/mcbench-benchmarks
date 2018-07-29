function mancala(varargin)
    close all
    clc
    clear all
    global h
    h.main=figure('name','MANCALA by VastMind Suleman(C)','NumberTitle','off','Position',[250 250 600 300]);
    uicontrol('style','text','string','MANCALA','position',[200 260 180 35],'foregroundcolor','r','backgroundcolor','w','fontsize',24);
    uicontrol('style','pushbutton','string','Rules','position',[425 10 80 35],'callback','web boardgames.about.com/cs/mancala/ht/play_mancala.htm');
    h.newgame=uicontrol(h.main,'style','pushbutton','position',[10,260,80,35],'string','New Game','callback','mancala','tooltipstring','Newgame');
    h.close=uicontrol(h.main,'style','pushbutton','position',[515,10,80,35],'string','Close','callback','close gcbf');
    h.whoseturn=uicontrol(h.main,'style','text','position',[250,140,100,15],'string','Player1 turn','backgroundcolor','w','foregroundcolor','k','fontsize',10);
%     h.popup=uicontrol(h.main,'style','popup','position',[h.boxdim(1)*(h.row+4)-150,h.boxdim(2)*(h.column+4)-20,100,20],...
%         'tooltipstring','Go for Expert','string','xx|xx|xx|xx','interruptible','off');
    h.noofbucks=6;
    h.noofpegs=3;
    h.totalbucks=h.noofbucks*2+2;
    h.plr2startingbucks=h.noofbucks+2;
    h.plr2endingbucks=h.totalbucks-1;
    h.buttongap=10;
    h.buckheight=60;
    h.bucketheight=200;
    h.bucketwidth=80;
    h.sidegap=50;
    h.plr1bucket=h.noofbucks+1;
    h.buckwidth=(600-2*h.bucketwidth-2*h.sidegap-h.buttongap)/h.noofbucks-h.buttongap;
    for x=1:h.noofbucks
        h.buck(x)=uicontrol(h.main,'style','pushbutton','FontWeight','bold','foregroundcolor','b','fontsize',12,...
                'position',[h.sidegap+h.bucketwidth+h.buttongap+(x-1)*(h.buckwidth+h.buttongap),50,h.buckwidth,h.buckheight],...
                'string',h.noofpegs,'tooltipstring','Player 1 buck','callback',@turn,'buttondownfcn',{'turn'});
    end
    h.buck(h.plr1bucket)=uicontrol(h.main,'style','pushbutton','FontWeight','bold','foregroundcolor','r','fontsize',14,...
                'position',[600-h.bucketwidth-h.sidegap 50 h.bucketwidth h.bucketheight],'string','0','tooltipstring','Player 1 bucket');
    for x=h.plr2startingbucks:h.plr2endingbucks
        h.buck(x)=uicontrol(h.main,'style','pushbutton','FontWeight','bold','foregroundcolor','b','fontsize',12,...
                'position',[600-h.sidegap-h.bucketwidth-(x-1-h.noofbucks)*(h.buckwidth+h.buttongap),50+h.bucketheight-h.buckheight,h.buckwidth,h.buckheight],...
                'string',h.noofpegs,'tooltipstring','Player 2 buck','callback',@turn,'buttondownfcn',@turn);
    end
    h.buck(h.totalbucks)=uicontrol(h.main,'style','pushbutton','FontWeight','bold','foregroundcolor','r','fontsize',14,...
                'position',[h.sidegap 50 h.bucketwidth h.bucketheight],'string','0','tooltipstring','Player 2 bucket');
    
    
%     h.plr1bucks=h.noofpegs*ones(1,h.noofbucks);
%     h.plr1bucks=h.noofpegs*ones(1,h.noofbucks);
    h.game=[h.noofpegs*ones(1,h.noofbucks) 0 h.noofpegs*ones(1,h.noofbucks) 0];
    h.plrturn=1;
end
function turn(hobj,~)
    global h
    for jj=1:h.totalbucks
        if h.buck(jj)==hobj
            h.buckselected=jj;
        end
    end
    updategame;
    displaygame;
    checkwin;
end
function updategame
    global h
    if ((h.buckselected>=1 && h.buckselected < h.plr1bucket && h.plrturn==1) || (h.buckselected>=h.plr2startingbucks && h.buckselected < h.totalbucks && h.plrturn==2)) && h.game(h.buckselected)~=0
        bucksinhand=h.game(h.buckselected);
        h.game(h.buckselected)=0;
        tempplace=h.buckselected;
        for i=1:bucksinhand
            tempplace=tempplace+1;
            if h.plrturn==1 && tempplace==h.totalbucks
                tempplace=1;h.buckselected=h.buckselected+1;
            elseif h.plrturn==2 && tempplace==h.plr1bucket
                tempplace=tempplace+1;h.buckselected=h.buckselected+1;
            end
            if tempplace>h.totalbucks
                tempplace=tempplace-h.totalbucks;
            end
            if h.game(tempplace)==0 && i==bucksinhand
                h.jump=1;
            else h.jump=0;
            end
            h.game(tempplace)=h.game(tempplace)+1;
        end
        if h.jump==1 && h.plrturn==1 && tempplace<=h.noofbucks
            h.game(h.plr1bucket)=h.game(h.plr1bucket)+h.game(tempplace)+h.game(h.totalbucks-tempplace);
            h.game(tempplace)=0;
            h.game(h.totalbucks-tempplace)=0;
        elseif h.jump==1 && h.plrturn==2 && tempplace>h.plr1bucket && tempplace<h.totalbucks
            h.game(h.totalbucks)=h.game(h.totalbucks)+h.game(tempplace)+h.game(h.totalbucks-tempplace);
            h.game(tempplace)=0;
            h.game(h.totalbucks-tempplace)=0;
        end
        if h.plrturn==1
            if tempplace~=h.plr1bucket
                h.plrturn=2;
            end
        elseif h.plrturn==2
            if tempplace~=h.totalbucks
                h.plrturn=1;
            end
        end
    else
%         msgbox('Wrong input');
    end   
end
function checkwin
    global h
    if sum(h.game(1:h.noofbucks))==0 || sum(h.game(h.plr2startingbucks:h.plr2endingbucks))==0
        h.game(h.plr1bucket)=sum(h.game(1:h.plr1bucket));
        h.game(h.totalbucks)=sum(h.game(h.plr2startingbucks:h.totalbucks));
        h.game(1:h.noofbucks)=zeros(1,h.noofbucks);
        h.game(h.plr2startingbucks:h.plr2endingbucks)=zeros(1,h.noofbucks);
        displaygame
        if h.game(h.plr1bucket)>h.game(h.totalbucks)
            msgbox('---------Player 1 wins---------');
        elseif h.game(h.plr1bucket)<h.game(h.totalbucks)
            msgbox('---------Player 2 wins---------');
        else
            msgbox('---------Its a tie----------');
        end
    end
end
function displaygame
    global h
    for x=1:h.totalbucks
        set(h.buck(x),'string',num2str(h.game(x)));
    end
    set(h.whoseturn,'string',strcat('Player',num2str(h.plrturn),' turn'));
end