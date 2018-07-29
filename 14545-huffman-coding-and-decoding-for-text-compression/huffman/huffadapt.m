function huffadapt()
clc;
fid=fopen('seq.txt','r');
seq=fread(fid,'*char');
fclose(fid);
seq=reshape(seq,1,length(seq));
[alpha prob]=probmodel(seq);
btag=huffadaptencod(alpha,seq);
disp(strcat('Tag =',btag));
seq=huffadaptdecod(alpha,btag);
disp(strcat('Sequence =',seq));
end