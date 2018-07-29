function [out] = graydil(im,se)

if (~isa(se,'strel'))
    se=strel(se);
end
seq=getsequence(se);
lunghezza=size(seq,1);

out=gdil(im,getnhood(seq(1)),2);
for ii=2:lunghezza
    out=gdil(out,getnhood(seq(ii)),2);        
end
