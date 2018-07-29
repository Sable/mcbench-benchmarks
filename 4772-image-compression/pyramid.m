function [out,im] = pyramid (infile,level,outfile)
% PYRAMID (infile,singvals,outfile)
% Image compression based on Gaussian Pyramid.
%  infile is input file name present in the current directory
%  level is a positive integer (the scaling factor)
%  outfile is output file name which will be created.
%
% It is possble to change the frequency response of the low pass 
% gaussian filter changing the parameter "varianza" (see below).
%
% Example of use:
% [out,im]=pyramid('input_image.bmp',3,'output_image.bmp');
% im will be a double cell array with the 3 resampled layers
% and out will be the reconstructed image.
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
% References:
%
% For more details concernings the algorithm implemented please visit the following links:
% 
%  http://www.cs.ucf.edu/courses/cap6411/lect826h.PDF
% 
%  http://www.wisdom.weizmann.ac.il/~maksimf/ex2/g3.html
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
   out=[];
   return
end

%------------------------------------
% The low-pass filter ---------------
%------------------------------------
% Gaussian Low Pass Filter ----------
%------------------------------------
x=[-16:1:16];
y=[-16:1:16];
dimx=size(x,2);
dimy=size(y,2);
varianza=2.3;
filtro=zeros(dimx,dimy);
for ii=1:dimx
    for jj=1:dimy
        esponente=exp(-(x(ii)^2+y(jj)^2)/(varianza));
        filtro(ii,jj)=esponente;
    end
end
% normalization
filtro=filtro/sum(sum(filtro)); 
%------------------------------------
%------------------------------------

if isgray(a)
    
    dvalue = double(a);
    dx     = size(dvalue,1);
    dy     = size(dvalue,2);
    dmin   = min(dx,dy);
    
    red_p  = floor(log2(dmin));
    red    = min(red_p,level);

    im=cell(red+1,1);

    % Image compression
    im{1}=dvalue;
    for ii=1:red
         % low-pass filter the image
         filtered        = conv2fft(dvalue,filtro,'same');
         % downsampling the image
         sottocampionato = dyaddown(filtered,1,'m');
         % save image
         im{ii+1}        = sottocampionato;
         % next step
         dvalue          = sottocampionato;         
    end
    
    % Image reconstruction
    for ii=1:red
         % upsampling the image
         sovracampionato = dyadup(dvalue,0,'m');
         % low-pass filter the image (there is a scaling factor)
         filtered        = 4*conv2fft(sovracampionato,filtro,'same');
         % next step
         dvalue          = filtered;         
    end

    
    
    
    
    if isa(a,'uint8')
        for ii=2:red+1
             testo=strcat('Image at level-',num2str(ii-1));
             figure('Name',testo);
             imshow(uint8(im{ii}));
             pause(0.6);
        end
        figure('Name','Reconstrunction');
        imshow(uint8(dvalue));
        pause(0.6);
        out=uint8(dvalue);
        
    end
    
    if isa(a,'uint16')
        for ii=2:red+1
             testo=strcat('Image at level-',num2str(ii-1));
             figure('Name',testo);
             imshow(uint16(im{ii}));
             pause(0.6);
        end
        figure('Name','Reconstrunction');
        imshow(uint16(dvalue));
        pause(0.6);
        out=uint16(dvalue);
       
    end
    
    if isa(a,'double')
        for ii=2:red+1
             testo=strcat('Image at level-',num2str(ii-1));
             figure('Name',testo);
             imshow(uint32(im{ii}));
             pause(0.6);
        end
        figure('Name','Reconstrunction');
        imshow((dvalue));
        pause(0.6);
        out=uint32(dvalue);
       
   end
    
    imwrite(out, outfile);
    return;    
end

%------------------------------------------------------
if isrgb(a)
    dvalue = double(a);
    dx     = size(dvalue,1);
    dy     = size(dvalue,2);
    dmin   = min(dx,dy);
    
    red_p  = floor(log2(dmin));
    red    = min(red_p,level);

    im=cell(red+1,1);

    % Image compression
    im{1}=dvalue;
    for ii=1:red
         % low-pass filter the image
         filtered_r        = conv2fft(dvalue(:,:,1),filtro,'same');
         filtered_g        = conv2fft(dvalue(:,:,2),filtro,'same');
         filtered_b        = conv2fft(dvalue(:,:,3),filtro,'same');
         % downsampling the image
         sottocampionato_r = dyaddown(filtered_r,1,'m');
         sottocampionato_g = dyaddown(filtered_g,1,'m');
         sottocampionato_b = dyaddown(filtered_b,1,'m');
         % save image
         clear sottocampionato;
         sottocampionato(:,:,1)=sottocampionato_r;
         sottocampionato(:,:,2)=sottocampionato_g;
         sottocampionato(:,:,3)=sottocampionato_b;
         im{ii+1}        = sottocampionato;
         % next step
         dvalue          = sottocampionato;         
    end
    
    % Image reconstruction
    for ii=1:red
         % upsampling the image
         sovracampionato_r = dyadup(dvalue(:,:,1),0,'m');
         sovracampionato_g = dyadup(dvalue(:,:,2),0,'m');
         sovracampionato_b = dyadup(dvalue(:,:,3),0,'m');
         % low-pass filter the image (there is a scaling factor)
         filtered_r        = 4*conv2fft(sovracampionato_r,filtro,'same');
         filtered_g        = 4*conv2fft(sovracampionato_g,filtro,'same');
         filtered_b        = 4*conv2fft(sovracampionato_b,filtro,'same');
         % next step
         clear dvalue;
         dvalue(:,:,1)          = filtered_r;
         dvalue(:,:,2)          = filtered_g;
         dvalue(:,:,3)          = filtered_b;         
    end

    
    
    
    
    if isa(a,'uint8')
        for ii=2:red+1
             testo=strcat('Image at level-',num2str(ii-1));
             figure('Name',testo);
             imshow(uint8(im{ii}));
             pause(0.6);
        end
        figure('Name','Reconstrunction');
        imshow(uint8(dvalue));
        pause(0.6);
        out=uint8(dvalue);
        
    end
    
    if isa(a,'uint16')
        for ii=2:red+1
             testo=strcat('Image at level-',num2str(ii-1));
             figure('Name',testo);
             imshow(uint16(im{ii}));
             pause(0.6);
        end
        figure('Name','Reconstrunction');
        imshow(uint16(dvalue));
        pause(0.6);
        out=uint16(dvalue);
       
    end
    
    if isa(a,'double')
        for ii=2:red+1
             testo=strcat('Image at level-',num2str(ii-1));
             figure('Name',testo);
             imshow((im{ii}));
             pause(0.6);
        end
        figure('Name','Reconstrunction');
        imshow((dvalue));
        pause(0.6);
        out=(dvalue);
       
   end
    
    imwrite(out, outfile);
    return;

end

