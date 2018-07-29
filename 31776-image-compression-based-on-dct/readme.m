%Image Compression 

%compdct.m:
%main code to compress an image we only run compdct.m
%decompdct.m:
% to decompress an image we only run compdct.m
%resize.m:
%here we give an esample: if we have value big than  65792 like 19071001 in
%8 bits we can not save it so we use resize:
%X=19071001;
%Y=resize(X) 
%>>Y
%1 35 0 25
%here X=1*256^3+35*256^2+0*256^1+25*256^0
%proba.m:
%like hist.m
%zigzag.m:
%zigzag scan for bloc [8 8]
%zigzaginv.m:
%inverse zigzag scan for bloc [8 8]
%zigzag16.m:
%zigzag scan for bloc [16 16]
%zigzinv16.m:
%inverse zigzag scan for bloc [16 16]
%zigzag32.m:
%zigzag scan for bloc [32 32]
%zigzinv32.m:
%inverse zigzag scan for bloc [32 32]
%rle.m:
%Run length encoding
%irle.m:
% Inverse Run length encoding
%abais.m:
%here we give an esample: if we have value big than 255 like 275 in
%8 bits we can not save it so we use resize:
%X=275;
%Y=resize(X) 
%>>Y
%1 19 
%here X=1*256^1+19*256^0
%Iabais.m:
%X=Iabais(y);




