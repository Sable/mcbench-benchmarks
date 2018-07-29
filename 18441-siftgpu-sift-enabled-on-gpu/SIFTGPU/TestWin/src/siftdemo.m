clear

mex -c mysift.cpp
mex mysift.cpp

% the name of your image should be entered in the line below
imname='Blue2.jpg';

% set the sift parameters in the line below
[descriptors keys]=mysift({'-e', '10'},{imname});

x=keys(1,:);
y=keys(2,:);
scale=keys(3,:);
ori=keys(4,:);


im=imread(imname);
figure
        imshow(im)
        hold on



hws=4;


ROIname=[imname(1:length(imname)-4) 'ROI.tif'];
    if exist(ROIname)    
        
        ROI=imread(ROIname);
        %pos=[y' x'];
        [descriptors,xx,yy,scale,ori]=keepROI(ROI,x,y,scale,ori,descriptors,size(descriptors,2));
        x=xx;
        y=yy;

        for i=1:size(ori,2)
    
            
    
                c=cos(ori(i));
                s=sin(ori(i));
                rotate=[c -s; s c];
                corners(1:2,1)=rotate*[1 1]';
                corners(1:2,2)=rotate*[-1 1]';
                corners(1:2,3)=rotate*[-1 -1]';
                corners(1:2,4)=rotate*[1 -1]';
                corners(1:2,5)=corners(1:2,1);
    
                cornersx=(corners(1,:)*hws*scale(i))+x(i);   
                cornersy=(corners(2,:)*hws*scale(i))+y(i);
    
                oriplot=[x(i)+hws*scale(i)*cos(ori(i)), y(i)+hws*scale(i)*sin(ori(i))];

    
               scale2=scale(i);
               if i==1 
                    scale1=scale(i);
                    pc=rand(3,1);
               end
               if scale2~=scale1
                    pc=rand(3,1);   
               end
               scale1=scale2;

               
               
               plot([x(i)+0.25*hws*scale(i)*cos(ori(i)) oriplot(1)],[y(i)+0.25*hws*scale(i)*sin(ori(i)) oriplot(2)],'Color',pc)
               plot(cornersx,cornersy,'Color',pc)
              % plot(x(i),y(i),'g+')
 
  
    
        end
    else

        
        plot(x,y,'g.')  
    
    end
%%

    storedata=input('Do you want to store that data? (1-yes, 2-no): ');          
          
if storedata==1 && i~=0
    
    
        
        
        
        
    database.desc=descriptors';
    database.scale=scale';
    database.ori=ori';
    database.im=im;
    database.pos(:,1)=x';
    database.pos(:,2)=y';
  
    save('SIFT_DATABASE.mat', 'database')
 
end
          

match=input('Do you want to match the descriptors with the database? (1-yes, 2-no): ');     

if match==1 && i~=0

    
    desc=descriptors';
    scale=scale';
    ori=ori';
    pos(:,1)=x';
    pos(:,2)=y';
    
    
    load SIFT_DATABASE.mat
    IM=im;
    matchlala


end





