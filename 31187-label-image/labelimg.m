function iout = labelimg(varargin)
%
% Label Image ver. 1.01
%
% Script to place text label on the image without losing on the pixel information by pixel replacement. 
%
% This is a function representation of the ImagePatchTool
% http://www.mathworks.com/matlabcentral/fileexchange/25111-imagepatchtool
% The character set can also be generated using the ImagePatchTool and incorporated into this script.
%
% Usage: 
%        iout = labelimg(original, label_text)
%        iout = labelimg(original, label_text, location, patch_trans)
%        iout = labelimg(original, label_text, location, patch_trans, add_border ,border_val, space_pixel, space_pixel_val, alpha, resize_img_label, [bR, bG, bB], [fR, fG, fB])
%
% original - image matrix to be patched with text
% label_text - character text label
%
% Default values:
% location = 2;                     [x,y] position; top-left = 4 top-right = 3 bottom-left = 2 bottom-right = 1
% patch_trans = 2;                  type of patch - original = 1, transparent = 2, original+alpha blending = 3, transparent+alpha blending = 4
% add_border = 0;                   add border to image (always at the bottom)
% border_val = 20;                  20 pixel border value (disabled when add_border=0) 
% space_pixel = 1;                  apply spacing (0 = disable, 1 = enable)
% space_pixel_val = 1;              1 pixel spacing
% alpha = 0.5;                      transparency value
% resize_img_label = 0;             resizing of label
% [bR, bG, bB] = [0,0,0];           background values 0 to 1 (0 = black, 1 = white) 
% [fR, fG, fB] = [1,1,1];           background values 0 to 1 (0 = black, 1 = white)
%
% 
% Author: Amitabh Verma 2012 (amitabh@amitabhverma.com)
% Updated: April 12, 2012

%% variables
location = 2;
patch_trans = 2;
add_border = 0;
border_val = 20;
space_pixel = 1;
space_pixel_val = 1;
alpha = 0.5;
resize_img_label = 0;
bR=0; bG=0; bB=0;
fR=1; fG=1; fB=1;

if size(varargin,2) < 2

disp('Error: Function needs Image matrix and text label. Refer help for more details.')
iout = [];

return
elseif size(varargin,2) == 2
    
original = varargin{1};
label_text = varargin{2};

elseif size(varargin,2) > 12
disp('Error: Too many input arguments. Function needs Image matrix and text label as minimum and maximum of 10 optional inputs. Refer help for more details.')
else
    for loop = 1:size(varargin,2)
        
        switch loop
            case 1
                original = varargin{1};
            case 2
                label_text = varargin{2};
            case 3
                if size(varargin{3},1)==1
                    location = varargin{3};
                elseif size(varargin{3},1)==2
                    location(1) = varargin{3}(1);
                    location(2) = varargin{3}(2);
                else
                    location = 2;
                end
            case 4                
                patch_trans = varargin{4};
            case 5
                add_border = varargin{5};                
            case 6
                border_val = varargin{6};                
            case 7
                space_pixel = varargin{7};                
            case 8
                space_pixel_val = varargin{8};
            case 9
                alpha = varargin{9};
            case 10
                resize_img_label = varargin{10};
            case 11
                bR = varargin{11}(1);
                bG = varargin{11}(2);
                bB = varargin{11}(3);
            case 12
                fR = varargin{12}(1);
                fG = varargin{12}(2);
                fB = varargin{12}(3);
        end
    end
end

if size(varargin{1},1) < 2 || size(varargin{1},2) < 2
    disp('Error: Function needs Image matrix [l x b] or [l x b x z] greater than size 1 (l,b)')
    iout = [];
return
end
if ischar(varargin{2})==0
    disp('Error: Function needs a character text label')
    iout = [];
return
end


try
%% make label from text
sq = 18;
my_chars_used{size(label_text,2)}=[];

for y = 1:size(label_text,2)
    my_chars_used{y}(:,:,:) = my_chars(unicode2native(label_text(1,y), 'Windows-1252'), size(original,3));
end

img_label = zeros(sq,sq*(size(label_text,2)),3);

for rgb=1:size(original,3)
seqc = 1;
i = my_chars_used{seqc};
k1 = 0; 
for k=1:size(img_label,2)
    j1=0;
    if k1==sq
        k1=0;
        seqc=seqc+1;
        i = my_chars_used{seqc};
    else
    end
     
    k1=k1+1;
    
    for j=1:(size(img_label,1))
        j1=j1+1;        
        img_label(j,k,rgb)=i(j1,k1,rgb);
    end
    
end
end

%% space saver
top_box=1;
bot_box=size(img_label,1);
for loop=1:size(img_label,1)/2
    bloop = size(img_label,1)+1-loop;
    if top_box==1 && sum(img_label(loop,:,1)) == 0%(255*bR*size(img_label,2)) && sum(img_label(loop,:,2)) == (255*bG*size(img_label,2)) && sum(img_label(loop,:,3)) == (255*bB*size(img_label,2))    
    top_box = loop;
    end
    
    if bot_box==size(img_label,1) && sum(img_label(bloop,:,1)) == 0%(255*bR*size(img_label,2)) && sum(img_label(bloop,:,2)) == (255*bG*size(img_label,2)) && sum(img_label(bloop,:,3)) == (255*bB*size(img_label,2))
    bot_box = bloop;
    end
end
cor_img = img_label(top_box:bot_box,:,:);
img_label = cor_img;

if space_pixel==1
    count=0;
    spacer=0;
   for loop=1:size(img_label,2)
        if sum(img_label(:,loop,1)) == 0%(255*bR*size(img_label,1))  && sum(img_label(:,loop,2)) == (255*bG*size(img_label,1)) && sum(img_label(:,loop,3)) == (255*bB*size(img_label,1))
            spacer=spacer+1;
            if spacer==1
                for loop2=1:space_pixel_val
                count=count+1;
%                 new_img(1:size(img_label,1),count,1) =bR*255;
%                 new_img(1:size(img_label,1),count,2) =bG*255;
%                 new_img(1:size(img_label,1),count,3) =bB*255;
                end
            end
            if spacer==(sq) || spacer==(sq*2)
                for loop2=1:ceil(sq/8)
                count=count+1;
%                 new_img(1:size(img_label,1),count,1) =bR*255;
%                 new_img(1:size(img_label,1),count,2) =bG*255;
%                 new_img(1:size(img_label,1),count,3) =bB*255;
                end
                spacer=spacer+1;
            end
        else
            count=count+1;
            new_img(1:size(img_label,1),count,:)=img_label(1:size(img_label,1),loop,:);
            spacer=0;
        end
   end
    img_label = new_img;
end

original_labelled = original;
bg(1)=bR*255;
bg(2)=bG*255;
bg(3)=bB*255;

%% border
if add_border==1
   switch location
       case 1
           for loop=1:size(original_labelled,3)
           original_labelled(size(original_labelled,1):size(original_labelled,1)+border_val,:,loop) = bg(loop);
           end
       case 2
           for loop=1:size(original_labelled,3)
           original_labelled(size(original_labelled,1):size(original_labelled,1)+border_val,:,loop) = bg(loop);
           end
       case 3
           for loop=1:size(original_labelled,3)
           original_labelled(size(original_labelled,1):size(original_labelled,1)+border_val,:,loop) = bg(loop);
           end
           original_labelled(1+border_val:size(original_labelled,1)+border_val,:,:) = original_labelled(1:size(original_labelled,1),:,:);
       case 4
           for loop=1:size(original_labelled,3)
           original_labelled(size(original_labelled,1):size(original_labelled,1)+border_val,:,loop) = bg(loop);
           end
           original_labelled(1+border_val:size(original_labelled,1)+border_val,:,:) = original_labelled(1:size(original_labelled,1),:,:);          
       otherwise
   end
end

%% image resizer
if resize_img_label==1 && size(img_label,2) > size(original_labelled,2)
new_img = imresize(img_label,(size(original_labelled,2)/size(img_label,2)));
img_label = new_img;
end

%% location
if size(location,2)==1
switch location(1)
    case 1
        rx=1+size(original_labelled,1)-size(img_label,1);
        ry=size(original_labelled,1);
        cx=1+size(original_labelled,2)-size(img_label,2);
        cy=size(original_labelled,2);
    case 2
        rx=1+size(original_labelled,1)-size(img_label,1);
        ry=size(original_labelled,1);
        cx=1;
        cy=size(img_label,2);
    case 3
        rx=1;
        ry=size(img_label,1);
        cx=1+size(original_labelled,2)-size(img_label,2);
        cy=size(original_labelled,2);
    case 4
        rx=1;
        ry=size(img_label,1);
        cx=1;
        cy=size(img_label,2);
    otherwise
end
else
        rx=location(2);
        if rx > size(original_labelled,1)-size(img_label,1)
            rx = size(original_labelled,1)-size(img_label,1);
        end
        ry=size(img_label,1)+rx-1;
        
        cx=location(1);
        if cx > size(original_labelled,2)-size(img_label,2)
            cx = size(original_labelled,2)-size(img_label,2);
        end        
        cy=size(img_label,2)+cx-1;
