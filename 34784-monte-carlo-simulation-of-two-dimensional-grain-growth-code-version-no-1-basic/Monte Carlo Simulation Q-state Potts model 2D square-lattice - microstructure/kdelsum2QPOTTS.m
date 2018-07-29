function kds2 = kdelsum2QPOTTS(IESMnew)
kd=zeros(1,8);
if IESMnew(2,2)==IESMnew(1,1);kd(1,1)=1;end;
if IESMnew(2,2)==IESMnew(1,2);kd(1,2)=1;end;
if IESMnew(2,2)==IESMnew(1,3);kd(1,3)=1;end;
if IESMnew(2,2)==IESMnew(2,3);kd(1,4)=1;end;
if IESMnew(2,2)==IESMnew(3,3);kd(1,5)=1;end;
if IESMnew(2,2)==IESMnew(3,2);kd(1,6)=1;end;
if IESMnew(2,2)==IESMnew(3,1);kd(1,7)=1;end;
if IESMnew(2,2)==IESMnew(2,1);kd(1,8)=1;end;
kds2 = sum(sum(kd));