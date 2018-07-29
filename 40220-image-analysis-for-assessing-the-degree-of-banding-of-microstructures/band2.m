function band2
A=imread('band.jpg');

tipoimagen=size(size(A));

if tipoimagen(2)==3

    A=rgb2gray(A);

end 

s=size(A);
w=s(2);
a=s(1);

%Step 2

for j=1:a
    
    m=mean(A(j,:));
    
    for i=1:w
    
        A(j,i)=m;
        
    end 
    
end

%Step 3

level = graythresh(A);

AW = im2bw(A,level);

imshow(AW)


  
    
  
