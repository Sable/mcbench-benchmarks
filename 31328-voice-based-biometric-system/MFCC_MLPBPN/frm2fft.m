%Voice Based Biometric System
%By Ambavi K. Patel.


function d1=frm2fft(fsize1,osize1,nwin1,ip1)
a1(1:fsize1,1:nwin1)=0; % framing the signal with overlap
a1(:,1)=ip1(1:fsize1);
for j=2:nwin1  
a1(:,j)=ip1((fsize1-osize1)*(j-1)+1:(fsize1-osize1)*(j-1)+fsize1); 
end;
h1= hamming(fsize1); % windowing using hamming window
b1(1:fsize1,1:nwin1)=0;
for j=1:nwin1
b1(:,j)= a1(:,j).* h1; % a is the segmented frame of size 250 samples and h is the hamming window for the segmented frame
end;
c1(1:fsize1,1:nwin1)=0;
for j=1:nwin1 %FFT(X) is the discrete Fourier transform (DFT) of vector X.
c1(:,j)=fft(b1(:,j)); 
end;
d1(1:floor(fsize1/2),1:nwin1)=c1(1:floor(fsize1/2),1:nwin1);% since power spetrum are symmetric
d1=nanclr(d1); % to clear 'not a number' value
%figure;
%plot(abs(d1));


