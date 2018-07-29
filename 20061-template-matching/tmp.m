function result=tmp(image1,image2);
%
% By Alaa Eleyan Nov,2005
%*********************************************************

if size(image1,3)==3
    image1=rgb2gray(image1);
end
if size(image2,3)==3
    image2=rgb2gray(image2);
end

% check which one is target and which one is template using their size

if size(image1)>size(image2)
    Target=image1;
    Template=image2;
else
    Target=image2;
    Template=image1;
end

% find both images sizes
[r1,c1]=size(Target);
[r2,c2]=size(Template);
% mean of the template
image22=Template-mean(mean(Template));

%corrolate both images
M=[];
for i=1:(r1-r2+1)
    for j=1:(c1-c2+1)
        Nimage=Target(i:i+r2-1,j:j+c2-1);
        Nimage=Nimage-mean(mean(Nimage));  % mean of image part under mask
        corr=sum(sum(Nimage.*image22));
        warning off
        M(i,j)=corr/sqrt(sum(sum(Nimage.^2)));
    end 
end
% plot box on the target image
result=plotbox(Target,Template,M);