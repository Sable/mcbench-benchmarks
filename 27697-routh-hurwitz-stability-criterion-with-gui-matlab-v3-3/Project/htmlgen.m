function [STR]=htmlgen(VEC,M,PRE,STA,COLOR)
%[string]=htmlgen(vector,M,precision,state,'color')
%'M' is the power of 's' that will change color
%color can be 'red' 'yellow' 'green' 'blue'
%state can be 'inf' or '-inf' or 'simp'
n=length(VEC);
htmlstr={};
for j=1:n
    if j~=n
        nsub=numchar(VEC(j))-1;
        htmlstr{j}=[num2str(VEC(j)) spahtml(PRE+6-nsub)];
    else
        htmlstr{j}=num2str(VEC(j));
    end
end
htmlvec=strcat(htmlstr{:});

msub=numchar(M)-1;

if strcmp(STA,'inf') && VEC(1)==inf
    p=['<HTML><FONT color=' sprintf('"%s">',COLOR)...
        sprintf('s^%g',M) spahtml(8-msub) htmlvec '</Font></html>'];
elseif strcmp(STA,'-inf') && VEC(1)==inf
    p=['<HTML><FONT color=' sprintf('"%s">',COLOR)...
        sprintf('s^%g',M) spahtml(9-msub) htmlvec '</Font></html>'];
elseif strcmp(STA,'-inf') && VEC(1)==-inf
    p=['<HTML><FONT color=' sprintf('"%s">',COLOR)...
        sprintf('s^%g',M) spahtml(8-msub) htmlvec '</Font></html>'];
elseif strcmp(STA,'inf') && VEC(1)~=inf && VEC(1)~=-inf
    p=['<HTML><FONT color=' sprintf('"%s">',COLOR)...
        sprintf('s^%g&',M) spahtml(10-msub) htmlvec '</Font></html>'];
elseif strcmp(STA,'-inf') && VEC(1)~=inf && VEC(1)~=-inf
    p=['<HTML><FONT color=' sprintf('"%s">',COLOR)...
        sprintf('s^%g',M) spahtml(11-msub) htmlvec '</Font></html>'];
elseif strcmp(STA,'simp')
    p=['<HTML><FONT color=' sprintf('"%s">',COLOR)...
        sprintf('s^%g',M) spahtml(8-msub) htmlvec '</Font></html>'];
end
STR=p;