end

fg(1)=fR*255;
fg(2)=fG*255;
fg(3)=fB*255;

%% patching
for RGB_layers = 1:size(original_labelled,3)
p11=0;
for p1 = (rx):(ry)
p11 = p11+1;
p22 = 0;
for p2 = (cx):(cy)
p22 = p22+1;

    switch patch_trans
        case 1
            if img_label(p11,p22,RGB_layers)==0
                original_labelled(p1,p2,RGB_layers) = bg(RGB_layers);
            else
                original_labelled(p1,p2,RGB_layers) = fg(RGB_layers);
            end
        case 2
            if (img_label(p11,p22,1)==img_label(1,1,1)) && (img_label(p11,p22,2)==img_label(1,1,2)) && (img_label(p11,p22,3)==img_label(1,1,3))
            else
                original_labelled(p1,p2,RGB_layers) = fg(RGB_layers);
            end
        case 3
        original_labelled(p1,p2,RGB_layers) = ((img_label(p11,p22,RGB_layers)*(alpha))+(original_labelled(p1,p2,RGB_layers)*(1-alpha)));
        case 4
        if (img_label(p11,p22,1)==img_label(1,1,1)) && (img_label(p11,p22,2)==img_label(1,1,2)) && (img_label(p11,p22,3)==img_label(1,1,3))
        else
        original_labelled(p1,p2,RGB_layers) = ((fg(RGB_layers)*(alpha))+(original_labelled(p1,p2,RGB_layers)*(1-alpha)));
        end
    otherwise
    end
end
end
end

catch ME
    original_labelled = original;
    disp(['Error: ',ME.message]); 
end
iout = original_labelled;
end


%% Stored characters (Calibri font)
function iout = my_chars(number, rgb)


i{1}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{2}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{3}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{4}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{5}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{6}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{7}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{8}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{9}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{10}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{11}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{12}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{13}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{14}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{15}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{16}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{17}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{18}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{19}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{20}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{21}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{22}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{23}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{24}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{25}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{26}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{27}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{28}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{29}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{30}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{31}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  204
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204
  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204
];

