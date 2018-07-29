function z=isar_hwtmapf(xf,w,len)

%% Function to compute Harmonic Wavelet Map.

%% Author : SHREYAMSHA KUMAR B.K.
%% Created on 26-02-2005. 
%% updated on 26-02-2005.

k=length(w);
for ii=1:len-k+1
    y=zeros(1,len);
    y(ii:k-1+ii)=w.*xf(ii:k-1+ii);
    temp=ifft(y)';
    z(:,ii)=abs(temp).^2;%% Magnitude Squared.
end