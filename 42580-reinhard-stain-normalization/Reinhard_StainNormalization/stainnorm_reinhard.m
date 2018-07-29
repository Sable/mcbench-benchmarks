%%%%This Routine takes two images as input,in which one is the source image
%%%%and other is the target one,and uses Reinhard's method to normalize the
%%%%stain of source image and gives the output as normalized image similar 
%%%%to target one.
function norm_img=stainnorm_reinhard(source,target)
[x y z]=size(source);
[x1 y1 z1]=size(target);

source1=zeros(x,y,1:3);
target1=zeros(x1,y1,1:3);
source=double(source);
target=double(target);

source1=RGB2Lab(source);    %Conversion from RGB to LAB colour space
src1=source1(:,:,1);
src2=source1(:,:,2);
src3=source1(:,:,3);

src_1=reshape(src1,1,x*y);
src_1=double(src_1);

src_2=reshape(src2,1,x*y);
src_2=double(src_2);

src_3=reshape(src3,1,x*y);
src_3=double(src_3);

std1=std(src_1,1);          %Finding out standard deviation of individual 
std2=std(src_2,1);          %channels of source image
std3=std(src_3,1);
m1=mean(mean(source1(:,:,1))); %Finding out mean of individual channels 
m2=mean(mean(source1(:,:,2))); %of source image
m3=mean(mean(source1(:,:,3)));
    

target1=RGB2Lab(target);    %Conversion from LAB to RGB colour space
tgt1=target1(:,:,1);
tgt2=target1(:,:,2);
tgt3=target1(:,:,3);

tgt_1=reshape(tgt1,1,x1*y1);
tgt_1=double(tgt_1);

tgt_2=reshape(tgt2,1,x1*y1);
tgt_2=double(tgt_2);

tgt_3=reshape(tgt3,1,x1*y1);
tgt_3=double(tgt_3);

std4=std(tgt_1,1);          %Finding out standard deviation of individual 
std5=std(tgt_2,1);          %channels of target image
std6=std(tgt_3,1);
m4=mean(mean(target1(:,:,1))); %Finding out mean of individual channels 
m5=mean(mean(target1(:,:,2))); %target image
m6=mean(mean(target1(:,:,3)));

    
result=zeros(x,y,1:3);

for i=1:x
    for j=1:y
        result(i,j,1)=((source1(i,j,1)-m1)*(std4/std1))+m4;
        result(i,j,2)=((source1(i,j,2)-m2)*(std5/std2))+m5;
        result(i,j,3)=((source1(i,j,3)-m3)*(std6/std3))+m6;
    end
end

norm_img=Lab2RGB(result);   %Conversion of result from LAB to RGB space
figure,imshow(uint8(norm_img)); %Output;stain normalized image
imwrite(norm_img,'rein.jpg');
end

        

    


