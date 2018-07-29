% OCR (Optical Character Recognition).
% Author: Anthony CONVERS and Martin PIEGAY
% e-mail: martin.piegay@telecom-st-etienne.fr
% A CHANGE IN THE WORK OF:Ing. Diego Barragán Guerrero 
% e-mail: diego@matpic.com
% For more information, visit: www.matpic.com
% 
%________________________________________
% PRINCIPAL PROGRAM
warning off %#ok<WNOFF>
% Clear all
clc, close all, clear all
% Read image LOAD AN IMAGE
[filename, pathname] = uigetfile('*','LOAD AN IMAGE');
imagen=imread(fullfile(pathname, filename));
% Show image
imshow(imagen);
title('ENTREE');
% Convert to gray scale
if size(imagen,3)==3 %RGB image
    imagen=rgb2gray(imagen);
end
% Convert to BW
threshold = graythresh(imagen);
imagen =~im2bw(imagen,threshold);
% Remove all object containing fewer than 100 pixels
imagen = bwareaopen(imagen,100);
%Storage matrix word from image
word=[ ];
re=imagen;
%Make and open *.txt as file for write
b=find(filename=='.');
pathname = [pathname filename(:,1:b-1) '.TXT'] ;
[FileName, PathName]= uiputfile('*.txt','Enregister le text sous ...', pathname);
save(fullfile(PathName, FileName));
fid = fopen(fullfile(PathName, FileName), 'wt');
% Load templates
load templates
global templates
% Load threshold
load seuil
global seuil
% Compute the number of letters in template file
num_letras=size(templates,2);
while 1
    %Fcn 'lines' separate lines in text
    [fl , re]=lines(re);
    re2=fl;
    %Uncomment line below to see lines one by one
    %imshow(fl);pause(0.5)    
    %-----------------------------------------------------------------
    while 1
        %Fcn 'chars' separate characters in text
        [fc, re2, inter]=chars(re2);
        %Width of a letter
        largeur=size(fc,2);
        %ratio of the space between two characters over the width of a letter 
        rapport=inter/largeur;
        %If this ratio exceeds the predefined threshold of when creating models
        if rapport >= seuil
            % We add a space
            word=[word ' '];
        end
        % Resize letter (same size of template)
        img_r=imresize(fc,[42 24]);
        %Uncomment line below to see letters one by one
         %imshow(img_r);pause(0.5)
        %-------------------------------------------------------------------
        % Call fcn to convert image to text
        letter=read_letter_perso(img_r,num_letras);
        % Letter concatenation
        word=[word letter];
        if isempty(re2)  %if variable 're2' in Fcn 'chars' is empty
            word=[word '\n']; %newline
            break %breaks the loop
        end
    end
    %When the sentences finish, breaks the loop
    if isempty(re)  %if variable 're' in Fcn 'lines' is empty
        break %breaks the loop
    end    
end
fprintf(fid,word);
fclose(fid);
%Open '*.txt' file
winopen(fullfile(PathName, FileName))

