function zz=trajt(para,chrom)
%syms para chrom
x0=para(1);
y0=para(2);
vx0=0;
vy0=0;
ax0=0;
ay0=0;
x2=para(3);
y2=para(4);
vx2=0;
vy2=0;
ax2=0;
ay2=0;

x1=chrom(1);
y1=chrom(2);
vx1=chrom(3);
vy1=chrom(4);
t1=chrom(5);
t2=chrom(6);
a00=x0;
a01=vx0;
a02=ax0/2;
a03=(4*x1-vx1*t1-4*x0-3*vx0*t1-ax0*t1^2)/t1^3;
a04=(vx1*t1-3*x1+3*x0+2*vx0*t1+ax0*t1^2/2)/t1^4;
ax1=2*a02+6*a03*t1+12*a04*t1^2;
c00=y0;
c01=vy0;
c02=ay0/2;
c03=(4*y1-vy1*t1-4*y0-3*vy0*t1-ay0*t1^2)/t1^3;
c04=(vy1*t1-3*y1+3*y0+2*vy0*t1+ay0*t1^2/2)/t1^4;
ay1=2*c02+6*c03*t1+12*c04*t1^2;
b10=x1;
b11=vx1;
b12=ax1/2;
b13=(20*x2-20*x1-(8*vx2+12*vx1)*t2-(3*ax1-ax2)*t2^2)/(2*t2^3);
b14=(30*x1-30*x2+(14*vx2+16*vx1)*t2+(3*ax1-2*ax2)*t2^2)/(2*t2^4);
b15=(12*x2-12*x1-(6*vx2+6*vx1)*t2-(ax1-ax2)*t2^2)/(2*t2^5);
d10=y1;
d11=vy1;
d12=ay1/2;
d13=(20*y2-20*y1-(8*vy2+12*vy1)*t2-(3*ay1-ay2)*t2^2)/(2*t2^3);
d14=(30*y1-30*y2+(14*vy2+16*vy1)*t2+(3*ay1-2*ay2)*t2^2)/(2*t2^4);
d15=(12*y2-12*y1-(6*vy2+6*vy1)*t2-(ay1-ay2)*t2^2)/(2*t2^5);
t=linspace(0,t1,20);
x01=a00+a01*t+a02*t.^2+a03*t.^3+a04*t.^4;
vx01=a01+2*a02*t+3*a03*t.^2+4*a04*t.^3;
ax01=2*a02+6*a03*t+12*a04*t.^2;
y01=c00+c01*t+c02*t.^2+c03*t.^3+c04*t.^4;
vy01=c01+2*c02*t+3*c03*t.^2+4*c04*t.^3;
ay01=2*c02+6*c03*t+12*c04*t.^2;

t=linspace(0,t2,20);

x12=b10+b11*t+b12*t.^2+b13*t.^3+b14*t.^4+b15*t.^5;
vx12=b11+2*b12*t+3*b13*t.^2+4*b14*t.^3+5*b15*t.^4;
ax12=2*b12+6*b13*t+12*b14*t.^2+20*b15*t.^3;
y12=d10+d11*t+d12*t.^2+d13*t.^3+d14*t.^4+d15*t.^5;
vy12=d11+2*d12*t+3*d13*t.^2+4*d14*t.^3+5*d15*t.^4;
ay12=2*d12+6*d13*t+12*d14*t.^2+20*d15*t.^3;


vvx=[vx01 vx12];vvy=[vy01 vy12];vq1=vvx;vq2=vvy;
ppx=[x01 x12];ppy=[y01 y12]; q1=ppx;q2=ppy;
aax=[ax01 ax12];aay=[ay01 ay12];aq1=aax;aq2=aay;

zz=[q1;q2;vq1;vq2;aq1;aq2];



