clear
preText = '.\Images';
numImage = 50;

for i=1:numImage
    file = ['\Image',sprintf('%03d',i),'.jpg'];
    I = imresize(imread([preText,file]),[375,300]);
    [aa,SN_fill,FaceDat]=detect_face(I);

    I2 = imresize(aa,[280,180]);
    file=[preText,'\Cropped\Image',sprintf('%03d',i),'.jpg'];
    imwrite(I2,file,'jpg');

    disp(file);
end



%for Test Images
for i=1:31
    file = ['\Image',sprintf('%03d',i),'.jpg'];
    I = imresize(imread(['.\Images\Test',file]),[375,300]);
    [aa,SN_fill,FaceDat]=detect_face(I);

    I2 = imresize(aa,[280,180]);
    file=['.\Images\Test_Cropped\Image',sprintf('%03d',i),'.jpg'];
    imwrite(I2,file,'jpg');

    disp(file);
end    