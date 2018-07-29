function imout=sizethre(im,s,mode);
% function sizethre(im,s,mode);
% input: im=binary image matrix. 0 is background. 1 is foreground
% input: s=pixel number
% mode: string varable. It should either be 'up' or 'down'
% when mode='up', area LARGER than s is DELETED
% when mode='down', area SMALLER than s is DELETED
% output: imout is an image matrix. size(imout)=size(im)
% foreground whose area is larger (or smaller, depending on 'mode') is
% preserved; otherwise, it is deleted (marked as background);
% Zhe Wu 01-08-2002 @ University of Rochester
 
%label each block with numbers
 [L,num ]=bwlabel(im,8);
 
%size threshold
 for i=1: num 
   blocksize( i)=length(find(L==i));
   if xor(blocksize(i)>s , strcmp(mode,'down'))
   mark( i)=0; %0 means it is big vessel
   else
   mark( i)=1;% 1 means it is small one
   end %end if
 end % end i 


   i=find(mark);
   imout=zeros(size(im));
   for p=1:length(i)
   imout=(L==i(p))+imout;
   end 
   
