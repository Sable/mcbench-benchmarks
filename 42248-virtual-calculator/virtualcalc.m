function virtualcalc
%% Virtual Calculator
% This calculator allows the user to perform calculations in front of the camera, 
% when tapping fingers on the virtual keyboard.

%% Description
% This calculator allows you to make calculations in front of the camera.
% Instructions:
% 
% All you have to do is: click on the Play button,
% The camera to be powered on and ready to use
% After pressing the Play button and moving the finger on the screen appear standard calculator buttons.
% 
% Press the desired button and wait a moment, to the number you want to appear in the title.

%% Explanations of the functions of the software:

% virtualcalc-This is the main program which does the virtual calculator.
% 
% displayscrean-This function displays the buttons on the screen
% Checks where the red object in relation to the buttons.
% 
% samenum - function determines how many times to press the button to display the desired digit,
% You can change, for example: 
% samenum (num, 6) - the sixth digit can be changed and that's the number of times that change click to view the desired digit.

%% Notes

% Finger identification scheme was based on sensitivity to red color
% Effective use is important that the camera red objects were filmed
% 
% Better to use a bottle of red jam
% Red cursor will appear showing where the camera detects red object
% 
% To change the sensitivity buttons change the digit function
% 
% Better to use fluorescent lighting
% 
% To exit the program - have to create a dark screen in front of the camera,...
%       you can do so by covering the camera eye
%
% For optimal performance, use Windows Camera
% Resolution of 160X120.
% 
% Necessary Toolbox: Image Processing.
% The software is constructed of the version of MATLAB 2011a.
% 
% This software was created by Oren Berkovich on Sunday June 16 2013.
%  update on Tuesday  June 18 2013
% Notes and suggestions are welcome.

close all
clear all
%% creat figure and uicontrol 
   set(0,'units','pixels');
   fig=   figure('menubar','none','pointer','hand','units','pixels',...
       'name','Virtual Calc','number','off')  ;
   
   %% find the screen /figure propotional size
%    figpos=get(fig,'position');
%    scrpos=get(0,'ScreenSize');
   set(fig,'unit','normalized');set(0,'unit','normalized');
   

    num=[];
    newstr=[];

    
    ply= uicontrol('parent',fig,'style','togg','units','normalized',...
        'position',[0.1 0.1 0.1 0.1],'str','Play','callback',{@PlayvideoLive});    
    
    uicontrol('parent',fig,'style','text','str' ,{'Point your finger on a particular button';...
    'And wait one minute, and the desired digit appears in the upper section';...
        
      'exit- cover the eye of the camera '},...
        'units','normalized','position',[0.3 0.0 0.47 0.15])
  
    %% main function
    function PlayvideoLive(~,~)
   
        set(ply,'enable','off');
        pause(0.5);
        
        try
    imaqreset
    vid = videoinput('winvideo', 1, 'YUY2_160x120');
    vid.ReturnedColorspace = 'rgb';
    set(vid,'framesperTrigger',10,'TriggerRepeat',Inf);
       
      
      % open time 
        tic  
        %% Started to take image
   
    start(vid);
        catch ex
            err=errordlg(ex.message);
            uiwait(err)
            close gcf
            return
        end

      while islogging(vid)
  %% Divide the image into three colors: R G B
   
    tv=getdata(vid,1);
    
    r=tv(:,:,1,1);
    g=tv(:,:,2,1);
    b=tv(:,:,3,1);
    
    flushdata(vid);
    
    %% Find the differences of each object

rg=r-g;
gb=g-b;
rggb=rg-gb;

%% build the color filters

filter=rggb>26;
filter=uint8(filter);
F=filter.*rggb;

%% Remove objects less than the pixel size prescribing function
 
 bw=imfill(F,'holes');
 bw=bwareaopen(bw,50);
 
 %% Identify the position of the marked
 W=regionprops(bw,'Centroid');
 
if isempty(W)==0
    hold on
    plot(W(1).Centroid(1),W(1).Centroid(2),'r*')
    axis off
%set(0,'PointerLocation',[W(1).Centroid(1)/140 1-(W(1).Centroid(2)/100)])
xy= W(1).Centroid;
X=xy(1) ;%*pwidth+fx;
Y=xy(2);%*phigth+fy;
num1=num;
[num,newstr]=displayscrean(X,Y,newstr);
num=strcat(num,num1);
y=newstr;
[newstr,num]=samenum(num,6);

newstr=strcat(y,newstr);
end
      %%
     
 hold on

 %% Rebuild the RGB image, if the part has been lightened

    figure(gcf)

    hold off
    imshow(tv(:,:,:,1))
    
    state =mean2(r);
    if state<20&&toc>20;
       break
    end
   
      end    
      % after you exit the loop 
       stop(vid)
       imaqreset

       close gcf
       clc
       disp('good by')
    end
    
     
    end










