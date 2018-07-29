function stepplot

rr=findobj(gcf,'Tag','edit1'); 
r1=get(rr,'string');% get the value of numenator of G(s)
rr=findobj(gcf,'Tag','edit2');
r2=get(rr,'string');% get the value of denomenator of G(s

numg=str2num(r1); %numenator of G(s)
deng=str2num(r2); %denomenator of G(s)

rr=findobj(gcf,'Tag','edit3');
r4=get(rr,'string');% get the value of numenator of H(s)
rr=findobj(gcf,'Tag','edit4');
r5=get(rr,'string');% get the value of denomenator of H(s)

numh=str2num(r4);%numenator of H(s)
denh=str2num(r5);%denomenator of H(s)
h=tf(numh,denh); % H(s)

rr=findobj(gcf,'Tag','slider1');
r6=get(rr,'value');% get the value of proportional controller
rr=findobj(gcf,'Tag','slider2');
r7=get(rr,'value');% get the value of integrater controller
rr=findobj(gcf,'Tag','slider3');
r8=get(rr,'value');% get the value of defferentiatr controller

Kp=r6;
Ki=r7;
Kd=r8;

numcf=[Kd Kp Ki];         % numinator of PID
dencf=[1 0];              % denomenator of PID  
numf=conv(numcf,numg);
denf=conv(dencf,deng);
fsys=tf(numf,denf); % forward transfare function.
csys=feedback(fsys,h);
[y,t] = step(csys); % step response
plot(t,y)
