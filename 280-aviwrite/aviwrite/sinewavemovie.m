x=0:pi/180:2*pi;

for i=1:20,
   phi=2*pi/20*i;
   plot(x,sin(x+phi));
   drawnow;
   M(i)=getindexedframe;
end;

aviwrite('sinewavemovie.avi',M,4);