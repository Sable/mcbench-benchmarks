function [color]= rgbcolor(x,y,color)


xr=20;xg=xr+40;xb=xr+80;

%% Red color

if x>xr&&x<xr+20&&y>1&&y<20
   rectangle('Position',[xr,1,20,20],'Curvature',[1,1],'facecolor','r') 
   color ='r';
   
rectangle('Position',[xg,1,20,20],'Curvature',[1,1],'edge','g')
text(xg+5,10,'Green')
rectangle('Position',[xb,1,20,20],'Curvature',[1,1],'edge','b')
text(xb+5,10,'Blue')
rectangle('Position',[xb+40,1,20,20],'Curvature',[1,1])
text(xb+45,10,'Erase')
   
   
   
   %% green color
     
elseif x>xg&&x<xg+20&&y>1&&y<20
       rectangle('Position',[xg,1,20,20],'Curvature',[1,1],'facecolor','g') 
       color ='g';
   
   
rectangle('Position',[xr,1,20,20],'Curvature',[1,1],'edge','r')
text(xr+5,10,'Red')
rectangle('Position',[xb,1,20,20],'Curvature',[1,1],'edge','b')
text(xb+5,10,'Blue')
rectangle('Position',[xb+40,1,20,20],'Curvature',[1,1])
text(xb+45,10,'Erase')


   
   %% blue color
   
   elseif x>xb&&x<xb+20&&y>1&&y<20
       rectangle('Position',[xb,1,20,20],'Curvature',[1,1],'facecolor','b') 
   color ='b';
   
   
rectangle('Position',[xr,1,20,20],'Curvature',[1,1],'edge','r')
text(xr+5,10,'Red')
rectangle('Position',[xg,1,20,20],'Curvature',[1,1],'edge','g')
text(xg+5,10,'Green')
rectangle('Position',[xb+40,1,20,20],'Curvature',[1,1])
text(xb+45,10,'Erase')



else
    hold on
rectangle('Position',[xr,1,20,20],'Curvature',[1,1],'edge','r')
text(xr+5,10,'Red')
rectangle('Position',[xg,1,20,20],'Curvature',[1,1],'edge','g')
text(xg+5,10,'Green')
rectangle('Position',[xb,1,20,20],'Curvature',[1,1],'edge','b')
text(xb+5,10,'Blue')
rectangle('Position',[xb+40,1,20,20],'Curvature',[1,1])
text(xb+45,10,'Erase')
  
end
    
axis off        


hold on



