function decseq=huffdecode(huf,encseq)
l=length(encseq);
h=length(huf);
for i=1:h
hufcod(i)=huf(i).code;
end
decseq='';
str='';
 for i=1:l
     str=[str encseq(i)];
    idx=find(strcmp(str,hufcod));
    if ~isempty(idx)
        decseq=[decseq huf(idx).sym];
        str='';
    end
 end
end