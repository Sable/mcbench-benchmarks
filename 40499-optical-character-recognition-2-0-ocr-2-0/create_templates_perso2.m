% CREATE TEMPLATES Machine Learning
% CAUTION:
% We must open an image with models in a specific order:
% First the numbers '0 'to '9' and the letters MAJUSQULES from 'A' to 'Z'. And lowercase letters 'a' to 'z'
% Dim templates must be equal to [42, 24 * 62] = [42, 1488]
%%
% Clear all
clc, close all, clear all
% Read image LOAD AN IMAGE
[filename, pathname] = uigetfile('*','LOAD AN Image');
modele=imread(fullfile(pathname, filename));
% Convert to gray scale
if size(modele,3)==3 %RGB image
    modele=rgb2gray(modele);
end
% Convert to BW
threshold = graythresh(modele);
modele =~im2bw(modele,threshold);
% Remove all object containing fewer than 100 pixels
modele = bwareaopen(modele,100);%Change the value if the dimension of templates are bad
re=modele;
%Storage matrix character from image
character=[];
%Storage matrix interchar from the space between two characters 
interchar=[];
%Storage matrix from the width of a letter
largeur=[];
while 1
    %Fcn 'lines' separate lines in text
    [fl, re]=lines(re);
    re2=fl;
    %Uncomment line below to see lines one by one
    %imshow(fl);pause(0.5)    
    while 1
        %Fcn 'chars' separate characters in text
        [fc, re2, inter]=chars(re2);
        % witdth of letter concatenation
        largeur=[largeur size(fc,2)];
        % space between two characters concatenation
        interchar=[interchar inter];
        % Resize letter (size of template)
        img_r=imresize(fc,[42 24]);
        %Uncomment line below to see template letters one by one
         %imshow(img_r);pause(0.5)
        %-------------------------------------------------------------------
        % character concatenation
        character=[character img_r];
        if isempty(re2)  %if variable 're2' is empty
            break %breaks the loop
        end
    end
    if isempty(re)  %if variable 're' is empty 
        break %breaks the loop
    end     
end
%dividing the matrix templetes
templates=mat2cell(character,42,[24 24 24 24 24 24 24 24 24 24 ...% dimension of the templates must be equal to [42, 24 * 62] = [42, 1488]                                              
    24 24 24 24 24 24 24 24 24 24 ...% if it is too small reduce the threshold line 20 else increase it
    24 24 24 24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 24 24 24 24 24]);
%threshold= the average of the space between two characters over the
%maximum of witdth of letter
seuil=mean(interchar)/max(largeur);
% save threshold and templetes
save('seuil','seuil')
save ('templates','templates')
disp('Les modeles sont creer')%the templetes are created
%clear all
clear all;