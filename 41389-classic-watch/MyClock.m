%% Myclock 

% first edited  in 10/04/2013 Wednesday .
% Add a digital clock and time numbers were added-in 14/04/2013 Sunday.
%  by oren berkovich ver 0.2.


function MyClock()

close all;

fig=figure(1);

set(fig,'renderer','opengl','windowStyle','docked',...
     'menubar','none','name','Clock Clasic','numbertitle','off',...
     'visible','on','units','normalized','toolbar','none')


ylim([-2 2]);
xlim([-2 2]);
 
axis off
hold on
   
% Setting the time component

a=timer;

set(a,'executionmode','fixedrate','Period',1);
set(a,'timerfcn',@StartTimer);
set(a,'StopFcn',@StopTimer);
start(a);

 % stop and delete the timer when the figure is closed
set(fig, 'closerequestfcn',@StopTimer);

% function of the timer

function StartTimer(~,~)
    
hhmmss =   datestr(clock, 'HH:MM:SS');
cla

rectangle('Position',[-1.15,-1.2,2.4,2.4],'Curvature',[1,1],...
        'FaceColor', [0.101961 0.680392 0.7],'linewidth',2.7);

    % number on the clock
text(1.1*cos((90-12* 30)*2*pi/360),1.1*sin((90-12* 30)*2*pi/360),'12','fontname','ravie') 
text(1.1*cos((90-1* 30)*2*pi/360),1.1*sin((90-1* 30)*2*pi/360),'1','fontname','ravie')
text(1.1*cos((90-2* 30)*2*pi/360),1.1*sin((90-2* 30)*2*pi/360),'2','fontname','ravie')
text(1.1*cos((90-3* 30)*2*pi/360),1.1*sin((90-3* 30)*2*pi/360),'3','fontname','ravie')
text(1.1*cos((90-4* 30)*2*pi/360),1.1*sin((90-4* 30)*2*pi/360),'4','fontname','ravie')
text(1.1*cos((90-5* 30)*2*pi/360),1.1*sin((90-5* 30)*2*pi/360),'5','fontname','ravie')
text(1.1*cos((90-6* 30)*2*pi/360),1.1*sin((90-6* 30)*2*pi/360),'6','fontname','ravie')
text(1.1*cos((90-7* 30)*2*pi/360),1.1*sin((90-7* 30)*2*pi/360),'7','fontname','ravie')
text(1.1*cos((90-8* 30)*2*pi/360),1.1*sin((90-8* 30)*2*pi/360),'8','fontname','ravie')
text(1.1*cos((90-9* 30)*2*pi/360),1.1*sin((90-9* 30)*2*pi/360),'9','fontname','ravie')
text(1.13*cos((90-10* 30)*2*pi/360),1.13*sin((90-10* 30)*2*pi/360),'10','fontname','ravie') 
text(1.1*cos((90-11* 30)*2*pi/360),1.1*sin((90-11* 30)*2*pi/360),'11','fontname','ravie') 

% second
ss=str2num(hhmmss(7:8)); %#ok<ST2NM>

sxdata=[0 cos((90-ss*6)*2*pi/360)];
sydata=[0 sin((90-ss*6)*2*pi/360)];

patch(sxdata,sydata,'r','LineWidth',1);

%Minutes
mm=str2num(hhmmss(4:5)); %#ok<ST2NM>
hold on
mxdata=[0 0.8*cos((90-mm*6-ss*0.1)*2*pi/360)];
mydata=[0 0.8*sin((90-mm*6-ss*0.1)*2*pi/360)];

patch(mxdata,mydata,'w','LineWidth',2.6);

% houre
hh=str2num(hhmmss(1:2)); %#ok<ST2NM>

hold on
hxdata=[0 0.6*cos((90-hh* 30-mm*.5-ss/120)*2*pi/360)];
hydata=[0 0.6*sin((90-hh*30-mm*.5-ss/120)*2*pi/360)];
patch(hxdata,hydata,'w','LineWidth',3);

%digital clock
text(0.4,0.4,num2str(hhmmss),'units','normalized',...
'visible','on',...
   'fontsize',16,...
   'fontname','freestyle script','color','y');
end

    function StopTimer(~,~)
       stop(a);
       delete(a);
      delete(gcf);
       
    end
end