i{32}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{33}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  255  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  140  255  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  225  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  178  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  178    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  154    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{34}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  167  208  167  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  167  208  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{35}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0  240    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  208    0  167  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  167    0  208  167    0    0    0    0    0  236
    0    0    0    0    0    0  124  255  255  255  255  255  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  154  217    0  140  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  154    0  208  167    0    0    0    0    0    0  236
    0    0    0    0    0  124  255  255  255  255  255  255  124    0    0    0    0    0  236
    0    0    0    0    0    0  154  217    0  154  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  208  167    0  208  167    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  248    0    0  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{36}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  104  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  178  199    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  255  255  248  124    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  208    0    0  178  240    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  154    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  248  225  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  248  199    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  104  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  104  248    0    0    0    0    0  236
    0    0    0    0    0    0  233  167    0    0  140  233  189    0    0    0    0    0  236
    0    0    0    0    0    0  189  240  255  255  233  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  178    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  104    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{37}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  208  255  225    0    0    0    0  167  233    0    0    0  236
    0    0    0    0    0  208  208    0  255    0    0    0  124  233    0    0    0    0  236
    0    0    0    0    0  248  104    0  255    0    0  124  225    0    0    0    0    0  236
    0    0    0    0    0  255    0  167  217    0  124  240  104    0    0    0    0    0  236
    0    0    0    0    0  189  255  240  124  124  240  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  240  140  208  255  225    0    0    0    0  236
    0    0    0    0    0    0    0  104  240  124  208  208    0  255    0    0    0    0  236
    0    0    0    0    0    0    0  225  124    0  248  104    0  255    0    0    0    0  236
    0    0    0    0    0    0  233  124    0    0  255    0  167  217    0    0    0    0  236
    0    0    0    0    0  233  167    0    0    0  189  255  240  124    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{38}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  225  255  248  178    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  178    0  124  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255    0    0  140  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  233  154  178  240  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  208  255  217  104    0    0  140    0    0    0    0  236
    0    0    0    0    0    0  225  225  233  208    0    0  124  240    0    0    0    0  236
    0    0    0    0    0  208  189    0  124  248  189    0  233  189    0    0    0    0  236
    0    0    0    0    0  255    0    0    0  167  255  233  233    0    0    0    0    0  236
    0    0    0    0    0  240  178    0    0  167  248  255  208    0    0    0    0    0  236
    0    0    0    0    0  124  240  255  248  208  124  154  240  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{39}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  167  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  208  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{40}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  124  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  225  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  167    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  178    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  124    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  199  178    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{41}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  104    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  178  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  178  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  178    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  104    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  225    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  225    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  124    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{42}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  240  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  240  124  248  124  240  104    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  240  248  225  167    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  208  240  248  225  104    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  199  208  178  208  199    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{43}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  255  255  255  255  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  154    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{44}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  225    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  124    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  233  167    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{45}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  255  255  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{46}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{47}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  104  233    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  217  167    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  140  225    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  233  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  167  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  167    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  233    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  167  217    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  240  104    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{48}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  199  248  255  233  124    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  225  104    0  217  233    0    0    0    0  236
    0    0    0    0    0    0    0  167  248    0    0    0  154  255    0    0    0    0  236
    0    0    0    0    0    0    0  217  199    0    0    0  154  255    0    0    0    0  236
    0    0    0    0    0    0    0  255  154    0    0    0  189  240    0    0    0    0  236
    0    0    0    0    0    0  140  255  104    0    0    0  217  217    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0  248  167    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  167  248    0    0    0    0    0  236
    0    0    0    0    0    0  104  255  167    0  140  248  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  248  255  240  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{49}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  189  248  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  233  255  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  189  199  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  208  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  178  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  124  255  255  255  255  255  199    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{50}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  217  255  255  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  154    0  154  255  178    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  255  189    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  140  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  233  225    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  208  233    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  124  248  208    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  217  255  255  255  255  255  189    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{51}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  217  255  255  225    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  154    0  124  255  189    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  255  178    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  104  225  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  255  255  233    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  104  233  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  189  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  208  248    0    0    0    0    0  236
    0    0    0    0    0    0  178  178    0    0  178  255  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  208  255  255  233  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{52}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  233  255  154    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  199  240  255  124    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  154  240  167  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  248  124  189  225    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  178    0  225  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  208  217    0    0  248  167    0    0    0    0    0  236
    0    0    0    0    0    0  167  233    0    0  104  255  124    0    0    0    0    0  236
    0    0    0    0    0    0  240  255  255  255  255  255  255  167    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  225  199    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{53}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  255  255  255  255  217    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  178    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  104  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  255  255  233  154    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  217  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  199  240    0    0    0    0    0  236
    0    0    0    0    0    0  189  178    0    0  189  255  154    0    0    0    0    0  236
    0    0    0    0    0    0    0  208  255  255  217  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{54}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  217  255  255  240  104    0    0    0  236
    0    0    0    0    0    0    0    0  124  248  178    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  178    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  240    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  233  233  255  255  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  199  104    0  140  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0  255  178    0    0    0    0  236
    0    0    0    0    0    0  124  255  140    0    0  140  255  124    0    0    0    0  236
    0    0    0    0    0    0    0  248  199    0  124  233  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  240  255  240  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{55}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  255  255  255  255  255  189    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  167  248  104    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  248  189    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  217  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  154  255  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  240  199    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  199  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255  154    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  248    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{56}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  248  255  240  154    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  208    0    0  217  248    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  104    0    0  199  240    0    0    0    0  236
    0    0    0    0    0    0    0  104  255  178    0  140  248  154    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  248  240  233  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  225  225  199  255  178    0    0    0    0    0  236
    0    0    0    0    0    0  124  248  167    0    0  178  255  124    0    0    0    0  236
    0    0    0    0    0    0  208  233    0    0    0  104  255  124    0    0    0    0  236
    0    0    0    0    0    0  199  248  104    0  104  225  233    0    0    0    0    0  236
    0    0    0    0    0    0    0  208  255  255  240  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{57}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  208  248  255  225    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  208    0    0  233  208    0    0    0    0  236
    0    0    0    0    0    0    0  178  240    0    0    0  189  225    0    0    0    0  236
    0    0    0    0    0    0    0  225  199    0    0    0  189  225    0    0    0    0  236
    0    0    0    0    0    0    0  217  240    0    0  154  240  208    0    0    0    0  236
    0    0    0    0    0    0    0  124  233  255  255  217  255  178    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  140  255  104    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  225  199    0    0    0    0    0  236
    0    0    0    0    0    0  104  104    0  104  217  233    0    0    0    0    0    0  236
    0    0    0    0    0    0  178  248  255  240  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{58}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{59}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  225    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  233  199    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{60}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0  167    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  167  240  199    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  167  240  208  104    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  240  225  124    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  178    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  225  233  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  248  199    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{61}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  255  255  255  255  255  248    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  255  255  255  255  255  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{62}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  240  208    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  248  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  248  225  124    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  178  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  208  248  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  248  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  167  240  189    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  178    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{63}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  233  255  255  217  104    0    0    0    0  236
    0    0    0    0    0    0    0    0  199  104    0    0  208  225    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  140  240    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  154  240  154    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  255  217  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  225    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  225    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{64}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  225  248  255  255  225  154    0    0    0  236
    0    0    0    0    0    0  124  240  208  154    0    0    0  167  248  154    0    0  236
    0    0    0    0    0  104  240  154    0    0    0    0    0    0  140  240    0    0  236
    0    0    0    0    0  225  178    0  140  240  255  178  225    0    0  255    0    0  236
    0    0    0    0  140  233    0  124  248  140    0  248  199    0    0  255    0    0  236
    0    0    0    0  208  167    0  208  178    0    0  248  154    0  140  225    0    0  236
    0    0    0    0  233  124    0  248    0    0  140  255    0    0  199  178    0    0  236
    0    0    0    0  255    0    0  255  104  124  240  240    0  140  248    0    0    0  236
    0    0    0    0  255    0    0  189  255  240  124  217  255  240  124    0    0    0  236
    0    0    0    0  233  178    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0  140  255  189  124    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  124  208  240  255  255  255  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{65}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  225  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  240  140  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  167    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0  225  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  140    0    0  208  208    0    0    0    0    0  236
    0    0    0    0    0    0  208  255  255  255  255  255  225    0    0    0    0    0  236
    0    0    0    0    0  124  255  104    0    0    0  140  255    0    0    0    0    0  236
    0    0    0    0    0  225  208    0    0    0    0  140  255  104    0    0    0    0  236
    0    0    0    0  124  255  104    0    0    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{66}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  255  255  255  248  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0  189  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0  154  255  124    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0  104  233  208    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  255  240  104    0    0    0    0    0  236
    0    0    0    0    0    0  189  233    0    0  104  233  225    0    0    0    0    0  236
    0    0    0    0    0    0  217  208    0    0    0  189  255    0    0    0    0    0  236
    0    0    0    0    0    0  240  189    0    0    0  208  233    0    0    0    0    0  236
    0    0    0    0    0    0  255  140    0    0  178  255  140    0    0    0    0    0  236
    0    0    0    0    0  140  255  255  255  255  217  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{67}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  208  248  255  240  167    0    0    0  236
    0    0    0    0    0    0    0    0  124  248  199    0    0  140  233    0    0    0  236
    0    0    0    0    0    0    0    0  240  208    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  248    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  233  208    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  178    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  199    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  248  140    0  104  189  189    0    0    0    0  236
    0    0    0    0    0    0    0    0  199  248  255  240  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{68}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  255  255  255  248  208  104    0    0    0    0  236
    0    0    0    0    0    0    0  217  217    0    0  124  233  248    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0  104  255  178    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0    0  255  189    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0    0  255  189    0    0    0  236
    0    0    0    0    0    0  189  240    0    0    0    0  104  255  154    0    0    0  236
    0    0    0    0    0    0  217  217    0    0    0    0  189  248    0    0    0    0  236
    0    0    0    0    0    0  240  189    0    0    0  124  248  189    0    0    0    0  236
    0    0    0    0    0    0  255  140    0    0  167  248  208    0    0    0    0    0  236
    0    0    0    0    0  140  255  255  255  255  217  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{69}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  255  255  255  217    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  255  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{70}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  255  255  255  255  225    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  255  255  255  255  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{71}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  233  255  255  233  189    0    0    0  236
    0    0    0    0    0    0    0  124  240  225  124    0    0  167  240    0    0    0  236
    0    0    0    0    0    0    0  233  208    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  240  199    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  140    0    0  240  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255  140    0    0    0    0  178  240    0    0    0    0  236
    0    0    0    0    0    0  248  199    0    0    0    0  217  217    0    0    0    0  236
    0    0    0    0    0    0  189  255  178    0    0  124  240  189    0    0    0    0  236
    0    0    0    0    0    0    0  167  233  255  255  233  199    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{72}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  240    0    0    0    0  189  225    0    0    0  236
    0    0    0    0    0    0    0  217  217    0    0    0    0  225  199    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0  248  167    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0  104  255  124    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  189  240    0    0    0    0  189  225    0    0    0    0  236
    0    0    0    0    0    0  217  217    0    0    0    0  225  199    0    0    0    0  236
    0    0    0    0    0    0  240  189    0    0    0    0  248  167    0    0    0    0  236
    0    0    0    0    0    0  255  140    0    0    0  104  255  140    0    0    0    0  236
    0    0    0    0    0  140  255    0    0    0    0  140  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{73}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{74}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  167  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  199  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  225  199    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  167  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  199  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  104    0  124  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  167  255  248  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{75}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  240    0    0    0  233  233    0    0    0  236
    0    0    0    0    0    0    0    0  217  217    0    0  233  233    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0  233  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  154  233  233    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  240  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  233  208  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  217  104  248  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0  189  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  240  208    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  167  255  104    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{76}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  255  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{77}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  178  255  233    0    0    0    0    0    0  233  255  189    0  236
    0    0    0    0    0  217  240  255    0    0    0    0    0  189  233  255  154    0  236
    0    0    0    0    0  240  178  255  140    0    0    0  104  248  178  255  104    0  236
    0    0    0    0    0  255  140  233  189    0    0    0  225  199  167  248    0    0  236
    0    0    0    0  140  255    0  208  217    0    0  167  248    0  199  225    0    0  236
    0    0    0    0  189  233    0  178  240    0    0  248  167    0  225  189    0    0  236
    0    0    0    0  217  208    0  140  255    0  208  225    0    0  255  154    0    0  236
    0    0    0    0  240  178    0    0  255  199  255  104    0  124  255  104    0    0  236
    0    0    0    0  255  140    0    0  233  255  189    0    0  178  248    0    0    0  236
    0    0    0  140  255    0    0    0  217  240    0    0    0  208  217    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{78}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  255  189    0    0    0  104  255  104    0    0  236
    0    0    0    0    0    0    0  217  233  240    0    0    0  154  248    0    0    0  236
    0    0    0    0    0    0    0  240  154  248  124    0    0  189  225    0    0    0  236
    0    0    0    0    0    0    0  255  104  208  199    0    0  225  189    0    0    0  236
    0    0    0    0    0    0  140  255    0  154  248    0    0  248  154    0    0    0  236
    0    0    0    0    0    0  189  225    0    0  248  154  104  255  104    0    0    0  236
    0    0    0    0    0    0  217  199    0    0  208  208  154  248    0    0    0    0  236
    0    0    0    0    0    0  240  167    0    0  124  248  199  225    0    0    0    0  236
    0    0    0    0    0    0  255  124    0    0    0  240  255  189    0    0    0    0  236
    0    0    0    0    0  140  255    0    0    0    0  189  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{79}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  208  248  255  248  208    0    0    0    0  236
    0    0    0    0    0    0    0  124  248  199  104    0  140  248  208    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0  178  255    0    0    0  236
    0    0    0    0    0    0  178  248    0    0    0    0    0  140  255    0    0    0  236
    0    0    0    0    0    0  233  208    0    0    0    0    0  167  255    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0    0  199  233    0    0    0  236
    0    0    0    0    0    0  255  140    0    0    0    0    0  248  178    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0  189  248    0    0    0    0  236
    0    0    0    0    0    0  208  248  140    0    0  189  248  124    0    0    0    0  236
    0    0    0    0    0    0    0  208  248  255  248  208  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{80}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  255  255  255  240  167    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  217    0    0  189  255  124    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0  104  255  140    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0  167  255  104    0    0    0  236
    0    0    0    0    0    0    0  140  255    0    0  140  248  199    0    0    0    0  236
    0    0    0    0    0    0    0  189  255  255  255  233  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{81}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  104  208  248  255  248  208    0    0    0    0    0  236
    0    0    0    0    0    0  124  248  189    0    0  140  248  225    0    0    0    0  236
    0    0    0    0    0    0  248  189    0    0    0    0  178  255    0    0    0    0  236
    0    0    0    0    0  178  248    0    0    0    0    0  140  255  140    0    0    0  236
    0    0    0    0    0  233  208    0    0    0    0    0  178  255    0    0    0    0  236
    0    0    0    0    0  255  178    0    0    0    0    0  208  240    0    0    0    0  236
    0    0    0    0    0  255  140    0    0    0    0    0  248  199    0    0    0    0  236
    0    0    0    0    0  255  178    0    0    0    0  189  248    0    0    0    0    0  236
    0    0    0    0    0  208  248  140    0    0  189  255  189    0    0    0    0    0  236
    0    0    0    0    0    0  208  248  255  248  178  208  255  167    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  178  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{82}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  255  255  255  240  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  217    0    0  189  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0  140  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  167  248    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0  140  248  167    0    0    0    0    0  236
    0    0    0    0    0    0  189  255  255  255  255  154    0    0    0    0    0    0  236
    0    0    0    0    0    0  217  217    0  104  248  199    0    0    0    0    0    0  236
    0    0    0    0    0    0  240  189    0    0  199  240    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  140    0    0  154  255  104    0    0    0    0    0  236
    0    0    0    0    0  140  255    0    0    0    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{83}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  225  255  248  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  104  248  189    0  104  233    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  255  124    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  255  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  167  248  233    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  104  255  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  255  178    0    0    0    0    0  236
    0    0    0    0    0    0  233  167    0    0  208  240    0    0    0    0    0    0  236
    0    0    0    0    0    0  154  233  255  248  208  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{84}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  255  255  255  255  255  255  240    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  167  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  199  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  154    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  255  104    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{85}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  225    0    0    0    0  124  255  104    0    0  236
    0    0    0    0    0    0    0  225  208    0    0    0    0  178  248    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0    0  208  225    0    0    0  236
    0    0    0    0    0    0  104  255  140    0    0    0    0  233  189    0    0    0  236
    0    0    0    0    0    0  154  255    0    0    0    0    0  255  154    0    0    0  236
    0    0    0    0    0    0  189  233    0    0    0    0  140  255  104    0    0    0  236
    0    0    0    0    0    0  225  217    0    0    0    0  178  240    0    0    0    0  236
    0    0    0    0    0    0  225  208    0    0    0    0  240  199    0    0    0    0  236
    0    0    0    0    0    0  189  248  140    0  104  217  233    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  248  255  248  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{86}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  189  248    0    0    0    0    0  199  240    0    0    0  236
    0    0    0    0    0    0  154  255    0    0    0    0  104  255  167    0    0    0  236
    0    0    0    0    0    0  124  255  140    0    0    0  208  225    0    0    0    0  236
    0    0    0    0    0    0    0  255  154    0    0  104  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0  225  217    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  208    0  140  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  225    0  225  199    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  248  154  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  240  178    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{87}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0  140  255    0    0    0    0  208  255    0    0    0    0  189  240  236
    0    0    0    0  140  255  124    0    0    0  255  255    0    0    0    0  248  167  236
    0    0    0    0    0  255  140    0    0  189  225  255  140    0    0  189  240    0  236
    0    0    0    0    0  255  140    0    0  248  140  255  140    0    0  248  167    0  236
    0    0    0    0    0  255  154    0  178  225    0  255  140    0  167  240    0    0  236
    0    0    0    0    0  225  189    0  240  167    0  233  189    0  240  167    0    0  236
    0    0    0    0    0  225  189  167  240    0    0  225  189  167  240    0    0    0  236
    0    0    0    0    0  217  189  240  167    0    0  225  189  233  167    0    0    0  236
    0    0    0    0    0  189  240  248    0    0    0  199  248  248    0    0    0    0  236
    0    0    0    0    0  178  255  189    0    0    0  189  255  189    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{88}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  255  154    0    0    0  225  233    0    0    0  236
    0    0    0    0    0    0    0    0  233  217    0    0  189  248  104    0    0    0  236
    0    0    0    0    0    0    0    0  167  255  104  140  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  199  248  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  255  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  255  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  225  178  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  240    0    0  255  167    0    0    0    0    0  236
    0    0    0    0    0    0  167  255  124    0    0  217  233    0    0    0    0    0  236
    0    0    0    0    0  104  248  167    0    0    0  154  255  124    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{89}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  248    0    0    0    0  233  199    0    0    0  236
    0    0    0    0    0    0    0  104  255  140    0    0  199  240    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  199    0  140  255  124    0    0    0    0  236
    0    0    0    0    0    0    0    0  199  233    0  240  189    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  255  208  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  248  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  154    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255  104    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{90}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  233  208    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  225  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  208  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  167  248  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  255  167    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  104  248  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  233  217    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  208  233    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  124  255  255  255  255  255  255  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{91}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248  255  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  178  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  233    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  199    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  154    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  233    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  199    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  154    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  255  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{92}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  167    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  154  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  225  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  167  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  140  233    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{93}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  255  255  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  178  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  199  208    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  178    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  225    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  199  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  167    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  124    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  248  255  248    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{94}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  225  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  199  217  124  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  248    0    0  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  233  154    0    0  225  140    0    0    0    0    0  236
    0    0    0    0    0    0  178  217    0    0    0  199  189    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{95}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  255  255  255  255  255  255  255  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{96}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{97}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  240  255  225  208  199    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0  255  124    0    0    0    0  236
    0    0    0    0    0    0  124  255  104    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  225  225    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  140    0  208  255  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  240  189  225  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{98}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  154  240  255  225    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  248  233  104  124  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  208  240    0    0    0  225  189    0    0    0    0  236
    0    0    0    0    0    0    0  233  189    0    0    0  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  167  248    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  208    0  124  248  189    0    0    0    0    0  236
    0    0    0    0    0    0  178  225  208  255  248  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{99}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  240  255  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  178    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  167    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  154    0  140  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  255  217  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{100}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0  240  178    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0  255  140    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  189  233    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  240  255  217  225  208    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255  178    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0  124  255  104    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  225  233    0    0    0    0    0  236
    0    0    0    0    0    0  124  255  124    0  208  248  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  240  189  225  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{101}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  233  255  248  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  167    0  104  208  240    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  240  208  104    0    0    0    0    0  236
    0    0    0    0    0    0  140  233    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  124  248  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  248  255  255  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{102}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  167  248  255  154    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  255  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  104  255  255  255  255  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  255  124    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  199    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  167    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  104  255  124    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  189  255  225    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{103}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  240  255  217  208  199    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0  255  124    0    0    0    0  236
    0    0    0    0    0    0  124  255  104    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  225  225    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  140    0  208  248  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  240  178  240  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  255  124    0    0    0    0    0  236
    0    0    0    0    0    0  167  208    0    0  208  233    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  255  255  217  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{104}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  167  240  255  225    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  248  233  104  124  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  208  240    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  233  178    0    0  140  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  189  233    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  217  208    0    0    0    0    0  236
    0    0    0    0    0    0  178  240    0    0    0  225  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{105}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248  199    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  208    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  178    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{106}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  217  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  225  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  255  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  154  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  167    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  124    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  189  255  225    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{107}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255    0    0  233  248  104    0    0    0    0  236
    0    0    0    0    0    0    0  178  233    0  233  233    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  208  217  233  208    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  233  217  255  154    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140  199  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0  248  199    0    0    0    0    0    0  236
    0    0    0    0    0    0  178  240    0    0  154  255  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{108}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  208  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{109}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0  140  240  154  240  255  225    0  208  255  248  154    0    0    0  236
    0    0    0    0  178  248  225  104  140  255  240  178    0  225  225    0    0    0  236
    0    0    0    0  208  240    0    0  124  255  178    0    0  217  208    0    0    0  236
    0    0    0    0  233  178    0    0  167  255    0    0    0  233  189    0    0    0  236
    0    0    0    0  255  140    0    0  189  225    0    0    0  255  140    0    0    0  236
    0    0    0  140  255    0    0    0  225  199    0    0  140  255    0    0    0    0  236
    0    0    0  178  240    0    0    0  248  167    0    0  178  240    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{110}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  240  154  240  255  225    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  248  233  104  124  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  208  240    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  233  178    0    0  140  255  104    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  189  240    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  217  217    0    0    0    0    0  236
    0    0    0    0    0    0  178  240    0    0    0  240  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{111}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  233  255  248  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  154    0  140  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0  225  189    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0  255  167    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  154  255  104    0    0    0    0  236
    0    0    0    0    0    0  124  255  154    0  140  248  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  248  255  240  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{112}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  240  154  240  255  225    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  248  217  104  104  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  217  240    0    0    0  233  189    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0    0  255  154    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  167  248    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  208    0  124  248  189    0    0    0    0    0  236
    0    0    0    0    0    0  178  240  199  255  248  189    0    0    0    0    0    0  236
    0    0    0    0    0    0  208  208    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  233  178    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{113}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  240  255  217  208  189    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0  255  124    0    0    0    0  236
    0    0    0    0    0    0  124  255  104    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  225  225    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  124    0  208  248  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  240  178  240  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  255  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{114}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  240  189  248  217    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  248  208    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  178    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{115}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  255  240  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  217    0  140  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  225  255  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  140  255  124    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  140    0  167  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  240  255  233  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{116}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  255  255  255  255  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  255  124    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  199    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  199    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  255  248  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{117}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255    0    0    0  217  208    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0    0  240  178    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  225  233    0    0    0    0    0  236
    0    0    0    0    0    0  124  255  154    0  208  248  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  248  189  225  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{118}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  140  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  178    0    0  208  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  199    0    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  208  225    0  189  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  248  104  248  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  225  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  233    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{119}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  255  167    0    0  189  248    0    0    0  248  154    0    0  236
    0    0    0    0    0  240  189    0    0  248  255    0    0  167  248    0    0    0  236
    0    0    0    0    0  225  199    0  189  208  255  124    0  233  189    0    0    0  236
    0    0    0    0    0  208  225    0  248  104  255  140  140  248    0    0    0    0  236
    0    0    0    0    0  189  225  189  208    0  225  178  225  189    0    0    0    0  236
    0    0    0    0    0  167  255  248  104    0  225  233  240    0    0    0    0    0  236
    0    0    0    0    0  140  255  208    0    0  199  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{120}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  208    0    0  208  233    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  248    0  178  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  225  248  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  255  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  248  225  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  154  255  124  104  255  154    0    0    0    0    0    0  236
    0    0    0    0    0  104  248  167    0    0  208  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{121}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  140  255  104    0    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0  208  217    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  208    0    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  225    0  189  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  255  104  248  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  104  255  240  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  217  233    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{122}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  255  255  255  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  240  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  199  233    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  248  124    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  255  255  255  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{123}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  124  240  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  240  178    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  154  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  199  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  248  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  255  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  199  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  199  199    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  154    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  154    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{124}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  140  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  189  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  225  178    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  167  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  154    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  104    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  178    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  124    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{125}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  248  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  167  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  240  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  233    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  199    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  167    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  104    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  240    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  248  255  167    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{126}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  240  255  199    0    0  255    0    0    0    0  236
    0    0    0    0    0    0    0  225  178    0  233  178  140  233    0    0    0    0  236
    0    0    0    0    0    0    0  255    0    0  124  240  248  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{127}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{128}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{129}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{130}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{131}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{132}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{133}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{134}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{135}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{136}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{137}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{138}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{139}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{140}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{141}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{142}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{143}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{144}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{145}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{146}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{147}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{148}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{149}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{150}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{151}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{152}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{153}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{154}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{155}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{156}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{157}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{158}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{159}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  208  255  248  167    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  140    0  104  255    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0  178  240    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  217  255  225  124    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  248  104    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255    0  104    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{160}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{161}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  240  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  225  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  178  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  178    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  124    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  225    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{162}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  189  233  255  199    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  178    0  140  240    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  208    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  178    0  140  248  140    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  248  255  255  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{163}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  154  233  255  248  189    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  255  178    0    0  208    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  208    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  255  255  255  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  225    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  199    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  248  255  255  255  255  255  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{164}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  248    0    0    0  124  248  154    0    0    0  236
    0    0    0    0    0    0    0    0  240  233  255  248  248  167    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  140    0  178  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  208  167    0    0    0  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  248    0    0    0    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0  255    0    0    0  167  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0  140  248  124    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  240  255  233  248  104    0    0    0    0    0  236
    0    0    0    0    0    0  233  189    0    0    0  225  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{165}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  104    0    0    0  124  248    0    0    0  236
    0    0    0    0    0    0    0    0  208  199    0    0    0  240  154    0    0    0  236
    0    0    0    0    0    0    0    0  124  248    0    0  225  199    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  189  189  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  167  248  248  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  255  255  255  255  255  124    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  178  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  255  255  255  255  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  178    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{166}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  140  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  217  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  240  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{167}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  225  255  225    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  167    0  208  225    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  217  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255  217  255  225  124    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  154    0    0  189  248    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0    0    0    0  233  124    0    0    0  236
    0    0    0    0    0    0    0    0  225  217  104    0  124  240    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  255  233  248  124    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  208  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0  189    0    0  140  217  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  255  255  225  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{168}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0  240    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{169}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  240  255  255  240  208  124    0    0    0  236
    0    0    0    0    0    0  124  248  189  104    0    0  104  189  248  140    0    0  236
    0    0    0    0    0    0  233  167    0  199  255  233    0    0  167  233    0    0  236
    0    0    0    0    0  167  225    0  140  233    0  140  240    0    0  255    0    0  236
    0    0    0    0    0  217  154    0  217  154    0    0    0    0    0  255    0    0  236
    0    0    0    0    0  240  104    0  248    0    0    0    0    0  104  240    0    0  236
    0    0    0    0    0  255    0    0  255    0    0    0    0    0  167  208    0    0  236
    0    0    0    0    0  255    0    0  248  104  104  225    0    0  240  140    0    0  236
    0    0    0    0    0  233  154    0  199  255  225  124    0  208  208    0    0    0  236
    0    0    0    0    0  154  248  154    0    0    0  154  225  217    0    0    0    0  236
    0    0    0    0    0    0  154  233  255  255  248  217  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{170}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  248  248  233  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  233  104    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  104    0  104  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  124    0  217  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  255  248  217  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  255  255  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{171}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  233    0  124  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  154    0  233  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  217    0  189  217    0    0    0    0    0    0  236
    0    0    0    0    0    0  104  255  104    0  255  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  154    0  233  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  208    0  178  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  104  248    0  104  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{172}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  255  255  255  255  255  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  225  199    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  255  104    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{173}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  255  255  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{174}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  167  248  255  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  233  104    0  208  208    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  140    0  248    0  248    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0  178  225    0  255    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0  178  240  140  233    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  208    0  140  233  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  255  240  154    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{175}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  255  255  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{176}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  167  248  248  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  124  124  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255    0  154  240    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  255  240  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{177}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  167  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  217  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  255  255  255  255  255  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  154  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  167    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  248  255  255  255  255  255  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{178}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  199  255  248  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140    0  124  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  104  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  225  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  225  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  225  124    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  255  255  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{179}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  199  255  248  189    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140    0  104  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  178  225    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  255  248  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  154  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124    0    0  178  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  255  248  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{180}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  124  233    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  240  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  124    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{181}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  104    0    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0  140  240    0    0    0  255    0    0    0    0    0    0  236
    0    0    0    0    0    0  189  217    0    0    0  255    0    0    0    0    0    0  236
    0    0    0    0    0    0  217  178    0    0  104  255    0    0    0    0    0    0  236
    0    0    0    0    0    0  240  140    0    0  217  255    0    0    0    0    0    0  236
    0    0    0    0    0  104  255  154    0  178  255  233    0    0    0    0    0    0  236
    0    0    0    0    0  154  255  255  240  154  208  255  217    0    0    0    0    0  236
    0    0    0    0    0  189  208    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  225  189    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  248  140    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{182}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  240  255  255  255  255  255  140    0    0  236
    0    0    0    0    0    0    0  178  255  255  255  140    0  255  255    0    0    0  236
    0    0    0    0    0    0    0  240  255  255  255  140  140  255  233    0    0    0  236
    0    0    0    0    0    0    0  255  255  255  255    0  140  255  208    0    0    0  236
    0    0    0    0    0    0    0  240  255  255  255    0  167  255  178    0    0    0  236
    0    0    0    0    0    0    0  124  233  255  225    0  189  255  140    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  225    0  189  255    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  189    0  208  233    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  178    0  225  217    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  140    0  225  189    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  124    0  248  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0  104  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{183}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{184}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  233    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  255  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{185}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  208  248  154    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  199  140  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  140  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  208  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  225  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{186}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  240  255  248  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  233  104    0  124  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  104    0    0  104  248    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  217  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  240  255  248  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  255  255  255  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{187}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  104    0  248  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  178    0  208  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  233    0  154  240    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  255  104  104  255  104    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  199    0  217  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  240    0  154  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  124    0  240  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{188}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  124  208  255  124    0    0    0  167  233    0    0    0  236
    0    0    0    0    0    0  208  178  248    0    0    0  124  233    0    0    0    0  236
    0    0    0    0    0    0    0  167  217    0    0  124  225    0    0    0    0    0  236
    0    0    0    0    0    0    0  208  178    0  124  240  104    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  124  124  240  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  240  124  140  255  189    0    0    0    0  236
    0    0    0    0    0    0    0  104  240  124  104  225  189  178    0    0    0    0  236
    0    0    0    0    0    0    0  225  124    0  225  124  217  140    0    0    0    0  236
    0    0    0    0    0    0  233  124    0  140  255  255  255  248    0    0    0    0  236
    0    0    0    0    0  233  167    0    0    0    0    0  255  104    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{189}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  124  208  255  124    0    0    0  167  233    0    0    0    0  236
    0    0    0    0    0  208  178  248    0    0    0  124  233    0    0    0    0    0  236
    0    0    0    0    0    0  167  217    0    0  124  225    0    0    0    0    0    0  236
    0    0    0    0    0    0  208  178    0  124  240  104    0    0    0    0    0    0  236
    0    0    0    0    0    0  248  124  124  240  124    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  240  124    0  255  255  217    0    0    0    0  236
    0    0    0    0    0    0  104  240  124    0    0    0  104  248    0    0    0    0  236
    0    0    0    0    0    0  225  124    0    0    0    0  225  167    0    0    0    0  236
    0    0    0    0    0  233  124    0    0    0  140  233  140    0    0    0    0    0  236
    0    0    0    0  233  167    0    0    0    0  248  255  255  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{190}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  140  255  255  208    0    0    0    0  167  233    0    0    0  236
    0    0    0    0    0    0    0  189  240    0    0    0  124  233    0    0    0    0  236
    0    0    0    0    0  140  255  255  154    0    0  124  225    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  217    0  124  240  104    0    0    0    0    0  236
    0    0    0    0  140  255  255  233  124  124  240  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  240  124  140  255  189    0    0    0    0  236
    0    0    0    0    0    0    0  104  240  124  104  225  189  178    0    0    0    0  236
    0    0    0    0    0    0    0  225  124    0  225  124  217  140    0    0    0    0  236
    0    0    0    0    0    0  233  124    0  140  255  255  255  248    0    0    0    0  236
    0    0    0    0    0  233  167    0    0    0    0    0  255  104    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{191}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  217  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  199  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  225  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  217  255  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  154  240  154    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  240  124    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  233  199    0    0  104  189    0    0    0    0    0    0  236
    0    0    0    0    0    0  124  225  255  255  240  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{912}.cdata = [

    0    0    0    0    0    0    0    0    0  217  167    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  225  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  240  140  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  167    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0  225  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  140    0    0  208  208    0    0    0    0    0  236
    0    0    0    0    0    0  208  255  255  255  255  255  225    0    0    0    0    0  236
    0    0    0    0    0  124  255  104    0    0    0  140  255    0    0    0    0    0  236
    0    0    0    0    0  225  208    0    0    0    0  140  255  104    0    0    0    0  236
    0    0    0    0  124  255  104    0    0    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{193}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0  167  217    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  208  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  225  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  240  140  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  167    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0  225  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  140    0    0  208  208    0    0    0    0    0  236
    0    0    0    0    0    0  208  255  255  255  255  255  225    0    0    0    0    0  236
    0    0    0    0    0  124  255  104    0    0    0  140  255    0    0    0    0    0  236
    0    0    0    0    0  225  208    0    0    0    0  140  255  104    0    0    0    0  236
    0    0    0    0  124  255  104    0    0    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{194}.cdata = [

    0    0    0    0    0    0    0    0    0    0  189  240  225    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  178    0  178  233    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  225  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  240  140  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  167    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0  225  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  140    0    0  208  208    0    0    0    0    0  236
    0    0    0    0    0    0  208  255  255  255  255  255  225    0    0    0    0    0  236
    0    0    0    0    0  124  255  104    0    0    0  140  255    0    0    0    0    0  236
    0    0    0    0    0  225  208    0    0    0    0  140  255  104    0    0    0    0  236
    0    0    0    0  124  255  104    0    0    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{195}.cdata = [

    0    0    0    0    0    0    0    0    0  233  124  225  124  233    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0  154  255  167    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  225  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  240  140  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  167    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0  225  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  140    0    0  208  208    0    0    0    0    0  236
    0    0    0    0    0    0  208  255  255  255  255  255  225    0    0    0    0    0  236
    0    0    0    0    0  124  255  104    0    0    0  140  255    0    0    0    0    0  236
    0    0    0    0    0  225  208    0    0    0    0  140  255  104    0    0    0    0  236
    0    0    0    0  124  255  104    0    0    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{196}.cdata = [

    0    0    0    0    0    0    0    0    0  248    0    0  240    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  225  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  240  140  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  167    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0  225  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  140    0    0  208  208    0    0    0    0    0  236
    0    0    0    0    0    0  208  255  255  255  255  255  225    0    0    0    0    0  236
    0    0    0    0    0  124  255  104    0    0    0  140  255    0    0    0    0    0  236
    0    0    0    0    0  225  208    0    0    0    0  140  255  104    0    0    0    0  236
    0    0    0    0  124  255  104    0    0    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{197}.cdata = [

    0    0    0    0    0    0    0    0    0    0  255  124  240    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  199  248  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  255  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  225  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  240  140  255  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  167    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0  225  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  140    0    0  208  208    0    0    0    0    0  236
    0    0    0    0    0    0  208  255  255  255  255  255  225    0    0    0    0    0  236
    0    0    0    0    0  124  255  104    0    0    0  140  255    0    0    0    0    0  236
    0    0    0    0    0  225  208    0    0    0    0  140  255  104    0    0    0    0  236
    0    0    0    0  124  255  104    0    0    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{198}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  248  255  255  255  255  248    0    0  236
    0    0    0    0    0    0    0    0    0  233  225  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  233  167  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  248  124  189  154    0    0    0    0    0    0  236
    0    0    0    0    0    0  124  248  178    0  225  255  255  255  248    0    0    0  236
    0    0    0    0    0    0  240  217    0    0  233    0    0    0    0    0    0    0  236
    0    0    0    0    0  217  240    0    0  124  199    0    0    0    0    0    0    0  236
    0    0    0    0  178  255  255  255  255  255  154    0    0    0    0    0    0    0  236
    0    0    0  140  255  167    0    0    0  208  104    0    0    0    0    0    0    0  236
    0    0    0  248  167    0    0    0    0  240  255  255  255  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{199}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  208  248  255  240  189    0    0    0  236
    0    0    0    0    0    0    0    0  124  248  189    0    0  140  240    0    0    0  236
    0    0    0    0    0    0    0    0  240  167    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  225    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  154    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  124    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  233  124    0    0  189  248    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  248  255  255  217  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  255  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{200}.cdata = [

    0    0    0    0    0    0    0    0    0  217  167    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  255  255  255  217    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  255  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{201}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0  167  217    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  208  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  255  255  255  217    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  255  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{202}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0  189  240  225    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  208  178    0  178  233    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  255  255  255  217    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  255  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{203}.cdata = [

    0    0    0    0    0    0    0    0    0    0  248    0    0  240    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0    0  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  255  255  255  255  255    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255  255  255  255  217    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  255  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{204}.cdata = [

    0    0    0    0    0    0    0    0    0  217  167    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{205}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0  167  217    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  208  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{206}.cdata = [

    0    0    0    0    0    0    0    0    0    0  189  240  225    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  178    0  178  233    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{207}.cdata = [

    0    0    0    0    0    0    0    0    0    0  248    0    0  240    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0    0  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{208}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255  255  255  240  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  255  104    0  104  233  189    0    0    0    0  236
    0    0    0    0    0    0    0  208  240    0    0    0  124  240    0    0    0    0  236
    0    0    0    0    0    0    0  240  217    0    0    0    0  255    0    0    0    0  236
    0    0    0    0    0  178  255  255  255  248    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0  154  255  140    0    0    0  140  225    0    0    0    0  236
    0    0    0    0    0    0  189  255    0    0    0    0  199  189    0    0    0    0  236
    0    0    0    0    0    0  217  225    0    0    0  124  248    0    0    0    0    0  236
    0    0    0    0    0    0  233  189    0    0  167  248  167    0    0    0    0    0  236
    0    0    0    0    0    0  255  255  255  255  217  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{209}.cdata = [

    0    0    0    0    0    0    0    0    0  233  124  225  124  233    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0  154  255  167    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  255  189    0    0    0  104  255  104    0    0  236
    0    0    0    0    0    0    0  217  233  240    0    0    0  154  248    0    0    0  236
    0    0    0    0    0    0    0  240  154  248  124    0    0  189  225    0    0    0  236
    0    0    0    0    0    0    0  255  104  208  199    0    0  225  189    0    0    0  236
    0    0    0    0    0    0  140  255    0  154  248    0    0  248  154    0    0    0  236
    0    0    0    0    0    0  189  225    0    0  248  154  104  255  104    0    0    0  236
    0    0    0    0    0    0  217  199    0    0  208  208  154  248    0    0    0    0  236
    0    0    0    0    0    0  240  167    0    0  124  248  199  225    0    0    0    0  236
    0    0    0    0    0    0  255  124    0    0    0  240  255  189    0    0    0    0  236
    0    0    0    0    0  140  255    0    0    0    0  189  255  140    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{210}.cdata = [

    0    0    0    0    0    0    0    0    0  217  167    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  208  248  255  248  208    0    0    0    0  236
    0    0    0    0    0    0    0  124  248  199  104    0  140  248  208    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0  178  255    0    0    0  236
    0    0    0    0    0    0  178  248    0    0    0    0    0  140  255    0    0    0  236
    0    0    0    0    0    0  233  208    0    0    0    0    0  167  255    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0    0  199  233    0    0    0  236
    0    0    0    0    0    0  255  140    0    0    0    0    0  248  178    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0  189  248    0    0    0    0  236
    0    0    0    0    0    0  208  248  140    0    0  189  248  124    0    0    0    0  236
    0    0    0    0    0    0    0  208  248  255  248  208  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{211}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0  167  217    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  208  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  208  248  255  248  208    0    0    0    0  236
    0    0    0    0    0    0    0  124  248  199  104    0  140  248  208    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0  178  255    0    0    0  236
    0    0    0    0    0    0  178  248    0    0    0    0    0  140  255    0    0    0  236
    0    0    0    0    0    0  233  208    0    0    0    0    0  167  255    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0    0  199  233    0    0    0  236
    0    0    0    0    0    0  255  140    0    0    0    0    0  248  178    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0  189  248    0    0    0    0  236
    0    0    0    0    0    0  208  248  140    0    0  189  248  124    0    0    0    0  236
    0    0    0    0    0    0    0  208  248  255  248  208  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{212}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0  189  240  225    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  208  178    0  178  233    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  208  248  255  248  208    0    0    0    0  236
    0    0    0    0    0    0    0  124  248  199  104    0  140  248  208    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0  178  255    0    0    0  236
    0    0    0    0    0    0  178  248    0    0    0    0    0  140  255    0    0    0  236
    0    0    0    0    0    0  233  208    0    0    0    0    0  167  255    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0    0  199  233    0    0    0  236
    0    0    0    0    0    0  255  140    0    0    0    0    0  248  178    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0  189  248    0    0    0    0  236
    0    0    0    0    0    0  208  248  140    0    0  189  248  124    0    0    0    0  236
    0    0    0    0    0    0    0  208  248  255  248  208  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{213}.cdata = [

    0    0    0    0    0    0    0    0    0    0  233  124  225  124  233    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0  154  255  167    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  208  248  255  248  208    0    0    0    0  236
    0    0    0    0    0    0    0  124  248  199  104    0  140  248  208    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0  178  255    0    0    0  236
    0    0    0    0    0    0  178  248    0    0    0    0    0  140  255    0    0    0  236
    0    0    0    0    0    0  233  208    0    0    0    0    0  167  255    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0    0  199  233    0    0    0  236
    0    0    0    0    0    0  255  140    0    0    0    0    0  248  178    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0  189  248    0    0    0    0  236
    0    0    0    0    0    0  208  248  140    0    0  189  248  124    0    0    0    0  236
    0    0    0    0    0    0    0  208  248  255  248  208  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{214}.cdata = [

    0    0    0    0    0    0    0    0    0    0  248    0    0  240    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0    0  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  104  208  248  255  248  208    0    0    0    0  236
    0    0    0    0    0    0    0  124  248  199  104    0  140  248  208    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0  178  255    0    0    0  236
    0    0    0    0    0    0  178  248    0    0    0    0    0  140  255    0    0    0  236
    0    0    0    0    0    0  233  208    0    0    0    0    0  167  255    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0    0  199  233    0    0    0  236
    0    0    0    0    0    0  255  140    0    0    0    0    0  248  178    0    0    0  236
    0    0    0    0    0    0  255  189    0    0    0    0  189  248    0    0    0    0  236
    0    0    0    0    0    0  208  248  140    0    0  189  248  124    0    0    0    0  236
    0    0    0    0    0    0    0  208  248  255  248  208  104    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{215}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  199    0    0    0  217    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  255  124  154  240  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  208  248  233    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  233  248  208    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  124  248  208    0  233  167    0    0    0    0    0    0  236
    0    0    0    0    0    0  240  208    0    0    0  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{216}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  104  240    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  225  167    0    0    0    0  236
    0    0    0    0    0    0    0  104  208  248  255  240  233    0    0    0    0    0  236
    0    0    0    0    0    0  124  240  178    0  104  255  255  167    0    0    0    0  236
    0    0    0    0    0    0  240  140    0    0  225  154  167  240    0    0    0    0  236
    0    0    0    0    0  167  208    0    0  189  199    0    0  255    0    0    0    0  236
    0    0    0    0    0  217  154    0  124  240    0    0    0  248    0    0    0    0  236
    0    0    0    0    0  248    0    0  233  124    0    0  154  225    0    0    0    0  236
    0    0    0    0    0  255    0  199  189    0    0    0  208  167    0    0    0    0  236
    0    0    0    0    0  255  154  225    0    0    0  140  240    0    0    0    0    0  236
    0    0    0    0    0  233  255  124    0    0  178  240  124    0    0    0    0    0  236
    0    0    0    0    0  225  225  255  255  248  208  104    0    0    0    0    0    0  236
    0    0    0    0  154  225    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0  248  124    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{217}.cdata = [

    0    0    0    0    0    0    0    0    0  217  167    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  178  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  225    0    0    0    0  124  255  104    0    0  236
    0    0    0    0    0    0    0  225  208    0    0    0    0  178  248    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0    0  208  225    0    0    0  236
    0    0    0    0    0    0  104  255  140    0    0    0    0  233  189    0    0    0  236
    0    0    0    0    0    0  154  255    0    0    0    0    0  255  154    0    0    0  236
    0    0    0    0    0    0  189  233    0    0    0    0  140  255  104    0    0    0  236
    0    0    0    0    0    0  225  217    0    0    0    0  178  240    0    0    0    0  236
    0    0    0    0    0    0  225  208    0    0    0    0  240  199    0    0    0    0  236
    0    0    0    0    0    0  189  248  140    0  104  217  233    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  248  255  248  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{218}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0  167  217    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  208  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  225    0    0    0    0  124  255  104    0    0  236
    0    0    0    0    0    0    0  225  208    0    0    0    0  178  248    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0    0  208  225    0    0    0  236
    0    0    0    0    0    0  104  255  140    0    0    0    0  233  189    0    0    0  236
    0    0    0    0    0    0  154  255    0    0    0    0    0  255  154    0    0    0  236
    0    0    0    0    0    0  189  233    0    0    0    0  140  255  104    0    0    0  236
    0    0    0    0    0    0  225  217    0    0    0    0  178  240    0    0    0    0  236
    0    0    0    0    0    0  225  208    0    0    0    0  240  199    0    0    0    0  236
    0    0    0    0    0    0  189  248  140    0  104  217  233    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  248  255  248  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{219}.cdata = [

    0    0    0    0    0    0    0    0    0    0  189  240  225    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  208  178    0  178  233    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  225    0    0    0    0  124  255  104    0    0  236
    0    0    0    0    0    0    0  225  208    0    0    0    0  178  248    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0    0  208  225    0    0    0  236
    0    0    0    0    0    0  104  255  140    0    0    0    0  233  189    0    0    0  236
    0    0    0    0    0    0  154  255    0    0    0    0    0  255  154    0    0    0  236
    0    0    0    0    0    0  189  233    0    0    0    0  140  255  104    0    0    0  236
    0    0    0    0    0    0  225  217    0    0    0    0  178  240    0    0    0    0  236
    0    0    0    0    0    0  225  208    0    0    0    0  240  199    0    0    0    0  236
    0    0    0    0    0    0  189  248  140    0  104  217  233    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  248  255  248  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{220}.cdata = [

    0    0    0    0    0    0    0    0    0    0  248    0    0  240    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0    0  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  225    0    0    0    0  124  255  104    0    0  236
    0    0    0    0    0    0    0  225  208    0    0    0    0  178  248    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0    0  208  225    0    0    0  236
    0    0    0    0    0    0  104  255  140    0    0    0    0  233  189    0    0    0  236
    0    0    0    0    0    0  154  255    0    0    0    0    0  255  154    0    0    0  236
    0    0    0    0    0    0  189  233    0    0    0    0  140  255  104    0    0    0  236
    0    0    0    0    0    0  225  217    0    0    0    0  178  240    0    0    0    0  236
    0    0    0    0    0    0  225  208    0    0    0    0  240  199    0    0    0    0  236
    0    0    0    0    0    0  189  248  140    0  104  217  233    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  248  255  248  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{221}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0  167  217    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  208  178    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  248    0    0    0    0  233  199    0    0    0  236
    0    0    0    0    0    0    0  104  255  140    0    0  199  240    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  199    0  140  255  124    0    0    0    0  236
    0    0    0    0    0    0    0    0  199  233    0  240  189    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  255  208  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248  248  104    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  154    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255  104    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  178  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{222}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  255  255  255  240  124    0    0    0    0  236
    0    0    0    0    0    0    0    0  217  217    0    0  167  240    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0    0  255    0    0    0    0  236
    0    0    0    0    0    0    0  104  255  140    0    0  140  233    0    0    0    0  236
    0    0    0    0    0    0    0  154  255    0    0  140  240  154    0    0    0    0  236
    0    0    0    0    0    0    0  189  255  255  255  233  154    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  208    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{223}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  178  240  255  240  154    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  248  140    0  154  248    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  189    0    0    0  248    0    0    0    0  236
    0    0    0    0    0    0    0  104  255  140    0  104  233  167    0    0    0    0  236
    0    0    0    0    0    0    0  154  255    0  140  225  104    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  225    0  217  154    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  233  189    0  189  248  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  167  248  208    0    0    0    0  236
    0    0    0    0    0    0  154  255    0    0    0    0  104  255    0    0    0    0  236
    0    0    0    0    0    0  199  225    0    0    0    0  178  225    0    0    0    0  236
    0    0    0    0    0    0  233  189  189  255  255  248  208    0    0    0    0    0  236
    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  154  248    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0  248  255  167    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{224}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  240  255  225  208  199    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0  255  124    0    0    0    0  236
    0    0    0    0    0    0  124  255  104    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  225  225    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  140    0  208  255  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  240  189  225  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{225}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  124  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  104  240  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  240  255  225  208  199    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0  255  124    0    0    0    0  236
    0    0    0    0    0    0  124  255  104    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  225  225    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  140    0  208  255  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  240  189  225  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{226}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  167  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  248  189  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  124    0  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  240  255  225  208  199    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0  255  124    0    0    0    0  236
    0    0    0    0    0    0  124  255  104    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  225  225    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  140    0  208  255  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  240  189  225  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{227}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  255  154    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  124  240  124  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0  167  255  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  240  255  225  208  199    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0  255  124    0    0    0    0  236
    0    0    0    0    0    0  124  255  104    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  225  225    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  140    0  208  255  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  240  189  225  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{228}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0  240    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  240  255  225  208  199    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0  255  124    0    0    0    0  236
    0    0    0    0    0    0  124  255  104    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  225  225    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  140    0  208  255  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  240  189  225  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{229}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  248  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  124  255    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  104  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  199  255  178    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  240  255  225  208  199    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0  255  124    0    0    0    0  236
    0    0    0    0    0    0  124  255  104    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  225  225    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  140    0  208  255  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  240  189  225  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{230}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0  154  217  255  255  240  124  199  248  255  233  154    0    0  236
    0    0    0    0    0  248  189    0    0  225  248  178    0    0  140  248    0    0  236
    0    0    0    0    0    0    0    0    0  217  178    0    0  124  189  233    0    0  236
    0    0    0    0    0  208  240  255  255  255  255  255  255  233  199    0    0    0  236
    0    0    0    0  225  189  104    0    0  255    0    0    0    0    0    0    0    0  236
    0    0    0    0  255  140    0  104  199  255  178    0    0    0    0    0    0    0  236
    0    0    0    0  167  248  255  240  178  124  225  255  255  248  217    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{231}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  240  255  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  104  248  140    0  178  233    0    0    0    0    0  236
    0    0    0    0    0    0    0  208  178    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  104    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  154    0  140  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  248  255  225  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  248  255  189    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{232}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  233  255  248  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  167    0  104  208  240    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  240  208  104    0    0    0    0    0  236
    0    0    0    0    0    0  140  233    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  124  248  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  248  255  255  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{233}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  124  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  104  240  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  233  255  248  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  167    0  104  208  240    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  240  208  104    0    0    0    0    0  236
    0    0    0    0    0    0  140  233    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  124  248  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  248  255  255  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{234}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  167  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  248  189  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  124    0  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  233  255  248  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  167    0  104  208  240    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  240  208  104    0    0    0    0    0  236
    0    0    0    0    0    0  140  233    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  124  248  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  248  255  255  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{235}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0  240    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  233  255  248  167    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  140    0  178  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  167    0  104  208  240    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  255  255  240  208  104    0    0    0    0    0  236
    0    0    0    0    0    0  140  233    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  124  248  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  248  255  255  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{236}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  154  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{237}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  124  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  104  240  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  154  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{238}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  167  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  248  189  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  124    0  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  154  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{239}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233    0  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  154  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  217  199    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  225  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{240}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  240  178  208  248    0    0    0  236
    0    0    0    0    0    0    0    0    0  140  208  248  255  217  154    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  208  178  255  167    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  240  225    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  240  255  225  217  255    0    0    0    0  236
    0    0    0    0    0    0    0  104  248  140    0  189  255  255    0    0    0    0  236
    0    0    0    0    0    0    0  208  167    0    0    0  255  248    0    0    0    0  236
    0    0    0    0    0    0    0  240  104    0    0    0  255  217    0    0    0    0  236
    0    0    0    0    0    0    0  255    0    0    0  178  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  248  154    0  140  248  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  248  255  240  189    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{241}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  255  154    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  124  240  124  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0  167  255  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  240  154  240  255  225    0    0    0    0    0  236
    0    0    0    0    0    0    0  178  248  233  104  124  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  208  240    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  233  178    0    0  140  255  104    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  189  240    0    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  217  217    0    0    0    0    0  236
    0    0    0    0    0    0  178  240    0    0    0  240  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{242}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  233  255  248  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  154    0  140  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0  225  189    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0  255  167    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  154  255  104    0    0    0    0  236
    0    0    0    0    0    0  124  255  154    0  140  248  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  248  255  240  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{243}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  124  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  104  240  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  233  255  248  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  154    0  140  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0  225  189    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0  255  167    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  154  255  104    0    0    0    0  236
    0    0    0    0    0    0  124  255  154    0  140  248  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  248  255  240  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{244}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  167  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  248  189  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  124    0  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  233  255  248  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  154    0  140  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0  225  189    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0  255  167    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  154  255  104    0    0    0    0  236
    0    0    0    0    0    0  124  255  154    0  140  248  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  248  255  240  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{245}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  167  255  154    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  240  124  240  124  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  255    0  167  255  167    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  233  255  248  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  154    0  140  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0  225  189    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0  255  167    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  154  255  104    0    0    0    0  236
    0    0    0    0    0    0  124  255  154    0  140  248  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  248  255  240  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{246}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0  240    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  154  233  255  248  199    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  248  154    0  140  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0    0  225  189    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0    0  255  167    0    0    0    0  236
    0    0    0    0    0    0  140  255    0    0    0  154  255  104    0    0    0    0  236
    0    0    0    0    0    0  124  255  154    0  140  248  189    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  248  255  240  167    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{247}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  240  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  255  217    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  255  255  255  255  255  248    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  248    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{248}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0  140  233    0    0    0    0  236
    0    0    0    0    0    0    0    0  124  225  255  255  255  167    0    0    0    0  236
    0    0    0    0    0    0    0  104  240  140    0  199  240  240    0    0    0    0  236
    0    0    0    0    0    0    0  208  189    0  154  225    0  255    0    0    0    0  236
    0    0    0    0    0    0    0  248  104    0  240    0  104  240    0    0    0    0  236
    0    0    0    0    0    0    0  255    0  225  154    0  189  208    0    0    0    0  236
    0    0    0    0    0    0    0  240  233  199    0  189  240    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  255  255  248  208    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  233  140    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{249}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  189  189    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  104  240    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255    0    0    0  217  208    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0    0  240  178    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  225  233    0    0    0    0    0  236
    0    0    0    0    0    0  124  255  154    0  208  248  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  248  189  225  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{250}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  124  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  104  240  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255    0    0    0  217  208    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0    0  240  178    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  225  233    0    0    0    0    0  236
    0    0    0    0    0    0  124  255  154    0  208  248  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  248  189  225  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{251}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  167  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  124  248  189  208    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  240  124    0  255    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255    0    0    0  217  208    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0    0  240  178    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  225  233    0    0    0    0    0  236
    0    0    0    0    0    0  124  255  154    0  208  248  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  248  189  225  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{252}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  248    0  240    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233    0  248    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  140  255    0    0    0  217  208    0    0    0    0  236
    0    0    0    0    0    0    0  189  233    0    0    0  240  178    0    0    0    0  236
    0    0    0    0    0    0    0  217  208    0    0    0  255  140    0    0    0    0  236
    0    0    0    0    0    0    0  240  178    0    0  154  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  225  233    0    0    0    0    0  236
    0    0    0    0    0    0  124  255  154    0  208  248  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  199  255  248  189  225  178    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{253}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0  124  233    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  104  240  124    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0  233  124    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  140  255  104    0    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0  208  217    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  208    0    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  225    0  189  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  255  104  248  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  104  255  240  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  217  233    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{254}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  255  140    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  140  255    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  189  233    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  225  199    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  189  240  255  178    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  255  233  104  124  248    0    0    0    0    0  236
    0    0    0    0    0    0    0  167  255  104    0    0  255    0    0    0    0    0  236
    0    0    0    0    0    0    0  208  217    0    0  104  240    0    0    0    0    0  236
    0    0    0    0    0    0    0  233  178    0    0  167  208    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  208    0  124  248  124    0    0    0    0    0  236
    0    0    0    0    0    0  140  255  199  255  248  167    0    0    0    0    0    0  236
    0    0    0    0    0    0  189  225    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  225  189    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  248  154    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

i{255}.cdata = [

    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  248    0  240    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0  233    0  248    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  255  140    0    0  140  255  104    0    0    0    0  236
    0    0    0    0    0    0    0  248  178    0    0  208  217    0    0    0    0    0  236
    0    0    0    0    0    0    0  225  208    0    0  255  140    0    0    0    0    0  236
    0    0    0    0    0    0    0  189  225    0  189  225    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  154  255  104  248  140    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  104  255  240  217    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0  248  240    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  124  255  140    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0  240  189    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0  217  233    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  236
  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236  236
];

for loop = 1:rgb
iout(:,:,loop) = i{number}.cdata(:,:,1);
end
end