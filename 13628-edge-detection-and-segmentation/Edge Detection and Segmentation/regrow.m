% Question No: 6

% Consider an image composed of small, no overlapping blobs. Segmenting the
% blobs based on region growing.

function regrow(x)
f1=imread(x);
f=double(f1);
s=255;
t=65;  
if numel(s)==1
    si=f==s;
    s1=s;
else
    si=bwmorph(s,'shrink',Inf);
    j=find(si);
    s1=f(j);
end
ti=false(size(f));
for k=1:length(s1)
    sv=s1(k);
    s=abs(f-sv)<=t;
    ti=ti|s;
end
[g nr]=bwlabel(imreconstruct(si,ti));
figure,imshow(f1),title('Original Image');
figure,imshow(g),title('Segmented Image - Region Growing');
display('No: of regions');
nr
end