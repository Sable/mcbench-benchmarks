function [char, re, esp]=chars(ligne)
% Divide text in caracters
% line->input image; char->first character; re->remain characters; esp->space between two characters
% Example:
% ligne=imread('..\test\espace.png');
% [char, re, esp]=chars(ligne);
% subplot(3,1,1);imshow(ligne);title('INPUT IMAGE')
% subplot(3,1,2);imshow(char);title('FIRST CHAR')
% subplot(3,1,3);imshow(re);title('REMAIN CHARS')
% esp


%%
%This function does the same thing as the function 'lines', working horizontally instead of vertically 
num_filas=size(ligne,2);
for i=1:num_filas
    if sum(ligne(:,i))~=0
        if i-1>0
            esp=i-1;
        else 
            esp=[];
        end
        for s=i+1:num_filas % from the first column to the last 
            if sum(ligne(:,s))==0 % if a column is blank
                char=ligne(:,i:s-1); % First char matrix
                char=clip(char);
                re=ligne(:,s:end);% Remain chars matrix
                
                %*-*-*Uncomment lines below to see the result*-*-*-*-
                %         subplot(2,1,1);imshow(char);
                %         subplot(2,1,2);imshow(re);
                %         esp
                break
            else 
                char=ligne(:,i:end);%Only one char.
                char=clip(char);
                re=[ ];
                %We decale column
            end
        end
        break
    else %error no character in 'line'
        char=[];
        re=[];
        esp='erreur pas de char';
        %We decale column
    end
end
%Fcn clip is the same in lines.m
function img_out=clip(img_in)
[f c]=find(img_in);
img_out=img_in(min(f):max(f),min(c):max(c));%Crops image
