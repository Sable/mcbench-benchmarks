function huff()
clc;
fid=fopen('seq1.txt','r');
seq=fread(fid,'*char');
fclose(fid);
seq=reshape(seq,1,length(seq));
[alpha prob]=probmodel(seq);
if ~isempty(alpha)
[huf entropy avglength redundancy]=huffman(alpha,prob);
if ~isempty(huf)
    lp=length(prob);
   for i=1:lp
     str=huf(i).sym;
     str=strcat(str,' :');
     str=strcat(str,num2str(huf(i).prob));
     str=strcat(str,' :');
     str=strcat(str,huf(i).code);
     disp(str);
   end
   disp(strcat('Entropy = ',num2str(entropy)));
   disp(strcat('Average length = ',num2str(avglength)));
   disp(strcat('Redundancy = ',num2str(redundancy)));
   encseq=huffencode(huf,seq);
   disp('Sequence :');
   disp(seq);
   disp('Encoded Sequence :');
   disp(encseq);
   decseq=huffdecode(huf,encseq);
   disp('Decoded Sequence :');
   disp(decseq);
end
else
    display('Empty Sequence....');
end
end