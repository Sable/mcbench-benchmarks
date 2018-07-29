function [huff entropy avglength redundancy]=huffman(alpha,prob)
s=sum(prob(:));
s=roundn(s,-4);
% Calculate length of source and probability
la=length(alpha);
lp=length(prob);
if (la==lp & s==1)
       %Calculate the Entropy
         entropy=prob.*log2(prob);   
         entropy=-sum(entropy(:));
         pos=1:lp;
         [prs idx]=sort(prob,'descend');
         npos=pos(idx);
         %Minimum Variance
         idx=find(prs==min(prs(:)));
         tp=npos(idx);
         tp=sort(tp,'descend');
         npos(idx)=tp;
         %
         codebook(1:lp)={''};
         ps=npos;
         np=lp;
         cb=zeros([lp-1 3]);
         cnt=lp+1;
         prb=prs;
         for i=1:lp-1
              fst=ps(np-1);
              sec=ps(np);
                
                if fst<=lp
                   codebook(fst)=strcat('0',codebook(fst));
                else
                  codebook=encod(fst,cb,codebook,'0',lp);
                   
                end
              
                if sec<=lp
                    codebook(sec)=strcat('1',codebook(sec));
                else
                   codebook=encod(sec,cb,codebook,'1',lp);
                end
              cb(i,1)=cnt;
              cb(i,2)=fst;
              cb(i,3)=sec;
              if np>2
                  ps=ps(1:np-2);
                  ps(np-1)=cnt;
                  cnt=cnt+1;
                  prbt=prb(1:np-2);
                  prbt(np-1)=prb(np-1)+prb(np);
                  prb=prbt;
                  [prb idx]=sort(prb,'descend');
                  ps=ps(idx);
                  %Minimum Variance
                  idx=find(prb==prbt(np-1));
                  tp=ps(idx);
                  tp=sort(tp,'descend');
                  ps(idx)=tp;
                  %
                  np=np-1;
              end
              
         end
         for i=1:lp
            huff(i).sym=alpha(i);
            huff(i).prob=prob(i);
            huff(i).code=codebook(i);
         end
           avglength=0;
           for i=1:lp
               avglength=avglength+huff(i).prob*length(cell2mat(huff(i).code));
           end
           redundancy=((avglength-entropy)/entropy)*100;
else
    display('Error in input.....');
    huff=[];
end


function codebook=encod(fs,cb,codebook,str,lp)
idx=find(cb(:,1)==fs);
x=cb(idx,2);
y=cb(idx,3);
 if x<=lp & y<=lp
     codebook(x)=strcat(str,codebook(x));
     codebook(y)=strcat(str,codebook(y));
     return
 elseif x<=lp
     codebook(x)=strcat(str,codebook(x));
     codebook=encod(y,cb,codebook,str,lp);
 elseif y<=lp
     codebook(y)=strcat(str,codebook(y));
     codebook=encod(x,cb,codebook,str,lp);
 else
     codebook=encod(x,cb,codebook,str,lp);
     codebook=encod(y,cb,codebook,str,lp);
 end
