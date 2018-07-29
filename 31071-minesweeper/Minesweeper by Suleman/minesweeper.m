function [varargout]=minesweeper(varargin)
%initialization
clc
clear all
close all
% playing a background music
% % [bk,fs]=wavread('bk2.wav',1000);
% % wavplay(bk,fs,'async');
%declaration and initializing variables
h=struct;
h.row=10;
h.column=10;
h.iposx=100;h.iposy=100;
h.boxdim=[35 35];
h.gap=[0.5 0.5];
h.mine=imread(strcat('mine','.png'));
% initializing gui
h.main=figure('name','Suleman''s minesweeper','NumberTitle','off','Position',[h.iposx,h.iposy,(h.row+4)*h.boxdim(1),(h.column+4)*h.boxdim(2)]);
h.newgame=uicontrol(h.main,'style','pushbutton','position',[0,h.boxdim(2)*(h.column+4)-35,100,35],'string','New Game','callback','minesweeper','tooltipstring','Newgame');
h.close=uicontrol(h.main,'style','pushbutton','position',[h.boxdim(1)*(h.row+4)-100,0,100,35],'string','Close','callback','close gcbf');
h.popup=uicontrol(h.main,'style','popup','position',[h.boxdim(1)*(h.row+4)-150,h.boxdim(2)*(h.column+4)-20,100,20],...
    'tooltipstring','Go for Expert','string','Difficulty|Beginner|Intermediate|Expert','interruptible','off');
for x=1:h.row+2
    for y=1:h.column+2
        h.box(y,x)=uicontrol(h.main,'style','pushbutton','FontWeight','bold','foregroundcolor','b','fontsize',12,...
            'position',[h.boxdim(1)*(x),h.boxdim(2)*(h.column+3-y),h.boxdim(1)-h.gap(1),h.boxdim(2)-h.gap(2)]);
        if x==1 || y==1 || x==h.row+2 || y==h.column+2
            set(h.box(y,x),'visible','off');
        end
    end
end
% initializing background work like bomb placement
h.difficulty=0.65;
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
% defining callbacks
set(h.popup,'callback',{@difficultylevel,h});
for ii=1:h.row+2
    for jj=1:h.column+2
        set(h.box(ii,jj),'callback',{'button',h},'buttondownfcn',{'mark',h});
    end
end
end