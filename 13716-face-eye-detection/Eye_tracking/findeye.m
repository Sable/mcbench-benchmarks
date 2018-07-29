function findeye(NumberOfFrames,prefix,fileformat,threshold);

ort=round(NumberOfFrames/2);
if ort<10
    art=strcat('00',num2str(ort));
elseif ort<100
    art=strcat('0',num2str(ort));
else
    art=strcat(num2str(ort));
end

I=imread(strcat(prefix,art,'.',fileformat));
disp('Please Crop The Right Eye Template');
templateR=double(rgb2gray(imcrop(uint8(I))));
disp('Please Crop The Left Eye Template');
templateL=double(rgb2gray(imcrop(uint8(I))));
close;

for num = 1:NumberOfFrames
     if num < 10 
      frame = imread(strcat(prefix,'00',num2str(num),'.',fileformat));
  elseif num<100
      frame = imread(strcat(prefix,'0',num2str(num),'.',fileformat));
  else
      frame = imread(strcat(prefix,num2str(num),'.',fileformat));
  end 
  
  eyematch2(frame,threshold,templateR,templateL);
   
end

