% AUTOENHANCE  Automatically adjusts/enhances the image(brightness, color
%    and contrast) to "optimum" levels.
%    e.g. autoenhance('Sunset.jpg','Output.jpg')

function autoenhance(input_img,output_img)

my_limit=0.5;
low_limit=0.008;
up_limit=0.992;
%----------------------------------------------------------------------
img=imread(input_img);
[m1 n1 r1]=size(img);
%----------------------------------------------------------------------
if r1==3
    my_limit2=0.04;my_limit3=-0.04;
    a=rgb2ntsc(img);
    mean_adjustment=my_limit2-mean(mean(a(:,:,2)));
    a(:,:,2)=a(:,:,2)+mean_adjustment*(0.596-a(:,:,2));
    mean_adjustment=my_limit3-mean(mean(a(:,:,3)));
    a(:,:,3)=a(:,:,3)+mean_adjustment*(0.523-a(:,:,3));
else
    a=double(img)./255;
end
%----------------------------------------------------------------------
mean_adjustment=my_limit-mean(mean(a(:,:,1)));
a(:,:,1)=a(:,:,1)+mean_adjustment*(1-a(:,:,1));
if r1==3
    a=ntsc2rgb(a);
end
%----------------------------------------------------------------------
img=a.*255;
%--------------------calculation of vmin and vmax----------------------
for k=1:r1
    arr=sort(reshape(img(:,:,k),m1*n1,1));
    v_min(k)=arr(ceil(low_limit*m1*n1));
    v_max(k)=arr(ceil(up_limit*m1*n1));
end
%----------------------------------------------------------------------
if r1==3
    v_min=rgb2ntsc(v_min);
    v_max=rgb2ntsc(v_max);
end
%----------------------------------------------------------------------
img=(img-v_min(1))/(v_max(1)-v_min(1));
imwrite(uint8(img.*255),output_img);