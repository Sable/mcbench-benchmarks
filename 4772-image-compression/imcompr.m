function [im] = imcompr (infile,singvals,outfile)
% IMCOMPR (infile,singvals,outfile)
% Image compression based on Singular Value Decomposition.
%  infile is input file name present in the current directory
%  singvals is the number of largest singular values (positive integer)
%  outfile is output file name which will be created
%
% Example of use:
% out=imcompr('input_image.bmp',20,'output_image.bmp');
% 
% The input image A can be RGB or GRAYSCALE.
%
% RGB case:
% If A is of class double, all values must be in the range [0,1],
% and A must be m-by-n-by-3.
% If A is of class uint16 or uint8, A must be m-by-n-by-3.
%
% GRAYSCALE case:
% If A is of class double, all values must be in the range [0,1], 
% and the number of dimensions of A must be 2. If A is of class
% uint16 or uint8, the number of dimensions of A must be 2.
% uint16 or double.
%
% 
% Compression ratio is equal to k(n+m+k) / n*m
% where k is the number of singular values (singvals)
% and [n,m]=size(input_image)
%
% References:
%
% For more details concernings the algorithm implemented please visit the following links:
% 
%  http://peter.wreck.org/reports/Math4305/
% 
%  http://online.redwoods.cc.ca.us/instruct/darnold/laproj/Fall2001/AdamDave/slideshow.pdf
%
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
        
        [u,s,v] = svds(red, singvals);
        imred = uint8(u * s * transpose(v));
        
        [u,s,v] = svds(green, singvals);
        imgreen = uint8(u * s * transpose(v));
        
        [u,s,v] = svds(blue, singvals);
        imblue = uint8(u * s * transpose(v));
        
        im(:,:,1) = imred;
        im(:,:,2) = imgreen;
        im(:,:,3) = imblue;
        
        imwrite(im, outfile);
        figure('Name','Output image');
        imshow(im);
        
        return;
    end
    
    if isa(a(:,:,1),'uint16')
        red = double(a(:,:,1));
        green = double(a(:,:,2));
        blue = double(a(:,:,3));
        
        [u,s,v] = svds(red, singvals);
        imred = uint16(u * s * transpose(v));
        
        [u,s,v] = svds(green, singvals);
        imgreen = uint16(u * s * transpose(v));
        
        [u,s,v] = svds(blue, singvals);
        imblue = uint16(u * s * transpose(v));
        
        im(:,:,1) = imred;
        im(:,:,2) = imgreen;
        im(:,:,3) = imblue;
        
        imwrite(im, outfile);
        figure('Name','Output image');
        imshow(im);
        
        return;
    end
    
    if isa(a(:,:,1),'double')
        red = double(a(:,:,1));
        green = double(a(:,:,2));
        blue = double(a(:,:,3));
        
        [u,s,v] = svds(red, singvals);
        imred = (u * s * transpose(v));
        
        [u,s,v] = svds(green, singvals);
        imgreen = (u * s * transpose(v));
        
        [u,s,v] = svds(blue, singvals);
        imblue = (u * s * transpose(v));
        
        im(:,:,1) = imred;
        im(:,:,2) = imgreen;
        im(:,:,3) = imblue;
        
        imwrite(im, outfile);
        figure('Name','Output image');
        imshow(im);
        
        return;
    end
end

if isgray(a)
    
    dvalue=double(a);
    
    [u,s,v] = svds(dvalue, singvals);
    
    if isa(a,'uint8')
        im = uint8(u * s * transpose(v));
    end
    
    if isa(a,'uint16')
        im = uint16(u * s * transpose(v));
    end
    
    if isa(a,'double')
        im = (u * s * transpose(v));
    end
    
    imwrite(im, outfile);
    figure('Name','Output image');
    imshow(im);
    return;
end
    
    
    
    
