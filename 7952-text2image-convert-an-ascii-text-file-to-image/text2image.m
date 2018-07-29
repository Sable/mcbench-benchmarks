%TEXT2IMAGE    Convert Text files into Images.
%   Syntax: text2image(input_text_filename, output_image_filename)
%   Example: text2image('christmas_carol.txt','christmas_carol.jpg')

function text2image(y1,y2)

load data_all.mat
load char_array_all.mat
load index_array_all.mat

strh=[];
congo=[];
fid=fopen(y1);
while 1
    comt=[];
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    str= tline;
    for dion=1:length(str)
        got=strfind(char_array_all,str(dion));
        com=data_all(:,sum(index_array_all(1:got-1))+1:sum(index_array_all(1:got-1))+index_array_all(got));
        comt=[comt com];
    end
    congo=[congo comt];
    strh=[strh size(comt,2)];
end
fclose(fid);
att2=ones(size(data_all,1)*length(strh),max(strh));
for i=1:length(strh)
    att=[congo(:,sum(strh(1:i-1))+1:sum(strh(1:i-1))+strh(i)) ones(15,max(strh)-strh(i))];
    att2(size(data_all,1)*(i-1)+1:size(data_all,1)*(i),:)=att;
end
att2=[ones(size(att2,1),2) att2];
imwrite(uint8(att2.*255),y2);