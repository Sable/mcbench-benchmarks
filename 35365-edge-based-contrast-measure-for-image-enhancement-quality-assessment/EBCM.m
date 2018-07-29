function EB=EBCM(I_prop1)
[m,n]=size(I_prop1);
h_sob=fspecial('sobel');
I_prop1_norm=double(I_prop1./255);
I_filt_norm=imfilter(I_prop1_norm,h_sob,'replicate');
gij_xij=(I_prop1_norm).*(I_filt_norm);
h_avg=fspecial('average'); %%%default size is 3 by 3
I_filt_avg=imfilter(I_filt_norm,h_avg,'replicate');
gij_xij_avg=imfilter(gij_xij,h_avg,'replicate');
eij=(gij_xij_avg./(I_filt_avg+0.0001));
cij=abs(I_prop1_norm-eij)./abs(I_prop1_norm+eij+0.0001);
cij_u=sum(sum(uint8(round(cij*255))));
EB=cij_u/(m*n);
end