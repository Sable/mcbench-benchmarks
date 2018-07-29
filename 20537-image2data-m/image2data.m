function data = image2data( thecolorbar, thefigure, z )

%IMAGE2DATA: reads a bitmap and converts it to numerical data. 
%
% 
% Usage:  data = image2data( bitmap_colorbar, bitmap, z )
%
%         This function requires two input files: a horizontal strip containing the 
%         different color levels from left to right, and the color bitmap which should  
%         be converted to numerical data; z is a two-element vector, containing the 
%         depth values, which are used to properly scale the output data.  
%          

%***************************************************************************************
% First version: 01/07/2008
% 
% Contact: orodrig@ualg.pt
% 
% Any suggestions to improve the performance of this 
% code will be greatly appreciated. 
% 
%***************************************************************************************

data = []; 

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
  RGB_levels = [Red_levels(:) Green_levels(:) Blue_levels(:)];
  
% Calculate equivalent gray levels: 

Gray_levels = round( linspace(0,255,levels) );

% Read the image and load it into Matlab space:

clear I 

I = imread( thefigure );
 
Red   = double( I(:,:,1) ); data = zeros( size( Red ) );
Green = double( I(:,:,2) );
Blue  = double( I(:,:,3) );

% Get the size of the image: 

[m n] = size( Red );

% Convert the color image to a gray image: 

for i = 1:m

    for j = 1:n
    
        r = Red(  i,j);
	g = Green(i,j);
	b = Blue( i,j);
	
	rgb_triplet = [r g b];

	auxiliary_rgb = repmat(rgb_triplet,levels,1);
	
	differences  = auxiliary_rgb - RGB_levels;
	
	thenorm  = sqrt( sum( differences.*differences , 2 ) );

       [dummymin index] = min( thenorm );

	data(i,j) = Gray_levels(index); clear index
	
    end
    
end

% Convert integer to double: 

data = double( data ); 

% Usually, the background is white and the axes are black,  
% so let's get rid of them: 

Iw = ( data == 255 ); data( Iw ) = NaN ; 
Ib = ( data ==  0  ); data( Ib ) = NaN ; 

% Scale the data: 

data = ( z(2)- z(1) )/255*data + z(1); 
