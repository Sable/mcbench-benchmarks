function pixel_scan
%author Imran Akthar imran_akthar@hotmail.com

clc;
clear all;
buffer=pwd;
[file, pathname] = uigetfile('*.jpg','Load Image');

cd(pathname);
a=imread(file);%color image

figure(1)
subplot(2,1,1)
subimage(a)
r=a(:,:,1);
g=a(:,:,2);
b=a(:,:,3);
size_row=size(a,1);
size_col=size(a,2);
for counter_row=1:size_row
    for counter_col=1:size_col
    rr=[r(counter_row,counter_col),g(counter_row,counter_col),b(counter_row,counter_col)];
    subplot(2,1,2);  
    u16=double(rr);
    image(colormap(u16./255));
    title(['Row',num2str(counter_row),'Col',num2str(counter_col),'RGB Color',num2str(double(rr))])
    pause(.001)
end
end

