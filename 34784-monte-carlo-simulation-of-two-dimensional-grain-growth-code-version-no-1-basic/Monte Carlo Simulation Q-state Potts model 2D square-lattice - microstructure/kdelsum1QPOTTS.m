function kds1 = kdelsum1QPOTTS(IESM)
kd=zeros(1,8);
if IESM(2,2)==IESM(1,1);kd(1,1)=1;end;
if IESM(2,2)==IESM(1,2);kd(1,2)=1;end;
if IESM(2,2)==IESM(1,3);kd(1,3)=1;end;
if IESM(2,2)==IESM(2,3);kd(1,4)=1;end;
if IESM(2,2)==IESM(3,3);kd(1,5)=1;end;
if IESM(2,2)==IESM(3,2);kd(1,6)=1;end;
if IESM(2,2)==IESM(3,1);kd(1,7)=1;end;
if IESM(2,2)==IESM(2,1);kd(1,8)=1;end;
kds1=sum(sum(kd));