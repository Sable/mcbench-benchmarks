function [dval] = float32hex2num(hstring)
%a is a hex string in float32 format
dec=hex2dec(hstring);

%find fraction first
maskf='7FFFFF'; %hex mask for 23 bit fraction 
maske='7F800000';
mdf=hex2dec(maskf);
mde=hex2dec(maske);

exp=bitand(dec,mde)/2^23;
frac=bitand(dec,mdf);
%find sign
sign=bitshift(dec,-31,32);


    temp=1+frac/2^23;
    temp=temp*(2^(exp-127));
    if sign~=0
        temp=-1*temp;
    end
    
    dval=temp;




