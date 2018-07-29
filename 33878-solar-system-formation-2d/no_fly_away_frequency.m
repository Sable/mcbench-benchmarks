function f=no_fly_away_frequency(G,mm,r)

r1=shiftdim(r);


dd2=sum(r1.^2,2);
dd=sqrt(dd2);
%ddm=max(dd);
ddm=mean(dd);

f=0.1*sqrt(G*mm/(ddm^3))/(2*pi); % itital frequency of global rotation
