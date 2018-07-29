%function lines%
%function letter_in_a_line
function [fl re space]=letter_crop(im_texto)
% Divide letters in lines


im_texto=clip(im_texto);
num_filas=size(im_texto,2);

%figure,imshow(im_texto);
%title('line sent in the function letter');
for s=1:num_filas
    s;
    sum_col = sum(im_texto(:,s));
    if sum_col==0
        k = 'true';
        nm=im_texto(:,1:s-1); % First letter matrix
        %figure,imshow(nm);
        %title('first letter in the function letter_in_a_line');
        %pause(1);
        rm=im_texto(:,s:end);% Remaining line matrix
        %figure,imshow(rm);
        %title('remaining letters in the function letter_in_a_line');
        %pause(1);
        fl = clip(nm);
        %pause(1);
        re=clip(rm);
        space = size(rm,2)-size(re,2);
        %*-*-*Uncomment lines below to see the result*-*-*-*-
               %subplot(2,1,1);imshow(fl);
               %subplot(2,1,2);imshow(re);
       break
    else
        fl=im_texto;%Only one line.
        re=[ ];
        space = 0;
    end
end


function img_out=clip(img_in)
[f c]=find(img_in);
img_out=img_in(min(f):max(f),min(c):max(c));


