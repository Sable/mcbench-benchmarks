%CONVERTRGB2GRAY: converts an RGB bitmap image to a gray image. 
%
%Written by Orlando Camargo Rodríguez
%14/03/2005
% 
%Sintax:   convertrgb2gray( colorbar, figure, graymin, graymax )
%
%          where colorbar is the name of the bitmap file, which can be 
%          used as the colorbar for the bitmap, figure is the name of the 
%          RGB bitmap itself and [graymin graymax] can be used to control 
%          the final palette of gray tones. On output the user obtains two 
%          gray-scaled figures, named 'figure_gray.jpg' and 
%          'figure_inverted_gray.jpg'.   
%          

function [K,K2] = convertrgb2gray( thecolorbar, thefigure, graymin, graymax )

% Check gray levels: 

if exist( 'graymin' ) == 0, graymin =  0 ; end
if exist( 'graymax' ) == 0, graymax = 255; end

if graymin <  0 , graymin =  0 , end
if graymax > 255, graymax = 255, end 

if graymin > graymax, 
   gray2   = graymin; 
   gray1   = graymax; 
   graymin = gray1;
   graymax = gray2; 
end

% Define white and black:

black = [  0   0   0];
white = [255 255 255];

% Read the image colorbar and load it into Matlab space: 

I = imread( thecolorbar );

% Get the color intensities:

Red   = I(:,:,1);
Green = I(:,:,2);
Blue  = I(:,:,3);

% Get the size of the colorbar: 

[m n] = size( Red ); levels = n;

  Red_levels = round( sum( double( Red   ) )/m );
Green_levels = round( sum( double( Green ) )/m );
 Blue_levels = round( sum( double( Blue  ) )/m );
  RGB_levels = [black;Red_levels(:) Green_levels(:) Blue_levels(:);white];
  RGB_levels_inverted = [black;flipud( Red_levels(:) ) flipud( Green_levels(:) ) flipud( Blue_levels(:) );white];
  
% Calculate equivalent gray levels: 

Gray_levels = round( linspace(graymin,graymax,levels) );

% Keep black and white to convert properly axis and text colors:

Gray_levels = [0 Gray_levels 255];

% Read the image and load it into Matlab space:

clear I 

I = imread( thefigure );
 
Red   = double( I(:,:,1) );
Green = double( I(:,:,2) );
Blue  = double( I(:,:,3) );

% Get the size of the image: 

[m n] = size( Red );

for i = 1:m

    for j = 1:n
        
	[i j]
	
        r = Red(  i,j);
	g = Green(i,j);
	b = Blue( i,j);
	
	rgb_triplet = [r g b];
	auxiliary_rgb = ones([levels+2 1])*rgb_triplet;
	
	differences  = auxiliary_rgb - RGB_levels;
	differences2 = auxiliary_rgb - RGB_levels_inverted;
	
	thenorm  = sqrt( sum( differences.*differences , 2 ) );
	thenorm2 = sqrt( sum( differences2.*differences2,2 ) );

       [dummymin index] = min( thenorm );
	
	K(i,j) = Gray_levels(index); clear index
	
       [dummymin index] = min( thenorm2 );
	
	K2(i,j) = Gray_levels(index);
	
    end
    
end

K  = uint8( K );
K2 = uint8( K2 );

figure(1), imshow( K )
figure(2), imshow( K2 )

imwrite( K , 'figure_gray.jpg'         , 'jpg' )  
imwrite( K2, 'figure_inverted_gray.jpg', 'jpg' ) 
