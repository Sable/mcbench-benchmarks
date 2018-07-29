%%  Virtual Painter 1
%% discription
% Virtual Painter - this software allows you to draw a picture on the screen
% By following the red color
% 
% Have the option to choose what color to paint by moving the red color to the desired color:
% Red, green, blue.
% 
% To close the program, have received faint image on the screen
% 
% Note: In order to achieve optimal results have run the program in the light of fluorescent lamp.
% % Operating Instructions
% To paint the color red object we vote to act as follows:
%% Play and exit:
%
% * To start the video: click on the Play button.
% * To exit from the function: Display to the camera very dark image ,
%    for example you can cover the camera with your hand,
%    Or turn off the light in the room.After doing so
%    The Camera and function should be closed automatically.
%% Notes
%  The identification of red objects in the picture depends on the lighting of the room.
%  Lighting Fluorescent light is the most appropriate lighting to this function to identify red objects.
%
%  first edited  in 8/06/2013 Saturday .
%  by Oren berkovich.


function virtualpaint()    
    

            
%% creat figure and uicontrol 
      figure('menubar','none')  
    

    ply= uicontrol('style','togg','units','normalized',...
        'position',[0.1 0.1 0.1 0.1],'str','Play','callback',{@PlayvideoLive});    
    
    uicontrol('style','text','str' ,'exit- cover the eye of the camera ',...
        'units','normalized','position',[0.2 0.1 0.5 0.05])
  
    %% main function
    function PlayvideoLive(~,~)
   
        set(ply,'enable','off');
        pause(0.5);
        
        try
    imaqreset
    vid = videoinput('winvideo', 1, 'YUY2_160x120');
    vid.ReturnedColorspace = 'rgb';
    set(vid,'framesperTrigger',10,'TriggerRepeat',Inf);
       
      color='y';
      x=[];
      y=[];
      Eraser='non';
      %
        tic  
   
    start(vid);
        catch ex
            err=errordlg(ex.message);
            uiwait(err)
            close gcf
            return
        end

      while islogging(vid)

    
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
 %%
 

 %% Identify the position of the marked
 W=regionprops(bw,'Centroid');
 if isempty(W)==0
     %axis([0 160 0 120])

 x=horzcat(x,W(1).Centroid(1));
 y=horzcat(y,W(1).Centroid(2));

  elseif length(W)==2
     hold on
     line([W(1).Centroid(1) W(2).Centroid(1)],[W(1).Centroid(2) W(2).Centroid(2)],'color','r','linew',2)
 
 end
  %% erse mode
      if length(x)==100
          Eraser='era';    
      end
      
      if eq(Eraser,'era')==1
           x=x(2:length(x));
           y=y(2:length(y));
           if  isempty(x)==1
               Eraser='non';
           end
      end
      %%
 hold on

 if isempty(x)==0
color=rgbcolor(x(length(x)),y(length(y)),color);
plot(x,y,'color',color,'linew',4) 
 end
 
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

