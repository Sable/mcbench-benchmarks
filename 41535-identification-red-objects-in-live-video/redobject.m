%% RedObject  ver 0.2
%% discription
% This function allows to identify red objects in live video,
%  and painting them according to user-selectable colors: red, green or blue.
%
% No need computer vision toolbox
%% Operating Instructions
% To paint the color red object we vote to act as follows:
%
% * Red -  redobject(1)
% * Green -redobject(2)
% * Blue   - redobject(3)
%% Play and exit:
%
% * To start the video: click on the Play button.
% * To exit from the function: Display to the camera very dark image ,
%    for example you can shelter the camera with your hand,
%    Or turn off the light in the room.After doing so
%    The Camera and function should be closed automatically.
%% Notes
%  The identification of red objects in the picture depends on the lighting of the room.
%  Lighting Fluorescent light is the most appropriate lighting to this function to identify red objects.
%
%  first edited  in 27/04/2013 Saturday .
%  by Oren berkovich.


function redobject(color)    
    
%condition for the color defulte
if nargin==1
        if isnumeric(color)==false
            color=1;
        elseif ((1<=color)&&(color<=3))==false
            color=1;
        end
else
    color=1;
end
            
        


    ply= uicontrol('style','togg','units','normalized',...
        'position',[0.1 0.1 0.1 0.1],'str','Play','callback',{@PlayvideoLive});    
    
   
    function PlayvideoLive(~,~)
   
        set(ply,'enable','off');
        pause(0.5);
        
        try
    imaqreset
    vid = videoinput('winvideo', 1, 'YUY2_320x240');
    vid.ReturnedColorspace = 'rgb';
    set(vid,'framesperTrigger',10,'TriggerRepeat',Inf);
        
      
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
% reduce one image fron another

rg=r-g;
gb=g-b;
rggb=rg-gb;


%% build the color filters

filter=rggb>26;
filter=uint8(filter);
F=filter.*rggb;

%% Remove objects less than the pixel size prescribing function

 bw=bwareaopen(F,1900);
 bw =imclearborder(bw);
 bw=imfill(bw,'holes');
 %% Identify the position of the marked
 bw = uint8(bw);
 
 
  fil = (b+50).*bw;
 
 
 %% Rebuild the RGB image, if the part has been lightened
 
 tv(:,:,color,1)=tv(:,:,color,1)+fil;
 
    figure(gcf)
    hold off
    imshow(tv(:,:,:,1))
    
    state =mean2(r);
    if state<20&&toc>20;
       break
    end
   
      end    
       stop(vid)
       imaqreset

       close gcf
       clc
       disp('good by')
    end
    
     
    end

