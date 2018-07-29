%BZreaction animation
%Belousov-Zhabotinsky Reaction animation
%This MATLAB code is converted from Processing code available in this link
%http://www.aac.bartlett.ucl.ac.uk/processing/samples/bzr.pdf

%version 2. Corrected the drift of pixels as suggested
%           by Jonh.

xres=75; %x resolution
yres=75; %y resolution

a=rand(xres,yres,2);
b=rand(xres,yres,2);
c=rand(xres,yres,2);
c_a = zeros(xres,yres);
c_b = zeros(xres,yres);
c_c = zeros(xres,yres);
p = 1;
q = 2;
img=zeros(xres,yres,3);

for k=1:100
         c_a = 0*c_a;
         c_b = 0*c_b;
         c_c = 0*c_c;
         for m=1:xres
            for n=1:yres
               for mm = m:m+2
                  for nn = n:n+2
                    c_a(m,n) =c_a(m,n)+ a( mod(mm+xres,xres)+1 ,mod(nn+yres,yres)+1 ,p);
                    c_b(m,n) =c_b(m,n)+ b( mod(mm+xres,xres)+1 ,mod(nn+yres,yres)+1 ,p);
                    c_c(m,n) =c_c(m,n)+ c( mod(mm+xres,xres)+1 ,mod(nn+yres,yres)+1 ,p);
                  end
               end
            end
         end

        %correction of pixel drift  
        c_a = circshift(c_a,[2 2]);
        c_b = circshift(c_b,[2 2]);
        c_c = circshift(c_c,[2 2]);

        c_a =c_a/ 9.0;
        c_b =c_b/ 9.0;
        c_c =c_c/ 9.0;
        
        a(:,:,q) = double(uint8(255*(c_a + c_a .* (c_b - c_c))))/255;
        b(:,:,q) = double(uint8(255*(c_b + c_b .* (c_c - c_a))))/255;
        c(:,:,q) = double(uint8(255*(c_c + c_c .* (c_a - c_b))))/255;
        
        img(:,:,1)=c(:,:,q);
        img(:,:,2)=b(:,:,q);
        img(:,:,3)=a(:,:,q);
   
        if  p == 1
          p = 2; q = 1;
        else 
          p = 1; q = 2;
        end

        image(uint8(255*hsv2rgb(img)))
        axis equal off
        drawnow
end

