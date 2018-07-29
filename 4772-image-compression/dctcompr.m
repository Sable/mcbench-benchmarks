function [im] = dctcompr (infile,coeff,outfile)
% DCTCOMPR (infile,coeff,outfile)
% Image compression based on Discrete Cosine Transform.
%  infile is input file name present in the current directory
%  coeff is the number of coefficients with the most energy
%  outfile is output file name which will be created
%
% Example of use:
% out=imcompr('input_image.bmp',2000,'output_image.bmp');
% 
% The input image A can be RGB or GRAYSCALE.
%
% RGB case:
% If A is of class double, all values must be in the range [0,1],
% and A must be m-by-n-by-3.
% If A is of class uint16 or uint8, A must be m-by-n-by-3.
% The same number of coefficients are selected for each component
% (red, green and blue).
%
% GRAYSCALE case:
% If A is of class double, all values must be in the range [0,1], 
% and the number of dimensions of A must be 2. If A is of class
% uint16 or uint8, the number of dimensions of A must be 2.
% uint16 or double.
%
% 
% 
%
% References:
%
% For more details concernings the algorithm implemented please visit the following links:
% 
%  http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=4328&objectType=file
% 
%  http://www.ece.purdue.edu/~ace/jpeg-tut/jpegtut1.html
% 
% Please contribute if you find this software useful.
% Report bugs to luigi.rosa@tiscali.it
%
%
%*****************************************************************
% Luigi Rosa
% Via Centrale 27
% 67042 Civita di Bagno
% L'Aquila --- ITALY 
% email  luigi.rosa@tiscali.it
% mobile +39 340 3463208 
% http://utenti.lycos.it/matlab
%*****************************************************************
%
%
if (exist(infile)==2)
    a = imread(infile);
    figure('Name','Input image');
    imshow(a);
else
    warndlg('The file does not exist.',' Warning ');
    im=[];
    return
end


