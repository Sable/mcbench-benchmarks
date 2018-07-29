%This function is used to combine a two group of images(that are named in a sequence manner,i.e ft1.jpg, ft2.jpg ft3.jpg....)   by imposing the two
%images on one image. It is used generally for large number of pictures
%(movie applications). Note that the name of the folders containing the
%images should be changed in the code and the user should also change the 
%name of the folder that will contain the processed images.
%All right are reserved to:
%                         Nassim Khaled
%                         American University of Beirut
%                         Research and Graduate Assistant


function final; 
clear all;
clc
%%%%%%%%%%%%%%%Change l, the amount of height cropping%%%%%%%%%%%%%%%
l=800;  
%%%%%% Change z %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z=50;   %number of images in your folder.
for i=1:z

%%%%%%Change the name of the first folder and the name of the image%%%%%%%%    
name='c:\folder1\ft (';   %put the name of directory plus the root name of the image (in this case ft)                
name1=strcat(name,num2str(i),').jpg');
a=imread(name1);                     %reading image i from the folder 'c:\folder1\ft(i).jpg'                                 

%%%%%%Change the name of the first folder and the name of the image%%%%%%%%
name='c:\folder2\st ('; 
name2=strcat(name,num2str(i),').jpg'); %reading image i from the folder 'c:\folder2\st(i).jpg'   
b=imread(name2);
c=overlap(a,b);

%%%%%%Change the name of the folder where you want to save your images%%%%%%%%
name='c:\folder3\image(';
name2=strcat(name,num2str(i),').jpg'); 
imwrite(c,name2);                 %writing image i from the folder 'c:\folder3\image(i).jpg' 
end








