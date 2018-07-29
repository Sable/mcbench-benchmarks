function segment=skin(I);

I=double(I);
[hue,s,v]=rgb2hsv(I);

cb =  0.148* I(:,:,1) - 0.291* I(:,:,2) + 0.439 * I(:,:,3) + 128;
cr =  0.439 * I(:,:,1) - 0.368 * I(:,:,2) -0.071 * I(:,:,3) + 128;
[w h]=size(I(:,:,1));

for i=1:w
    for j=1:h            
        if  140<=cr(i,j) & cr(i,j)<=165 & 140<=cb(i,j) & cb(i,j)<=195 & 0.01<=hue(i,j) & hue(i,j)<=0.1     
            segment(i,j)=1;            
        else       
            segment(i,j)=0;    
        end    
    end
end

% imshow(segment);
im(:,:,1)=I(:,:,1).*segment;   
im(:,:,2)=I(:,:,2).*segment; 
im(:,:,3)=I(:,:,3).*segment; 
% figure;imshow(uint8(im));
  
