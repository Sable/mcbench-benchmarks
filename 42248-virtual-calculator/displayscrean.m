function [num,newstr]= displayscrean(x,y,newstr)

%
x=x/100;
y=y/100;

%
title(newstr,'fonts',15,'fontw','bold','units','normalized',...
    'position',[0.1 1.02],'HorizontalAlignment','left')

% 7
rectangle('Position',[0.2,0.1,0.20,0.20]*100,'Curvature',[1,1],'edge','b') 
%text(30,20,'7')
%8
rectangle('Position',[0.45,0.1,0.20,0.20]*100,'Curvature',[1,1],'edge','b') 
%text(55,20,'8')
%9
rectangle('Position',[0.7,0.1,0.20,0.20]*100,'Curvature',[1,1],'edge','b') 
%text(78,20,'9')
%6
rectangle('Position',[0.7,0.35,0.20,0.20]*100,'Curvature',[1,1],'edge','b')
%text(75,45,'6')
%5
rectangle('Position',[0.45,0.35,0.20,0.20]*100,'Curvature',[1,1],'edge','b') 
%text(55,45,'5')
%4
rectangle('Position',[0.2,0.35,0.20,0.20]*100,'Curvature',[1,1],'edge','b') 
%text(30,45,'4')
%1
 rectangle('Position',[0.2,0.6,0.20,0.20]*100,'Curvature',[1,1],'edge','b') 
 %text(30,65,'1')
  %2
  rectangle('Position',[0.45,0.6,0.20,0.20]*100,'Curvature',[1,1],'edge','b')
% text(55,65,'2')
  %3
  rectangle('Position',[0.7,0.6,0.20,0.20]*100,'Curvature',[1,1],'edge','b') 
 %  text(75,65,'3')
%0
rectangle('Position',[0.2,0.85,0.20,0.20]*100,'Curvature',[1,1],'edge','y') 
 text(30,95,'0')
%.
rectangle('Position',[0.45,0.85,0.20,0.20]*100,'Curvature',[1,1],'edge','w')
 text(55,95,'.','fonts',16,'fontw','bold')
