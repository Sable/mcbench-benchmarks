function Disp_HHT(imf,t,f,sub,color)

[Ae,fe,tte]=hhspectrum(imf);
[im,tt,ff]=toimage(Ae,fe);
%disp_hhs(im,t);
disp_hhs2(im,t,[],0,sub,color);
if color == 0
    subplot(6,1,1);plot(t,f,'black');
else
    subplot(6,1,1);plot(t,f);
end
axis tight