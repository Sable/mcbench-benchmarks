function encseq=huffencode(huf,seq)
l=length(seq);
h=length(huf);
hufstr=struct2cell(huf);
hufstr=hufstr(1,1:h);
hufstr=cell2mat(hufstr);
encseq='';
 for i=1:l
     idx=find(seq(i)==hufstr);
     encseq=strcat(encseq,cell2mat(huf(idx).code));
 end
end