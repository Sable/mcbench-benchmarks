function [hRevolve, hPlate1,hPlate2]=Revolve(orgin,x,y,dir,n,closed)

m=length(x);
t=linspace(0,2*pi,n);
if dir=='y'
    xx1=x*sin(t)+orgin(1);
	xx2=y*ones(1,n)+orgin(2);
	xx3=x*cos(t)+orgin(3);    
elseif dir =='x'
    xx1=y*ones(1,n)+orgin(1);
	xx2=x*sin(t)+orgin(2);
	xx3=x*cos(t)+orgin(3);
else
    xx1=x*cos(t)+orgin(1);
	xx2=x*sin(t)+orgin(2);
	xx3=y*ones(1,n)+orgin(3);
    
end
hRevolve=surf(xx1,xx2,xx3,repmat(2,size(xx1)));

if strcmp(closed,'closed')==1
    hold on
    hPlate1=fill3(xx1(1,:),xx2(1,:),xx3(1,:),'g');
    hPlate2=fill3(xx1(m,:),xx2(m,:),xx3(m,:),'g');
end