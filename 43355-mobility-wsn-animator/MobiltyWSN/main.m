%%
% Simple Mobility WSN Animator
% Author: Amburose Sekar.S
% E-mail: amburoseicanwin@gmail.com
% 
%%
clear all;
close all;  
clc;
%creation of nodes

   nr_fr=10;
 %  frames = moviein(nr_fr); 
   N=1000;
   Color='b';
   

%%

Totalnodes='10';  % Total Numbr of Nodes
n11=str2num(Totalnodes);
%%distance of nodes
min1=20;
max1=120;

%% Coverage Range

ca=20;

%%

o1 = floor(min1 + (max1-min1).*rand(1,n11));
o2 = floor(min1 + (max1-min1).*rand(1,n11));


%%  
%intiator
   
oint1=10;
oint2=10;

%figure(1)
global slider_data slider1_data
slider_data.val = 25;
slider1_data.val = 25;
  
global fh 

fh = figure('Position',[250 250 450 450],...
            'MenuBar','none','NumberTitle','off',...
            'Name','Simple Mobility WSN');
sh = uicontrol(fh,'Style','slider',...
               'Max',100,'Min',0,'Value',25,...
               'SliderStep',[0.05 0.2],...
               'Position',[10+90 10 100 20],...
               'Callback',@slider_callback);
           
           
sh1 = uicontrol(fh,'Style','slider',...
               'Max',100,'Min',0,'Value',25,...
               'SliderStep',[0.05 0.2],...
               'Position',[150+80 10 100 20],...
               'Callback',@slider1_callback);           
         
sth = uicontrol(fh,'Style','text','String',...
                'Animator Speed',...
                'Position',[10+90 25 100 20]);
            
     
sth1 = uicontrol(fh,'Style','text','String',...
                'Mobility Speed',...
                'Position',[150+80 25 100 20]);
            
            
            

setappdata(fh,'slider',slider_data); 
setappdata(fh,'slider',slider1_data); 



 for i=1:400%coverage range

     
  
     
     
  cla;   

  axis([min1-30 max1+30 min1-30 max1+30]) 
  hold on
  
int=[1 2 3 4 5 6 7 8 9 10];
%axis([0 100 0 100])
%Access Point

okgc1=40;
okgc2=40;

plot(okgc1,okgc2,'s','LineWidth',1,...
              'MarkerEdgeColor','k',...
              'MarkerFaceColor','r',...
              'MarkerSize',16);
          
   text(okgc1,okgc2,'AP','FontSize',8);        
  hold on
  
%% Mobility Range
m1=0.01+(slider1_data.val/100);

  aa=-1;
  ba=1;
  m=3;
  n=2;
  
  x = aa + (ba-aa)*rand(1,numel(o1));
  x1 = aa + (ba-aa)*rand(1,numel(o1));
  
  o11=o1+i.*x.*m1;
  o21=o2+i.*x1.*m1;
  
       hold on
      plot(o11,o21,'o','LineWidth',1,...
              'MarkerEdgeColor','k',...
              'MarkerFaceColor','y',...
              'MarkerSize',12);
      
       for j=1:n11     
          text(o11(j),o21(j),int2str(j),'FontSize',8);
       end    
     hold on
     


  %plotpoint(i,[oint1 okgc1],[oint2 okgc2],'b');  
  
     d=sqrt((oint1-okgc1)^2+(oint2-okgc2)^2);
     d2=max(sqrt((o1-okgc1).^2+(o2-okgc2).^2));
    
    da=[];
    for j=1:numel(int)
    da(:,j)=(sqrt((o11-o11(int(j))).^2+(o21-o21(int(j))).^2));
    end
  
  k=d;
  
      
      for j=1:numel(int)
      [v1 ind]=find(da(:,j)<ca & da(:,j~=0));
        for v=1:numel(v1)  
            plotpoint(i-0,[o11(int(j)) o11(int(v1(v)))],[o21(int(j)) o21(int(v1(v)))],'r')  
        end
      end

    
     k2=d2+d;   %find k2 value
    
  
  
  z=rem(i,k);
  
  if (i>=k && i<2*k)%(2*d2+d)
       da=[];
    for j=1:numel(int)
    da(:,j)=(sqrt((o11-o11(int(j))).^2+(o21-o21(int(j))).^2));
    end
      
      
      for j=1:numel(int)
      [v1 ind]=find(da(:,j)<20 & da(:,j~=0));
        for v=1:numel(v1)  
            plotpoint(i-k,[o11(int(j)) o11(int(v1(v)))],[o21(int(j)) o21(int(v1(v)))],'r')  
        end
      end
      
  end
  
  if i>=2*k%(2*d2+d)
      
       da=[];
    for j=1:numel(int)
    da(:,j)=(sqrt((o11-o11(int(j))).^2+(o21-o21(int(j))).^2));
    end
    
    
      
      for j=1:numel(int)
      [v1 ind]=find(da(:,j)<20 & da(:,j~=0));
        for v=1:numel(v1)  
            plotpoint(i-2.*k,[o11(int(j)) o11(int(v1(v)))],[o21(int(j)) o21(int(v1(v)))],'r')  
        end
      end
      
  end

kk=1.2*d2+d;
 if i>=(1.2*d2+d)
  break;
 end
     
    sth3 = uicontrol(fh,'Style','text','String',...
                strcat('Percentage to Completed-->',num2str(floor((i/kk).*100)),' %'),...
                'Position',[250+100  10 100 35]);         
         hold on
         
         frames(:, i) = getframe;
         za=10/(slider_data.val+0.001);
         pause(za)
 end

   save frames
    
    load frames
    fh2 = figure('Position',[250 250 450 450],...
            'MenuBar','none','NumberTitle','off',...
            'Name','Simple Mobility WSN');
    movie(frames,1,10,[1 2 0 100])

  


 




          
          
          
