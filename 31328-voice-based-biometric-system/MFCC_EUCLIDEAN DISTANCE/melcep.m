%Voice Based Biometric System
%By Ambavi K. Patel.


function mfcc3=melcep(mel1,powspc1,noc1,fsize1,nwin1)
mfcc1(1:noc1,1:nwin1)=0;
for j=1:nwin1
 n=floor(fsize1/2);
 mfcc1(:,j)=dct(log(mel1*abs(powspc1(1:n,j).^2)));
 %converting the power-spectrum to a melfrequency spectrum &taking the logarithm of that spectrum and by computing its inverse using
 %discrete cosine transform 
end;
mfcc2(1:13,1:nwin1)=0;
mfcc2(1:13,1:nwin1)=mfcc1(3:15,1:nwin1);
mfcc3=nanclr(mfcc2);
