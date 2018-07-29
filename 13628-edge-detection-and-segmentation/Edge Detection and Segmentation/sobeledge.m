% Question No:2

% Detect the edges in an image
% a)Using a vertical Sobel mask with a threshold determined automatically.
% b)Using a vertical Sobel mask with a specified threshold
% c)Both vertical and horizontal edges with a specified threshold
% d)Edges at 45 degree with image filter using a specified mask and a 
%   specified threshold
% e)Edges at -45 degree with image filter using a specified mask and a 
%   specified threshold

function sobeledge(x)
f=imread(x);
f=im2double(f);
choice=0;
while (choice~=6)
choice=input('1: Vertical Sobel Mask - Automatic Threshold\n2: Vertical Sobel Mask - Specified Threshold\n3: Horizontal and Vertical Edges - Specified Threshold\n4: Edges at 45 degree - Specified Threshold\n5: Edges at -45 degree - Specified Threshold\n6: Exit\n Enter your choice : ');
switch choice
    case 1
        [VSFAT Threshold]=edge(f,'sobel','vertical');
        figure, imshow(f),title('Original Image'),figure,imshow(VSFAT),title('Sobel Filter - Automatic Threshold');
        Threshold
    case 2
        Threshold=input('Enter a Threshold value : ');
        VSFST=edge(f,'sobel',Threshold,'vertical');
        figure, imshow(f),title('Original Image'),figure,imshow(VSFST),title('Sobel Filter - Specified Threshold');
        Threshold
    case 3
        Threshold=input('Enter a Threshold value : ');
        SFST=edge(f,'sobel',Threshold);
        figure, imshow(f),title('Original Image'),figure,imshow(SFST),title('Sobel Filter (Horizontal and Vertical) - Specified Threshold');
        Threshold
    case 4
        Threshold=input('Enter a Threshold value : ');
        s45=[-2 -1 0;-1 0 1;0 1 2];
        SFST45=imfilter(f,s45,'replicate');
        SFST45=SFST45>=Threshold;
        figure, imshow(f),title('Original Image'),figure,imshow(SFST45),title('Sobel Filter (45 Degree) - Specified Threshold');
        Threshold
    case 5
        Threshold=input('Enter a Threshold value : ');
        sm45=[0 1 2;-1 0 1;-2 -1 0];
        SFSTM45=imfilter(f,sm45,'replicate');
        SFSTM45=SFSTM45>=Threshold;
        figure, imshow(f),title('Original Image'),figure,imshow(SFSTM45),title('Sobel Filter (45 Degree) - Specified Threshold');
        Threshold
    case 6
        display('Program Exited');
    otherwise
        display('\nWrong Choice\n');
    end
end