%Voice Based Biometric System
%By Ambavi K. Patel.

function mfcc2=postnorm(mfcc1,nwin1)
for j=1:nwin1                      % normalising for constant variance and zero mean 
    m=mean(mfcc1(:,j));
    mfcc2(:,j)=mfcc1(:,j)-m;        
end;