function difficultylevel(hObject,eventdata,h)
val=get(h.popup,'value');
switch val
    case 2
        h.row=6;
        h.column=6;
    case 3
        h.row=10;
        h.column=10;
    case 4
        h.row=14;
        h.column=14;
        h.iposx=50;h.iposy=50;
end
% initializing background work like bomb placement etc
bomb=int8(h.difficulty*rand(h.row+2,h.column+2));
bomb(:,1)=zeros(h.row+2,1);bomb(:,h.column+2)=zeros(h.row+2,1);bomb(1,:)=zeros(1,h.column+2);bomb(h.row+2,:)=zeros(1,h.column+2);
h.game=bomb*9;
for x=2:h.row+1
    for y=2:h.column+1
        n=0;
        if bomb(x,y)==0
            if bomb(x-1,y-1)==1
                n=n+1;
            end
            if bomb(x-1,y)==1
                n=n+1;
            end
            if bomb(x-1,y+1)==1
                n=n+1;
            end
            if bomb(x,y-1)==1
                n=n+1;
            end
            if bomb(x,y+1)==1
                n=n+1;
            end
            if bomb(x+1,y-1)==1
                n=n+1;
            end
            if bomb(x+1,y)==1
                n=n+1;
            end
            if bomb(x+1,y+1)==1
                n=n+1;
            end
        h.game(x,y)=n;    
        end 
    end
end
h.game=flipud(h.game');
% disp(h.game);
% initializing gui
close(gcbf);
h.main=figure('name','Suleman''s minesweeper','NumberTitle','off','Position',[h.iposx,h.iposy,(h.row+4)*h.boxdim(1),(h.column+4)*h.boxdim(2)]);
h.newgame=uicontrol(h.main,'style','pushbutton','position',[0,h.boxdim(2)*(h.column+4)-35,100,35],'string','New Game','callback','minesweeper');
h.close=uicontrol(h.main,'style','pushbutton','position',[h.boxdim(1)*(h.row+4)-100,0,100,35],'string','Close','callback','close gcbf');
h.popup=uicontrol(h.main,'style','popup','position',[h.boxdim(1)*(h.row+4)-150,h.boxdim(2)*(h.column+4)-20,100,20],...
    'string','Difficulty|Beginner|Intermediate|Expert');
for x=1:h.row+2
    for y=1:h.column+2
        h.box(y,x)=uicontrol(h.main,'style','pushbutton','FontWeight','bold','foregroundcolor','b','fontsize',12,...
            'position',[h.boxdim(1)*(x),h.boxdim(2)*(h.column+3-y),h.boxdim(1)-h.gap(1),h.boxdim(2)-h.gap(2)]);
        if x==1 || y==1 || x==h.row+2 || y==h.column+2
            set(h.box(y,x),'visible','off');
        end
    end
end
% defining callbacks
set(h.popup,'callback',{@difficultylevel,h});
for ii=1:h.row+2
    for jj=1:h.column+2
        set(h.box(ii,jj),'callback',{'button',h},'buttondownfcn',{'mark',h});
    end
end
end