function Arrow2d = arrow2d(x1,x2,acolor)
% x1=[4,4];
% x2=[8 8];
% 
% acolor=[ 0.25 0.25 0.25];

theta=atan2( (x2(2)-x1(2) ),( x2(1)-x1(1) ) );
r=sqrt( (x2(1)-x1(1))^2 + (x2(2)-x1(2))^2 );

if theta<0
    theta=theta+2*pi;
end

dtheta=2.3*pi/180;
dr=0.1;

rmdr=(1-dr)*r;

plustheta=theta+dtheta;
midtheta=theta;
minustheta=theta-dtheta;

xarrow=[ x1(1)+rmdr*cos(minustheta) x1(1)+r*cos(midtheta) x1(1)+rmdr*cos(plustheta)];
yarrow=[ x1(2)+rmdr*sin(minustheta) x1(2)+r*sin(midtheta) x1(2)+rmdr*sin(plustheta)];


Arrow2d(1)=plot([x1(1) x2(1)],[x1(2) x2(2)],'Color',acolor,'LineWidth',2);
hold on
Arrow2d(2)=fill(xarrow,yarrow,acolor);
axis equal