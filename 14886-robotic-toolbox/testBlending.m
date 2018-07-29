
%%Test the blending trajectory:
tb=blendingCoeff(30,75,1,50,0,0);
tt=linspace(0,1);
[pos,vel,acc]=parabolicblend(tt,tb,40,0,20);
plot(tt,pos);