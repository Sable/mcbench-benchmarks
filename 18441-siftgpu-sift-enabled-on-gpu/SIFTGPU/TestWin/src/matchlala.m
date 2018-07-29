thresh=inf;
percentile=7; %=1 for nVIDIA 8800GTX 

    pos2=[pos(:,1) pos(:,2)];
    %scale2=PYRAMIDSCALE';
    %orient2=ORIENTATION';
    desc2=descriptors';
    disp(['size(descriptors) = ' num2str(size(desc2))])
    
    load SIFT_DATABASE.mat
    
    
    %[im_idx trans theta rho idx nn_idx wght] = hough( database, pos2, scale2, orient2, desc2, 1.5 );
    
    
  
    
ii=0;
%%    
matchplot=[];
%%    
    
    for i=1:size(desc2,1)
        nn=find_nearest_neighbours(database,desc2(i,:),1.5,thresh);
        if nn(1)~=0 
          % disp(['point ' num2str(i) ' matches point ' num2str(nn(1)) ' in database. Euclidean distance is ' num2str(nn(2))]) 
%%           
        
           x=pos2(i,1);%/pyramid;
                                        y=pos2(i,2);%/pyramid;
                                        ii=ii+1;
                                        matchplot(ii,1:2)=[x y];
                                        matchidx(ii,1:2)=nn(1);
                                        dist(ii)=nn(2);
%%           
        end
    end
    
    
thresh=prctile(dist,percentile);
%thresh=346
    
    

    

    
ii=0;
%%    
matchplot=[];
%%    
    
    for i=1:size(desc2,1)
        nn=find_nearest_neighbours(database,desc2(i,:),1.5,thresh);
        if nn(1)~=0 
           disp(['point ' num2str(i) ' matches point ' num2str(nn(1)) ' in database. Euclidean distance is ' num2str(nn(2))]) 
%%           
         x=pos2(i,1);%/pyramid;
                                        y=pos2(i,2);%/pyramid;
                                        ii=ii+1;
                                        matchplot(ii,1:2)=[x y];
                                        matchidx(ii,1:2)=nn(1);
                                        dist(ii)=nn(2);
                                        NN(ii,1:2)=nn;
%%           
        end
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

figure 
                                        [x1 y1]=meshgrid(1:size(database.im,2),1:size(database.im,1));
                                        xinset=size(database.im,2)+100;
                                        yinset=size(database.im,1);
                                        [x2 y2]=meshgrid(xinset+1:xinset+size(IM,2),yinset+1:yinset+size(IM,1));
                                        z1(1:size(database.im,1),1:size(database.im,2))=0;
                                        z2(1:size(IM,1),1:size(IM,2))=0;
                                        colour1=single(database.im);
                                        colour2=single(IM);
                                        warp(x1,y1,z1,database.im);
                                        hold on
                                        warp(x2,y2,z2,IM);
                                        
                                        view(0,90)
  if size(matchplot,1)~=0                                      
      for i=1:size(matchplot,1)
          XX=[database.pos(matchidx(i),1) matchplot(i,1)+xinset];
          YY=[database.pos(matchidx(i),2) matchplot(i,2)+yinset];
          plot(XX,YY,'g','MarkerSize',10)
      end
  end              
                                        
    grid off
    axis off
          
%%i


%figure
    %imshow(theta(:,:,1),[])
%[x y]=meshgrid(1:2*hws+1, 1:2*hws+1);
%surf(x,y,M(:,:,6))
%shading interp
%G=ORI(:,:,6);
%for i=1:(hws+1)^2
%    ori(i)=G(i);
%end
%n = hist(ori,36);