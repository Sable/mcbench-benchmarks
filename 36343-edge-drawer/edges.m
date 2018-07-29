function edges
%edges is a simple edge detector program to make funny pictures from photos. The code is a version of [1]
% 
% NOTE:The program takes a while to create the final image so wait until it
% asks for the name of the final image.
% 
% INPUTS: 
%       The function can be called edges because the function has a GUI that
%       lets you select an existing image. Allowed formats are *.jpg *.tif
%       *.png and *.bmp
%       
%
%
% OUTPUTS: 
%       Once you finish your edition, the GUI allows you to save the final
%       image as a *.tif image.
%     
%
%  References:
%  [1] Daker Edges by Angel Johnsy.
%      http://angeljohnsy.blogspot.com.es/2011/09/darker-edges.html
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
global A AA I cmap target info;        
        
%First we set GUI. A Windown a button and two sliders.
scz=get(0,'ScreenSize');
Width=round(scz(1,3));
Height=round(scz(1,4));

figure('Position',[round(Width/4) round(Height/4) round(Width/2) round(Height/2)],'MenuBar','None','NumberTitle','off','Name','Edge_Drawer','Resize','off');
axes('Position',[0 0 .7 1],'xtick',[],'ytick',[]);


Posx=round(Width/2)-200;
Posy=round(Height/2);


uicontrol('Style','pushbutton','String','Load Image','Position',[Posx Posy-30 80 20],'Callback',@loadme);
uicontrol('Style','pushbutton','String','Save Final','Position',[Posx+100 Posy-30 80 20],'Callback',@saveme);




Posy=round(Height/2)-100;


uicontrol('style','text','Position',[Posx,Posy 100 20]','String','High:');
High1=uicontrol('Style','slider','Position',[Posx,Posy-20 200 20],'Max',1,'Min',0.1,'Value',.5,'SliderStep',[0.05,0.1],'Callback',@draw1);
uicontrol('style','text','Position',[Posx,Posy-40 100 20]','String','Low:');
Low1=uicontrol('Style','slider','Position',[Posx,Posy-60 200 20],'Max',0.99 ,'Min',0,'Value',0.0,'SliderStep',[0.05,0.1],'Callback',@draw1);

Posy=round(Height/2)-280;

uicontrol('style','text','Position',[Posx,Posy 100 20]','String','High:');
High2=uicontrol('Style','slider','Position',[Posx,Posy-20 200 20],'Max',1,'Min',0.1,'Value',.5,'SliderStep',[0.05,0.1],'Callback',@draw2);
uicontrol('style','text','Position',[Posx,Posy-40 100 20]','String','Low:');
Low2=uicontrol('Style','slider','Position',[Posx,Posy-60 200 20],'Max',0.99 ,'Min',0,'Value',0.0,'SliderStep',[0.05,0.1],'Callback',@draw2);

Posy=round(Height/2)-450;

uicontrol('style','text','Position',[Posx,Posy 100 20]','String','High:');
High3=uicontrol('Style','slider','Position',[Posx,Posy-20 200 20],'Max',1,'Min',0.1,'Value',.5,'SliderStep',[0.05,0.1],'Callback',@draw3);
uicontrol('style','text','Position',[Posx,Posy-40 100 20]','String','Low:');
Low3=uicontrol('Style','slider','Position',[Posx,Posy-60 200 20],'Max',0.99 ,'Min',0,'Value',0.0,'SliderStep',[0.05,0.1],'Callback',@draw3);

function draw1(obj,eve)
        H1=get(High1,'Value');
        L1=get(Low1,'Value'); 
        I(:,:,1)=imadjust(A(:,:,1),[L1; H1],[]);
        draw()
end

function draw2(obj,eve)        
        H2=get(High2,'Value');
        L2=get(Low2,'Value');  
        I(:,:,2)=imadjust(A(:,:,2),[L2; H2],[]);
        draw()
end

function draw3(obj,eve)        
        H3=get(High3,'Value');
        L3=get(Low3,'Value');  
        I(:,:,3)=imadjust(A(:,:,3),[L3; H3],[]);
        draw()
end

function draw(obj,eve)
    

        A1=rgb2gray(I);
        B=(edge(I(:,:,1))|edge(I(:,:,2))|edge(I(:,:,3))); 
        SE=strel('disk',1);
        C=~(imdilate(B,SE));
        target=(ones([size(A1,1) size(A1,2)] ));
        [BW,label]=bwlabel(~C,4);
        for l=1:max(max(label))
        [row, col] = find(BW==l);
        if(size(row,1)>30)
        for i=1:size(row,1)
            x=row(i,1);
            y=col(i,1);
            target(x,y)=C(x,y);
        end
        end
        end
        %Red color
        R=I;
        R(:,:,2)=0.*R(:,:,2);
        R(:,:,3)=0.*R(:,:,3);
        subplot('Position',[0   0.5 .45 .45]);imshow(I);title('Original Image Adjusted (Low Res)');
        subplot('Position',[0.5 0.6 .30 .25]);imshow(R);title('RED');
        %Green color
        G=I;
        G(:,:,1)=0.*G(:,:,1);
        G(:,:,3)=0.*G(:,:,3);
        subplot('Position',[0.5 0.3 .30 .25]);imshow(G);title('GREEN');
        %Blue color
        B=I;
        B(:,:,1)=0.*B(:,:,1);
        B(:,:,2)=0.*B(:,:,2);
        subplot('Position',[0.5 0   .30 .25]);imshow(B);title('BLUE');        
        subplot('Position',[0   0   .45 .45]);imshow(target);title('Final Image (Low Res)');
    end

    function loadme(obj,ev)
        
        [name,path]=uigetfile('*.*','Image load','MultiSelect','on');
        if path ~=0
        filename=[path,name];  
        info = imfinfo(filename);
        [AA,cmap]=imread(filename);        
        if strcmp(info.ColorType,'truecolor')==1
        
          
        elseif strcmp(info.ColorType,'grayscale')==1
       
           
        elseif strcmp(info.ColorType,'indexed')==1
        AA = ind2rgb(AA,cmap);
           
        end       
        
        A = imresize(AA, 0.5);
        I=A;
        draw()
        end
        
    end

    function saveme(obj,ev)
        H1=get(High1,'Value');
        L1=get(Low1,'Value');  
        H2=get(High2,'Value');
        L2=get(Low2,'Value');  
        H3=get(High3,'Value');
        L3=get(Low3,'Value');  
        I2=AA;
        I2=imadjust(AA,[L1 L2 L3;H1 H2 H3],[]);
        A1=rgb2gray(I2);
        B=(edge(I2(:,:,1))|edge(I2(:,:,2))|edge(I2(:,:,3)));
        SE=strel('disk',1);
        C=~(imdilate(B,SE));
        target=(ones([size(A1,1) size(A1,2)] ));
        [BW,label]=bwlabel(~C,4);
        for l=1:max(max(label))
        [row, col] = find(BW==l);
        if(size(row,1)>30)
        for i=1:size(row,1)
            x=row(i,1);
            y=col(i,1);
            target(x,y)=C(x,y);
        end
        end
        end                
        [file,path] = uiputfile('*.tif','Save file name');
        if path ~=0
        filename=[path,file];    
        figure('visible','off');
        imshow(target);
        saveas(gca,[filename,'.tif']);
        close gcf  
        end
    end

end

