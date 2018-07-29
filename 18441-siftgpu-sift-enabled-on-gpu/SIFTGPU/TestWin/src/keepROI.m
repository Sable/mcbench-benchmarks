function [DESCRIPTORS,X,Y,SCALE,ORI]=keepROI(ROI,x,y,scale,ori,descriptors,descriptorcount)

X=[];
 Y=[];
 DESCRIPTORS=[];
  SCALE=[];
        ORI=[];
ii=0;


for i=1:descriptorcount
    
  %  if ori(i)>=10
  %i=i
   % xxx=x(i)
   % yyy=y(i)
    if ROI(floor(y(i)),floor(x(i)))==255
        ii=ii+1;
        X(ii,1)=x(i);
        Y(ii,1)=y(i);
        DESCRIPTORS(:,ii)=descriptors(:,i);
        SCALE(ii)=scale(i);
        ORI(ii)=ori(i);
    end
    
  %  end
    
end
        
   
    
    
    
    
    
    
    
    