% (
rectangle('Position',[0.7,0.85,0.20,0.20]*100,'Curvature',[1,1],'edge','k')
 text(75,95,'(','fonts',16)
%************************************************************
%% oparetion

% DELL
rectangle('Position',[1.1,0.1,0.20,0.20]*100,'Curvature',[1,1],'edge','y') 
 text(115,20,'DEL','color','r')
%AC
rectangle('Position',[1.35,0.1,0.20,0.20]*100,'Curvature',[1,1],'edge','r') 
text(140,20,'AC','color','r')
% +
rectangle('Position',[1.1,0.35,0.20,0.20]*100,'Curvature',[1,1],'edge','g') 
%text(120,45,'+','color','r')
%-
rectangle('Position',[1.35,0.35,0.20,0.20]*100,'Curvature',[1,1],'edge','g') 
%text(140,45,'-','color','r')
% x
rectangle('Position',[1.1,0.6,0.20,0.20]*100,'Curvature',[1,1],'edge','g') 
%text(120,70,'x','color','r')
% /
rectangle('Position',[1.35,0.6,0.20,0.20]*100,'Curvature',[1,1],'edge','g') 
%text(140,70,'/','color','r')
% =
rectangle('Position',[1.35,0.85,0.20,0.20]*100,'Curvature',[1,1],'edge','c') 
text(145,95,'=','color','r')
%  )
rectangle('Position',[1.1,0.85,0.20,0.20]*100,'Curvature',[1,1],'edge','k') 
text(120,95,')','fonts',16)
 
  %**************************************************
  %% check digit  position
 hold on
 % number side
 if x<0.91;
             % position 7
             if     x>0.20&&x<0.4&&y>0.20&&y<0.35
                     rectangle('Position',[0.2,0.1,0.20,0.20]*100,'Curvature',[1,1],'facecolor','b') 
                    num='7';
            % position 8

             elseif   x>0.45&&x<0.65&&y>0.2&&y<0.35
                        rectangle('Position',[0.45,0.1,0.20,0.20]*100,'Curvature',[1,1],'facecolor','b') 
                        num='8';
            % position 9

             elseif   x>0.7&&x<0.9&&y>0.2&&y<0.35
                        rectangle('Position',[0.7,0.1,0.20,0.20]*100,'Curvature',[1,1],'facecolor','b') 
                        num='9';
            % position 6

             elseif    x>0.7&&x<0.9&&y>0.4&&y<0.5
                        rectangle('Position',[0.7,0.35,0.20,0.20]*100,'Curvature',[1,1],'facecolor','b') 
                        num='6';
            % position 5

             elseif    x>0.45&&x<0.65&&y>0.4&&y<0.5
                        rectangle('Position',[0.45,0.35,0.20,0.20]*100,'Curvature',[1,1],'facecolor','b') 
                        num='5';
            % position 4

             elseif      x>0.20&&x<0.4&&y>0.4&&y<0.5
                        rectangle('Position',[0.2,0.35,0.20,0.20]*100,'Curvature',[1,1],'facecolor','b') 
                        num='4';
             % position 3

             elseif     x>0.7&&x<0.9&&y>0.65&&y<0.75
                        rectangle('Position',[0.7,0.6,0.20,0.20]*100,'Curvature',[1,1],'facecolor','b') 
                        num='3' ;           

             % position 2

             elseif   x>0.45&&x<0.65&&y>0.65&&y<0.75
                        rectangle('Position',[0.45,0.6,0.20,0.20]*100,'Curvature',[1,1],'facecolor','b') 
                        num='2' ;
             % position 1

             elseif   x>0.20&&x<0.4&&y>0.65&&y<0.75
                        rectangle('Position',[0.2,0.6,0.20,0.20]*100,'Curvature',[1,1],'facecolor','b') 
                        num='1' ;
             % position 0

             elseif    x>0.20&&x<0.4&&y>0.9&&y<1.15
                        rectangle('Position',[0.2,0.85,0.20,0.20]*100,'Curvature',[1,1],'facecolor','y') 
                        num='0' ;
             % position .

             elseif    x>0.45&&x<0.65&&y>0.9&&y<1.15
                        rectangle('Position',[0.45,0.85,0.20,0.20]*100,'Curvature',[1,1],'facecolor','w') 
                        num='.' ;    
             % position (

             elseif    x>0.7&&x<0.9&&y>0.9&&y<1.15
                        rectangle('Position',[0.7,0.85,0.20,0.20]*100,'Curvature',[1,1],'facecolor','k') 
                        num='(' ;                
             else
                 num=[];
             end
 
 %************************************************************
%% check for oparetion position
% oparetion side
elseif x>0.91
            %AC
             if   x>1.36&&x<1.51&&y>0.20&&y<0.30
                        rectangle('Position',[1.35,0.1,0.20,0.20]*100,'Curvature',[1,1],'facecolor','r') 

                        newstr=[];
                        num=[];
                        sound(cos(1:0.1:100),9000)
            %DELL
             elseif   x>1.06&&x<1.26&&y>0.20&&y<0.30
                        rectangle('Position',[1.1,0.1,0.20,0.20]*100,'Curvature',[1,1],'facecolor','y') 

                        newstr=newstr(:,1:length(newstr)-1);
                        num=[];
                        sound(sin(1:1:100),4900)

            % position +

             elseif   x>1.06&&x<1.26&&y>0.4&&y<0.5
                        rectangle('Position',[1.1,0.35,0.20,0.20]*100,'Curvature',[1,1],'facecolor','g') 
                        num='+';
            % position -
             elseif   x>1.31&&x<1.51&&y>0.4&&y<0.5
                        rectangle('Position',[1.35,0.35,0.20,0.20]*100,'Curvature',[1,1],'facecolor','g') 
                        num='-';
            % position x

             elseif   x>1.06&&x<1.26&&y>0.65&&y<0.75
                        rectangle('Position',[1.1,0.6,0.20,0.20]*100,'Curvature',[1,1],'facecolor','g') 
                        num='*';
            % position /
             elseif   x>1.31&&x<1.51&&y>0.65&&y<0.75
                        rectangle('Position',[1.35,0.6,0.20,0.20]*100,'Curvature',[1,1],'facecolor','g') 
                        num='/';
            % position )
             elseif   x>1.06&&x<1.26&&y>0.9&&y<1
                        rectangle('Position',[1.1,0.85,0.20,0.20]*100,'Curvature',[1,1],'facecolor','k') 
                        num=')';

             % position =
             elseif   x>1.31&&x<1.61&&y>0.9&&y<1.1
                        rectangle('Position',[1.35,0.85,0.20,0.20]*100,'Curvature',[1,1],'facecolor','c') 
                        equl=str2num(newstr);
                        newstr=num2str(equl);
                        num=[];
                        sound(sin(1:1:100),4900)

                 else
                     num=[];
             end
 else
     num=[];
end
 
end