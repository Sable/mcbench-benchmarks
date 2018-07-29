%%
% Simple WSN Animator2
% Author: Amburose Sekar.S
% E-mail: amburoseicanwin@gmail.com
% Future Work---Full supported WSN toolbox using parrallel computing
% 
%%
clear all;
close all;
clc;
%creation of nodes

   nr_fr=10;
   frames = moviein(nr_fr); 
   N=1000;
   Color='b';
   


Totalnodes='10';  % Total Numbr of Nodes
n11=str2num(Totalnodes);
%%distance of nodes
min1=20;
max1=120;


%%


for i1=1:n11
    if i1==1 
        node(i1,:)=cat(2,i1+1:n11,n11);
    else   
        node(i1,:)=floor(n11*rand(1,n11))+1;
    end
end   


o1 = floor(min1 + (max1-min1).*rand(1,n11));
o2 = floor(min1 + (max1-min1).*rand(1,n11));


%%
%intiator

oint1=10;
oint2=10;

figure(1)

 for i=1:400%coverage range

  cla;   
     
 plot(oint1,oint2,'*','LineWidth',1,...
              'MarkerEdgeColor','k',...
              'MarkerFaceColor','y',...
              'MarkerSize',12);
  text(oint1,oint2,'intiator','FontSize',8);          
  
   axis([min1-30 max1+30 min1-30 max1+30]) 
  hold on
  
int=[1 3 4 5 7 8 9 10];
%axis([0 100 0 100])
%KGC

okgc1=40;
okgc2=40;

plot(okgc1,okgc2,'o','LineWidth',1,...
              'MarkerEdgeColor','k',...
              'MarkerFaceColor','r',...
              'MarkerSize',16);
          
   text(okgc1,okgc2,'CH','FontSize',8);        
  hold on
  
  
       hold on
      plot(o1,o2,'^','LineWidth',1,...
              'MarkerEdgeColor','k',...
              'MarkerFaceColor','y',...
              'MarkerSize',12);
      
       for j=1:n11     
          text(o1(j),o2(j),int2str(j),'FontSize',12);
       end    
     hold on
     


  plotpoint(i,[oint1 okgc1],[oint2 okgc2],'b');  
  
  d=sqrt((oint1-okgc1)^2+(oint2-okgc2)^2);
  
    d2=max(sqrt((o1-okgc1).^2+(o2-okgc2).^2));
  
  k=d;
  %k=40;  % find k value
  if i>k



    for j=1:numel(int)
        
        plotpoint(i-k,[okgc1 o1(int(j))],[okgc2 o2(int(j))],'r')  
    end
    
    
     k2=d2+d;   %find k2 value
    
    
    if i>k2
      
       for j=1:numel(int)
               plotpoint(i-k2,[o1(int(j)) okgc1],[o2(int(j)) okgc2],'k')  
       end 
        
    end    

      
      
  end
  
  
  
  
  if i>=(2*d2+d)
  
  break;
  end



          
         hold on
         
  

         frames(:, i) = getframe;

     
 end

    save frames
    
    load frames
    figure(2)
    movie(frames,1,60,[1 2 0 100])

  


 




          
          
          
