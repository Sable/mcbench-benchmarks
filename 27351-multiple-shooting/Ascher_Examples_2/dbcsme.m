function res = dbcsme(ya,yb)
% derivative of F respect to ya
Ba=zeros(5,5);
Ba(1,1)=1;Ba(2,2)=1;Ba(3,3)=1;Ba(4,4)=1;
res.Ba=Ba;
% derivative of F respect to yb
Bb=zeros(5,5);
Bb(5,3)=-1;Bb(5,5)=1;
res.Bb=Bb;
end
