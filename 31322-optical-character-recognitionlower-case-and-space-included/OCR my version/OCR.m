% OCR (Optical Character Recognition).
% Author: Ankit Saroch 
% e-mail: saroch.ankit@gmail.com
% 
%________________________________________
% PRINCIPAL PROGRAM
warning off %#ok<WNOFF>
% Clear all
clc, close all, clear all
% Read image
imagen=imread('testcheck.bmp');
% Show image
imagen1 = imagen;
figure,imshow(imagen1);
title('INPUT IMAGE WITH NOISE')
% Convert to gray scale
if size(imagen,3)==3 %RGB image
    imagen=rgb2gray(imagen);
end
% Convert to BW
threshold = graythresh(imagen);

imagen =~im2bw(imagen,threshold);
imagen2 = imagen;
%figure,imshow(imagen2);
% title('before bwareaopen')
% Remove all object containing fewer than 15 pixels
imagen = bwareaopen(imagen,15);
imagen3 = imagen;
%figure,imshow(imagen3);
%title('after bwareaopen')
%Storage matrix word from image 
word=[ ];
re=imagen;
%Opens text.txt as file for write
fid = fopen('text.txt', 'wt');
% Load templates
load templates
global templates
% Compute the number of letters in template file
num_letras=size(templates,2);
while 1
    %Fcn 'lines_crop' separate lines in text
    [fl re]=lines_crop(re); %fl= first line, re= remaining image
    imgn=fl;
    n=0;
    %Uncomment line below to see lines one by one
    %figure,imshow(fl);pause(2)  
    %-----------------------------------------------------------------
    
    spacevector = [];      % to compute the total spaces betweeen
                           % adjacent letter
    rc = fl;              
   
    while 1
        %Fcn 'letter_crop' separate letters in a line
       [fc rc space]=letter_crop(rc);  %fc =  first letter in the line
                                       %rc =  remaining cropped line
                                       %space = space between the letter
                                       %   cropped and the next letter
       %uncomment below line to see letters one by one
       %figure,imshow(fc);pause(0.5)
       img_r = imresize(fc,[42 24]);   %resize letter so that correlation
                                       %can be performed
       n = n + 1;
       spacevector(n)=space;
       
       %Fcn 'read_letter' correlates the cropped letter with the images
       %given in the folder 'letters_numbers'
       letter = read_letter(img_r,num_letras);
       
       %letter concatenation
       word = [word letter];
       
       if isempty(rc)  %breaks loop when there are no more characters
           break;
        end
    end
    
        %-------------------------------------------------------------------
        
        %
    max_space = max(spacevector);
    no_spaces = 0;
    
     for x= 1:n   %loop to introduce space at requisite locations
       if spacevector(x+no_spaces)> (0.75 * max_space)
          no_spaces = no_spaces + 1;
            for m = x:n
              word(n+x-m+no_spaces)=word(n+x-m+no_spaces-1);
            end
           word(x+no_spaces) = ' ';
           spacevector = [0 spacevector];
       end
     end
   
            
    %fprintf(fid,'%s\n',lower(word));%Write 'word' in text file (lower)
    fprintf(fid,'%s\n',word);%Write 'word' in text file (upper)
    % Clear 'word' variable
    word=[ ];
    %*When the sentences finish, breaks the loop
    if isempty(re)  %See variable 're' in Fcn 'lines'
        break
    end
end
fclose(fid);
%Open 'text.txt' file
winopen('text.txt')
clear all