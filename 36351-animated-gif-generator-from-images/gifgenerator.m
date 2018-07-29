function gifgenerator
%gifgenerator is a simple srcipt with GUI to generate animetd gif from
%multiple images. It supports image formats *.jpg *.tiff *.bmp
%and *.png.
%All images must have same size.
% 
% 
% INPUTS: 
%       The function can be called gifgenerator.
%       
%
%
% OUTPUTS: 
%       Once you finish your edition, the GUI allows you to save the final
%       animated gif.     
%
%
%
%This function was written by :
%                             Héctor Corte
%                             B.Sc. in physics 2010
%                             Battery Research Laboratory
%                             University of Oviedo
%                             Department of Electrical, Computer, and Systems Engineering
%                             Campus de Viesques, Edificio Departamental 3 - Office 3.2.05
%                             PC: 33204, Gijón (Spain)
%                             Phone: (+34) 985 182 559
%                             Fax: (+34) 985 182 138
%                             Email: cortehector@uniovi.es
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b=[];
imind=[];
cm=[];
        
%First we set GUI. A Windown with buttons to set options, load and save
%images.
scz=get(0,'ScreenSize');
figure('Position',[round(scz(1,3)/2) round(scz(1,4)/4) 700 500],'MenuBar','None','NumberTitle','off','Name','Animated_gif_generator','Resize','off');
axes('Position',[0 0 .7 1],'xtick',[],'ytick',[]);

uicontrol('Style','pushbutton','String','Load Images','Position',[500 200 80 20],'Tag','loadbutton','Callback',@loadme);
uicontrol('Style','pushbutton','String','Save Animated gif','Position',[600 200 80 20],'Tag','savebutton','Callback',@saveme);
uicontrol('Style','pushbutton','String','Play','Position',[550 250 80 40],'Callback',@draw);

uicontrol('style','text','Position',[500,350 100 40]','String','Time between images:');
Time=uicontrol('Style','edit','String','0.050','Position',[500 330 80 20]);
bdown=uicontrol('Style','pushbutton','Position',[590 320 20 20],'Callback',@timedown);
bup=uicontrol('Style','pushbutton','Position',[590 340 20 20],'Callback',@timeup);

up=imread('up.png');
up = imresize(up, 0.30);
set(bup,'CData',up);
set(bup,'TooltipString','More Time')
down=imread('down.png');
down = imresize(down, 0.30);
set(bdown,'CData',down);
set(bdown,'TooltipString','Less Time')
uicontrol('style','text','Position',[500,440 200 40]','String','Compression Rate (Affects final file size, only avalible with Image Proccesing Toolbox)');
lista{1}='1';lista{2}='0.75';lista{3}='0.5';lista{4}='0.25';
hPopup=uicontrol('style','popupmenu','Position',[500,410 100 20]','String',lista);

%To increase or decrease timelapse between images on final gif.
    function timedown(obj,eve)
        T= str2double(get(Time,'String'));
        if T>0.005
            set(Time,'String',num2str(-0.005+T));  
        end
    end
    function timeup(obj,eve)
        T= str2double(get(Time,'String'));
        if T>0.005
            set(Time,'String',num2str(+0.005+T));  
        end
    end

%To make an animation of how final gif will be.

    function draw(obj,eve)
        T=str2double(get(Time,'String'));          
        for n=1:b
         subplot('Position',[0 0   0.7 1]);image(imind{n});title('gif preview');
        colormap(cm{n})
        axis off
         drawnow()
         pause(T)
        end        
    end

%To upload images into program and convert them into indexed images.
    function loadme(obj,eve)
        [name,path]=uigetfile('*.*','Image load','MultiSelect','on');
        [~,b]=size(name);       
        if b > 1
          info = imfinfo([path,name{1}]);
        for n = 1:b
            [im{n},cmap{n}] = imread([path,name{n}]); 
        end
           for n = 1:b               
               %Convert images to indexed images 
               if strcmp(info.ColorType,'truecolor')==1
                   [imind{n},cm{n}] = rgb2ind(im{n},256);
               elseif strcmp(info.ColorType,'grayscale')==1
                   [imind{n},cm{n}] =  gray2ind(im{n});
               elseif strcmp(info.ColorType,'indexed')==1
                   imind{n}=im{n};   
                   cm{n}=cmap{n};
               end
           end
           draw()
        end
    end

%To save images as a gif.
    function saveme(obj,ev)
             [file,path] = uiputfile('*.gif','Save file name');             
        if length(path)>1
            val = get(hPopup,'Value');
            string_list = get(hPopup,'String');
            CR =str2double( string_list{val});
            T=str2double(get(Time,'String'));
            filename = [path,file];
          
        for n = 1:b
            try
                %If Image Processing is avalible then we can use it to
                %serize image, if not we use a simple interpolation. 
                [imind2 cm2] = imresize(imind{n},cm{n}, CR); 
            catch err
                imind2 = imind{n};
                cm2=cm{n};
            end            
            if n == 1;
                imwrite(imind2,cm2,filename,'gif', 'Loopcount',inf,'DelayTime',T);
            else
                imwrite(imind2,cm2,filename,'gif','WriteMode','append','DelayTime',T);
            end
        end
        end
    end
end

