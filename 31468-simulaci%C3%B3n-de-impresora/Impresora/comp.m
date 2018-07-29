%% 
I = imread('shakira.jpg');
        level = graythresh(I);
        BW = im2bw(I,level);
        figure, imshow(BW)
        
%%  img= imread('Shakira.jpg');
 img = imread('shakira.jpg');
%  img = imread('evo.jpg');
%  img = imread('anime.jpg');
imshow(img);

figure
img=rgb2gray(img);
imshow(img);

global f
global c
[f,c]=size(img);

fprintf(' * Número de filas es %d \n', f );
fprintf(' * Número de columnas es %d \n', c);

%% Binarización
 for i = 1:1:f
     for j = 1:1:c
         if img(i,j) > 120 % definir umbral!
             new(i,j)=1;
         else
             new(i,j)=0;
         end
     end
 end
 binarizada=new;
 figure
 imshow(binarizada);
  