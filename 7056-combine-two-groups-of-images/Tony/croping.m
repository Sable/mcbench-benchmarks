%This function cuts the height of the image by an amount defined by l
%All right are reserved to:
%                         Nassim Khaled
%                         American University of Beirut
%                         Research and Graduate Assistant


function b=croping(a,l);

[m,n,p]=size(a);
x=0;
y=l;
width=n;
height=m-l;
b=imcrop(a,[x y width height]);
