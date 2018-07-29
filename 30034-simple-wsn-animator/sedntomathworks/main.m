%%
% Simple WSN Animator
% Author: Amburose Sekar.S
% E-mail: amburoseicanwin@gmail.com
% Date  : jan.15.2011
% Future Work---Full supported WSN toolbox using parrallel computing
% 
%%
clear all;
close all;
clc;
%creation of nodes


Totalnodes='10';  % Total Numbr of Nodes
n11=str2num(Totalnodes);
%%distance of nodes
min=20;
max=120;


%%


for i1=1:n11
    if i1==1 
        node(i1,:)=cat(2,i1+1:n11,n11);
    else   
        node(i1,:)=floor(n11*rand(1,n11))+1;
    end
end   


o1 = floor(min + (max-min).*rand(1,n11));
o2 = floor(min + (max-min).*rand(1,n11));


figure(1)
 plot(o1,o2,'^','LineWidth',1,...
              'MarkerEdgeColor','k',...
              'MarkerFaceColor','y',...
              'MarkerSize',12);
   hold on
          
    for i=1:n11     
     text(o1(i),o2(i),int2str(i),'FontSize',12);
    end
   hold on; 
   
   nr_fr=10;
   frames = moviein(nr_fr); 
   N=1000;
   Color='b';
   
 for i=1:100%coverage range
    
       cla
 
      axis([min-30 max+30 min-30 max+30])
      hold on
      plot(o1,o2,'^','LineWidth',1,...
              'MarkerEdgeColor','k',...
              'MarkerFaceColor','y',...
              'MarkerSize',12);
      
       for j=1:n11     
          text(o1(j),o2(j),int2str(j),'FontSize',12);
       end    
     hold on
     
        
               plotpoint(i,[o1(1) o1(4)],[o2(1) o2(4)])  
               plotpoint(i,[o1(2) o1(8)],[o2(2) o2(8)])  
              
               plotpoint(i,[o1(3) o1(7)],[o2(3) o2(7)])  
               plotpoint(i,[o1(6) o1(10)],[o2(6) o2(10)])  
    

          
         hold on
         
  

         frames(:, i) = getframe;

     
 end

   save frames
   figure(2)
   movie(frames,1,60,[1 2 0 100])

  


 




          
          
          
