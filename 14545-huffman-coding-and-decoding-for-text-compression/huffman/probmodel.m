function [alpha prob]=probmodel(seq)
 if ~isempty(seq)
     alpha(1)=seq(1);
     prob(1)=1;
     l=length(seq);
     k=2;
     for i=2:l
         idx=find(seq(i)==alpha);
         if isempty(idx)
             alpha(k)=seq(i);
             prob(k)=1;
             k=k+1;
         else
            prob(idx)=prob(idx)+1; 
         end
     end
     prob=prob./l;
 else
     alpha=[];
     prob=[];
 end
end