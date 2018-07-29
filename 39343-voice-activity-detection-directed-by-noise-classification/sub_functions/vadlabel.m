function [lab]=vadlabel(data)


l=abs(data)>0;
n=find(l==0);
for i=2:length(n)-1
if data(n(i)-1)~=0 || data(n(i)+1)~=0
l(n(i))=1;
end
end
lab = l;
