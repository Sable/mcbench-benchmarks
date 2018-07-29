function lett = edu_imgresize(bw2)
% This function will take the cropped binary image and change it to 5 x 7
% character representation in single vector.

bw_7050=imresize(bw2,[70,50]);
for cnt=1:7
    for cnt2=1:5
        Atemp=sum(bw_7050((cnt*10-9:cnt*10),(cnt2*10-9:cnt2*10)));
        lett((cnt-1)*5+cnt2)=sum(Atemp);
    end
end

lett=((100-lett)/100);
lett=lett';