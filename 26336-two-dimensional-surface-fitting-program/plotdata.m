function plotdata
load('AN')
load('AT')
w=[1:5,10:10:100];
p=[3 5 8 12 15];
AA=squeeze(AT(1,:,:));
plot(w,AA)
figure
plot(p,AA')