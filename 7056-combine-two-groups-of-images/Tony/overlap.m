% This code combines two images a and b. It puts an image 'b' on the top of
% 'a' starting from the half of the picture 'a'till the top.
% a should be in the format: 'a.format' example: pict.jpg'  
%All right are reserved to:
%                         Nassim Khaled
%                         American University of Beirut
%                         Research and Graduate Assistant

function c=overlap(a,b);
a=croping(a);
b=croping(b);
[m,n,p]=size(a);
[q,r,s]=size(b);
a=im2double(a);
b=im2double(b);
c=a;
C=[b;a];
c=C;
