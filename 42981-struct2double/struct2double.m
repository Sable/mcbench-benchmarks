function [out]=struct2double(in,field)
% Converts a structure into a double matrix. 
% [out]=struct2double(in) creates out(A,B,C) where [A,B]=size(in) and
% fn=fieldnames(in)  C=length(fn)
% 
% fields must be doubles and not structures
% 
% [out]=struct2double(in,field) creates out(A,B,C) where [A,B]=size(in) and
% for the given fieldname 'field'.






[A,B]=size(in);
if nargin==1
[AA1,BB1,CC1]=structfun(@size,in);

AA=max(AA1);
BB=max(BB1);
CC=max(CC1);
 fn=fieldnames(in);
C=length(fn);  
out=nan(A,B,C,AA,BB,CC);

 
for i=1:C
    for j=1:A
        for k=1:B
            
            out(j,k,i,1:AA1(i),1:BB1(i),1:CC1(i))=getfield(in,{j,k},fn{i});
        end
    end
    
end


elseif nargin==2
    
    
 
    for j=1:A
        for k=1:B
            out(j,k,:,:,:)=getfield(in,{j,k},field);
        end
    end
 
end
    
out=squeeze(out);