if isrgb(a)  
    
    if isa(a(:,:,1),'uint8')
        red = double(a(:,:,1));
        green = double(a(:,:,2));
        blue = double(a(:,:,3));
        
        red_dct=dct2(red);
        green_dct=dct2(green);
        blue_dct=dct2(blue);
        
        red_pow   = red_dct.^2;
        green_pow = green_dct.^2;
        blue_pow  = blue_dct.^2;
        
        red_pow=red_pow(:);
        green_pow=green_pow(:);
        blue_pow=blue_pow(:);
        
        [B_r,index_r]=sort(red_pow);
        [B_g,index_g]=sort(green_pow);
        [B_b,index_b]=sort(blue_pow);
        
        index_r=flipud(index_r);
        index_g=flipud(index_g);
        index_b=flipud(index_b);
        
        im_dct_r=zeros(size(red));
        im_dct_g=zeros(size(green));
        im_dct_b=zeros(size(blue));
        
        for ii=1:coeff
            im_dct_r(index_r(ii))=red_dct(index_r(ii));
            im_dct_g(index_g(ii))=green_dct(index_g(ii));
            im_dct_b(index_b(ii))=blue_dct(index_b(ii));
        end
        
        im_r=idct2(im_dct_r);
        im_g=idct2(im_dct_g);
        im_b=idct2(im_dct_b);
        
        im=zeros(size(red,1),size(red,2),3);
        im(:,:,1)=im_r;
        im(:,:,2)=im_g;
        im(:,:,3)=im_b;
        
        im=uint8(im);
        
        imwrite(im, outfile);       
        
        
        figure('Name','Output image');
        imshow(im);
        
        return;
    end
    
    if isa(a(:,:,1),'uint16')
        red = double(a(:,:,1));
        green = double(a(:,:,2));
        blue = double(a(:,:,3));
        
        red_dct=dct2(red);
        green_dct=dct2(green);
        blue_dct=dct2(blue);
        
        red_pow   = red_dct.^2;
        green_pow = green_dct.^2;
        blue_pow  = blue_dct.^2;
        
        red_pow=red_pow(:);
        green_pow=green_pow(:);
        blue_pow=blue_pow(:);
        
        [B_r,index_r]=sort(red_pow);
        [B_g,index_g]=sort(green_pow);
        [B_b,index_b]=sort(blue_pow);
        
        index_r=flipud(index_r);
        index_g=flipud(index_g);
        index_b=flipud(index_b);
        
        im_dct_r=zeros(size(red));
        im_dct_g=zeros(size(green));
        im_dct_b=zeros(size(blue));
        
        for ii=1:coeff
            im_dct_r(index_r(ii))=red_dct(index_r(ii));
            im_dct_g(index_g(ii))=green_dct(index_g(ii));
            im_dct_b(index_b(ii))=blue_dct(index_b(ii));
        end
        
        im_r=idct2(im_dct_r);
        im_g=idct2(im_dct_g);
        im_b=idct2(im_dct_b);
        
        im=zeros(size(red,1),size(red,2),3);
        im(:,:,1)=im_r;
        im(:,:,2)=im_g;
        im(:,:,3)=im_b;
        
        im=uint16(im);
        
        imwrite(im, outfile);       
        
        
        figure('Name','Output image');
        imshow(im);
        
        
        return;
    end
    
    if isa(a(:,:,1),'double')
        red = double(a(:,:,1));
        green = double(a(:,:,2));
        blue = double(a(:,:,3));
        
        red_dct=dct2(red);
        green_dct=dct2(green);
        blue_dct=dct2(blue);
        
        red_pow   = red_dct.^2;
        green_pow = green_dct.^2;
        blue_pow  = blue_dct.^2;
        
        red_pow=red_pow(:);
        green_pow=green_pow(:);
        blue_pow=blue_pow(:);
        
        [B_r,index_r]=sort(red_pow);
        [B_g,index_g]=sort(green_pow);
        [B_b,index_b]=sort(blue_pow);
        
        index_r=flipud(index_r);
        index_g=flipud(index_g);
        index_b=flipud(index_b);
        
        im_dct_r=zeros(size(red));
        im_dct_g=zeros(size(green));
        im_dct_b=zeros(size(blue));
        
        for ii=1:coeff
            im_dct_r(index_r(ii))=red_dct(index_r(ii));
            im_dct_g(index_g(ii))=green_dct(index_g(ii));
            im_dct_b(index_b(ii))=blue_dct(index_b(ii));
        end
        
        im_r=idct2(im_dct_r);
        im_g=idct2(im_dct_g);
        im_b=idct2(im_dct_b);
        
        im=zeros(size(red,1),size(red,2),3);
        im(:,:,1)=im_r;
        im(:,:,2)=im_g;
        im(:,:,3)=im_b;
        
        imwrite(im, outfile);       
        
        figure('Name','Output image');
        imshow(im);
        return;
    end
end

if isgray(a)
    
    dvalue=double(a);
    
    
    if isa(a,'uint8')
        img_dct=dct2(dvalue);
        img_pow=(img_dct).^2;
        img_pow=img_pow(:);
        [B,index]=sort(img_pow);
        B=flipud(B);
        index=flipud(index);
        
        compressed_dct=zeros(size(dvalue));
        for ii=1:coeff
            compressed_dct(index(ii))=img_dct(index(ii));
        end
        im=idct2(compressed_dct);
        im=uint8(im);
    end
    
    if isa(a,'uint16')
        img_dct=dct2(dvalue);
        img_pow=(img_dct).^2;
        img_pow=img_pow(:);
        [B,index]=sort(img_pow);
        B=flipud(B);
        index=flipud(index);
        
        compressed_dct=zeros(size(dvalue));
        for ii=1:coeff
            compressed_dct(index(ii))=img_dct(index(ii));
        end
        im=idct2(compressed_dct);
        im=uint16(im);
        
    end
    
    if isa(a,'double')
        img_dct=dct2(dvalue);
        img_pow=(img_dct).^2;
        img_pow=img_pow(:);
        [B,index]=sort(img_pow);
        B=flipud(B);
        index=flipud(index);
        
        compressed_dct=zeros(size(dvalue));
        for ii=1:coeff
            compressed_dct(index(ii))=img_dct(index(ii));
        end
        im=idct2(compressed_dct);
        
    end
    
    imwrite(im, outfile);
    figure('Name','Output image');
    imshow(im);
    return;
end




