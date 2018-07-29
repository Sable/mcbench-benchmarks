%for subplots

function p=plots1(x,y,z,img)

H1=abs(img);
colormap(hot)
subplot(x,y,z);
image(5*100*H1/max(max(H1)));%4 for B-727r;

if z==2
    title('ISAR images using Harmonic Wavelets');
end
if z==4
    ylabel('Range')
end
if z==8
    xlabel('Doppler')
end