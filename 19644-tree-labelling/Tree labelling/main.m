% Algorithm and Programming by: Alireza Fasih
% 16 April 2008
% special thanks to "Nicholas Howe" for his very useful junction extractor routine

clc;
clear all;
BW = imread('test.bmp');
BW3 = bwmorph(BW,'skel',Inf); 
BW4 = bwmorph(BW3,'spur',10);  % 10=delete noise branchs Inf=Extract Main branch
BW5 = bwmorph(BW3,'spur',Inf); % 10=delete noise branchs Inf=Extract Main branch
[row,col]=size(BW);

[d_map,e_xy,j_xy] = anaskel(BW4);

% junction count
len = length (j_xy(1,:)); 

% Junction Removing
%      j
%  [ ][ ][ ]
% i[ ][0][ ]
%  [ ][ ][ ]

for i=1:len % 'len' is count of junction
   BW4(j_xy(2,i),j_xy(1,i))=0; % [i,j] = 0
   
   BW4(j_xy(2,i)-1,j_xy(1,i))=0;
   BW4(j_xy(2,i)+1,j_xy(1,i))=0;
   BW4(j_xy(2,i),j_xy(1,i)-1)=0;
   BW4(j_xy(2,i),j_xy(1,i)+1)=0;
   
   BW4(j_xy(2,i)-1,j_xy(1,i)-1)=0;
   BW4(j_xy(2,i)+1,j_xy(1,i)+1)=0;
   BW4(j_xy(2,i)-1,j_xy(1,i)+1)=0;
   BW4(j_xy(2,i)+1,j_xy(1,i)-1)=0;   
end

% (main tree) - (main branch) = branches
branchs = BW4 - BW5;
sm = bwmorph(BW5,'dilate',3);

% Label connected components in binary image
L = bwlabel(branchs);

% adding branchs and main branch.
L = L + (BW5*20);  % 20 is an assumed number!

% Convert label matrix into RGB image
RGB = label2rgb(L,'Lines');
imshow(RGB);
hold on

% End of points and Junction Plot 
plot(e_xy(1,:),e_xy(2,:),'go') % green dots
plot(j_xy(1,:),j_xy(2,:),'ro') % red dots

len_e = length (e_xy(1,:)) ;

for i=2:len+1
 
 if ( abs(e_xy(2,i)-row)>20 || abs(e_xy(1,i)-col)>20 )
     
    % selecting the i'th label
    sel_color = L(e_xy(2,i),e_xy(1,i));           
   
    % splitting of selected branch
    sel_label = (L==sel_color);
    
    % if this branch is a soundly branch, then ...
    if (bwarea(sel_label)>4)
      
      % selected branch dilating, for finding collision between it and main branch.
      sl = bwmorph(sel_label,'dilate',3);
      
      % collision evaluation between selected branch and main branch by multiply function.      
      dif = immultiply(sm,sl); % Multiply two images or multiply image by constant
      
      % zero result means there isn't any collision. on the other hand,
      % this branch is tertiary branch. wow! otherwise, it's a secondary
      % branch
      if (dif==zeros(row,col))          
          text (e_xy(1,i)+4,e_xy(2,i)-8,'3');        
      else
          text (e_xy(1,i)+4,e_xy(2,i)-8,'2');              
      end            
      
    end
    
 end

 
end

 % main branch will find in BW5 variable! 
 % set label '1' on image 
 hold on
 flag=0;
 for i=1:row     
  for j=1:col     
      
    if (BW5(i,j)==1)
      text (j+15,i+15,'1');
       flag=1;
       break;                 
    end        
    
  end 
  
   if (flag==1)
         break;         
    end        

 end


