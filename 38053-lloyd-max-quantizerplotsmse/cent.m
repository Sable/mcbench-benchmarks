function [ sk,lu ] = cent( mint,mfin,sig,k,levels )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
lu=0;
sk=0;
for j=1:10000
    if(sig(j)<mfin && sig(j)>=mint)
        lu=lu+1;
        sk=sk+sig(j);
    end
end
if lu==0
    sk=(mint+mfin)/2;
    lu=1;
end
% if (lu==0 && k <= levels/2)
%     sk = mint;
%     lu=1;
% elseif (lu == 0 && k > levels/2)
%     sk = mfin;
%     lu=1;
% end

end