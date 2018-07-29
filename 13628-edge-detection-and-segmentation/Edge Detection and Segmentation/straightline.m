% Question No:1

% A binary image contains straight lines oriented horizontally, vertically,
% at 45 degree and at -45 degree. Detect these straight lines in that image.

function straightline(x)
f=imread(x);
f=im2double(f);
choice=0;
H=[-1 -1 -1; 2 2 2;-1 -1 -1];
V=[-1 2 -1;-1 2 -1;-1 2 -1];
P45=[-1 -1 2;-1 2 -1;2 -1 -1];
M45=[2 -1 -1;-1 2 -1;-1 -1 2];
while (choice~=5)
choice=input('1: Horizontal\n2: Vertical\n3: 45 Degree\n4: -45 Degree\n5: Exit\n Enter your choice : ');
switch choice
    case 1
        DH=imfilter(f,H);
        figure, imshow(f),title('Original Image'),figure,imshow(DH),title('Horizontal Line Detection');
    case 2
        DV=imfilter(f,V);
        figure, imshow(f),title('Original Image'),figure,imshow(DV),title('Vertical Line Detection');
    case 3
        D45=imfilter(f,P45);
        figure, imshow(f),title('Original Image'),figure,imshow(D45),title('45 Degree Line Detection');
    case 4
        DM45=imfilter(f,M45);
        figure, imshow(f),title('Original Image'),figure,imshow(DM45),title('-45 Degree Line Detection');
    case 5
        display('Program Exited');
    otherwise
        display('\nWrong Choice\n');
    end
end